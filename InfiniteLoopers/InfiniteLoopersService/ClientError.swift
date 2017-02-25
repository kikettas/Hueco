//
//  ClientError.swift
//  InfiniteLoopers
//
//  Created by Enrique del Pozo Gómez on 2/25/17.
//  Copyright © 2017 Infinite Loopers. All rights reserved.
//

import Foundation
import Firebase

public enum ClientError{
    case invalidCredentials
    case unknownError
    case userNotFound
    case accountDisabled
    case emailAlreadyInUse
    case wrongPassword
    case weakPassword
    
    
    static func parseFirebaseError(errorCode:Int) -> ClientError{
        
        guard let error = FIRAuthErrorCode(rawValue: errorCode) else{
            return .unknownError
        }
        
        switch error{
        case .errorCodeInvalidCredential:
            return .invalidCredentials
        case .errorCodeUserNotFound:
            return .userNotFound
        case .errorCodeEmailAlreadyInUse:
            return .emailAlreadyInUse
        case .errorCodeUserDisabled:
            return .accountDisabled
        case .errorCodeWrongPassword:
            return .wrongPassword
        case .errorCodeWeakPassword:
            return .weakPassword
        default:
            return .unknownError
        }
    }
}
