//
//  Alert.swift
//  CedroProva
//
//  Created by Everton Miranda Vitório on 01/05/18.
//  Copyright © 2018 Everton Miranda Vitório. All rights reserved.
//

import UIKit

class Alert: NSObject {
    
    
    static func showAlertController(_ message: String, viewController: UIViewController) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        viewController.present(alertController, animated: true, completion: nil)
        
    }
}
