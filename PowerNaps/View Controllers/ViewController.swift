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
        if timer.isOn {
            timer.stopTimer()
        } else {
            timer.startTimer(5)
        }
        updateLabel()
        updateButton()
    }
    
    func updateLabel() {
        if timer.isOn {
            timeLabel.text = "\(timer.timeRemaining)"
        } else {
            timeLabel.text = "00.05"
        }
    }
    
    func updateButton() {
        if timer.isOn {
            //If timer is on, button reads "Cancel", if off reads "Start"
            napButton.setTitle("Cancel Nap", for: .normal)
        } else {
            napButton.setTitle("Start Nap", for: .normal)
        }
    }
}

//Make class conform to protocol (step 3)
extension ViewController: MyTimerDelegate {
    
    //Provide the data the VC class must conform to (step 5)
    
    func timerSecondTicked() {
        updateLabel()
    }
    
    func timerCompleted() {
        updateLabel()
        updateButton()
        //Call the display alert controller function
    }
    
    func timerStopped() {
        updateButton()
        updateLabel()
    }
}

extension ViewController {
    func displaySnoozeAlertController() {
        
    }
}


//delegate : send data from one controller to another
//VC doenst know when seconds get ticked, what time the timer is at, etc. Has to get that info from the Model

