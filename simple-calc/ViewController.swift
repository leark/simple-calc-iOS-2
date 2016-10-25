//
//  ViewController.swift
//  simple-calc
//
//  Created by iGuest on 10/24/16.
//  Copyright © 2016 iSchool. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var notationStatus: UILabel!
    @IBOutlet weak var currentOperator: UILabel!
    @IBOutlet weak var numberView: UILabel!
    @IBOutlet weak var notationButton: UIButton!
    var doubles = [Double]()
    var operatorPressed = true
    var pressedOperator = ""
    var result = 0.0
    var rP = false
    var dotPressed = false
    var dotPlace = 1
    var lastResult = false
    let normalPolan = #imageLiteral(resourceName: "Polandball")
    let notNormalPolan = #imageLiteral(resourceName: "Polandball2")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // need to refactor
    @IBAction func clear(_ sender: AnyObject) {
        if sender.currentTitle!! == "cc" {
            doubles.removeAll()
            result = 0.0
            operatorPressed = true
            currentOperator.text = "--"
            pressedOperator = ""
            numberView.text = "0.0"
        } else if operatorPressed {
            operatorPressed = false
            currentOperator.text = "--"
            pressedOperator = ""
        } else {
            numberView.text = "0.0"
        }
    }
    
    @IBAction func pressedNumber(_ sender: AnyObject) {
        var number = Double(sender.currentTitle!!)!
        
        if rP {
            
        } else {
            if operatorPressed {
                operatorPressed = false
            } else if dotPressed {
                number = doubles.popLast()! + number / pow(10.0, Double(dotPlace))
                dotPlace += 1
            } else {
                number = doubles.popLast()! * 10 + number
            }
            doubles.append(number)
            numberView.text = "\(number)"
        }
    }
    
    @IBAction func pressedOperator(_ sender: AnyObject) {
        if rP {
            
        } else {
            operatorPressed = true
            pressedOperator = sender.currentTitle!!
            currentOperator.text = pressedOperator
            if dotPressed {
                dotPressed = false
            }
        }
        
        if pressedOperator == "!" {
            calculate(sender)
        }
    }
    
    @IBAction func pressedDot(_ sender: AnyObject) {
        dotPressed = true
    }
    
    @IBAction func notationSwap(_ sender: AnyObject) {
        if rP {
            rP = false
            notationStatus.text = "Normal"
            notationButton.setImage(normalPolan, for: UIControlState.normal)
        } else {
            rP = true
            notationStatus.text = "RPN"
            notationButton.setImage(notNormalPolan, for: UIControlState.normal)
        }
    }
    
    @IBAction func calculate(_ sender: AnyObject) {
        
        currentOperator.text = "="
        
        switch pressedOperator {
        case "+":
            result = doubles[0] + doubles[1]
        case "-":
            result = doubles[0] - doubles[1]
        case "*":
            result = doubles[0] * doubles[1]
        case "/":
            result = doubles[0] / doubles[1]
        case "%":
            result = fmod(doubles[0], doubles[1])
        case "count":
            result = Double(doubles.count)
        case "avg":
            for stored in doubles {
                result += stored
            }
            result = result / Double(doubles.count)
        case "!":
            if doubles.count == 1 {
                result = factorial(number: doubles[0])
            }
        case "↵":
            doubles.append(3.4)
        default:
            numberView.text = "unknown operand"
        }
        doubles.removeAll()
        doubles.append(result)
        lastResult = true
        numberView.text = "\(String(result))"
        
    }
    
    func factorial(number: Double) -> Double {
        if number == 0 {
            return 1;
        } else {
            return number * factorial(number: number - 1)
        }
    }
    
    

/*
 
     
     classic "text field and buttons" display
     ten digit buttons (0, 1, 2, ... 9)
     operations add, sub, mul, div, mod
     equals button
     when user enters number, then operation, then number, then equals, calculate result

     
     Add a few new (multi-operand) operations in
     "count": count the number of input
     10 count 4 count 25 equals => 3
     "avg": average all the inputs
     2 avg 4 avg 6 avg 8 avg 10 equals => 6
     "fact": calculate factorial
     5 fact => 60
     fact can only accept one number

 
     Extra credit: 2 points
     support decimal operations
     Extra extra credit: 2 points
     add a toggle between traditional and RPN functionality
     RPN = Reverse Polish Notation
     different input style:
     22 7 + (outputs 29)
     1 2 3 4 5 count (outputs 5)
     you will need some kind of "enter" key to indicate when the user is done entering a number
     
     
     
 */
}

