//
//  TouchID.swift
//  CedroProva
//
//  Created by Everton Miranda Vitório on 01/05/18.
//  Copyright © 2018 Everton Miranda Vitório. All rights reserved.
//

import UIKit
import LocalAuthentication

class TouchIDAuth: NSObject {
    static func authWithTouchID(viewController: UIViewController, showSucess: Bool, callback: @escaping (Bool) -> ()){
        let context = LAContext()
        var error: NSError?
        
        // check if Touch ID is available
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Authenticate with Touch ID"
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { (succes, error) in
                if succes {
                    DispatchQueue.main.async(){
                        if showSucess{
                            Alert.showAlertController("Autentificação com o Touch ID sucedida", viewController: viewController)
                        }
                        callback(true)
                    }
                }
                else {
                    DispatchQueue.main.async(){
                        Alert.showAlertController("Falhou a conexão com o Touch ID", viewController: viewController)
                        callback(false)
                    }
                }
            }
        }
        else {
            DispatchQueue.main.async(){
                Alert.showAlertController("Touch ID não disponivel", viewController: viewController)
            }
        }
        
    }
}
