//
//  ProfileViewController.swift
//  BLEDemo
//
//  Created by Nguyen on 10/31/22.
//  Copyright © 2022 Rick Smith. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var proPicView: UIImageView!
    var newEmail: String = "..."
    var newFirstName: String = "..."
    var newLastName: String = "..."
    var waitingForResponse: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        proPicView.layer.masksToBounds = true
        proPicView.layer.cornerRadius = proPicView.frame.height / 4
        waitingForResponse = BLEDemo.getUserData(callback_func: self.setUserData)
        while (waitingForResponse) {
            usleep(1000)
        }
        self.updateUIView()
        
    }
    
    func updateUIView() {
        self.firstName.text = self.newFirstName
        self.lastName.text = self.newLastName
        self.email.text = self.newEmail
    }
    
    func setUserData(userData: [String: String]) {
        self.newFirstName = userData["first_name"] ?? "..."
        self.newLastName = userData["last_name"] ?? "..."
        self.newEmail = userData["email"] ?? "..."
        
        self.waitingForResponse = false
    }
}
