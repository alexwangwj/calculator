//
//  ViewController.swift
//  MyCalculator
//
//  Created by wangjie on 2017/7/26.
//  Copyright © 2017年 wangjiejuranaa. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    var userIsInTheMiddleOfTyping = false
    @IBOutlet weak var display: UILabel!
    var lastKey = "noneOperation"
    //按数字键
    @IBAction func digit(_ sender: UIButton) {
        lastKey = "noneOperation"
        let digit = sender.currentTitle!

        if userIsInTheMiddleOfTyping{
            //如果按过小数点后再按小数点，应当无效，保持当前数字
            //如当前数字为0.5，此时再按小数点，仍应显示0.5，而不是0.5.
            if display.text!.contains(".") && digit == "."{
                display.text = display.text!
            }
            else{
                //如果第一个数字为0，按了任意数字后，不应再显示0，或者0x，而应显示x
                //按了0，又按了5，应显示5，而不是05
                if display.text == "0" && digit != "."{
                    display.text = digit
                }
                else{//以上两种都不是，那么就在后面直接加数字或者小数点就可以了
                    display.text = display.text! + digit
                }
            }
        }
        else{//如果之前没有输过任何数字，按小数点直接显示0.，而不是显示.
            if digit == "."{
                display.text = "0."
            }
            else{//如果没有输入过任何数字，那么第一个输入的数字应该替换掉原来默认显示的0，而不是显示0x
            display.text = digit
            }
            userIsInTheMiddleOfTyping = true
        }
    }
    
    //按清除键
    @IBAction func clear() {
        lastKey = "noneOperation"
        display.text = "0"
        userIsInTheMiddleOfTyping = false
        operandStack.removeAll()
    }
    
    var operandStack = [Double]()
    var displayValue : Double{//定义Double型的变量用来计算结果
        get{
            return NumberFormatter().number(from: display.text!)!.doubleValue//从display拿数字，string转换成double
        }
        set{//把计算结果放到display上显示
            userIsInTheMiddleOfTyping = false
            display.text = "\(newValue)"
        }
    }
    
    func yunSuan(){
        if operandStack.count >= 2{//至少有两个数字输入才运算，否则不动
            if operation == 3 && operandStack.last == 0{//如果是除以0的运算，那么应显示“除数不能为0”
                display.text = "除数不能为0"
                operandStack.removeAll()
            }
            else{//如果不是除以0的运算，弹出盏内最后两个数字进行计算
                displayValue = performOperation(op1: operandStack.removeLast(), op2: operandStack.removeLast())
                operandStack.append(displayValue)
            }
        }
    }
    //按加减乘除键
    var operation = 0
    
    @IBAction func operation(_ sender: UIButton) {
        let op = sender.currentTitle!

        //如果前一次没有按过加减乘除，也没有显示“除数不能为0”，那么就把当前显示的数字压栈并计算结果，并且在lastKey中记录当前做的是什么操作
        if lastKey == "noneOperation" && display.text != "除数不能为0"{
        operandStack.append(displayValue)//压栈
        print(operandStack)

            switch op {
            case "+":
                yunSuan()//计算结果
                operation = 0//记录当前按下的运算类型，下次performoOperation需要用到
                lastKey = "+"//记录当前按下的运算类型
                
            case "-":
                yunSuan()
                lastKey = "-"
                operation = 1
                
                
            case "x":
                yunSuan()
                lastKey = "x"
                operation = 2
                
                
            case "÷":
                yunSuan()
                lastKey = "÷"
                operation = 3
                
            default:
                break
            }
            userIsInTheMiddleOfTyping = false
        }

        //如果上一次按的是个运算符，并且和这次按的不同，那么不运算，只是记录当前按下的运算类型
        else if lastKey != op{
            switch op {
            case "+":
                operation = 0
                lastKey = "+"

            case "-":
                lastKey = "-"
                operation = 1

            case "x":
                lastKey = "x"
                operation = 2

            case "÷":
                lastKey = "÷"
                operation = 3

            default:
                break
            }

        }
        //如果连续按了两次同样的运算符，那么不做任何操作

    }

    
    func performOperation(op1: Double, op2:Double) -> Double{
    
        switch operation{//根据operation记录的运算类型进行计算
        case 0:
            return op2 + op1
            
        case 1:
            return op2 - op1
            
        case 2:
            return op2 * op1
            
        case 3:
            return op2 / op1
            
        default:
            return 0
        }
    }
    
 
    //按等于键
    @IBAction func equal() {
        lastKey = "noneOperation"
        if userIsInTheMiddleOfTyping{
            operandStack.append(displayValue)//将显示的数值压栈
            if operandStack.count >= 2{
                if operation == 3 && operandStack.last == 0{
                    display.text = "除数不能为0"
                    operandStack.removeAll()
                }
                else{
                    displayValue = performOperation(op1:operandStack.removeLast(), op2: operandStack.removeLast())
                }
            }
        }
            
        else{
            operandStack.removeAll()
        }
        userIsInTheMiddleOfTyping = false
    }
    
}
