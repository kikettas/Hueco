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
    var chats:ChatSectionDataSource!
    var didSelectChat:((Int) -> ())!
    
    convenience init(didSelectChat:@escaping ((Int) -> ())) {
        self.init()
        self.didSelectChat = didSelectChat
        minimumInteritemSpacing = 1
        minimumLineSpacing = 1
    }
    
    func numberOfItems() -> Int {
        return chats.items.count
    }
    
    func sizeForItem(at index: Int) -> CGSize {
        return CGSize(width: (collectionContext?.containerSize.width)!, height: 67)
    }
    
    func cellForItem(at index: Int) -> UICollectionViewCell {
        let cellCollection = collectionContext?.dequeueReusableCell(withNibName: "ChatCell", bundle: nil, for: self, at: index)
        
        guard let cell = cellCollection as? ChatCell else{
            return cellCollection!
        }
        
        cell.userName.text = chats.items[index].name
        cell.userPhoto.setAvatarImage(urlString: chats.items[index].photo)
        cell.userPhoto.setBorderAndRadius(color: UIColor.mainDarkGrey.cgColor, width: 0.5, cornerRadius: 5)
        cell.lastMessage.text = chats.items[index].lastMessage ?? ""
        return cell
    }
    
    func didUpdate(to object: Any) {
        chats = object as? ChatSectionDataSource
    }
    
    func didSelectItem(at index: Int) {
        didSelectChat(index)
    }
    
}

class ChatSectionDataSource:IGListDiffable{
    let items:[Chat]
    
    init(chats:[Chat]){
        items = chats
        
    }
    func diffIdentifier() -> NSObjectProtocol {
        return self as! NSObjectProtocol
    }
    
    func isEqual(toDiffableObject object: IGListDiffable?) -> Bool {
        return false
    }
}
