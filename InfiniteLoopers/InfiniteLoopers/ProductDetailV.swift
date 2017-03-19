//
//  ProductDetailV.swift
//  InfiniteLoopers
//
//  Created by Enrique del Pozo Gómez on 2/11/17.
//  Copyright © 2017 Infinite Loopers. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxOptional
import Swarkn

class ProductDetailV: UIViewController, UICollectionViewDataSource {
    
    var model:ProductDetailVMProtocol!
    var disposeBag = DisposeBag()
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productType: UILabel!
    @IBOutlet weak var productDescription: UILabel!
    @IBOutlet weak var productOwnerImage: UIImageView!
    @IBOutlet weak var productOwnerName: UILabel!
    @IBOutlet weak var productOwnerRating: RatingView!
    @IBOutlet weak var productSpaces: UILabel!
    @IBOutlet weak var productParticipantsCollection: UICollectionView!
    @IBOutlet weak var productParticipantsCollectionHeight: NSLayoutConstraint!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var chatButton: UIButton!
    
    convenience init(model:ProductDetailVMProtocol) {
        self.init(nibName: nil, bundle: nil)
        self.model = model
    }
    
}

// MARK: - UIViewController

extension ProductDetailV{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollection()
        setupButton()
        syncModelAndView()
    }
    
    func syncModelAndView(){
        model.productName.asDriver().filterNil().drive(productName.rx.text).addDisposableTo(disposeBag)
        model.productCategory.asDriver().filterNil().drive(productType.rx.text).addDisposableTo(disposeBag)
        model.productDescription.asDriver().filterNil().drive(productDescription.rx.text).addDisposableTo(disposeBag)
        model.productPrice.asDriver().filterNil().drive(productPrice.rx.text).addDisposableTo(disposeBag)
        model.productSpaces.asDriver().filterNil().drive(productSpaces.rx.text).addDisposableTo(disposeBag)
        model.productSellerNickname.asDriver().filterNil().drive(productOwnerName.rx.text).addDisposableTo(disposeBag)

        model.productSellerRating.asDriver().filterNil().drive(onNext:{[unowned self] rating in
            self.productOwnerRating.rating = rating
        }).addDisposableTo(disposeBag)
        
        model.productSellerAvatar.asDriver().drive(onNext:{ [unowned self] avatar in
            self.productOwnerImage.setAvatarImage(urlString: avatar)
        }).addDisposableTo(disposeBag)
        
        productOwnerImage.setBorderAndRadius(color:UIColor.mainDarkGrey.cgColor, width: 0.5)
    }
    
    func setupCollection(){
        productParticipantsCollection.dataSource = self
        productParticipantsCollection.register(UINib(nibName: "ParticipantCell", bundle: nil), forCellWithReuseIdentifier: "ParticipantCell")
        productParticipantsCollection
            .rx
            .observe(CGSize.self, "contentSize")
            .observeOn(MainScheduler.instance)
            .distinctUntilChanged({return $0.0?.height == $0.1?.height})
            .subscribe(onNext:{[unowned self] size in
                self.productParticipantsCollectionHeight.constant = (size?.height)!
            }).addDisposableTo(disposeBag)
        
        productParticipantsCollection.rx.itemSelected.observeOn(MainScheduler.instance).bindNext{[unowned self] indexPath in
            if indexPath.row < self.model.participants.value.count{
                // Show user profile
            }else{
                self.showJoinAlert()
            }
            self.productParticipantsCollection.deselectItem(at: indexPath, animated: true)

            }.addDisposableTo(disposeBag)
        
        model.participants.asObservable().subscribe(onNext:{ [unowned self] _ in
            self.productParticipantsCollection.reloadData()
        }).addDisposableTo(disposeBag)
        
    }
    
    
    func setupButton(){
        closeButton
            .rx
            .tap
            .observeOn(MainScheduler.instance)
            .bindNext(){ [unowned self] in
                self.dismiss(animated: true, completion: nil)
            }
            .addDisposableTo(disposeBag)
        
        shareButton
            .rx
            .tap
            .observeOn(MainScheduler.instance)
            .bindNext(){[unowned self] in
                Navigator.navigateToShareProduct(from: self, sourceView: self.shareButton){
                }
            }
            .addDisposableTo(disposeBag)
        
        
        chatButton
            .rx
            .tap
            .observeOn(MainScheduler.instance)
            .bindNext(){[unowned self] in
                self.showJoinAlert()
            }
            .addDisposableTo(disposeBag)
        
        let attString = NSMutableAttributedString()
        attString.append(NSAttributedString(string: "¡Habla con ", attributes: [NSFontAttributeName:UIFont(name: "HelveticaNeue-Light", size: 17)!, NSForegroundColorAttributeName:UIColor.white]))
        attString.append(NSAttributedString(string: (self.model.product.value.seller.nickname ?? "")! + "!", attributes: [NSFontAttributeName:UIFont(name: "HelveticaNeue-Bold", size: 17)!, NSForegroundColorAttributeName:UIColor.white]))
        
        chatButton.setAttributedTitle(attString, for: .normal)
    }
    
    func showJoinAlert(){
        if let _ = AppManager.shared.userLogged.value{
            let owner = self.productOwnerName.text ?? ""
            Navigator.showAlert(on: self,title:"¿Quieres enviar una petición para unirte a \(self.productName.text!)?", message: "Una vez que tu petición para unirte sea aceptada, podrás hablar con \(owner) y empezar a compartir 🤝", positiveMessage: "Enviar", negativeMessage:"Cancelar"){ positive in
                if(positive){
                    print("positive")
                    self.model.join(){ [weak self] chat, error in
                        guard let `self` = self else {
                            return
                        }
                        if let error = error{
                            print(error)
                            return
                        }
                        Navigator.navigateToChat(from: self, chat: chat!)
                    }
                }
            }
        }else{
            Navigator.navigateToMainLogin(from: self)
        }
    }
}


// MARK: - UICollectionViewDataSource

extension ProductDetailV{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model.product.value.slots - 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ParticipantCell", for: indexPath) as! ParticipantCell
        if indexPath.row < model.participants.value.count{
            let participant = model.participants.value[indexPath.row]
            cell.participantImage.setAvatarImage(urlString: participant?.avatar)
            cell.participantImage.highlightedImage = nil
            cell.participantName.text = participant?.nickname
        }else{
            cell.participantImage.image = UIImage(named: "ic_plus_w_padding")
            cell.participantImage.highlightedImage = UIImage(named: "ic_plus_w_padding_highlighted")
            
            cell.participantName.text = "¡Únete!"
        }
        return cell
    }
}



