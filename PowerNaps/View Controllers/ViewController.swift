//
//  ViewController.swift
//  PowerNaps
//
//  Created by Madison Kaori Shino on 6/18/19.
//  Copyright © 2019 Madi S. All rights reserved.
//

import UIKit
import UserNotifications

class ViewController: UIViewController {
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var napButton: UIButton!
    
    let timer = MyTimer()
    
    //The unique identifier for our notification
    //Identifier for the notification request
    fileprivate let userNotificationIdentifier = "timerFinishedNotification"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Make class confrom to this delegate (step 4)
        timer.delegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateTimer()
    }
    
    @IBAction func buttonTapped(_ sender: Any) {
        if timer.isOn {
            timer.stopTimer()
            cancelLocalNotification()
        } else {
            timer.startTimer(5)
            scheduleLocalNotification()
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
    
    func updateTimer() {
        //Get all notifications for our app from the notifications center
        UNUserNotificationCenter.current().getPendingNotificationRequests { (requests) in
            //.filter - filtering out notifications that do not match our identifier from our constant
            //create new array ourNotification and append to our one notification at index 0 that matches the identifier
            let ourNotification = requests.filter { $0.identifier == self.userNotificationIdentifier }
            
            //Get our notification from the array which should have either 1 or 0 elements inside the array
            guard let timerNotificationRequest = ourNotification.first,
                //Get the trigger from the request and cast it as our UNCalendar notification trigger
                //We know it can be a UNCalender notification because we created it as such
                let trigger = timerNotificationRequest.trigger as? UNCalendarNotificationTrigger,
                //get the exact date the trigger should fire to the exact nanosecond
                let fireDate = trigger.nextTriggerDate()
                else { return }
            
            //Turn off our timer in case one is still running
            self.timer.stopTimer()
            //turn on the timer and have it correspond to the amount of time between now and the next trigger date of the trigger(fire date)
            self.timer.startTimer(fireDate.timeIntervalSinceNow)
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
        displaySnoozeAlertController()
    }
    
    func timerStopped() {
        updateButton()
        updateLabel()
    }
}

//Snooze button protocol
extension ViewController {
    func displaySnoozeAlertController() {
        let alertController = UIAlertController(title: "Your Timer has Completed!", message: "Get up Sleepy Head!", preferredStyle: .alert)
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Snooze for a few more minutes..."
            textField.keyboardType = .numberPad
        }
        
        let snoozeAction = UIAlertAction(title: "Snooze", style: .default) { (_) in
            guard let timeText = alertController.textFields?.first?.text,
                let time = TimeInterval(timeText)
                else { return }
                    self.timer.startTimer(time * 60)
                    self.scheduleLocalNotification()
                    self.updateLabel()
                    self.updateButton()
            }
        
        alertController.addAction(snoozeAction)
        
        let dismissAction = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
        alertController.addAction(dismissAction)
        
        present(alertController, animated: true, completion: nil)
    }
}

//Notification protocol
extension ViewController {
    func scheduleLocalNotification() {
        //Create content for the notification (text, sound, badge number, etc)
        let notificationContent = UNMutableNotificationContent()
        //Set features
        notificationContent.title = "Wake Up!"
        notificationContent.subtitle = "Your Nap Timer has Finished"
        notificationContent.badge = 1
        notificationContent.sound = .default
        
        //Set up when the notification should fire
        guard let timeRemaining = timer.timeRemaining else { return }
        //get the actual date and add the amount of seconds left on our timer for the 'fire date'
        let date = Date(timeInterval: timeRemaining, since: Date())
        //get date components from the fire date (minutes and seconds)
        let dateComponents = Calendar.current.dateComponents([.minute, .second], from: date)
        //create a trigger for when the notification should fire and be sent to the user
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        //create the request for this notification by passing in the identifier, constant, the content, and the trigger
        let request = UNNotificationRequest(identifier: userNotificationIdentifier, content: notificationContent, trigger: trigger)
        
        //Adding the request to the phones notification center
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    //removing our notificaiton from the notification center by cancelling the pending request by that notification's identifier
    func cancelLocalNotification() {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [userNotificationIdentifier])
    }
}


//delegate : send data from one controller to another
//VC doenst know when seconds get ticked, what time the timer is at, etc. Has to get that info from the Model

