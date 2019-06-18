//
//  MyTimer.swift
//  PowerNaps
//
//  Created by Madison Kaori Shino on 6/18/19.
//  Copyright © 2019 Madi S. All rights reserved.
//

import Foundation

//MARK: - Protocol

//Create the protocol (step 1)
protocol MyTimerDelegate: class {
    func timerSecondTicked()
    func timerStarted()
    func timerStopped()
}




class MyTimer: NSObject {
    
    //MARK: - MyTimer Class Values
    
    //Timer object we are hiding behind the 'wrapper'
    var timer: Timer?
    //How many seconds are remaining
    var timeRemaining: TimeInterval?
    //Timer status for on/off functionality
    var isOn: Bool = false
    
    //Weak var delegate of the protocol that lives on the object class (step 2)
    weak var delegate: MyTimerDelegate?
    
    //MARK: - MyTimer Class Functions
    
    //private function to tick seconds, so it cant be called on any other page
    private func secondTicked() {
        //unwrap optional time remaining value
        guard let timeRemaining = timeRemaining else { return }
        //Remove 1 second from timer each second that passes
        if timeRemaining > 0 {
            self.timeRemaining = timeRemaining - 1
            print(timeRemaining)
        } else {
            //Stops timer from running if its done (turn off)
            timer?.invalidate()
            //Set to nil so it returns out of the guard let if function is called again
            self.timeRemaining = nil
        }
    }
    
    func startTimer(_ time: TimeInterval) {
        //Check on/off status
        if isOn == false {
            //If timer is off, turn on and set the time remaining
            isOn = true
            self.timeRemaining = time
            //Make timer that will Subtract seconds in 1 second interals, and repeat every second.
            self.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { (_) in
                self.secondTicked()
            })
        }
    }
    
    func stopTimer() {
        //Check on/off status of bool
        if isOn {
            self.timeRemaining = nil
            isOn = false
        }
    }
    
}
