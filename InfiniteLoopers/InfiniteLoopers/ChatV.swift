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
    var avatars = Dictionary<String, JSQMessagesAvatarImage?>()
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
        
        if let urlString = AppManager.shared.userLogged.value?.avatar {
            setupAvatarImage(name: senderId, imageUrl: urlString as String, incoming: false)
            senderImageUrl = urlString as String
        } else {
            setupAvatarColor(name: senderId, incoming: false)
            senderImageUrl = ""
        }
        
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
        if let imageUrl = model.chat.photo{
            let button = UIButton(type: UIButtonType.custom)
            let processor = ResizingImageProcessor(targetSize: CGSize(width: 70, height: 70), contentMode: ContentMode.aspectFill)
            button.bounds = CGRect(x: 0, y: 0, width: 35, height: 35)
            button.clipsToBounds = true
            button.kf.setImage(with: URL(string:imageUrl), for: .normal, placeholder: UIImage(color: UIColor.mainBackgroundColor), options: [.processor(processor)]){(image, error, cacheType, imageUrl) in
                
                
            }
            button.setBorderAndRadius(color: UIColor.clear.cgColor, width: 0, cornerRadius: 5)
            self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: button)
        }
    }
}


// MARK: - JSQMessagesAvatarImageFactory

extension ChatV{
    func setupAvatarImage(name: String, imageUrl: String?, incoming: Bool) {
        if let stringUrl = imageUrl{
            ImagesManager.fetchImage(url: stringUrl){ [weak self] image, error in
                guard let `self` = self else {
                    return
                }
                if let error = error{
                    print(error)
                    return
                }
                
                let diameter = incoming ? UInt(self.collectionView.collectionViewLayout.incomingAvatarViewSize.width) : UInt(self.collectionView.collectionViewLayout.outgoingAvatarViewSize.width)
                let avatarImage = JSQMessagesAvatarImageFactory.avatarImage(with: image, diameter: diameter)
                
                self.avatars[name] = avatarImage
                self.collectionView.reloadData()
                return
            }
        }
        
        setupAvatarColor(name: name, incoming: incoming)
    }
    
    func setupAvatarColor(name: String, incoming: Bool) {
        let diameter = incoming ? UInt(collectionView.collectionViewLayout.incomingAvatarViewSize.width) : UInt(collectionView.collectionViewLayout.outgoingAvatarViewSize.width)
        
        let rgbValue = name.hash
        let r = CGFloat(Float((rgbValue & 0xFF0000) >> 16)/255.0)
        let g = CGFloat(Float((rgbValue & 0xFF00) >> 8)/255.0)
        let b = CGFloat(Float(rgbValue & 0xFF)/255.0)
        let color = UIColor(red: r, green: g, blue: b, alpha: 0.5)
        
        let nameLength = name.characters.count
        let initials : String? = name.substring(to: senderId.index(senderId.startIndex, offsetBy: min(3, nameLength)))
        let userImage = JSQMessagesAvatarImageFactory.avatarImage(withUserInitials: initials, backgroundColor: color, textColor: UIColor.black, font: UIFont.systemFont(ofSize: CGFloat(13)), diameter: diameter)
        
        avatars[name] = userImage
    }
}


// MARK: - JSQMessagesViewController

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
        let message = model.chatMessages[indexPath.item]
        if let avatar = avatars[message.senderId()] {
            return avatar
        } else {
            setupAvatarImage(name: message.senderId(), imageUrl: message.senderImage, incoming: true)
            let avatar = avatars[message.senderId()]
            return avatar!
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
        
        let message = model.chatMessages[indexPath.item]
        if message.senderId() == senderId {
            cell.textView.textColor = UIColor.white
        } else {
            cell.textView.textColor = UIColor.black
        }
        
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
