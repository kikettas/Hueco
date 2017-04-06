//
//  EditProfileVM.swift
//  InfiniteLoopers
//
//  Created by Enrique del Pozo Gómez on 3/18/17.
//  Copyright © 2017 Infinite Loopers. All rights reserved.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift


protocol EditProfileVMProtocol:class{
    
    var client:ClientProtocol { get }
    var name:Variable<String?> { get }
    var gender:Variable<String?> { get }
    var phone:Variable<String?> { get }
    var profilePictureUrl:Variable<String?> { get }
    var genders:[User.Gender] { get }

    
    func uploadPicture(withData data: Data, completion: @escaping ClientCompletion<String?>)
    func updateProfile(name:String?, gender:String?, phone:String?, image:UIImage?, completion: @escaping ClientCompletion<Void>)
}

final class EditProfileVM:EditProfileVMProtocol{
    
    var client: ClientProtocol
    var disposeBag = DisposeBag()
    var name: Variable<String?>
    var gender: Variable<String?>
    var phone: Variable<String?>
    var profilePictureUrl: Variable<String?>
    var genders: [User.Gender]
    
    init(client:ClientProtocol = Client.shared){
        self.client = client
        name = Variable(nil)
        gender = Variable(nil)
        phone = Variable(nil)
        profilePictureUrl = Variable(nil)
        genders = [User.Gender.male, User.Gender.female]
        
        AppManager.shared.userLogged.asObservable().filter{ $0 != nil}.bindNext {[unowned self] user in
            self.name.value = user!.name
            self.gender.value = user!.gender?.commonDescription
            self.phone.value = user!.phone
            self.profilePictureUrl.value = user!.avatar
        }.addDisposableTo(disposeBag)
    }
    
    func uploadPicture(withData data: Data, completion: @escaping ClientCompletion<String?>) {
        let fileName = (AppManager.shared.userLogged.value?.uid)! + String(describing: Date().timeIntervalSince1970)
        client.uploadPicture(imageData: data, pictureName: fileName){urlString, error in
            if let error = error{
                completion(nil, error)
                return
            }
            completion(urlString, nil)
        }
    }
    
    func updateProfile(name: String?, gender: String?, phone: String?, image: UIImage?, completion: @escaping ClientCompletion<Void>) {
        var parameters:[String:Any] = [:]
        
        if let name = name, !name.isEmpty{
            parameters["name"] = name
        }
        
        if let gender = gender, !gender.isEmpty{
            parameters["gender"] = gender
        }
        
        if let phone = phone, !phone.isEmpty{
            parameters["phone"] = phone
        }
        
        
        if let image = image{
            let data:Data
            if(image.size.width > 512){
                data = UIImageJPEGRepresentation(image.resizedImage(newWidth: 512)!, 0.75)!
            }else{
                data = UIImageJPEGRepresentation(image, 0.75)!
            }
            
            self.uploadPicture(withData: data){[weak self] url, error in
                guard let `self` = self else {
                    return
                }
                if let error = error{
                    completion((), error)
                    return
                }
                
                parameters["avatar"] = url
                self.client.updateProfile(parameters: parameters){_, error in
                    if let error = error{
                        completion((), error)
                        return
                    }
                    completion((), nil)
                }
                
            }
        }else{
            self.client.updateProfile(parameters: parameters){_, error in
                if let error = error{
                    completion((), error)
                    return
                }
                completion((), nil)
            }
        }
    }
    
}
