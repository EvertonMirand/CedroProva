//
//  SessionManager.swift
//  CedroProva
//
//  Created by Everton Miranda Vitório on 01/05/18.
//  Copyright © 2018 Everton Miranda Vitório. All rights reserved.
//

import UIKit
import Alamofire

class SessionManager: NSObject {
    public static var manager: Alamofire.SessionManager = {
        
        // Create the server trust policies
        let serverTrustPolicies: [String: ServerTrustPolicy] = [
            "https://dev.people.com.ai/": .disableEvaluation
        ]
        
        // Create custom manager
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = Alamofire.SessionManager.defaultHTTPHeaders
        let manager = Alamofire.SessionManager(
            configuration: URLSessionConfiguration.default,
            serverTrustPolicyManager: ServerTrustPolicyManager(policies: serverTrustPolicies)
        )
        
        return manager
    }()
}
