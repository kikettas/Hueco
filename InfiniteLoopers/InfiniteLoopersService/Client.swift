//
//  NetworkManager.swift
//  InfiniteLoopers
//
//  Created by Enrique del Pozo Gómez on 2/10/17.
//  Copyright © 2017 Infinite Loopers. All rights reserved.
//

import Foundation
import Alamofire
import Firebase
import RxCocoa
import RxSwift

typealias ClientCompletion<T> = (T,ClientError?) -> ()
typealias JSON = [String:Any?]

protocol ClientProtocol {
    
    var itemsPerPage:Int { get }
    
    func isAccessTokenAvailable() -> Bool
    
    // API
    func chats(withChatIDs ids:[String]) -> Observable<Chat>
    func check(nickName:String, completion: @escaping ClientCompletion<Bool>)
    func join(ownID:String, sellerID: String, name:String, chatID:String?, productID:String) -> Observable<Chat>
    func logIn(withEmail: String, password:String, completion:@escaping ClientCompletion<Void>)
    func logIn(withCredential: FIRAuthCredential, completion:@escaping ClientCompletion<Void>)
    func logInWithFacebook(from: UIViewController, completion:@escaping ClientCompletion<Void>)
    func logInWithGoogle(from: UIViewController, completion: @escaping ClientCompletion<Void>)
    func products(startingAt:Any) -> Observable<Product>
    func product(withID:String, completion: @escaping ClientCompletion<Product?>)
    func productKeys(completion: @escaping ClientCompletion<[String]>)
    func publishProduct(product:[String:Any]) -> Observable<Void>
    func refreshAccessToken(completion:@escaping ClientCompletion<String?>)
    func sendResetPaswordTo(email:String, completion:@escaping ClientCompletion<Void>)
    func signOut(completion:@escaping ClientCompletion<Void>)
    func signUp(withEmail: String, password:String, nickName:String, completion:@escaping ClientCompletion<Void>)
    func transaction(withID:String, completion:@escaping ClientCompletion<Transaction?>)
    func updateEmail(withEmail: String,completion:@escaping ClientCompletion<Void>)
    func updatePassword(withPassword: String,completion:@escaping ClientCompletion<Void>)
    func user(withId id:String, completion:@escaping ClientCompletion<User?>)
}

class Client: ClientProtocol {
    static let shared:Client = Client()
    
    let authHandler:AuthHandler
    var googleLoginDelegate:GoogleLoginDelegate!
    var sessionManager:SessionManager
    var itemsPerPage: Int
    
    private init(sessionManager: SessionManager = SessionManager()) {
        authHandler = AuthHandler()
        self.sessionManager = sessionManager
        self.sessionManager.adapter = authHandler
        self.sessionManager.retrier = authHandler
        self.itemsPerPage = 10
    }
    
    
    func refreshAccessToken(completion: @escaping (String?, ClientError?) -> ()) {
        if let user = FIRAuth.auth()?.currentUser{
            user.getTokenForcingRefresh(true){ idToken, error in
                if let error = error{
                    completion(nil, ClientError.parseFirebaseError(errorCode: error._code))
                    return
                }
                completion(idToken, nil)
            }
        }else{
            completion(nil,ClientError.userNotFound)
        }
    }
    
    func isAccessTokenAvailable() -> Bool {
        return authHandler.accessToken != nil
    }
}


extension DataRequest{
    
    func responseValidatedJson(_ callback: @escaping (Result<JSON>) -> ()) {
        self.validate().responseJSON { response in
            if(response.result.isSuccess){
                print("✅ Success request: ➡️ \(response.request!)")
                callback(.success(response.result.value as! JSON))
            }else if(response.result.isFailure){
                if(response.response?.statusCode == 200){
                    print("✅ Success request: ➡️ \(response.request!)")
                    callback(.success(response.result.value as! JSON))
                }else{
                    print("❌ Failure (\(response.response?.statusCode)) request: ➡️ \(response.request!)")
                    
                    if let data = response.data, let jsonError:JSON = try! JSONSerialization.jsonObject(with: data, options: []) as? JSON{
                        let error = ClientError.parseErrorFromAPI(message: jsonError["message"] as! String)
                        print("❌ Error: \(error)")
                        callback(.failure(error))
                        return
                    }
                    callback(.failure(ClientError.unknownError))
                }
            }
        }
    }
}
