//
//  SaveUserLoginViewController.swift
//  CedroProva
//
//  Created by Everton Miranda Vitório on 01/05/18.
//  Copyright © 2018 Everton Miranda Vitório. All rights reserved.
//

import UIKit
import TweeTextField
import DefaultsKit
import KeychainSwift


class SaveUserLoginViewController: UIViewController {
    
    var email: String?
    var logins: LoginArray?
    var loginsMutable: NSMutableArray?
    @IBOutlet var loginText: TweeActiveTextField?
    
    @IBOutlet var urlText: TweeActiveTextField?
    @IBOutlet var passwordText: TweeActiveTextField?
    
    @IBOutlet weak var saveButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.saveButton.layer.cornerRadius = 12
        if logins?.logins != nil{
            loginsMutable = NSMutableArray(array: (logins?.logins)!)
        }
    }
    
    @IBAction func save(_ sender: Any) {
        if let login = loginText?.text?.trimmingCharacters(in: .whitespacesAndNewlines){
            if let url = urlText?.text?.trimmingCharacters(in: .whitespacesAndNewlines){
                if let password = passwordText?.text {
                    if password.trimmingCharacters(in: .whitespacesAndNewlines) != ""{
                        if RegexValidator.isValidURL(testStr: url){
                            let keychain = KeychainSwift()
                            if keychain.get("\(email!)_\(login.lowercased())_\(url.lowercased())") == nil{
                                
                                self.saveDefaults(login: login, url: url)
                                // Senha do login salva com a chave do email da pessoa + o login + a url do site
                                keychain.set(password, forKey: "\(email!)_\(login.lowercased())_\(url.lowercased())")
                                self.navigationController?.popViewController(animated: true)
                            }else{
                                Alert.showAlertController("Dados já cadastrados", viewController: self)
                            }
                        }else{
                            Alert.showAlertController("URL invalida", viewController: self)
                        }
                    }else{
                        Alert.showAlertController("Senha não pode ser vazia", viewController: self)
                    }
                    
                }
            }
        }
    }
    
    
    // Salvar dados no userDefaults
    func saveDefaults(login: String, url: String){
        let loginSave = Login(login: login, url: url)
        if self.loginsMutable != nil{
            self.loginsMutable?.add(loginSave)
        }else{
            let loginTemp = NSArray(object: loginSave)
            self.loginsMutable = NSMutableArray(array: loginTemp)
        }
        let defaults = Defaults()
        let logins = LoginArray(logins: self.loginsMutable as! [Login])
        let key = Key<LoginArray>(email!)
        defaults.set(logins, for: key)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
}
