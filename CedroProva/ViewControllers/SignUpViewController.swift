//
//  SignUpViewController.swift
//  CedroProva
//
//  Created by Everton Miranda Vitório on 01/05/18.
//  Copyright © 2018 Everton Miranda Vitório. All rights reserved.
//

import UIKit
import TweeTextField
import Alamofire

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var nameText: TweeActiveTextField!
    
    @IBOutlet weak var emailText: TweeActiveTextField!
    
    @IBOutlet weak var passwordText: TweeActiveTextField!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    var token: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.signUpButton.layer.cornerRadius = 12
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.nameText.text = ""
        self.emailText.text = ""
        self.passwordText.text = ""
    }
    
    private func parameters()-> [String: String]{
        return  ["email":self.emailText.text!.trimmingCharacters(in: .whitespacesAndNewlines),"name":self.nameText.text!.trimmingCharacters(in: .whitespacesAndNewlines),"password":self.passwordText.text!]
    }
    
    
    @IBAction func signUp(_ sender: Any) {
        let parameters = self.parameters()
        //var touchSucess = false
        let name = self.nameText.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        if name != ""{
            if ValEntry.validateEntrys(email: self.emailText.text!.trimmingCharacters(in: .whitespacesAndNewlines), password: self.passwordText.text!, controller: self){
                SessionManager.manager.request(JSon.signUp, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: ["Content-Type":"application/json"]).responseJSON{ (response) in
                    switch response.result{
                    case .success:
                        let dict = response.result.value as? NSDictionary
                        // Tratar as chaves que são retornadas pela api
                        self.token = dict!["token"] as? String
                        let errors = dict!["errors"] as? NSArray
                        let error = dict!["message"] as? String
                        if self.token != nil{
                            self.performSegue(withIdentifier: Storyboard.signUserSegue, sender: self)
                        }else if errors != nil{
                            Alert.showAlertController(errors![0] as! String, viewController: self)
                        }else if error != nil{
                            Alert.showAlertController(error!, viewController: self)
                        }
                        
                    case .failure(let error):
                        Alert.showAlertController("Erro na hora de cadastrar! \(error)", viewController: self)
                    }
                }
            }
            
        }else{
            Alert.showAlertController("Nome não pode ficar em branco", viewController: self)
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Storyboard.signUserSegue{
            if (self.token != nil){
                if let navController = segue.destination as? UINavigationController{
                    if let userLogVc = navController.topViewController as? UserLoginsViewController{
                        
                        userLogVc.email = self.emailText.text?.trimmingCharacters(in: .whitespacesAndNewlines)
                        userLogVc.token = self.token
                        userLogVc.password = self.passwordText.text
                    }
                }
                
            }
        }
    }
    
    
    
}
