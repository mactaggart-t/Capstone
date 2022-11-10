//
//  CreateAccountViewController.swift
//  BLEDemo
//
//  Created by Nguyen on 11/9/22.
//  Copyright © 2022 Rick Smith. All rights reserved.
//

import UIKit

class CreateAccountViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func createTapped(_ sender: UIButton){
        //login validation goes here
        //*********
        
        
        //once login is validated, run the following lines:
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mainTabBarController = storyboard.instantiateViewController(identifier: "TabBar")
        (UIApplication.shared.delegate as? AppDelegate)?.changeRootViewController(mainTabBarController)
        
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
