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
        productName.text = model.product.0
        productType.text = model.product.1
        productDescription.text = model.product.2 
        productOwnerRating.rating = 4
        productOwnerImage.setBorderAndRadius(color:UIColor.mainDarkGrey.cgColor, width: 0.5)
        productOwnerImage.kf.setImage(with: URL(string:"http://az616578.vo.msecnd.net/files/2016/07/12/6360394709229451671057390252_michae-scott-quotes-5.jpg"))
        productOwnerName.text = "Michael Scott"
        productSpaces.text = "(15/20)"
        productPrice.text = "4€"
    }
    
    func setupCollection(){
        productParticipantsCollection.dataSource = self
        productParticipantsCollection.register(UINib(nibName: "ParticipantCell", bundle: nil), forCellWithReuseIdentifier: "ParticipantCell")
        productParticipantsCollection
            .rx
            .observe(CGSize.self, "contentSize")
            .observeOn(MainScheduler.instance)
            .distinctUntilChanged({return $0.0?.height == $0.1?.height})
            .subscribe(onNext:{ size in
                self.productParticipantsCollectionHeight.constant = (size?.height)!
            }).addDisposableTo(disposeBag)
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
            .bindNext(){
                print("Share product")
            }
            .addDisposableTo(disposeBag)

    
        chatButton
            .rx
            .tap
            .observeOn(MainScheduler.instance)
            .bindNext(){
                print("Chat with Michael Scott")
            }
            .addDisposableTo(disposeBag)
        
        let attString = NSMutableAttributedString()
        attString.append(NSAttributedString(string: "¡Habla con ", attributes: [NSFontAttributeName:UIFont(name: "HelveticaNeue-Light", size: 17)!, NSForegroundColorAttributeName:UIColor.white]))
        attString.append(NSAttributedString(string: "Michael Scott!", attributes: [NSFontAttributeName:UIFont(name: "HelveticaNeue-Bold", size: 17)!, NSForegroundColorAttributeName:UIColor.white]))
        
        chatButton.setAttributedTitle(attString, for: .normal)
    }
    
    
}

// MARK: - UICollectionViewDataSource

extension ProductDetailV{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ParticipantCell", for: indexPath) as! ParticipantCell
        if(indexPath.row > 14){
            cell.participantImage.image = UIImage(named: "ic_plus_w_padding")
            cell.participantName.text = "¡Únete!"
        }else{
            cell.participantImage.kf.setImage(with: URL(string: "http://www.tvstyleguide.com/wp-content/uploads/2015/08/jesse_pinkman_article_image_3.jpg"))
            cell.participantName.text = "Jesse Pinkman"
        }
        return cell
    }
    
}
