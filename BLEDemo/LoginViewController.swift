//
//  LoginViewController.swift
//  BLEDemo
//
//  Created by Thomas Mactaggart on 10/4/22.
//  Copyright © 2022 Rick Smith. All rights reserved.
//

import Foundation
import UIKit
import CoreBluetooth



class LoginViewController: UIViewController {
    /*var finalURL:NSString = "\(Settings.webServerLoginURL)?username=\(username)&password=\(password)"

            LoginService.requestLoginWithURL(NSURL(string: finalURL as String)!, completionHandler: { (success) -> Void in
                if (success) {
                    NSLog("Login OK")

                    /* Scarica dal database i tasks di LoggedUser.id */
                    /* Redirect al tab HOME dell'applicazione dove si mostrano il numero di task
                    di quell'utente ed in cima "BENVENUTO: name surname" */


                }

                else {
                    self.alertView.title = "Autenticazione fallita!"
                    self.alertView.message = "Username o passowrd."
                    self.alertView.delegate = self
                    self.alertView.addButtonWithTitle("OK")
                    self.alertView.show()
                }*/
    
    @IBOutlet weak var loginBorder: UIView!
    
    
    @IBOutlet weak var signIn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        loginBorder.layer.masksToBounds = true
        loginBorder.layer.cornerRadius = loginBorder.frame.height / 8
    }
    
    /*var storyBoard = UIStoryboard(name: "SecondStoryboard", bundle: nil)*/
    
    
    /*var tabbar: UITabBarController? = (storyBoard.instantiateViewController(withIdentifier: "tabbar") as? UITabBarController)
    navigationController?.pushViewController(tabbar, animated: true)*/
    //self.performSegue(withIdentifier: "signInSegue", sender: nil)
}
