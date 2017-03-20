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
    case transactionNotFound
    
    var errorDescription:String {
        switch self {
        case .invalidCredentials:
            return NSLocalizedString("error_invalid_credentials", comment: "error_invalid_credentials")
        case .unknownError:
            return NSLocalizedString("error_unknown_error", comment: "error_unknown_error")
        case .userNotFound:
            return NSLocalizedString("error_user_not_found", comment: "error_user_not_found")
        case .accountDisabled:
            return NSLocalizedString("error_account_disabled", comment: "error_account_disabled")
        case .emailAlreadyInUse:
            return NSLocalizedString("error_email_already_in_use", comment: "error_email_already_in_use")
        case .wrongPassword:
            return NSLocalizedString("error_wrong_password", comment: "error_wrong_password")
        case .weakPassword:
            return NSLocalizedString("error_weak_password", comment: "error_weak_password")
        case .failedLoginWithFacebook:
            return NSLocalizedString("error_login_with_facebook", comment: "error_login_with_facebook")
        case .logInCanceled:
            return NSLocalizedString("error_login_canceled", comment: "error_login_canceled")
        case .invalidEmail:
            return NSLocalizedString("error_invalid_email", comment: "error_invalid_email")
        case .invalidParameters:
            return NSLocalizedString("error_invalid_parameters", comment: "error_invalid_parameters")
        case .transactionNotFound:
            return NSLocalizedString("error_transaction_not_found", comment: "error_transaction_not_found")
            
        }
    }
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

