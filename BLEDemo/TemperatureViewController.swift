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
    
    @IBOutlet weak var marker2: UIView!
    
    @IBOutlet weak var highNum2: UILabel!
    @IBOutlet weak var lowNum2: UILabel!
    
    @IBOutlet weak var currNum2: UILabel!
    
    @IBOutlet weak var currNum: UILabel!
    private var timer: DispatchSourceTimer?
    var lowTemp1: String = ""
    var lowTemp2: String = ""
    var currentTemp1: String = ""
    var currentTemp2: String = ""
    var highTemp1: String = ""
    var highTemp2: String = ""
    var tempUpdated: Bool = false
   
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
        setSize1(low: "0", current: "108", high: "200")
        setSize2(low: "0", current: "150", high: "200")
        startTimer();
    }
    
    // Start the 10 second time for the next data send task and clear out all caches
    func startTimer() {
        let queue = DispatchQueue(label: Bundle.main.bundleIdentifier! + ".timer")
        timer = DispatchSource.makeTimerSource(queue: queue)
        timer!.schedule(deadline: .now(), repeating: .seconds(5))
        timer!.setEventHandler { [weak self] in

            self?.getTempData();
        }
        timer!.resume()
    }
    
    func useTempData(lowest: String, current: String, highest: String) {
        lowTemp1 = lowest
        currentTemp1 = current
        highTemp1 = highest
        lowTemp2 = lowest
        currentTemp2 = current
        highTemp2 = highest
        tempUpdated = true
    }
    
    func getTempData() {
        tempUpdated = false
        BLEDemo.getTemperatureData(callback_func: useTempData);
        while (!self.tempUpdated) {
            usleep(500)
        }
        setSize1(low: lowTemp1, current: currentTemp1, high: highTemp1)
        setSize2(low: lowTemp2, current: currentTemp2, high: highTemp2)
    }
    
    func setSize1(low: String, current: String, high: String){
        highNum.text = high
        lowNum.text = low
        currNum.text = current
        //let a: Int = Int(currNum.text ?? "")!
        //if(a > 100){
        
        /*    let newHeight: CGFloat = 145
            //width should stay the same - 45
            UIView.animate(withDuration: 3.0, //1
                delay: 0.0, //2
                usingSpringWithDamping: 0.3, //3
                initialSpringVelocity: 1, //4
                options: UIView.AnimationOptions.curveEaseInOut, //5
                animations: ({ //6
                    self.marker.frame = CGRect(x: 0, y: -5, width: 45, height: newHeight)
                    self.marker.center = self.view.center
            }), completion: nil)//}*/
        
        
        /*var newFrame = self.marker.frame
        newFrame.size.height = 80*/
    }
    
    func setSize2(low: String, current: String, high: String){
        highNum2.text = high
        lowNum2.text = low
        currNum2.text = current
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
