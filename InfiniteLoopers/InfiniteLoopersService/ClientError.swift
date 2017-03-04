//
//  ClientError.swift
//  InfiniteLoopers
//
//  Created by Enrique del Pozo Gómez on 2/25/17.
//  Copyright © 2017 Infinite Loopers. All rights reserved.
//

import Foundation
import Firebase
import GoogleSignIn

public enum ClientError:Error{
    case invalidCredentials
    case unknownError
    case userNotFound
    case accountDisabled
    case emailAlreadyInUse
    case wrongPassword
    case weakPassword
    case failedLoginWithFacebook
    case logInCanceled
    case invalidEmail
    case invalidParameters
}

// MARK: - Firebase Errors

extension ClientError{
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
        case .errorCodeInvalidEmail:
            return .invalidEmail
        default:
            return .unknownError
        }
    }
}

// MARK: - Google SignIn Errors

extension ClientError{
    static func parseGoogleSignInError(errorCode:Int) -> ClientError{
        guard let error = GIDSignInErrorCode(rawValue: errorCode) else{
            return .unknownError
        }
        switch error{
        case .canceled:
            return .logInCanceled
        case .unknown:
            return .unknownError
        default:
            return .unknownError
        }
    }
    
    static func parseErrorFromAPI(message:String) -> ClientError{
        switch message {
        case "Invalid parameters":
            return .invalidParameters
        default:
            return .unknownError
        }
    }
}

