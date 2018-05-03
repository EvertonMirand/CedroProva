//
//  LoginInfoViewController.swift
//  CedroProva
//
//  Created by Everton Miranda Vitório on 02/05/18.
//  Copyright © 2018 Everton Miranda Vitório. All rights reserved.
//

import UIKit
import KeychainSwift
import TweeTextField
import DefaultsKit

class LoginInfoViewController: UIViewController, UITextFieldDelegate{
    
    var login: Login?
    var email: String?
    var index: Int?
    
    @IBOutlet weak var loginText: TweeActiveTextField!
    
    @IBOutlet weak var urlText: TweeActiveTextField!
    
    @IBOutlet weak var passwordText: TweeActiveTextField!
    
    
    @IBOutlet weak var showPasswordButton: UIButton!
    
    
    @IBOutlet weak var editButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.editButton.layer.cornerRadius = 12
        self.loginText.text = login?.login
        self.loginText.delegate = self
        self.urlText.text = login?.url
        self.passwordText.isSecureTextEntry = true
        if let login = self.login{
            let password = KeychainSwift().get("\(self.email!)_\((login.login?.lowercased())!)_\((login.url?.lowercased())!)")
            self.passwordText.text = password
        }
        
    }
    
    // Esconder e mostrar a senha
    @IBAction func showHidePassword(_ sender: Any) {
        if self.passwordText.isSecureTextEntry == true{
            self.passwordText.isSecureTextEntry = false
            self.showPasswordButton.setTitle("Ocultar senha", for: .normal)
        }else{
            self.passwordText.isSecureTextEntry = true
            self.showPasswordButton.setTitle("Mostrar senha", for: .normal)
            
        }
    }
    
    // Confirmar ou negar a edição dos dados do login
    @IBAction func editLogin(_ sender: Any) {
        if let password = passwordText.text{
            if let login = loginText.text?.trimmingCharacters(in: .whitespacesAndNewlines){
                if let url = urlText.text?.trimmingCharacters(in: .whitespacesAndNewlines){
                    let loginEdit = Login(login: login, url: url)
                    if loginEdit==self.login || KeychainSwift().get("\(email!)_\(login.lowercased())_\(url.lowercased())") == nil {
                        if password.trimmingCharacters(in: .whitespacesAndNewlines) != ""{
                            self.changeLogin(login: login, url: url, loginEdit: loginEdit)
                            self.keychainAjust(password: password, key: "\(email!)_\(login.lowercased())_\(url.lowercased())")
                            self.navigationController?.popViewController(animated: true)
                        }else{
                            Alert.showAlertController("Senha não pode ser vazia", viewController: self)
                        }
                    }else{
                        Alert.showAlertController("Dados já cadastrados", viewController: self)
                    }
                    
                }
            }
        }
    }
    
    // Editar os dados sobre o login
    func changeLogin(login: String, url: String, loginEdit: Login){
        if loginEdit != self.login{
            let key = Key<LoginArray>(email!)
            let defaults = Defaults()
            let logins = defaults.get(for: key)
            let mutableTemp = NSMutableArray(array: (logins?.logins)!)
            mutableTemp.replaceObject(at: self.index!, with: loginEdit)
            logins?.logins = mutableTemp as? [Login]
            defaults.set(logins!, for: key)
        }
    }
    
    // Arrumar os dados da senha no keychain
    // Apenas troca a senha caso a senha do text view seja diferente da senha cadastrada anteriormente
    func keychainAjust(password:String ,key: String){
        
        KeychainSwift().delete("\(self.email!)_\((self.login?.login?.lowercased())!)_\((self.login?.url?.lowercased())!)")
        KeychainSwift().set(password, forKey: key)
        
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.text=textField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    // Copiar a senha para o clipboard
    @IBAction func copyPassword(_ sender: Any) {
        UIPasteboard.general.string = self.passwordText.text
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    
}
