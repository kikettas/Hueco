//
//  ChatSectionController.swift
//  InfiniteLoopers
//
//  Created by Enrique del Pozo Gómez on 3/26/17.
//  Copyright © 2017 Infinite Loopers. All rights reserved.
//

import UIKit
import IGListKit

class ChatSectionController: IGListSectionController, IGListSectionType {
    var chat:Chat!
    var didSelectChat:((Int) -> ())!
    
    convenience init(didSelectChat:@escaping ((Int) -> ())) {
        self.init()
        self.didSelectChat = didSelectChat
    }
    
    func numberOfItems() -> Int {
        return 1
    }
    
    func sizeForItem(at index: Int) -> CGSize {
        return CGSize(width: (collectionContext?.containerSize.width)!, height: 67)
    }
    
    func cellForItem(at index: Int) -> UICollectionViewCell {
        let cellCollection = collectionContext?.dequeueReusableCell(withNibName: "ChatCell", bundle: nil, for: self, at: index)
        
        guard let cell = cellCollection as? ChatCell else{
            return cellCollection!
        }
        
        cell.userName.text = chat.name
        cell.userPhoto.setAvatarImage(urlString: chat.photo)
        cell.userPhoto.setBorderAndRadius(color: UIColor.mainDarkGrey.cgColor, width: 0.5, cornerRadius: 5)
        cell.lastMessage.text = ""
        return cell
    }
    
    func didUpdate(to object: Any) {
        chat = object as? Chat
    }
    
    func didSelectItem(at index: Int) {
        
    }
}
