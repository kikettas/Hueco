//
//  Client+Endpoint.swift
//  InfiniteLoopers
//
//  Created by Enrique del Pozo Gómez on 3/4/17.
//  Copyright © 2017 Infinite Loopers. All rights reserved.
//

import Foundation
import Alamofire

enum Router:URLRequestConvertible{
    case checkNickName(parameters:Parameters)
    case signUp(parameters:Parameters)
    case updateProfile(parameters:Parameters)
    
    static let baseURLString = "https://api.infiniteloopers.site/v1"
    
    var method:HTTPMethod{
        switch self {
        case .checkNickName:
            return .get
        case .signUp:
            return .post
        case .updateProfile:
            return .put
        }
    }
    
    var path:String{
        switch self {
        case .checkNickName:
            return "check/nickname"
        case .signUp, .updateProfile:
            return "users"
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = try Router.baseURLString.asURL()
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        
        switch self {
        case .checkNickName(let parameters):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
        case .signUp(let parameters):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
        case .updateProfile(let parameters):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
        }
        
        return urlRequest
    }

}
