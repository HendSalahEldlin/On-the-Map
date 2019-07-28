//
//  ManagerTabBarController.swift
//  On the Map
//
//  Created by Hend  on 7/19/19.
//  Copyright © 2019 Hend . All rights reserved.
//

import UIKit
class ManagerTabBarController:UITabBarController{
    
    @IBAction func btnLogoutPressed(_ sender: Any) {
        OnTheMapClient.sharedInstance().DeleteSession(){(success, errorMessage) in
            if success{
                DispatchQueue.main.async {
                    self.completeLogout()
                }
            }else{
                print(errorMessage)
            }
        }
    }
    
    func completeLogout() {
        let controller = storyboard!.instantiateViewController(withIdentifier: "LoginViewController") as! UIViewController
        present(controller, animated: true, completion: nil)
    }
}
