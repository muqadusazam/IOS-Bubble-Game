//
//  HomeController.swift
//  Bubble Pop
//
//  Created by Muqadus on 27/4/19.
//  Copyright © 2019 Muqadus. All rights reserved.
//

import UIKit

class HomeController: UIViewController, UITextFieldDelegate {
    // outlets of textfields, sliders and labels
    @IBOutlet weak var TxtPlayerName: UITextField!
    
    // Variables to store data
    var heighestScore: Int = 0
    var playTime: Int = 60
    var maxBubbles: Int = 15
    
    override func viewDidLoad() {
        // assigning name text to self
        TxtPlayerName.delegate = self
    }
    
    // Restrictring the screen from being rotated (verticle only)
    override open var shouldAutorotate: Bool {
        return false
    }
    
    // checking for input if empty
    func checkInput(input: String) -> Bool {
        return input.isEmpty == true ? true : false
    }
    
    @IBAction func btnSettings(_ sender: UIButton) {
        // Calling the segue function to show the settings controller
        showSettings()
    }
    
    func showSettings(){
        // creating an object of the story controller, calling it by its assigned indentifier
        let gs = self.storyboard?.instantiateViewController(withIdentifier: "gameSettingsID") as! GameSettingsController
        gs.highScores = self.heighestScore
        // showing the view
        self.show(gs, sender: nil)
    }
    
    @IBAction func btnContinueTapped(_ sender: UIButton) {
        // check for textfield if empty unpon clicking the button
        if checkInput(input: TxtPlayerName.text!) == true {
            // if empty then show message
            showNameMessage()
            return
        } else { showGame() }
    }
    
    func showGame(){
        // creating an object of the story controller, calling it by its assigned indentifier
        let gv = self.storyboard?.instantiateViewController(withIdentifier: "gameViewID") as! GameViewController
        
        // pass name, time and bubbles values to game view
        gv.playerName = TxtPlayerName.text
        gv.heighestScores = heighestScore
        gv.sliderTime = playTime
        gv.sliderBubbles = maxBubbles
        // showing the view
        self.show(gv, sender: nil)
    }
    
    // function to show message
    func showNameMessage(){
        // creating an alert of error
        let alert = UIAlertController(title: "Error", message: "Please provide player's name", preferredStyle: UIAlertController.Style.alert)
        // adding an action option of "OK" underneath the alert
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        // Finally present it to the screen
        self.present(alert, animated: true, completion: nil)
    }
}
