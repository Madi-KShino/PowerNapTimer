//
//  ViewController.swift
//  PowerNaps
//
//  Created by Madison Kaori Shino on 6/18/19.
//  Copyright © 2019 Madi S. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var napButton: UIButton!
    
    let timer = MyTimer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Make class confrom to this delegate (step 4)
        timer.delegate = self
        
    }

    @IBAction func buttonTapped(_ sender: Any) {
    }
    
    func updateLabel() {
        
    }
    
    func updateButton() {
        
    }
    
    func startTimer() {
        
    }
    
    func stopTimer() {
        
    }
    
    func setTimer() {
        
    }
}

//Make class conform to protocol (step 3)
extension ViewController: MyTimerDelegate {
    
    //Provide the data the VC class must conform to (step 5)
    func timerSecondTicked() {
        <#code#>
    }
    
    func timerStarted() {
        <#code#>
    }
    
    func timerStopped() {
        <#code#>
    }
}
