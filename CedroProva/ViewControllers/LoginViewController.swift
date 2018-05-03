//
//  ViewController.swift
//  CedroProva
//
//  Created by Everton Miranda Vitório on 30/04/18.
//  Copyright © 2018 Everton Miranda Vitório. All rights reserved.
//

import UIKit
import Alamofire
import LocalAuthentication
import TweeTextField
import KeychainSwift


class LoginViewController: UIViewController {
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var touchButton: UIButton!
    
    @IBOutlet weak var emailText: TweeActiveTextField!
    @IBOutlet weak var passwordText: TweeActiveTextField!
    var token: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loginButton.layer.cornerRadius = 12
        self.touchButton.layer.cornerRadius = 12
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.emailText.text = ""
        self.passwordText.text = ""
        
    }
    
    private func parameters(password: String)-> [String: String]{
        return ["email":self.emailText.text!.trimmingCharacters(in: .whitespacesAndNewlines),"password":password]
    }
    @IBAction func touch(_ sender: Any) {
        tryTouchLogin()
    }
    
    func tryTouchLogin(){
        if let email = self.emailText.text?.trimmingCharacters(in: .whitespacesAndNewlines){
            let usesTouch = UserDefaults().object(forKey: "\(email)_use_touch_id") as? Bool
            if usesTouch != nil && usesTouch!{
                
                self.touchPassword(email: email)
                
            }else{
                Alert.showAlertController("Usuario não cadastrado ou que não cadastrou o Touch ID", viewController: self)
            }
        }else{
            
        }
        
        
    }
    
    // Recuperar a senha atraves do touch id
    func touchPassword(email: String){
        TouchIDAuth.authWithTouchID(viewController: self, showSucess: false) { (response) in
            if response{
                
                self.loginSend(passw: KeychainSwift().get("\(email)_password"))
            }
        }
    }
    
    func loginSend(passw: String?){
        var password: String
        if passw == nil{
            password = self.passwordText.text!
        }else{
            password = passw!
        }
        print(password)
        let email = self.emailText.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if ValEntry.validateEntrys(email: email!, password: password, controller: self){
            let postParam = self.parameters(password: password)
            SessionManager.manager.request(JSon.login, method: .post, parameters: postParam, encoding: JSONEncoding.default, headers: ["Content-Type":"application/json"]).responseJSON{ (response) in
                switch response.result{
                case .success:
                    let dict = response.result.value as? NSDictionary
                    self.token = dict!["token"] as? String
                    if self.token != nil{
                        self.performSegue(withIdentifier: Storyboard.userLoginSegue, sender: self)
                    }else{
                        Alert.showAlertController(dict!["message"] as! String, viewController: self)
                    }
                case .failure:
                    Alert.showAlertController("Error na hora de fazer o login", viewController: self)
                }
            }
            
        }
    }
    
    @IBAction func login(_ sender: Any) {
        
        self.loginSend(passw: nil)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Storyboard.userLoginSegue{
            if (self.token != nil){
                if let navController = segue.destination as? UINavigationController{
                    if let userLogVc = navController.topViewController as? UserLoginsViewController{
                        userLogVc.email = self.emailText.text
                        userLogVc.token = self.token
                        userLogVc.password = self.passwordText.text
                    }
                }
                
            }
        }
    }
    
    
    
}


