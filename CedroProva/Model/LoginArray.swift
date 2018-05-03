//
//  LoginMArray.swift
//  CedroProva
//
//  Created by Everton Miranda Vitório on 02/05/18.
//  Copyright © 2018 Everton Miranda Vitório. All rights reserved.
//

import UIKit

class LoginArray: Codable {
    var logins: [Login]?
    init(logins: [Login]) {
        self.logins = logins
    }

}
