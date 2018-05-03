//
//  Login.swift
//  CedroProva
//
//  Created by Everton Miranda Vitório on 01/05/18.
//  Copyright © 2018 Everton Miranda Vitório. All rights reserved.
//

import UIKit

class Login: Codable {
    var login: String?
    var url: String?
    
    init(login: String, url: String) {
        
        self.login = login
        self.url = url
    }
}

extension Login: Equatable{
    static func == (lhs: Login, rhs: Login) -> Bool {
        return lhs.login == rhs.login && lhs.url == rhs.url
    }
}
