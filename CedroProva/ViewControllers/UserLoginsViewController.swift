//
//  UserLoginsViewController.swift
//  CedroProva
//
//  Created by Everton Miranda Vitório on 01/05/18.
//  Copyright © 2018 Everton Miranda Vitório. All rights reserved.
//

import UIKit
import KeychainSwift
import DefaultsKit
import Alamofire


class UserLoginsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var loginTableView: UITableView?
    var email: String?
    var token: String?
    var logins: LoginArray?
    var password: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        
        self.loginTableView?.delegate = self
        self.loginTableView?.dataSource = self
        self.loginTableView?.tableFooterView = UIView()
        self.checkHasTouch()
        
        let key = Key<LoginArray>(email!)
        self.logins = Defaults().get(for: key)
        self.loginTableView?.reloadData()
        self.loginTableView?.estimatedRowHeight = 116
        self.loginTableView?.rowHeight = UITableViewAutomaticDimension
    }
    
    func checkHasTouch(){
        if let email = self.email{
            let useTouch = UserDefaults().object(forKey: "\(email)_use_touch_id") as? Bool
            if useTouch == nil || !useTouch!{
                self.willUseTouch(email: email)
            }
        }
    }
    
    func willUseTouch(email: String){
        TouchIDAuth.authWithTouchID(viewController: self, showSucess: true) { (response) in
            if response{
                UserDefaults().setValue(true, forKey: "\(email)_use_touch_id")
                KeychainSwift().set(self.password!, forKey: "\(email)_password")
                print(KeychainSwift().get("\(email)_password")!)
                print("\(email)_password")
            }else{
                UserDefaults().setValue(false, forKey: "\(email)_use_touch_id")
            }
            self.password = ""
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let logins = self.logins{
            return logins.logins!.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.loginCell, for: indexPath) as! LoginTableViewCell
        let login = self.logins!.logins![indexPath.row]
        let resource = URL(string: "\(JSon.logo)\(login.url!)")
        SessionManager.manager.request(resource!, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: ["authorization":self.token!]).responseData { (response) in
            switch response.result{
            case .success:
                if let image = UIImage(data: response.result.value!){
                    cell.bannerImage.image = image
                }
                
            case .failure:
                print(response.result.value!)
            }
        }
        
        cell.loginLabel.text = login.login
        cell.urlLabel.text = login.url
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 116
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Storyboard.loginSave{
            if let saveVC = segue.destination as? SaveUserLoginViewController{
                saveVC.email = self.email
                saveVC.logins = self.logins
            }
        }else if segue.identifier == Storyboard.loginInfoSegue{
            if let loginInfoVC = segue.destination as? LoginInfoViewController{
                let index = self.loginTableView?.indexPathForSelectedRow
                let login = self.logins?.logins![(index?.row)!]
                loginInfoVC.email = self.email
                loginInfoVC.login = login
                loginInfoVC.index = index?.row
            }
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            
            if self.logins?.logins != nil{
                if let login = self.logins?.logins![indexPath.row]{
                    KeychainSwift().delete("\(self.email!)_\((login.login?.lowercased())!)_\((login.url?.lowercased())!)")
                    self.logins?.logins?.remove(at: indexPath.row)
                    let defaults = Defaults()
                    let key = Key<LoginArray>(email!)
                    
                    defaults.set(self.logins!, for: key)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                }
                
            }
            
        }
    }
    
    @IBAction func logout(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
}
