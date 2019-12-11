//
//  LoginError.swift
//  Dizzy
//
//  Created by ジャティン on 2019/11/15.
//

import Foundation

/**
 An error produced by a Provider on redirecting back to the app. Error domain is "Dizzy"
 */

public class LoginError: NSError {
    /// An error that should never happen. If seen, please open a GitHub issue.
    public static let InternalSDKError = LoginError(code: 0, description: "Internal SDK Error")
    
    /**
     Initializer for LoginError
     
     - parameters:
     - code: Error code for the error
     - description: Localized description of the error.
     */
    public init(code: Int, description: String) {
        var userInfo = [String: Any]()
        userInfo[NSLocalizedDescriptionKey] = description
        
        super.init(domain: "Dizzy", code: code, userInfo: userInfo)
    }
    
    /// Unimplemented stub since NSError implements  requires this init method.
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
