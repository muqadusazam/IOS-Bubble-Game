//
//  ViewController.swift
//  Bubble Pop
//
//  Created by Muqadus on 27/4/19.
//  Copyright © 2019 Muqadus. All rights reserved.
//

import UIKit
import GameKit
import Foundation
import CoreData

// Class to store circle color and scores
class CircleTypeData {
    // Variables for storing color and scores
    let circleColor: UIColor
    // initialising color and scores (acts as a constructor)
    init(circleColor: UIColor) { self.circleColor = circleColor }
}

// Class for making circle UI
// inhehits from Circle Type Data Class
class CircleUIView: UIButton {
    // Circle Type variable to create a UI
    var circleType: CircleTypeData?
}

class GameViewController: UIViewController {

    // Outlet of view and lables to get and send data to them
    @IBOutlet weak var gameView: UIView!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblScore: UILabel!
    @IBOutlet weak var lblHighScores: UILabel!
    
    // variables to store time, score, name and previous circle
    var score: Int = 0
    var timer = Timer()
    var sliderTime: Int!
    var sliderBubbles: Int!
    var time: Int!
    var playerName: String?
    var heighestScores: Int = 0
    var preCircle: CircleTypeData?
    
    // arrays of class and buttons to store and fetch data
    var circles: [CircleTypeData] = []
    var circleArray = [UIButton]()
    
    // variables of points assugned to each circle
    var redPoints = 1
    var pinkPoints = 2
    var greenPoints = 5
    var bluePoints = 8
    var blackPoints = 10
    
    // variable to genrate a random number
    let randomNum: GKRandomSource = GKARC4RandomSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        appendCircles() // Asigning points and colors and storing each circle / bubble in circles array
        lblScore.text = "\(score)" // assigning a default score at the start of game
        lblHighScores.text = "\(checkCurrentHighest())" // Showing the heighest Score on screen
        time = sliderTime // assiging the value of slider to time (changeable through slider)
        countDown() // starting the countdown in interval of 1 second
        // For loop to draw circles randomly on screen within the range of bublbe assigned from the value of slider
        for _ in 0...sliderBubbles {
            createCircle() // creating and displaying the circles on screen
        }
    }
     // function to lock screen from rotating (potrate only - EXTRA Functionality)
    override open var shouldAutorotate: Bool {
        return false
    }
    
    // method to check for the heighest score
    func checkHighScores() {
        // checking if current score is greator than the heightest score
        if (self.score > self.heighestScores) {
            // update the score and display it on label
            heighestScores = score
            lblHighScores.text = "\(heighestScores)"
        }
    }
    
    // function to start the countdown by calling a "Time action" method on selector
    func countDown() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
    }
    
    // Function of core functionaity code for the timeer
    @objc func timerAction(){
        // checking while the time is above or equal to 0
        if time >= 0 {
            lblTime.text = "\(time!)" // update the time on the label at interval of every second
            time -= 1 // at every second minus the second by 1
            removeCirclesRandomly() // removing circles from screen randomly at game time count down
        } else {
            // show scores board after the time finishes
            showScores()
        }
    }
    
    // function show score board controller
    func showScores(){
        // creating an object of the story controller, calling it by its assigned indentifier
        let sb = self.storyboard?.instantiateViewController(withIdentifier: "ScoreBoardController") as! ScoreBoardController
        // Passing name and scores to scoreboard controller
        sb.playerName = self.playerName
        sb.playerScore = self.score
        // finally showing the score board on the screen
        self.show(sb, sender: nil)
    }
    
    // assigning color and scores to circle data class and saving them into an array
    func appendCircles() {
        circles.append( CircleTypeData (circleColor: .red))
        circles.append( CircleTypeData (circleColor: .magenta))
        circles.append( CircleTypeData (circleColor: .green))
        circles.append( CircleTypeData (circleColor: .blue))
        circles.append( CircleTypeData (circleColor: .black))
    }
    
    // function to create a circle
    @objc func createCircle(){
        // defining x and y position of and assining a randomised number to them
        let xPos = CGFloat( randomNum.nextUniform()) * ((self.gameView?.frame.width)! - 50)
        let yPos = CGFloat( randomNum.nextUniform()) * ((self.gameView?.frame.height)! - 50)
        
        // creating a circle by using circle view class and creating a shape of the circle
        let circle = CircleUIView(frame: CGRect(x: xPos, y: yPos, width: 50, height: 50))
        circle.circleType = weightCircles() // Assigning weights to each circle from 100 percent
        circle.layer.cornerRadius = 0.5 * circle.bounds.size.width // rounding off the corners of the circle
        circle.clipsToBounds = true
        setCircleColor(circle: circle) // filling in the colors of the circles
        
        // making a variable by providing circle a method to avoid overlapping each other
        let fixCirclePos = fixPosition(of: circle)
        if fixCirclePos == true { // checking if circles are positioned in right by checking the return bool statement
            circleArray.append(circle) // saving all the circles in array of buttons
            for circles in circleArray { // iterating through the circle arrays of buttons
                // and adding a calling method on each of them once pressed
                circles.addTarget(self, action: #selector( circlePressed(sender: )), for: UIControl.Event.touchUpInside)
            }
            // finally adding the circle on the game view as subview
            self.gameView.addSubview(circle)
        }
    }
    
    func weightCircles() -> CircleTypeData {
        // creating a variable to store all the data of circle
        var group: [CircleTypeData] = []
        for _ in 1...40 { group.append(circles[0]) } // adding 40% of weight on the circle (Showing percentage)
        for _ in 1...30 { group.append(circles[1]) } // adding 30% of weight on the circle (Showing percentage)
        for _ in 1...15 { group.append(circles[2]) } // adding 15% of weight on the circle (Showing percentage)
        for _ in 1...10 { group.append(circles[3]) } // adding 10% of weight on the circle (Showing percentage)
        for _ in 1...5 { group.append(circles[4]) } // adding 5% of weight on the circle (Showing percentage)
        
        // genrating a randomised number within the array's count
        let selected: Int = randomNum.nextInt(upperBound: group.count)
        // returning the array of selected circles with percetage weight on them
        return group[selected]
    }
    
    // function to fix the position of the circles
    func fixPosition(of circle: CircleUIView) -> Bool {
        // iterrating through the views in game view's subview
        for subView in self.gameView.subviews {
            // checking if the circles intersects with each other then return false else true
            if let circles = subView as? CircleUIView { if circles.frame.intersects(circle.frame) { return false }}}
        return true
    }
    
    func setCircleColor(circle: CircleUIView){
        // checking if color matches the view circle color
        if let color = circle.circleType?.circleColor {
            // if it matches then change the circle's background color to its color
            if color == UIColor.red {circle.backgroundColor = UIColor .red}
            else if color == UIColor.magenta {circle.backgroundColor = UIColor .magenta}
            else if color == UIColor.green {circle.backgroundColor = UIColor .green}
            else if color == UIColor.blue {circle.backgroundColor = UIColor .blue}
            else if color == UIColor.black {circle.backgroundColor = UIColor .black}
        }
    }
    
    // function to remove circles randomly
    @objc func removeCirclesRandomly(){
        // cerate random number within the range of slider value for bubbles
        let randNum = Int.random(in: 0 ..< sliderBubbles)
        // iterating through the array of buttons
        for circles in circleArray {
            // checking if the random number is smaller or equal to slider's value
            if randNum <= sliderBubbles { circles.removeFromSuperview() }
        }
        // Recreate the circles by looping through 0 to slider's value
        for _ in 0...sliderBubbles {
            createCircle()
        }
    }
    
    // function created when a circle is pressed
    @objc func circlePressed(sender: UIButton!){
        // get the circle points by calling amethod where UIButton is passed in as a parameter
        let scores = getCirclePoints(from: sender)
        self.score += scores // store the scores in the variabble to be called later
        lblScore.text = "\(score)" // Update the score everytime the circle is pressed
        checkHighScores()
        sender.removeFromSuperview() // remove the specific circle from the view once it's pressed
    }

    // function to get circle points and returns the int value of score
    func getCirclePoints(from curCircle: UIButton) -> Int {
        // creating a variable to store score with 0 as default value
        var curScore: Int = 0
        // Assigning points to each circle based on their color
        if (curCircle.backgroundColor == UIColor .red) { curScore = redPoints }
        else if (curCircle.backgroundColor == UIColor .magenta){ curScore = pinkPoints }
        else if (curCircle.backgroundColor == UIColor .green){ curScore = greenPoints }
        else if (curCircle.backgroundColor == UIColor .blue){ curScore = bluePoints }
        else if (curCircle.backgroundColor == UIColor .black){ curScore = blackPoints } else { curScore = 0 }
        
        return curScore
    }
    
    // function to get the current highest score from data
    func checkCurrentHighest() -> Int {
        var pointsArray: [Int32] = [] // making an empty array to store the data
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Data")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                pointsArray.append(data.value(forKey: "points") as! Int32) // getting the data for points
            }
            // sorting the array
            pointsArray = pointsArray.sorted()
            
            // checking if the array is not empty
            if (pointsArray.count != 0){
                // change the heightest score the heighest value in the array
                heighestScores = Int(pointsArray[pointsArray.count-1])
            } else {
                // deafult value of 0
                heighestScores = 0
            }
        } catch {
            print("Failed")
        }
        return heighestScores // returning the heighest score
    }
}

