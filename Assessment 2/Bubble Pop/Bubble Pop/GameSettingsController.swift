//
//  GameSettingsController.swift
//  Bubble Pop
//
//  Created by Muqadus on 10/5/19.
//  Copyright © 2019 Muqadus. All rights reserved.
//

import UIKit

class GameSettingsController: UIViewController {

    @IBOutlet weak var timeSlider: UISlider!
    @IBOutlet weak var bubblesSlider: UISlider!
    @IBOutlet weak var lblPlayTime: UILabel!
    @IBOutlet weak var lblMaxBubbles: UILabel!
    
    // store the heighest scores
    var highScores: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Setting the values on screen
        lblPlayTime.text = String(Int(timeSlider.value)) + " seconds"
        lblMaxBubbles.text = String(Int(bubblesSlider.value)) + " bubbles"
    }
    
    @IBAction func playTimeChnaged(_ sender: UISlider) {
        // changing the current value on the label every time slider is moved or changed position
        lblPlayTime.text = String(Int(sender.value)) + " seconds"
    }
    
    @IBAction func bubblesChanged(_ sender: UISlider) {
        // changing the current value on the label every time slider is moved or changed position
        lblMaxBubbles.text = String(Int(sender.value)) + " bubbles"
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // game controller object to pass data between self and game controller
        let homeContrllerObj = segue.destination as! HomeController
        do {
            // pass name, time and bubbles values to game view
            homeContrllerObj.playTime = Int(timeSlider.value)
            homeContrllerObj.maxBubbles = Int(bubblesSlider.value)
            homeContrllerObj.heighestScore = highScores
        }
    }
}
