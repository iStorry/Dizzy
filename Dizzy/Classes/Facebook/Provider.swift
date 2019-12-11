//
//  Provider.swift
//  Dizzy
//
//  Created by ジャティン on 2019/11/15.
//

import Foundation

/**
 A Provider represents an external login provider that needs to be opened.
 */
public protocol Provider {
    /// The URL to redirect to when beginning the login process
    var authorizationURL: URL { get }
    
    /// The URL Scheme that this LoginProvider is bound to.
    var urlScheme: String { get }
    
    /**
     Called when the external login provider links back into the application
     with a URL Scheme matching the login provider's URL Scheme.
     
     - parameters:
       - url: The URL that triggered that AppDelegate's link handler
       - callback: A callback that returns with an access token or NSError.
     */
    func linkHandler(_ url: URL, callback: @escaping ExternalLoginCallback)
}

public extension Provider {
    func login(_ callback: @escaping ExternalLoginCallback) {
        DizzyLogin.login(self, callback: callback)
    }
}
