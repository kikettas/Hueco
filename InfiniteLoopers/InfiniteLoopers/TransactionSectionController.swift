//
//  TransactionSectionController.swift
//  InfiniteLoopers
//
//  Created by Enrique del Pozo Gómez on 3/26/17.
//  Copyright © 2017 Infinite Loopers. All rights reserved.
//

import UIKit
import IGListKit
import RxCocoa
import RxSwift

class TransactionSectionController: IGListSectionController, IGListSectionType {
    
    var transaction:Transaction!
    var viewModel:NotificationsVMProtocol!
    var disposeBag = DisposeBag()
    
    convenience init(model:NotificationsVMProtocol) {
        self.init()
        viewModel = model
        inset = UIEdgeInsets(top: 0, left: 0, bottom: 15, right: 0)
    }
    
    func numberOfItems() -> Int {
        return 1
    }
    
    func sizeForItem(at index: Int) -> CGSize {
        if transaction.status == .pending && transaction.owner.uid == AppManager.shared.userLogged.value?.uid {
            return CGSize(width: 375, height: 130)
        }else{
            return CGSize(width: 375, height: 70)
        }
    }
    
    func cellForItem(at index: Int) -> UICollectionViewCell {
        let cellCollection = collectionContext?.dequeueReusableCell(withNibName: "TransactionCollectionCell", bundle: nil, for: self, at: index)
        guard let cell = cellCollection as? TransactionCollectionCell else{
            return cellCollection!
        }
        
        cell.loadingIndicator.isHidden = true

        cell.participantPicture.setAvatarImage(urlString: transaction.owner.uid == AppManager.shared.userLogged.value?.uid ? transaction.participant.avatar : transaction.owner.avatar)
        cell.participantPicture.setBorderAndRadius(color: UIColor.mainDarkGrey, width: 0.5, cornerRadius: 5)
        cell.requestText.attributedText = cellMessage()
        cell.acceptButton.setBorderAndRadius(color: UIColor(hexValue: 0x28CA86), width: 1, cornerRadius: 5)
        cell.rejectButton.setBorderAndRadius(color: UIColor.mainRedTranslucent, width: 1, cornerRadius: 5)
        
        cell.acceptButton.rx.tap.observeOn(MainScheduler.instance).bindNext {[weak self] in
            guard let `self` = self else {
                return
            }
            cell.acceptButton.isHidden = true
            cell.rejectButton.isHidden = true
            cell.loadingIndicator.isHidden = false
            cell.loadingIndicator.startAnimating()
            
            self.transaction.status = .accepted
            
            self.viewModel.changeTransactionValue(transaction: self.transaction){_,_ in
                print("Accepted")
                cell.buttonStack.isHidden = true
                self.collectionContext?.reload(self)
            }
            
            }.addDisposableTo(self.disposeBag)
        
        cell.rejectButton.rx.tap.observeOn(MainScheduler.instance).bindNext {[weak self] in
            guard let `self` = self else {
                return
            }
            cell.acceptButton.isHidden = true
            cell.rejectButton.isHidden = true
            cell.loadingIndicator.isHidden = false
            cell.loadingIndicator.startAnimating()
            self.transaction.status = .rejected
            
            self.viewModel.changeTransactionValue(transaction: self.transaction){_,_ in
                print("Rejected")
                cell.buttonStack.isHidden = true
                self.collectionContext?.reload(self)
            }
            
            }.addDisposableTo(self.disposeBag)
        
        cell.buttonStack.isHidden = transaction.status != .pending || transaction.owner.uid != AppManager.shared.userLogged.value?.uid
        
        return cell
    }
    
    func didUpdate(to object: Any) {
        transaction = object as? Transaction
    }
    
    func didSelectItem(at index: Int) {
    }
    
    private func cellMessage() -> NSMutableAttributedString{
        let att:NSMutableAttributedString
        
        if transaction.owner.uid == AppManager.shared.userLogged.value?.uid{
            att = NSMutableAttributedString(string: transaction.participant.nickname!,attributes:[NSFontAttributeName:UIFont.init(name: "HelveticaNeue-Bold", size: 14)!])
            switch self.transaction.status! {
            case .pending:
                att.append(NSAttributedString(string: NSLocalizedString("join_request_message", comment: "join_request_message")))
                att.append(NSAttributedString(string: transaction.product.name, attributes: [NSFontAttributeName:UIFont.init(name: "HelveticaNeue-Bold", size: 14)!]))
                att.append(NSAttributedString(string: ".\n" + NSLocalizedString("accept_for_joining", comment: "accept_for_joining")))
            case .rejected:
                att.append(NSAttributedString(string: NSLocalizedString("rejected_join_request_message", comment: "rejected_join_request_message")))
                att.append(NSAttributedString(string: transaction.product.name, attributes: [NSFontAttributeName:UIFont.init(name: "HelveticaNeue-Bold", size: 14)!]))
            case .accepted:
                att.append(NSAttributedString(string: NSLocalizedString("accepted_join_request_message", comment: "accepted_join_request_message")))
                att.append(NSAttributedString(string: transaction.product.name, attributes: [NSFontAttributeName:UIFont.init(name: "HelveticaNeue-Bold", size: 14)!]))
            }
        }else{
            
            switch self.transaction.status! {
            case .pending:
                att = NSMutableAttributedString(string: NSLocalizedString("you_requested_to_join", comment: "you_requested_to_join"),attributes:[NSFontAttributeName:UIFont.init(name: "HelveticaNeue", size: 14)!])
                att.append(NSAttributedString(string: transaction.product.name, attributes: [NSFontAttributeName:UIFont.init(name: "HelveticaNeue-Bold", size: 14)!]))
            case .rejected:
                att = NSMutableAttributedString(string: transaction.owner.nickname!,attributes:[NSFontAttributeName:UIFont.init(name: "HelveticaNeue-Bold", size: 14)!])
                att.append(NSAttributedString(string: NSLocalizedString("rejected_you_join_request_message", comment: "rejected_you_join_request_message")))
                att.append(NSAttributedString(string: transaction.product.name, attributes: [NSFontAttributeName:UIFont.init(name: "HelveticaNeue-Bold", size: 14)!]))
            case .accepted:
                att = NSMutableAttributedString(string: transaction.owner.nickname!,attributes:[NSFontAttributeName:UIFont.init(name: "HelveticaNeue-Bold", size: 14)!])
                att.append(NSAttributedString(string: NSLocalizedString("accepted_you_join_request_message", comment: "accepted_you_join_request_message")))
                att.append(NSAttributedString(string: transaction.product.name, attributes: [NSFontAttributeName:UIFont.init(name: "HelveticaNeue-Bold", size: 14)!]))
            }
        }
        
        return att
    }
}
