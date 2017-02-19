//
//  ViewController.swift
//  Set Timer
//
//  Created by Charles Burnett on 10/9/16.
//  Copyright © 2016 Charles Burnett. All rights reserved.
//

import UIKit
import AVFoundation
import UserNotifications

class ViewController: UIViewController {

    @IBOutlet weak var setButton: UIButton!
    @IBOutlet weak var repButton: UIButton!
    @IBOutlet weak var timerButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var timeSetButton: UIButton!
    @IBOutlet weak var startButton: UIButton!
    
    var timeWhenStarted = 0.0
    var secondsForTimer = 0
    var counter = 0

    var isPaused = false
    var isGrantedNotificationAccess:Bool = false
    
    var timer = Timer()
    var player: AVAudioPlayer?
    let url = Bundle.main.url(forResource: "alarm", withExtension: "wav")!

    

    var setCounter = 0
    var repCounter = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UNUserNotificationCenter.current().requestAuthorization(
            options: [.alert,.sound,.badge],
            completionHandler: { (granted,error) in
                self.isGrantedNotificationAccess = granted
        }
        )
        pauseButton.setTitle("", for: UIControlState.normal)
        pauseButton.isUserInteractionEnabled = false
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.didEnterForeground),
            name: .UIApplicationDidBecomeActive,
            object: nil)
    }
    
    func didEnterForeground() {
        invalidateTimer()

        let timeInterval = NSDate().timeIntervalSince1970
        
        let timeRemaining = secondsForTimer - Int(round(timeInterval-timeWhenStarted))
        print("\(secondsForTimer - Int(round(timeInterval-timeWhenStarted)))")
        
        if timeRemaining > 0
        {
            startTimer(count: timeRemaining)
        }
        
        else{
            timerButton.setTitle("Start", for: UIControlState.normal)
        }
    }
    
    override func viewDidLayoutSubviews() {
        setButton.layer.cornerRadius = setButton.frame.width / 2.0
        repButton.layer.cornerRadius = repButton.frame.width / 2.0
        timerButton.layer.cornerRadius = 10
        timeSetButton.layer.cornerRadius = 10
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func setPressed(_ sender: AnyObject){
        setCounter += 1
        setButton.setTitle("Set \(setCounter)", for: UIControlState.normal)
        repCounter = 0
        repButton.setTitle("Reps", for: UIControlState.normal)
    }

    @IBAction func repPressed(_ sender: AnyObject) {
        repCounter += 1
        repButton.setTitle("\(repCounter) Reps", for: UIControlState.normal)
    }
    
    @IBAction func startPressed(_ sender: AnyObject) {
        
        if counter == 0 {
            timerNotSetAlert()
            return
        }
            
        else {
        secondsForTimer = counter
        timeWhenStarted = NSDate().timeIntervalSince1970
        setBGNotification()
            startTimer(count:counter)
        }
    }
    
    @IBAction func resetPressed(_ sender: AnyObject) {
        setCounter = 0
        repCounter = 0
        setButton.setTitle("Sets", for: UIControlState.normal)
        repButton.setTitle("Reps", for: UIControlState.normal)
        timer.invalidate()
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()

        timerButton.setTitle("Start", for: UIControlState.normal)
    }
    @IBAction func pauseTimer(_ sender: AnyObject) {
        if isPaused == false && counter >= 0 {
        timer.invalidate()
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()

        pauseButton.setTitle("Play", for: UIControlState.normal)
        isPaused = true
        }
        else if isPaused == true && counter >= 0 {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
        setBGNotification()

        pauseButton.setTitle("Pause", for: UIControlState.normal)
        isPaused = false
        }
    }
    
    func timerAction() {
        if counter == 0 {
            let state: UIApplicationState = UIApplication.shared.applicationState
            if state == .active {                
                do {
                    player = try AVAudioPlayer(contentsOf: url)
                    guard let player = player else { return }
                    
                    player.prepareToPlay()
                    player.play()
                } catch let error {
                    print(error.localizedDescription)
                }
            }
            invalidateTimer()
            timerButton.setTitle("Start", for: UIControlState.normal)

            return
        }
        
        let (hours,minutes,seconds) = secondsToHoursMinutesSeconds(seconds: counter)
        
        if hours == 0 {
            if seconds >= 10 {
                timerButton.setTitle("\(minutes):\(seconds)", for: UIControlState.normal)
            }
            else
            {
                timerButton.setTitle("\(minutes):0\(seconds)", for: UIControlState.normal)
            }
        }
        else
        {
            if minutes >= 10 && seconds >= 10 {
                timerButton.setTitle("\(hours):\(minutes):\(seconds)", for: UIControlState.normal)
            }
            else if minutes >= 10 && seconds < 10 {
                timerButton.setTitle("\(hours):\(minutes):0\(seconds)", for: UIControlState.normal)
            }
            else if minutes < 10 && seconds >= 10 {
                timerButton.setTitle("\(hours):0\(minutes):\(seconds)", for: UIControlState.normal)
            }
            else
            {
                timerButton.setTitle("\(hours):0\(minutes):0\(seconds)", for: UIControlState.normal)
            }
        }
        counter -= 1
    }
    
    func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    
    func hoursMinutesSecondsToSeconds(hours: Int, minutes: Int, seconds: Int) -> Int
    {
        let hoursToSeconds = hours * 60 * 60
        let minutesToSeconds = minutes * 60
        
        return hoursToSeconds + minutesToSeconds + seconds
    }
    
    func timerNotSetAlert()
    {
        let alert = UIAlertController(title: "No time set", message: "Please set the time for the timer", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func setBGNotification()
    {
        if isGrantedNotificationAccess{
            let content = UNMutableNotificationContent()
            content.title = "Timer's Done"
            content.subtitle = "It's time to start your next set"
            content.body = "Tap to return to the app"
            content.sound = UNNotificationSound.init(named: "alarm.wav")
            
            let trigger = UNTimeIntervalNotificationTrigger(
                timeInterval: TimeInterval(counter),
                repeats: false)
            
            let request = UNNotificationRequest(
                identifier: "set.timer",
                content: content,
                trigger: trigger
            )
            
            UNUserNotificationCenter.current().add(
                request, withCompletionHandler:nil
            )
        }
    }
    
    func startTimer(count: Int)
    {
        counter = count
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
        startButton.isUserInteractionEnabled = false
        pauseButton.setTitle("Pause", for: UIControlState.normal)
        pauseButton.isUserInteractionEnabled = true
    }
    
    func invalidateTimer()
    {
        timer.invalidate()
        startButton.isUserInteractionEnabled = true
        pauseButton.setTitle("", for: UIControlState.normal)
        pauseButton.isUserInteractionEnabled = false
    }
    
    //unwind segue
    @IBAction func unwindToThisView(sender: UIStoryboardSegue) {
            if let sourceViewController = sender.source as? PickerViewController {
                self.counter = hoursMinutesSecondsToSeconds(hours: sourceViewController.hours, minutes: sourceViewController.minutes, seconds: sourceViewController.seconds)
        }
        
    }
}

