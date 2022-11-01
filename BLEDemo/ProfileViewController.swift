//
//  ProfileViewController.swift
//  BLEDemo
//
//  Created by Nguyen on 10/31/22.
//  Copyright © 2022 Rick Smith. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var proPicView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        proPicView.layer.masksToBounds = true
        proPicView.layer.cornerRadius = proPicView.frame.height / 4
        
        
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
