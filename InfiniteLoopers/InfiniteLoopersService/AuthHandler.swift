//
//  AuthHandler.swift
//  InfiniteLoopers
//
//  Created by Enrique del Pozo Gómez on 2/10/17.
//  Copyright © 2017 Infinite Loopers. All rights reserved.
//

import Foundation
import Alamofire


class AuthHandler:RequestAdapter, RequestRetrier {
    private typealias RefreshCompletion = (_ succeeded: Bool, _ accessToken: String?) -> Void
    
    private let lock = NSLock()
    
    private(set) var accessToken:String? = nil
    private(set) var refreshingToken: Bool = false
    private var requestsToRetry: [RequestRetryCompletion] = []
    
    func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        var urlRequest = urlRequest
        if let urlString = urlRequest.url?.absoluteString, urlString.hasPrefix(Router.baseURLString), accessToken != nil{
            urlRequest.setValue(accessToken!, forHTTPHeaderField: "x-access-token")
        }
        
        return urlRequest
    }
    
    func should(_ manager: SessionManager, retry request: Request, with error: Error, completion: @escaping RequestRetryCompletion) {
        lock.lock() ; defer { lock.unlock() }
        
        if let response = request.task?.response as? HTTPURLResponse, response.statusCode == 403, !(request.request?.url?.absoluteString.contains("token"))! {
            if(request.retryCount < 1){
                requestsToRetry.append(completion)
            }
            if !refreshingToken {
                refreshToken {[weak self] succeeded, accessToken in
                    guard let `self` = self else {
                        return
                    }
                    
                    self.lock.lock() ; defer { self.lock.unlock() }
                    
                    if let accessToken = accessToken{
                        self.accessToken = accessToken
                    }
                    
                    self.requestsToRetry.forEach { $0(succeeded, 0.0) }
                    self.requestsToRetry.removeAll()
                }
            }
        }else{
            completion(false, 0.0)
        }
    }
    
    private func refreshToken(completion: @escaping RefreshCompletion) {
        guard !refreshingToken else { return }
        
        refreshingToken = true
        
        Client.shared.refreshAccessToken { [weak self] token, error in
            guard let `self` = self else {
                return
            }
            if let _ = error{
                completion(false, nil)
                return
            }
            
            completion(true, token)
            self.refreshingToken = false
            
        }
    }
}
