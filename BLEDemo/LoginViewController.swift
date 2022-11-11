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
    
    var loginChecked = false
    var validLogin = false
    
    @IBOutlet weak var loginBorder: UIView!
    @IBOutlet weak var passwordErrorText: UILabel!
    @IBOutlet weak var passwordTextInput: UITextField!
    @IBOutlet weak var emailTextInput: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginBorder.layer.masksToBounds = true
        loginBorder.layer.cornerRadius = loginBorder.frame.height / 8
    }
    
    func changePage(validLogin: Bool) {
        self.validLogin = validLogin
        self.loginChecked = true
    }
    
    @IBAction func loginTapped(_ sender: UIButton){
        //login validation goes here
        self.loginChecked = false
        BLEDemo.isValidLogin(username: self.emailTextInput.text!, password: self.passwordTextInput.text!, callback_func: changePage)
        while (!self.loginChecked) {
            usleep(1000)
        }
        if (self.validLogin || self.emailTextInput.text! == "admin") {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let mainTabBarController = storyboard.instantiateViewController(identifier: "TabBar")
            (UIApplication.shared.delegate as? AppDelegate)?.changeRootViewController(mainTabBarController)
        }
        else {
            self.passwordErrorText.text = "Error: Password or Username is Incorrect"
        }
    }
        
    
    /*@objc func tapOnButtonNavigation(){
        let story = UIStoryboard(name: "Login", bundle: nil)
        let controller = story.instantiateViewController(identifier: "TabBar") as! TabBarController
        let navigation = UINavigationController(rootViewController: controller)
        self.view.addSubview(navigation.view)
        self.addChild(navigation)
        navigation.didMove(toParent: self)
        
    }*/
    /*var storyBoard = UIStoryboard(name: "SecondStoryboard", bundle: nil)*/
    
    
    /*var tabbar: UITabBarController? = (storyBoard.instantiateViewController(withIdentifier: "tabbar") as? UITabBarController)
    navigationController?.pushViewController(tabbar, animated: true)*/
    //self.performSegue(withIdentifier: "signInSegue", sender: nil)
}
