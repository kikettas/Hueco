//
//  SharedV.swift
//  InfiniteLoopers
//
//  Created by Enrique del Pozo Gómez on 2/4/17.
//  Copyright © 2017 Infinite Loopers. All rights reserved.
//

import UIKit
import JSQMessagesViewController
import Kingfisher
import RxCocoa
import RxSwift
import Swarkn

class ChatV: JSQMessagesViewController, UITextFieldDelegate {
    
    var model:ChatVMProtocol!
    var disposeBag = DisposeBag()
    var avatarPlaceholder:JSQMessagesAvatarImage!
    var senderImageUrl: String!
    
    var outgoingBubbleImageView = JSQMessagesBubbleImageFactory().outgoingMessagesBubbleImage(with:UIColor.mainRedTranslucent)
    var incomingBubbleImageView = JSQMessagesBubbleImageFactory().incomingMessagesBubbleImage(with:UIColor.white)
    
    convenience init(model:ChatVMProtocol) {
        self.init(nibName: nil, bundle: nil)
        self.model = model
        self.title = model.chat.name
    }
}


// MARK: - UIViewController

extension ChatV{
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppNavBarStyle()
        
        self.edgesForExtendedLayout = []
        setNavBarButtonImage()
        inputToolbar.contentView.leftBarButtonItem = nil
        collectionView.backgroundColor = UIColor.mainBackgroundColor
        collectionView.collectionViewLayout.springinessEnabled = true
        automaticallyScrollsToMostRecentMessage = true
        
        senderDisplayName = AppManager.shared.userLogged.value?.nickname
        senderId = AppManager.shared.userLogged.value?.uid
        senderImageUrl = AppManager.shared.userLogged.value?.avatar ?? ""
        avatarPlaceholder = JSQMessagesAvatarImageFactory.avatarImage(with: UIImage(named: "ic_avatar_placeholder"), diameter: UInt(self.collectionView.collectionViewLayout.outgoingAvatarViewSize.width))
        
        self.model.newMessage.subscribe(onNext:{ [unowned self] in
            self.finishReceivingMessage(animated: true)
        }).addDisposableTo(disposeBag)
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        let message = ChatMessage(text: text, senderId: senderId, senderDisplayName: senderDisplayName, date: date.timeIntervalSince1970, isMediaMessage: false, senderPhoto:senderImageUrl)
        model.sendMessage(withData: message)
        finishSendingMessage(animated: true)
    }
    
    func setNavBarButtonImage(){
        let button = UIButton(type: UIButtonType.custom)
        let processor = ResizingImageProcessor(targetSize: CGSize(width: 70, height: 70), contentMode: ContentMode.aspectFill)
        button.bounds = CGRect(x: 0, y: 0, width: 35, height: 35)
        button.clipsToBounds = true
        button.kf.setImage(with: URL(string:model.chat.photo ?? ""), for: .normal, placeholder: UIImage(named: "ic_avatar_placeholder"), options: [.processor(processor)])
        button.setBorderAndRadius(color: UIColor.mainDarkGrey.cgColor, width: 0.5, cornerRadius: 5)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: button)
    }
}


extension ChatV{
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        return model.chatMessages[indexPath.row]
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model.chatMessages.count
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        let message = model.chatMessages[indexPath.row]
        
        if message.senderId() == senderId{
            return outgoingBubbleImageView
        }
        
        return incomingBubbleImageView
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        return avatarPlaceholder
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
        
        let message = model.chatMessages[indexPath.item]
        if message.senderId() == senderId {
            cell.textView.textColor = UIColor.white
        } else {
            cell.textView.textColor = UIColor.black
        }
        cell.avatarImageView.kf.setImage(with: URL(string:message.senderImage ?? ""), placeholder:UIImage(named: "ic_avatar_placeholder")){(image, error, cacheType, imageUrl) in
            if let _ = error{
                cell.avatarImageView.image = UIImage(named: "ic_avatar_placeholder")
            }
            cell.avatarImageView.setBorderAndRadius(color: UIColor.mainDarkGrey.cgColor, width: 0.5, cornerRadius: 5)
        }
        
        cell.avatarImageView.contentMode = .scaleAspectFill
        cell.avatarImageView.clipsToBounds = true
        
        let attributes : [String:AnyObject] = [NSForegroundColorAttributeName:cell.textView.textColor!, NSUnderlineStyleAttributeName: 1 as AnyObject]
        cell.textView.linkTextAttributes = attributes
        
        return cell
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, attributedTextForMessageBubbleTopLabelAt indexPath: IndexPath!) -> NSAttributedString! {
        let message = model.chatMessages[indexPath.item];
        
        if message.senderId() == senderId {
            return nil;
        }
        
        if indexPath.item > 0 {
            let previousMessage = model.chatMessages[indexPath.item - 1];
            if previousMessage.senderId() == message.senderId() {
                return nil;
            }
        }
        
        return NSAttributedString(string:message.senderDisplayName())
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForMessageBubbleTopLabelAt indexPath: IndexPath!) -> CGFloat {
        let message = model.chatMessages[indexPath.item]
        
        if message.senderId() == senderId {
            return CGFloat(0.0);
        }
        
        if indexPath.item > 0 {
            let previousMessage = model.chatMessages[indexPath.item - 1];
            if previousMessage.senderId() == message.senderId() {
                return CGFloat(0.0);
            }
        }
        
        return kJSQMessagesCollectionViewCellLabelHeightDefault
    }
}
