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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginBorder.layer.masksToBounds = true
        loginBorder.layer.cornerRadius = loginBorder.frame.height / 8
    }
    
    @IBAction func loginTapped(_ sender: UIButton){
        
        //login validation goes here
        //*********
        
        
        //if login is validated, run the following lines:
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mainTabBarController = storyboard.instantiateViewController(identifier: "TabBar")
        (UIApplication.shared.delegate as? AppDelegate)?.changeRootViewController(mainTabBarController)
        
        
        //if login fails, return error message
        //*****
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
