//
//  TemperatureViewController.swift
//  BLEDemo
//
//  Created by Nguyen on 11/1/22.
//  Copyright © 2022 Rick Smith. All rights reserved.
//

import UIKit

class TemperatureViewController: UIViewController {

    @IBOutlet weak var tCircle: UIView!
    @IBOutlet weak var tCircle2: UIView!
    
    @IBOutlet weak var tTop: UIView!
    @IBOutlet weak var tTop2: UIView!
    @IBOutlet weak var lowNum: UILabel!
    @IBOutlet weak var highNum: UILabel!
    
    @IBOutlet weak var marker: UIView!
    
    
    @IBOutlet weak var highNum2: UILabel!
    @IBOutlet weak var lowNum2: UILabel!
    
   
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tCircle.layer.cornerRadius = tCircle.frame.height / 2
        tCircle.clipsToBounds = true
        
        tTop.layer.cornerRadius = tTop.frame.height / 3
        tTop.clipsToBounds = true
        
        tCircle2.layer.cornerRadius = tCircle2.frame.height / 2
        tCircle2.clipsToBounds = true
        
        tTop2.layer.cornerRadius = tTop2.frame.height / 3
        tTop2.clipsToBounds = true
        setSize1()
        setSize2()
    }
    
    func setSize1(){
        let max : Int = 200
        let maxString = String(max)
        highNum.text = maxString
        
        let low : Int = 100
        let lowString = String(low)
        lowNum.text = lowString
        
        /*var newFrame = self.marker.frame
        newFrame.size.height = 80*/
    }
    
    func setSize2(){
        let max : Int = 100
        let maxString = String(max)
        highNum2.text = maxString
        
        let low : Int = 50
        let lowString = String(low)
        lowNum2.text = lowString
        
        /*var newFrame = self.marker.frame
        newFrame.size.height = 80
         */
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
