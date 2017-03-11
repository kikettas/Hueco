
//
//  Client+API.swift
//  InfiniteLoopers
//
//  Created by Enrique del Pozo Gómez on 2/25/17.
//  Copyright © 2017 Infinite Loopers. All rights reserved.
//

import Alamofire
import Foundation
import FirebaseAuth
import FirebaseDatabase
import FacebookLogin
import GoogleSignIn
import ObjectMapper
import UIKit
import RxCocoa
import RxSwift

extension Client{
    
    func chats(withChatIDs ids: [String]) -> Observable<Chat> {
        return Observable.create(){ observer in
            _ = ids.map{chatID in
                FIRDatabase.database().reference().child("chats").child(chatID).queryOrderedByValue().observeSingleEvent(of: .value){ (snapshot,x) in
                    if let chat = snapshot.value as? [String:Any]{
                        if let members = chat["members"] as? JSON, members.keys.count == 2{
                            for member in members.keys{
                                if(member != AppManager.shared.userLogged.value?.uid){
                                    self.user(withId: member){ user, error in
                                        if let error = error{
                                            print(error)
                                            return
                                        }
                                        let c = Chat.init(id: chatID, photo: user.avatar, name: user.nickname ?? "No nickname")
                                        observer.onNext(c)
                                    }
                                }
                            }
                        }
                        
                    }
                }
            }
            return Disposables.create{
                print("aa")
            }
        }
    }
    
    func check(nickName: String, completion: @escaping (Bool, ClientError?) -> ()) {
        sessionManager.request(Router.checkNickName(parameters: ["nickname":nickName])).responseValidatedJson{response in
            switch response{
            case .success(let json):
                if let available = json["available"]{
                    completion(available as! Bool,nil)
                }
                break
            case .failure(let error):
                completion(false,error as? ClientError)
                break
            }
        }
    }
    
    public func logIn(withEmail: String, password:String, completion:@escaping ClientCompletion<Void>){
        FIRAuth.auth()?.signIn(withEmail: withEmail, password: password){(user,error) in
            if let error = error{
                completion((), ClientError.parseFirebaseError(errorCode: error._code))
            }else{
                completion((), nil)
            }
        }
    }
    
    func logIn(withCredential: FIRAuthCredential, completion: @escaping ClientCompletion<Void>) {
        FIRAuth.auth()?.signIn(with: withCredential){(user,error) in
            if let error = error{
                completion((), ClientError.parseFirebaseError(errorCode: error._code))
            }else{
                completion((), nil)
            }
        }
    }
    
    func logInWithFacebook(from: UIViewController, completion: @escaping ClientCompletion<Void>) {
        let loginManager = LoginManager()
        loginManager.logIn([.publicProfile, .email], viewController: from){ loginResult in
            switch loginResult{
            case .failed(_):
                completion((), ClientError.failedLoginWithFacebook)
            case .cancelled:
                completion((), ClientError.logInCanceled)
            case .success(_, _, let accessToken):
                let credential = FIRFacebookAuthProvider.credential(withAccessToken: accessToken.authenticationToken)
                self.logIn(withCredential: credential, completion: completion)
            }
        }
    }
    
    func logInWithGoogle(from: UIViewController, completion: @escaping ClientCompletion<Void>){
        googleLoginDelegate = GoogleLoginDelegate(from:from, didLogin: {idToken, accessToken, error in
            if let error = error{
                // figure out what kind of error is and parse to ClientError
                completion((),ClientError.parseGoogleSignInError(errorCode: error._code))
                return
            }
            let credential = FIRGoogleAuthProvider.credential(withIDToken: idToken!, accessToken: accessToken!)
            self.logIn(withCredential: credential, completion: completion)
        })
        GIDSignIn.sharedInstance()?.delegate = googleLoginDelegate
        GIDSignIn.sharedInstance()?.uiDelegate = googleLoginDelegate
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    func products(startingAt:Any) -> Observable<Product> {
        return Observable.create {[unowned self] observer in            
            FIRDatabase.database().reference().child("products").queryOrderedByKey().queryLimited(toFirst: UInt(self.itemsPerPage)).queryStarting(atValue: startingAt).observeSingleEvent(of: FIRDataEventType.value, with: { snapshot in
                if let productsJson = snapshot.value as? [String:Any]{
                    print("products...\(productsJson.count)")
                    for (index, element) in productsJson.enumerated(){
                        let productJson:[String:Any] = element.value as! [String : Any]
                        
                        self.user(withId: productJson["seller"] as! String){ user, error in
                            if let _ = error{
                                return
                            }
                            observer.onNext(Product(json:productJson, seller:user))
                            if(index == (productsJson.count - 1)){
                                observer.onCompleted()
                            }
                        }

                    }
                }else{
                    observer.onError(ClientError.unknownError as Error)
                }
            })
            return Disposables.create()
        }
    }
    
    func productKeys(completion: @escaping ([String], ClientError?) -> ()) {
        sessionManager.request(URL(string:"https://infinite-loopers.firebaseio.com/products.json?shallow=true")!).responseValidatedJson{
            switch $0{
            case .success(let json):
                completion(json.keys.sorted(), nil)
            case .failure(let error):
                completion([],error as? ClientError)
            }
        }
    }
    
    func signOut(completion: @escaping ClientCompletion<Void>) {
        do{
            try FIRAuth.auth()?.signOut()
            completion((), nil)
        }catch{
            
        }
    }
    
    func sendResetPaswordTo(email: String, completion: @escaping ClientCompletion<Void>) {
        FIRAuth.auth()?.sendPasswordReset(withEmail: email){ error in
            if let error = error{
                completion((),ClientError.parseFirebaseError(errorCode: error._code))
                return
            }else{
                completion((),nil)
            }
        }
    }
    
    func signUp(withEmail: String, password: String, nickName:String, completion: @escaping ClientCompletion<Void>) {
        FIRAuth.auth()?.createUser(withEmail: withEmail, password: password) { (user, error) in
            if let error = error{
                completion((), ClientError.parseFirebaseError(errorCode: error._code))
            }else{
                self.sessionManager.request(Router.signUp(parameters: ["nickname":nickName])).responseValidatedJson{ response in
                    switch response{
                    case .success(_):
                        completion((),nil)
                    case .failure(let error):
                        completion((),error as? ClientError)
                    }
                }
            }
        }
    }
    
    func updateEmail(withEmail: String, completion: @escaping ClientCompletion<Void>) {
        let user = FIRAuth.auth()?.currentUser
        user?.updateEmail(withEmail){ error in
            if let error = error{
                completion((),ClientError.parseFirebaseError(errorCode: error._code))
                return
            }else{
                completion((),nil)
            }
        }
    }
    
    func updatePassword(withPassword: String, completion: @escaping ClientCompletion<Void>) {
        let user = FIRAuth.auth()?.currentUser
        user?.updatePassword(withPassword){ error in
            if let error = error{
                completion((),ClientError.parseFirebaseError(errorCode: error._code))
                return
            }else{
                completion((),nil)
            }
        }
    }
    
    func user(withId id: String, completion:@escaping ClientCompletion<User>){
        FIRDatabase.database().reference().child("users").child(id).observeSingleEvent(of: .value){ (snapshot,x) in
            if let user = snapshot.value as? [String:Any]{
                if let u = User(JSON:user) {
                    completion(u,nil)
                }
            }
        }
    }
}
