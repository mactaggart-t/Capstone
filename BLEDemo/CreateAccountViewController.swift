//
//  CreateAccountViewController.swift
//  BLEDemo
//
//  Created by Nguyen on 11/9/22.
//  Copyright © 2022 Rick Smith. All rights reserved.
//

import UIKit

class CreateAccountViewController: UIViewController {

    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var passwordOne: UITextField!
    @IBOutlet weak var passwordTwo: UITextField!
    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var errorMessage: UILabel!
    var loginChecked = false
    var validLogin = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func isValidAccount(isValid: Bool) {
        self.validLogin = isValid
        self.loginChecked = true
    }
    
    @IBAction func createTapped(_ sender: UIButton){
        //login validation goes here
        //*********
        self.loginChecked = false
        if (self.email.text! == "" || self.passwordOne.text! == "" ||
            self.passwordTwo.text! == "" || self.firstName.text! == "" || self.lastName.text! == "") {
            self.errorMessage.text = "Error: Please fill in all fields to create an account"
            return
        }
        if (self.passwordOne.text! != self.passwordTwo.text!) {
            self.errorMessage.text = "Error: Passwords must match"
            return
        }
        
        BLEDemo.createAccount(username: self.email.text!, password: self.passwordOne.text!,
                              firstName: self.firstName.text!, lastName: self.lastName.text!,
                              callback_func: self.isValidAccount)
        while (!self.loginChecked) {
            usleep(1000)
        }
        if (self.validLogin) {
            //once login is validated, run the following lines:
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let mainTabBarController = storyboard.instantiateViewController(identifier: "TabBar")
            (UIApplication.shared.delegate as? AppDelegate)?.changeRootViewController(mainTabBarController)
        }
        else {
            self.errorMessage.text = "Error: Account already exists"
        }
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
