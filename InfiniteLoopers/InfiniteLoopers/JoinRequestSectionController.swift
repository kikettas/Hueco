//
//  JoinRequestSectionController.swift
//  InfiniteLoopers
//
//  Created by Enrique del Pozo Gómez on 3/26/17.
//  Copyright © 2017 Infinite Loopers. All rights reserved.
//

import UIKit
import IGListKit
import RxCocoa
import RxSwift

class JoinRequestSectionController: IGListSectionController, IGListSectionType {
    
    var joinRequest:JoinRequest!
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
        if joinRequest.status == .pending {
            return CGSize(width: 375, height: 130)
        }else{
            return CGSize(width: 375, height: 70)
        }
    }
    
    func cellForItem(at index: Int) -> UICollectionViewCell {
        let cellCollection = collectionContext?.dequeueReusableCell(withNibName: "JoinRequestCollectionCell", bundle: nil, for: self, at: index)
        guard let cell = cellCollection as? JoinRequestCollectionCell else{
            return cellCollection!
        }
        
        cell.loadingIndicator.isHidden = true
        cell.participantPicture.setAvatarImage(urlString: joinRequest.participant.avatar)
        cell.participantPicture.setBorderAndRadius(color: UIColor.mainDarkGrey.cgColor, width: 0.5, cornerRadius: 5)
        cell.requestText.attributedText = cellMessage()
        cell.acceptButton.setBorderAndRadius(color: UIColor(rgbValue: 0x28CA86).cgColor, width: 1, cornerRadius: 5)
        cell.rejectButton.setBorderAndRadius(color: UIColor.mainRedTranslucent.cgColor, width: 1, cornerRadius: 5)

        cell.acceptButton.rx.tap.observeOn(MainScheduler.instance).bindNext {[weak self] in
            guard let `self` = self else {
                return
            }
            cell.acceptButton.isHidden = true
            cell.rejectButton.isHidden = true
            cell.loadingIndicator.isHidden = false
            cell.loadingIndicator.startAnimating()
            
            self.joinRequest.status = .accepted
            
            self.viewModel.changeJoinRequestValue(joinRequest: self.joinRequest){_,_ in
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
            
            self.joinRequest.status = .rejected
            
            self.viewModel.changeJoinRequestValue(joinRequest: self.joinRequest){_,_ in
                print("Rejected")
                cell.buttonStack.isHidden = true
                self.collectionContext?.reload(self)
            }
            
            }.addDisposableTo(self.disposeBag)
        
        cell.buttonStack.isHidden = joinRequest.status != .pending
        
        return cell
    }
    
    func didUpdate(to object: Any) {
        joinRequest = object as? JoinRequest
    }
    
    func didSelectItem(at index: Int) {
    }
    
    private func cellMessage() -> NSMutableAttributedString{
        let att = NSMutableAttributedString(string: joinRequest.participant.nickname!,attributes:[NSFontAttributeName:UIFont.init(name: "HelveticaNeue-Bold", size: 14)!])
        
        switch self.joinRequest.status! {
        case .pending:
            att.append(NSAttributedString(string: NSLocalizedString("join_request_message", comment: "join_request_message")))
            att.append(NSAttributedString(string: joinRequest.product.name, attributes: [NSFontAttributeName:UIFont.init(name: "HelveticaNeue-Bold", size: 14)!]))
            att.append(NSAttributedString(string: ".\n" + NSLocalizedString("accept_for_joining", comment: "accept_for_joining")))
        case .accepted:
            att.append(NSAttributedString(string: NSLocalizedString("rejected_join_request_message", comment: "rejected_join_request_message")))
            att.append(NSAttributedString(string: joinRequest.product.name, attributes: [NSFontAttributeName:UIFont.init(name: "HelveticaNeue-Bold", size: 14)!]))
        case .rejected:
            att.append(NSAttributedString(string: NSLocalizedString("accepted_join_request_message", comment: "accepted_join_request_message")))
            att.append(NSAttributedString(string: joinRequest.product.name, attributes: [NSFontAttributeName:UIFont.init(name: "HelveticaNeue-Bold", size: 14)!]))
        }
        
        return att
    }
}
