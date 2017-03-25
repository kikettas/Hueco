//
//  NotificationsV.swift
//  InfiniteLoopers
//
//  Created by Enrique del Pozo Gómez on 2/4/17.
//  Copyright © 2017 Infinite Loopers. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class NotificationsV: UIViewController, UICollectionViewDelegateFlowLayout {

    var disposeBag = DisposeBag()
    var model:NotificationsVMProtocol!
    
    @IBOutlet weak var collectionView: UICollectionView!
    var emptyView:EmptyCollectionBackgroundView!
    
    convenience init(model:NotificationsVMProtocol) {
        self.init(nibName: nil, bundle: nil)
        self.model = model
        self.tabBarItem = UITabBarItem(title: NSLocalizedString("notifications", comment: "Notications tab title"), image: UIImage(named: "ic_notifications_tab_unselected"), selectedImage: UIImage(named: "ic_notifications_tab_selected"))
        self.title = NSLocalizedString("notifications", comment: "Notications view title")
    }
}


// MARK: - UIViewController

extension NotificationsV{
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppNavBarStyle()
        emptyView = EmptyCollectionBackgroundView(frame: self.collectionView.frame)
        collectionView.backgroundView = emptyView
        collectionView.register(UINib.init(nibName: "JoinRequestCollectionCell", bundle: nil), forCellWithReuseIdentifier: "joinRequestCellIdentifier")
        collectionView.delegate = self
        
        model.dataSource.asObservable()
            .map{$0.isNotEmpty}
            .bindTo(emptyView.rx.isHidden)
            .addDisposableTo(disposeBag)
        
        model.dataSource.asObservable().bindTo(collectionView.rx.items(cellIdentifier: "joinRequestCellIdentifier", cellType: JoinRequestCollectionCell.self)){ row, element, cell in
            if let joinRequest = element as? JoinRequest{
                cell.loadingIndicator.isHidden = true
                cell.participantPicture.setAvatarImage(urlString: joinRequest.participant.avatar)
                cell.participantPicture.setBorderAndRadius(color: UIColor.mainDarkGrey.cgColor, width: 0.5, cornerRadius: 5)
                let att = NSMutableAttributedString(string: joinRequest.participant.nickname!,attributes:[NSFontAttributeName:UIFont.init(name: "HelveticaNeue-Bold", size: 14)!])
            
                att.append(NSAttributedString(string: " ha solicitado unirse a "))
                att.append(NSAttributedString(string: joinRequest.product.name, attributes: [NSFontAttributeName:UIFont.init(name: "HelveticaNeue-Bold", size: 14)!]))
                att.append(NSAttributedString(string: ".\n ¿Aceptas que se una?"))
                cell.requestText.attributedText = att
                cell.acceptButton.setBorderAndRadius(color: UIColor(rgbValue: 0x28CA86).cgColor, width: 1, cornerRadius: 5)
                cell.acceptButton.rx.tap.observeOn(MainScheduler.instance).bindNext {[weak self] in
                    guard let `self` = self else {
                        return
                    }
                    cell.acceptButton.isHidden = true
                    cell.rejectButton.isHidden = true
                    cell.loadingIndicator.isHidden = false
                    cell.loadingIndicator.startAnimating()

                    joinRequest.status = .accepted
                    
                    self.model.changeJoinRequestValue(joinRequest: joinRequest){_,_ in
                        print("Accepted")
                        cell.buttonStack.isHidden = true
                        self.collectionView.reloadData()
                    }
                    
                }.addDisposableTo(self.disposeBag)
                cell.rejectButton.setBorderAndRadius(color: UIColor.mainRedTranslucent.cgColor, width: 1, cornerRadius: 5)
                
                cell.rejectButton.rx.tap.observeOn(MainScheduler.instance).bindNext {[weak self] in
                    guard let `self` = self else {
                        return
                    }
                    cell.acceptButton.isHidden = true
                    cell.rejectButton.isHidden = true
                    cell.loadingIndicator.isHidden = false
                    cell.loadingIndicator.startAnimating()
                    
                    joinRequest.status = .rejected
                    
                    self.model.changeJoinRequestValue(joinRequest: joinRequest){_,_ in
                        print("Rejected")
                        cell.buttonStack.isHidden = true
                        self.collectionView.reloadData()
                    }
                    
                    }.addDisposableTo(self.disposeBag)
                
                cell.buttonStack.isHidden = joinRequest.status != .pending
            }
            
        }.addDisposableTo(disposeBag)
        
        Observable.combineLatest(model.dataSource.asObservable()
            .map{ return $0.isEmpty },AppManager.shared.userLogged.asObservable().map{$0 == nil}, resultSelector: { return ($0, $1)}).bindNext {(emptyNotifications, notLogged ) in
                if(notLogged){
                    self.emptyView.setLabelMessage(emoji: "🔑", text: NSLocalizedString("empty_notifications_message_not_logged", comment: "empty_notifications_message_not_logged"))
                }else{
                    if !emptyNotifications{
                        self.emptyView.setLabelMessage(emoji: nil, text: nil)
                    }else{
                        self.emptyView.setLabelMessage(emoji: "📥", text: NSLocalizedString("empty_notifications_message", comment: "empty_notifications_message"))
                    }
                }
            }.addDisposableTo(disposeBag)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let joinRequest = model.dataSource.value[indexPath.row] as? JoinRequest, joinRequest.status == .pending {
            return CGSize(width: 375, height: 130)
        }else{
            return CGSize(width: 375, height: 70)
        }
    }
}
