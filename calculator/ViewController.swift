//
//  ViewController.swift
//  calculator
//
//  Created by 徐岩 on 16/2/29.
//  Copyright © 2016年 xuyan. All rights reserved.
//

import UIKit
import Material
import Foundation


class ViewController: UIViewController {

    private var resultLabel:UILabel?
    private var typingFlag: Bool = false
    private var buttonView:MaterialView?
    private var buttonList: [UIView] = [UIView]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = MaterialColor.white
        
        var resultView:MaterialView
        resultView = MaterialView(frame: CGRectMake(10, 30, UIScreen.mainScreen().bounds.width - 20, 88))
        resultView.depth = .Depth3
        resultLabel = UILabel(frame: CGRectMake(0, 0, resultView.bounds.width - 20, 44))
        resultLabel!.backgroundColor = MaterialColor.white
        resultLabel!.text = "结果"
        resultLabel!.textColor = MaterialColor.blue.accent3
        resultLabel!.textAlignment = .Right
        resultLabel!.font = RobotoFont.medium
        resultView.addSubview(resultLabel!)
        buttonView = MaterialView(frame: CGRectMake(0, resultView.frame.maxY + 30, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height - 200))
        
        let buttonTitles: Array<String> = [ "9", "8", "7", "/",
                                            "6", "5", "4", "*",
                                            "3", "2", "1", "+",
                                            ".", "0", "=", "-"]
        for index in 0...15{
            
            let button: RaisedButton = RaisedButton()
            button.setTitle("\(buttonTitles[index])", forState: .Normal)
            button.titleLabel!.font = RobotoFont.mediumWithSize(32)
            button.grid.columns = 3
            button.grid.rows = 3
            button.grid.offset.columns = index % 4 * 3
            button.grid.offset.rows = index / 4 * 3
            button.depth = .Depth2
            button.backgroundColor = MaterialColor.grey.base
            button.addTarget(self,action:Selector("tapped:"),forControlEvents:.TouchUpInside)

            switch index{
            case 14:
                button.backgroundColor = MaterialColor.red.darken1
                button.removeTarget(self, action: Selector("tapped:"), forControlEvents: .TouchUpInside)
                button.addTarget(self,action:Selector("bingo:"),forControlEvents:.TouchUpInside)
                
                
            default: break
            }
            buttonList.append(button)
            
            
   
            buttonView!.addSubview(button)
            
           
        }
        buttonView!.grid.axis.direction = .None
        buttonView!.grid.spacing = 8
        buttonView!.grid.axis.inherited = false
        buttonView!.grid.views = buttonList
        buttonView!.grid.axis.columns = 12
        buttonView!.grid.axis.rows = 12
        buttonView!.grid.contentInsetPreset = .Square3
        //buttonView.
        self.view.addSubview(resultView)
        self.view.addSubview(buttonView!)

        
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tapped(button:UIButton){
        if(typingFlag){
            resultLabel!.text! = "\(resultLabel!.text!)\(button.currentTitle!)"
        }
        else{
            resultLabel!.text! = "\(button.currentTitle!)"
        }
        typingFlag = true
        
        
    }
    func bingo(button:UIButton){
        let cal: CalculatorBrain = CalculatorBrain()
        
        let result: Double = cal.eval(resultLabel!.text!)
        resultLabel!.text! = "\(result)"
       // print(resultLabel!.text! )
        if(resultLabel!.text! == "1990.09.08="){
            buttonList.removeFirst()
            var view:UIView?

            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                
                //这里写需要大量时间的代码
                print("这里写需要大量时间的代码")
                
                dispatch_async(dispatch_get_main_queue(), {
                    
                    //这里返回主线程，写需要主线程执行的代码
                    print("这里返回主线程，写需要主线程执行的代码")
                })
            })
            
            if(true)
            {
                view = buttonView!.subviews[0]
                
                view!.removeFromSuperview()
                //delay(2.0, task: <#T##() -> ()#>)
            }
            buttonView!.grid.views = buttonList
           // buttonView?.grid
        }

        typingFlag = false
        
        
    }
    

    typealias Task = (cancel : Bool) -> ()
    func delay(time:NSTimeInterval, task:()->()) ->  Task? {
        func dispatch_later(block:()->()) {
            dispatch_after(
                dispatch_time(
                    DISPATCH_TIME_NOW,
                    Int64(time * Double(NSEC_PER_SEC))),
                dispatch_get_main_queue(),
                block)
        }
        var closure: dispatch_block_t? = task
        var result: Task?
        let delayedClosure: Task = {
            cancel in
            if let internalClosure = closure {
                if (cancel == false) {
                    dispatch_async(dispatch_get_main_queue(), internalClosure);
                }
            }
            closure = nil
            result = nil
        }
        result = delayedClosure
        dispatch_later {
            if let delayedClosure = result {
                delayedClosure(cancel: false)
            }
        }
        return result;
    }
    func cancel(task:Task?) {
        task?(cancel: true)
    }

}

