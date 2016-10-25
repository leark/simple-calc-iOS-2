//
//  ViewController.swift
//  simple-calc
//
//  Created by iGuest on 10/24/16.
//  Copyright © 2016 iSchool. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    // check behavior for clear and =
    @IBOutlet weak var enter: UIButton!
    @IBOutlet weak var equals: UIButton!
    @IBOutlet weak var rPStack: UILabel!
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
        enter.isEnabled = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // need to refactor
    @IBAction func clear(_ sender: AnyObject) {
        if sender.currentTitle!! != "c" {
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
        updateRPStack()
    }
    
    @IBAction func pressedNumber(_ sender: AnyObject) {
        var number = Double(sender.currentTitle!!)!
        
        if lastResult && !operatorPressed && !dotPressed {
            lastResult = false
            clear(sender)
        }
        
        if rP {
            // must form a number until enter is pressed
            let cur = Double(numberView.text!)!
            if dotPressed {
                number =  cur + number / pow(10.0, Double(dotPlace))
                dotPlace += 1
            } else {
                number = cur * 10 + number
            }
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
        }
        
        numberView.text = "\(number)"
    }
    
    @IBAction func pressedOperator(_ sender: AnyObject) {
        pressedOperator = sender.currentTitle!!
        currentOperator.text = pressedOperator
        if rP {
            // operation happens instantly with values in doubles
            if doubles.count >= 2 {
                calculate(sender)
            }
            // update rpstack
            updateRPStack()
            numberView.text = "0.0"
        } else {
            operatorPressed = true
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
            equals.isEnabled = true
            enter.isEnabled = false
        } else {
            rP = true
            notationStatus.text = "RPN"
            notationButton.setImage(notNormalPolan, for: UIControlState.normal)
            equals.isEnabled = false
            enter.isEnabled = true
        }
    }
    
    
    @IBAction func enter(_ sender: AnyObject) {
        if rP {
            // finishes a number
            doubles.append(Double(numberView.text!)!)
            numberView.text = "0.0"
            // update rpstack
            updateRPStack()
        }
    }
    
    func updateRPStack() {
        var rpstacks = ""
        for num in doubles {
            rpstacks += "\(num) "
        }
        rPStack.text = rpstacks
    }
    
    @IBAction func calculate(_ sender: AnyObject) {
        //hotfix 
        
        currentOperator.text = "="
        
        switch pressedOperator {
        case "+":
            result = doubles.popLast()! + doubles.popLast()!
        case "-":
            let num2 = doubles.popLast()!
            let num1 = doubles.popLast()!
            result = num1 - num2
        case "*":
            result = doubles.popLast()! * doubles.popLast()!
        case "/":
            let num2 = doubles.popLast()!
            let num1 = doubles.popLast()!
            result = num1 / num2
        case "%":
            let num2 = doubles.popLast()!
            let num1 = doubles.popLast()!
            result = fmod(num1, num2)
        case "count":
            result = Double(doubles.count)
        case "avg":
            for stored in doubles {
                result += stored
            }
            result = result / Double(doubles.count)
        case "!":
            if doubles.count == 1 {
                result = factorial(number: doubles.popLast()!)
            }
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
     what happens when
     5 avg 4 avg 2 + 1 ???
     5 count 3 count 2 + 1 ???
     
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

