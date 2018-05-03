//
//  ValEntry.swift
//  CedroProva
//
//  Created by Everton Miranda Vitório on 01/05/18.
//  Copyright © 2018 Everton Miranda Vitório. All rights reserved.
//

import UIKit

class ValEntry: NSObject {
    // Validar as entradas de email e senha
    static func validateEntrys(email: String, password: String, controller: UIViewController)-> Bool{
        if RegexValidator.isValidEmail(testStr: email){
            
            if RegexValidator.isValidPassword(testStr: password){
                return true
            }else{
                Alert.showAlertController("Senha invalida! Deve conter ao menos uma letra maiuscula uma minuscula um numero e um caracter especial e ser maior que 10.", viewController: controller)
            }
        }else{
            Alert.showAlertController("E-Mail invalido!", viewController: controller)
        }
        return false
    }
}
