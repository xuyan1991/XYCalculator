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
import SnapKit


class ViewController: UIViewController {

    var titleLabel: UILabel = UILabel()
    var detailLabel: UILabel = UILabel()
    let resultView: MaterialView = MaterialView()
    private var beforeOp: String = ""
    private var typingFlag: Bool = false
    private var opFlag: Bool = false
    private var buttonList: [UIView] = [UIView]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = MaterialColor.white
        titleLabel.text = "INPUT"
        titleLabel.textColor = MaterialColor.blue.darken1
        titleLabel.textAlignment = .Right
        titleLabel.font = RobotoFont.mediumWithSize(20)
        titleLabel.alpha = 1
        detailLabel.text = "RESULT"
        detailLabel.textAlignment = .Right
        detailLabel.font = RobotoFont.mediumWithSize(40)
        detailLabel.alpha = 1

        let buttonView = MaterialView()
        
        let buttonTitles: Array<String> = [ "7", "8", "9", "/",
                                            "4", "5", "6", "*",
                                            "1", "2", "3", "+",
                                            ".", "0", "=", "-"]
        resultView.depth = .Depth3
        resultView.addSubview(titleLabel)
        resultView.addSubview(detailLabel)
        self.view.addSubview(buttonView)
        self.view.addSubview(resultView)
        resultView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(self.view).offset(20)
            make.left.equalTo(self.view).offset(20)
            make.right.equalTo(self.view).offset(-20)
            make.height.equalTo(152)
            
        }
        titleLabel.snp_makeConstraints{ (make) ->Void in
            make.top.equalTo(resultView).offset(10)
            make.left.equalTo(resultView).offset(10)
            make.right.equalTo(resultView).offset(-10)
            make.height.equalTo(44)
        }
        detailLabel.snp_makeConstraints{ (make) ->Void in
            make.top.equalTo(titleLabel.snp_bottom)
            make.left.equalTo(resultView).offset(10)
            make.bottom.equalTo(resultView).offset(-10)
            make.right.equalTo(resultView).offset(-10)
        }

        buttonView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(resultView.snp_bottom).offset(10)
            make.left.equalTo(self.view).offset(10)
            make.bottom.equalTo(self.view).offset(-20)
            make.right.equalTo(self.view).offset(-10)
        }
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
            buttonView.addSubview(button)
            
            
        }
        buttonView.grid.axis.direction = .None
        buttonView.grid.spacing = 8
        buttonView.grid.axis.inherited = false
        buttonView.grid.views = buttonList
        buttonView.grid.axis.columns = 12
        buttonView.grid.axis.rows = 12
        buttonView.grid.contentInsetPreset = .Square3
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tapped(button:UIButton){
        print(beforeOp)
        let ops: [String] = ["*", "+", "-", "/", "."]
        if ops.contains(beforeOp) && ops.contains(button.currentTitle!){
            opFlag = true
        }
        else{
            opFlag = false
        }
        if opFlag == false {
            if(typingFlag) {
                titleLabel.text! = "\(titleLabel.text!)\(button.currentTitle!)"
            }
            else{
                titleLabel.text! = "\(button.currentTitle!)"
            }
            beforeOp = String(titleLabel.text!.characters.last!)
        }
        
        let cal: CalculatorBrain = CalculatorBrain()
        let result: Double = cal.eval(titleLabel.text!)
        detailLabel.text! = "\(result)"
        typingFlag = true
    }
    func bingo(button:UIButton){
        
        titleLabel.text = ""
        typingFlag = false
    }
    



}


