//
//  ViewController.swift
//  BreakTime
//
//  Created by Taylor Givens on 6/16/23.
//

import Cocoa

class ViewController: NSViewController {
    
    @IBOutlet var leftImage: NSImageView!
    @IBOutlet var hoursWorked: NSTextField!
    @IBOutlet var timeLabel: NSTextField!

    
    @IBOutlet var remainingTimeLabel: NSTextField!
    @IBOutlet var textField: NSTextField!
    @IBOutlet var takeBreak: NSButton!
    @IBOutlet var BreakLabel: NSTextField!
    @IBOutlet var clockInButton: NSButton!
    @IBOutlet var clockOut: NSButton!
    
    @IBOutlet var miniClock: NSTextField!
    
    @IBOutlet var rightImage: NSImageView!
    
    var timer: Timer?
    var hourlyTimer: Timer?
    var minuteTimer: Timer?
    var breakTimer: Timer?
    var secondsBreakTimer: Timer?
    var cancel: Bool = true
    
    var hour: Int = 0
    var minute: Int = 0
    var remainingTime: Int = 0
    var remainingSeconds: Int = 0
    
    override func viewDidLoad() {
      
              
        super.viewDidLoad()
      //  hoursWorked.isHidden = true
        takeBreak.isHidden = true
        clockOut.isHidden = true
        textField.stringValue = ""
        textField.isEditable = false
        textField.isHidden = true
        leftImage.image = NSImage(named: "")
        rightImage.isHidden = true
        
      // Do any additional setup after loading the view.
        startClock()
    }
    @IBAction func takeBreak(_ sender: Any) {
        cancel = !cancel
        if(cancel){
            cancelBreak()
        }
        else{
            startBreak()
        }
    }
    @IBAction func clockOut(_ sender: Any) {
    
        if let windowControl = self.view.window?.windowController{
            windowControl.close()
        }
            
    }
    @IBAction func clockIn(_ sender: Any) {
        startHourlyUpdate()
        clockInButton.title = "..."
        clockInButton.isEnabled = false
        clockInButton.isBordered = false
        clockInButton.font = NSFont.systemFont(ofSize: 24)
        clockInButton.frame.origin.y = clockInButton.frame.origin.y + 8
        hoursWorked.isHidden = false
        takeBreak.isHidden = false
        clockOut.isHidden = false
        leftImage.image = NSImage(named: "cat")
      
    }
    
    @IBAction func isEditing(_ sender: NSTextField) {
        if let intValue = Int(sender.stringValue) {
            // Valid integer entered
           
            if(intValue < 1){
                BreakLabel.stringValue = "Please input a valid number"
                return
            }
            remainingTime = intValue - 1
            breakCountdown()
         } else {
             // Invalid input, not a valid integer
             BreakLabel.stringValue = "Please input a valid number"
             return
         }
    }
   

    func startHourlyUpdate(){
        // Set up a timer to fire every hour and call the updateHourlyLabel() method
        hourlyTimer = Timer.scheduledTimer(timeInterval: 3600, target: self, selector: #selector(updateHourlyLabel), userInfo: nil, repeats: true)
        minuteTimer = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(updateMinuteLabel), userInfo: nil, repeats: true)
        
    }
    func startClock() {
          // Set up a timer to fire every second and call the updateClock() method
          timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateClock), userInfo: nil, repeats: true)
      }
    @objc func updateHourlyLabel() {
        hour = hour + 1
        hoursWorked.stringValue = "Worked: \(hour) hours and \(minute) minutes"
        
        
    }
    @objc func updateMinuteLabel() {
    minute = minute + 1
    hoursWorked.stringValue = "Worked: \(hour) hours and \(minute) minutes"
        
        
    }
      @objc func updateClock() {
          let dateFormatter = DateFormatter()
          dateFormatter.dateFormat = "h:mm a" // Use "h" for 12-hour format, "a" for AM/PM indicator
          
          let currentTime = dateFormatter.string(from: Date()) // Get the current time and format it
          
           // Update the label with the formatted time
          timeLabel.stringValue = currentTime
      }
    
    func updateCountdownLabel() {
           // Format the remaining time as minutes and seconds
       
        remainingTimeLabel.stringValue = String(format: "%02d:%02d", remainingTime, remainingSeconds)
           // Update the countdown label with the formatted time
           
       }
    @objc func updateCountdownSeconds() {
        remainingSeconds -= 1

        if(remainingSeconds == 0){
            remainingSeconds = 59
        }
             updateCountdownLabel()
        
    }
    
    @objc func updateCountdown() {
        if remainingTime > 0 {
            // Decrement the remaining time by 1 second
            remainingTime -= 1
            // Update the countdown label
            updateCountdownLabel()
        } else {
            // Countdown has finished, stop the timer
          endBreak()
        }
    }
    
    func startBreak(){
        textField.isEditable = true
        BreakLabel.isHidden = false
        takeBreak.title = "Cancel"
        BreakLabel.stringValue = "How long is your break?"
        hoursWorked.isHidden = true
        clockInButton.isHidden = true
        textField.isHidden = false
    }
    
    func breakCountdown(){
        hourlyTimer?.invalidate()
        minuteTimer?.invalidate()
        miniClock.stringValue = timeLabel.stringValue
        clockInButton.isHidden = false
        textField.stringValue = ""
        textField.isHidden = true
        timeLabel.isHidden = true
        BreakLabel.stringValue = "Enjoy your break!"
        leftImage.image = NSImage(named: "cloud")
        remainingSeconds = 59
        rightImage.isHidden = false
        // Update the countdown label with the initial time
        updateCountdownLabel()
                    
        // Start the countdown timer
        breakTimer = Timer.scheduledTimer(timeInterval: 59, target: self, selector: #selector(updateCountdown), userInfo: nil, repeats: true)
        secondsBreakTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateCountdownSeconds), userInfo: nil, repeats: true)
    }
    
    func cancelBreak(){
        breakTimer?.invalidate()
           breakTimer = nil

           secondsBreakTimer?.invalidate()
           secondsBreakTimer = nil

           restoreAfterBreak()
    }
    func restoreAfterBreak(){
        textField.isEditable = false
       startHourlyUpdate()
        remainingTimeLabel.stringValue = ""
        timeLabel.isHidden = false
        hoursWorked.isHidden = false
      BreakLabel.isHidden = true
        takeBreak.title = "Take Break"
        textField.stringValue = ""
      textField.isHidden = true
      
        rightImage.isHidden = true
        leftImage.image = NSImage(named: "cat")
        miniClock.stringValue = ""
    }
    @objc func endBreak(){
        breakTimer?.invalidate()
           breakTimer = nil

           secondsBreakTimer?.invalidate()
           secondsBreakTimer = nil

           restoreAfterBreak()
    }
  }



