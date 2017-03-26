
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
import FirebaseStorage
import FacebookLogin
import GoogleSignIn
import ObjectMapper
import UIKit
import RxCocoa
import RxSwift

extension Client{
    
    func changeJoinRequestStatus(joinRequest: JoinRequest, completion: @escaping (JoinRequest.JoinRequestStatus?, ClientError?) -> ()) {
        FIRDatabase.database().reference().child("join_requests").child(joinRequest.id).child("status").setValue(joinRequest.status.rawValue)
        if joinRequest.status == .accepted{
            self.createChat(ownID: joinRequest.owner.uid, sellerID: joinRequest.participant.uid, name: joinRequest.product.name, chatID: joinRequest.product.chat, productID: joinRequest.product.id){_, error in
                if let error = error{
                    completion(nil, error)
                    return
                }
                completion(joinRequest.status, nil)
            }
        }else{
            completion(joinRequest.status, nil)
        }
    }
    
    func chats(withChatIDs ids: [String]) -> Observable<Chat> {
        return Observable.create(){ observer in
            _ = ids.map{chatID in
                FIRDatabase.database().reference().child("chats").child(chatID).queryOrderedByValue().observeSingleEvent(of: .value){ (snapshot,x) in
                    if let chatJson = snapshot.value as? [String:Any]{
                        let c = Chat(id: chatID, json: chatJson)
                        guard let chat = c else { return }
                        
                        if let _ = chat.photo{
                            observer.onNext(chat)
                        }else{
                            chat.memberIDs.forEach{ member in
                                if(member != AppManager.shared.userLogged.value?.uid){
                                    self.user(withId: member){ user, error in
                                        if let error = error{
                                            print(error)
                                            return
                                        }
                                        let mutableChat = chat
                                        mutableChat.photo = user!.avatar
                                        observer.onNext(mutableChat)
                                    }
                                }
                            }
                        }
                        
                    }
                }
            }
            return Disposables.create{
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
    
    func createChat(ownID: String, sellerID: String, name: String, chatID: String?, productID: String, completion: @escaping (Chat?, ClientError?) -> ()) {
        let membersChat = [ownID:true, sellerID:true]
        let chatReference:FIRDatabaseReference
        if let chatID = chatID {
            chatReference = FIRDatabase.database().reference().child("chats").child(chatID)
        }else{
            chatReference = FIRDatabase.database().reference().child("chats").childByAutoId()
            FIRDatabase.database().reference().child("products").child(productID).child("chat").setValue(chatReference.key)
        }
        
        chatReference.child("name").setValue(name)
        chatReference.child("createdAt").setValue(Date.toUTC(from: Date()))
        chatReference.child("productID").setValue(productID)
        chatReference.child("members").setValue(membersChat){ error, dbreference in
            if let error = error{
                completion(nil,ClientError.parseFirebaseError(errorCode: error._code) )
                return
            }
            FIRDatabase.database().reference().child("products").child(productID)
            FIRDatabase.database().reference().child("users").child(sellerID).child("chats").child(chatReference.key).setValue(true)
            FIRDatabase.database().reference().child("users").child(ownID).child("chats").child(chatReference.key).setValue(true){ error, dbreference in
                if let error = error{
                    completion(nil,ClientError.parseFirebaseError(errorCode: error._code) )
                    return
                }
                // This will change when first step validation is enabled
                completion(Chat(id: chatReference.key, photo: nil, name: name,productID:productID, members:[ownID,sellerID]), nil)
            }
        }
    }
    
    func joinRequest(withID id: String, completion: @escaping (JoinRequest?, ClientError?) -> ()) {
        _ = FIRDatabase.database().reference().child("join_requests").child(id).observeSingleEvent(of: .value, with:{snapshot in
            if let joinRequestJson = snapshot.value as? [String:Any]{
                guard let joinRequest = JoinRequest(JSON:joinRequestJson) else{
                    completion(nil,ClientError.unknownError)
                    return
                }
                
                self.user(withId: joinRequestJson["owner"] as! String){ user, error in
                    guard let user = user else{
                    completion(nil,ClientError.unknownError)
                        return
                    }
                    joinRequest.owner = user
                    self.user(withId: joinRequestJson["participant"] as! String){ user, error in
                        guard let user = user else{
                            completion(nil,ClientError.unknownError)
                            return
                        }
                        joinRequest.participant = user
                        self.product(withID:joinRequestJson["product"] as! String){product, error in
                            guard let product = product else{
                                completion(nil,ClientError.unknownError)
                                return
                            }
                            joinRequest.product = product
                            completion(joinRequest, nil)
                        }
                    }
                }
            }
        })
    }
    
    func joinRequest(joinRequestID: String, completion: @escaping (JoinRequest?, ClientError?) -> ()) {
        _ = FIRDatabase.database().reference().child("join_requests").child(joinRequestID).observeSingleEvent(of: .value, with:{snapshot in
            if let joinRequestJson = snapshot.value as? [String:Any]{
                guard let joinRequest = JoinRequest(JSON:joinRequestJson) else{
                    completion(nil, nil)
                    return
                }
                
                self.user(withId: joinRequestJson["owner"] as! String){ user, error in
                    guard let user = user else{ return }
                    joinRequest.owner = user
                    self.user(withId: joinRequestJson["participant"] as! String){ user, error in
                        guard let user = user else{ return }
                        joinRequest.participant = user
                        self.product(withID:joinRequestJson["product"] as! String){product, error in
                            guard let product = product else{ return }
                            joinRequest.product = product
                            completion(joinRequest, nil)
                        }
                    }
                }
            }
        })
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
    
    func products(startingAt:String) -> Observable<Product> {
        return Observable.create {[unowned self] observer in
            let url = "https://infinite-loopers.firebaseio.com/products.json"
            let parameters = ["orderBy":"\"id\"", "limitToFirst":self.itemsPerPage, "startAt":"\""+startingAt+"\""] as [String : Any]
            self.sessionManager.request(URL(string:url)!, parameters: parameters).responseValidatedJson{result in
                if result.isSuccess{
                    if let json = result.value{
                        print("products...\(json.count)")
                        self.fetchUser(fromProducts: json, atIndex: 0, observer: observer)
                    }
                }else if result.isFailure{
                    observer.onError(result.error!)
                }
            }
            return Disposables.create()
        }
    }
    
    func product(withID: String, completion: @escaping (Product?, ClientError?) -> ()) {
        FIRDatabase.database().reference().child("products").child(withID).observeSingleEvent(of: FIRDataEventType.value, with: { snapshot in
            if let productJson = snapshot.value as? [String:Any] {
                self.user(withId: productJson["seller"] as! String){user ,error in
                    if let error = error{
                        completion(nil, error)
                        return
                    }
                    completion(Product(json: productJson, seller: user!), nil)
                }
            }
        })
    }
    
    fileprivate func fetchUser(fromProducts:[String:Any], atIndex index:Int, observer:AnyObserver<Product>){
        let productJson:[String:Any] = Array(fromProducts.values)[index] as! [String : Any]
        
        self.user(withId: productJson["seller"] as! String){ user, error in
            if let error = error{
                if index == (fromProducts.count - 1){
                    observer.onError(error)
                }else{
                    self.fetchUser(fromProducts: fromProducts, atIndex: index + 1, observer: observer)
                }
                return
            }
            observer.onNext(Product(json:productJson, seller:user!))
            if(index == (fromProducts.count - 1)){
                observer.onCompleted()
            }else{
                self.fetchUser(fromProducts: fromProducts, atIndex: index + 1, observer: observer)
            }
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
    
    func publishProduct(product: [String : Any]) -> Observable<Void> {
        return Observable.create { observer in
            let dbReference = FIRDatabase.database().reference().child("products").childByAutoId()
            var product = product
            product["id"] = dbReference.key
            dbReference.setValue(product){ error, dbReference in
                if let error = error{
                    observer.onError(ClientError.parseFirebaseError(errorCode: error._code))
                    return
                }
                
                FIRDatabase.database().reference().child("users").child(product["seller"] as! String).child("products").child(dbReference.key).setValue(true)
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
    
    func requestToJoin(ownerID: String, participantID: String, product: String, completion: @escaping (Void, ClientError?) -> ()) {
        let joinRequestRef = FIRDatabase.database().reference().child("join_requests").childByAutoId()
        var newJoinRequestJson = JoinRequest(id: joinRequestRef.key).toJSON()
        newJoinRequestJson["owner"] = ownerID
        newJoinRequestJson["participant"] = participantID
        newJoinRequestJson["product"] = product
        joinRequestRef.setValue(newJoinRequestJson, withCompletionBlock: { error, _ in
            if let error = error{
                completion((), ClientError.parseFirebaseError(errorCode: error._code))
                return
            }
            _ = FIRDatabase.database().reference().child("users").child(ownerID).child("join_requests").child(joinRequestRef.key).setValue(true, withCompletionBlock: { error, _ in
                if let error = error{
                    completion((), ClientError.parseFirebaseError(errorCode: error._code))
                    return
                }
                
                _ = FIRDatabase.database().reference().child("users").child(participantID).child("join_requests").child(joinRequestRef.key).setValue(true, withCompletionBlock: { error, _ in
                    if let error = error{
                        completion((), ClientError.parseFirebaseError(errorCode: error._code))
                        return
                    }
                    
                    _ = FIRDatabase.database().reference().child("products").child(product).child("join_requests").child(joinRequestRef.key).setValue(true, withCompletionBlock: { error, _ in
                        if let error = error{
                            completion((), ClientError.parseFirebaseError(errorCode: error._code))
                            return
                        }
                        
                        completion((),nil)
                    })
                })
            })
        })
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
    
    func transaction(withID: String, completion: @escaping (Transaction?, ClientError?) -> ()) {
        FIRDatabase.database().reference().child("transactions").child(withID).observeSingleEvent(of: .value){(snapshot,x) in
            if let transactionJson = snapshot.value as? [String:Any], let transaction = Transaction(JSON:transactionJson){
                completion(transaction,nil)
            }else{
                completion(nil, ClientError.transactionNotFound)
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
    
    func uploadPicture(imageData data: Data,pictureName:String, completion: @escaping (String?, ClientError?) -> ()) {
        let imageRef = FIRStorage.storage().reference().child("profile-pictures").child(pictureName+".jpg")
        imageRef.put(data, metadata: nil){ metadata, error in
            if let error = error{
                completion(nil, ClientError.parseFirebaseError(errorCode: error._code))
                return
            }
            completion(metadata?.downloadURL()?.absoluteString, nil)
        }
        
    }
    
    func updateProfile(parameters: Parameters, completion: @escaping (Void, ClientError?) -> ()) {
        sessionManager.request(Router.updateProfile(parameters: parameters)).responseValidatedJson{
            switch $0 {
            case .success(_):
                completion((), nil)
            case .failure(let error):
                let error:ClientError = error as! ClientError
                completion((), error)
            }
        }
    }
    
    func user(withId id: String, completion:@escaping ClientCompletion<User?>){
        FIRDatabase.database().reference().child("users").child(id).observeSingleEvent(of: .value){ (snapshot,x) in
            if let user = snapshot.value as? [String:Any]{
                if let u = User(JSON:user) {
                    completion(u,nil)
                }
            }else{
                completion(nil, ClientError.userNotFound)
            }
        }
    }
}
