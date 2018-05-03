//
//  RegexValidator.swift
//  CedroProva
//
//  Created by Everton Miranda Vitório on 01/05/18.
//  Copyright © 2018 Everton Miranda Vitório. All rights reserved.
//

import UIKit

class RegexValidator: NSObject {
    // Verficar se o e-mail é valido
    static func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    // Verificar se a senha é valida
    static func isValidPassword(testStr:String) -> Bool {
        let passwordRegEx = "^(?=.*[A-Z])(?=.*[a-z])(?=.*[!@#$&*])(?=.*[0-9]).{10,}$"
        let passwordTest = NSPredicate(format:"SELF MATCHES %@", passwordRegEx)
        return passwordTest.evaluate(with: testStr)
    }
    
    // Verificar se a url é valida
    static func isValidURL(testStr:String) -> Bool {
        let urlRegEx = "((?:http|https)://)?(?:www\\.)?[\\w\\d\\-_]+\\.\\w{2,3}(\\.\\w{2})?(/(?<=/)(?:[\\w\\d\\-./_]+)?)?"
        let urlTest = NSPredicate(format:"SELF MATCHES %@", urlRegEx)
        return urlTest.evaluate(with: testStr)
    }
}
