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


typealias ClientCompletion<T> = (T,ClientError?) -> ()
typealias JSON = [String:Any?]

protocol ClientProtocol {
    init(sessionManager:SessionManager)
    
    // API
    func check(nickName:String, completion: @escaping ClientCompletion<Bool>)
    func logIn(withEmail: String, password:String, completion:@escaping ClientCompletion<User?>)
    func logIn(withCredential: FIRAuthCredential, completion:@escaping ClientCompletion<User?>)
    func logInWithFacebook(from: UIViewController, completion:@escaping ClientCompletion<User?>)
    func logInWithGoogle(from: UIViewController, completion: @escaping ClientCompletion<User?>)
    func signOut(completion:@escaping ClientCompletion<Void>)
    func signUp(withEmail: String, password:String, nickName:String, completion:@escaping ClientCompletion<User?>)
    func updateEmail(withEmail: String,completion:@escaping ClientCompletion<Void>)
    func updatePassword(withPassword: String,completion:@escaping ClientCompletion<Void>)
    func sendResetPaswordTo(email:String, completion:@escaping ClientCompletion<Void>)

}

class Client: ClientProtocol {
    
    let authHandler:AuthHandler
    var googleLoginDelegate:GoogleLoginDelegate!
    var sessionManager:SessionManager

    required public init(sessionManager: SessionManager = SessionManager()) {
        authHandler = AuthHandler()
        self.sessionManager = sessionManager
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
