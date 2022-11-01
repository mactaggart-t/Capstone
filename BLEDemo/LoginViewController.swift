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
    //@IBOutlet weak var userTextField: UITextField!
    //@IBOutlet weak var passwordTextField: UITextField!
    //@IBOutlet weak var signInButton: UIButton!

    @IBOutlet weak var loginBorder: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginBorder.layer.masksToBounds = true
        loginBorder.layer.cornerRadius = loginBorder.frame.height / 8
    }
    
    
}
