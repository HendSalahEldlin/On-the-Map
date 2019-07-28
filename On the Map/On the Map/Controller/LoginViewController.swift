//
//  ViewController.swift
//  On the Map
//
//  Created by Hend  on 7/18/19.
//  Copyright © 2019 Hend . All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var txtUserName: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var lblDebug: UILabel!
    @IBOutlet weak var btnSignUp: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnSignUp.titleLabel?.textAlignment = .left
    }
    
    @IBAction func btnLoginPressed(_ sender: Any) {
        
        guard txtUserName.text != "" && txtPassword.text != "" else {
            self.lblDebug.text = "Login failed: Empty username or password!"
            return
        }
        
        OnTheMapClient.sharedInstance().login(userName: txtUserName.text!, password: txtPassword.text!){(success, errorString) in
            DispatchQueue.main.async {
                if success{
                    self.completeLogin()
                }else{
                    self.lblDebug.text = "Login Faild: The Email or password is invalid \nDetail: \(errorString)"
                }
            }
        }
    }
    
    func completeLogin() {
        lblDebug.text = ""
        let controller = storyboard!.instantiateViewController(withIdentifier: "ManagerNavigationController") as! UINavigationController
        present(controller, animated: true, completion: nil)
    }
}

