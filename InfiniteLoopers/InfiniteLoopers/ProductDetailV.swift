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
import Swarkn

class ProductDetailV: UIViewController {
    
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
        model.product.asObservable().observeOn(MainScheduler.instance).map{$0.name}.bindTo(productName.rx.text).addDisposableTo(disposeBag)
        model.product.asObservable().observeOn(MainScheduler.instance).map{$0.category.name}.bindTo(productType.rx.text).addDisposableTo(disposeBag)
        model.product.asObservable().observeOn(MainScheduler.instance).map{$0.productDescription}.bindTo(productDescription.rx.text).addDisposableTo(disposeBag)

        productOwnerRating.rating = model.product.value.seller.rating
        productOwnerImage.setBorderAndRadius(color:UIColor.mainDarkGrey.cgColor, width: 0.5)
        productOwnerImage.kf.setImage(with: URL(string:model.product.value.seller.avatar ?? ""), placeholder: UIImage(named: "ic_avatar_placeholder"))
        productOwnerName.text = model.product.value.seller.nickname
        productSpaces.text = model.product.value.slotsFormatted
        productPrice.text = model.product.value.priceWithCurrency
    }
    
    func setupCollection(){
        productParticipantsCollection.register(UINib(nibName: "ParticipantCell", bundle: nil), forCellWithReuseIdentifier: "ParticipantCell")
        productParticipantsCollection
            .rx
            .observe(CGSize.self, "contentSize")
            .observeOn(MainScheduler.instance)
            .distinctUntilChanged({return $0.0?.height == $0.1?.height})
            .subscribe(onNext:{ size in
                self.productParticipantsCollectionHeight.constant = (size?.height)!
            }).addDisposableTo(disposeBag)
        
        model.participants.asObservable().bindTo(productParticipantsCollection.rx.items(cellIdentifier: "ParticipantCell", cellType: ParticipantCell.self)){row, element, cell in
            if let participant = element{
                cell.participantImage.kf.setImage(with: URL(string:participant.avatar ?? ""), placeholder: UIImage(named: "ic_avatar_placeholder"))
                cell.participantImage.highlightedImage = nil
                cell.participantName.text = participant.nickname
            }else{
                cell.participantImage.image = UIImage(named: "ic_plus_w_padding")
                cell.participantImage.highlightedImage = UIImage(named: "ic_plus_w_padding_highlighted")

                cell.participantName.text = "¡Únete!"
            }
        }.addDisposableTo(disposeBag)
    }
    
    
    func setupButton(){
        closeButton
            .rx
            .tap
            .observeOn(MainScheduler.instance)
            .bindNext(){
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
                Navigator.showAlert(on: self, message: "¿Deseas unirte a ésta ... de \(self.productName.text!)?", positiveMessage: "¡Unirte!", negativeMessage:"Cancelar"){ positive in
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
            }
            .addDisposableTo(disposeBag)
        
        let attString = NSMutableAttributedString()
        attString.append(NSAttributedString(string: "¡Habla con ", attributes: [NSFontAttributeName:UIFont(name: "HelveticaNeue-Light", size: 17)!, NSForegroundColorAttributeName:UIColor.white]))
        attString.append(NSAttributedString(string: "Michael Scott!", attributes: [NSFontAttributeName:UIFont(name: "HelveticaNeue-Bold", size: 17)!, NSForegroundColorAttributeName:UIColor.white]))
        
        chatButton.setAttributedTitle(attString, for: .normal)
    }
}
