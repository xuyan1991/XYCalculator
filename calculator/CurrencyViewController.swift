//
//  LeftViewController.swift
//  calculator
//
//  Created by 徐岩 on 16/3/8.
//  Copyright © 2016年 xuyan. All rights reserved.
//



import UIKit
import Material
import SwiftyJSON
import Alamofire
private struct Cell {
    var text: String
    var imageName: String
    var selected: Bool

}


class CurrencyViewController: UIViewController {
    /// A tableView used to display navigation items.
    private let tableView: UITableView = UITableView()
    
    /// A list of all the navigation items.
    private var items: Array<Cell> = Array<Cell>()
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareView()

        self.reloadData()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        /*
        The dimensions of the view will not be updated by the side navigation
        until the view appears, so loading a dyanimc width is better done here.
        The user will not see this, as it is hidden, by the drawer being closed
        when launching the app. There are other strategies to mitigate from this.
        This is one approach that works nicely here.
        */
        //prepareProfileView()
    }
    
    /// General preparation statements.
    private func prepareView() {
        view.backgroundColor = MaterialColor.white
        
    }
    
    /// Prepares the items that are displayed within the tableView.
    private func prepareCells() {
        
        
//        for country in model.request(){
//        }
    }
    private func reloadData() {
        let request = Alamofire.request(.GET, "http://apis.baidu.com/apistore/currencyservice/type",headers:["apikey": "a7c0f1c570be9e0f9f09ef88213ce7b1"])
            .responseJSON { _, _, result in
                
                print(result.value!["retData"]!)
                
                let country:[String] = result.value!["retData"]!! as! [String]
                for name in country {
                    self.items.append(Cell(text: name, imageName: "ic_inbox", selected: true))

                }
                self.prepareTableView()
                //debugPrint(result)
        }
        
        
        
    }
    
    //Prepares profile view.
    private func prepareProfileView() {
        let backgroundView: MaterialView = MaterialView()
        backgroundView.image = UIImage(named: "MaterialBackground")
        
        let profileView: MaterialView = MaterialView()
        profileView.image = UIImage(named: "Profile9")?.resize(toWidth: 72)
        profileView.backgroundColor = MaterialColor.clear
        profileView.shape = .Circle
        profileView.borderColor = MaterialColor.white
        profileView.borderWidth = 3
        view.addSubview(profileView)
        
        let nameLabel: UILabel = UILabel()
        nameLabel.text = "Michael Smith"
        nameLabel.textColor = MaterialColor.white
        nameLabel.font = RobotoFont.mediumWithSize(18)
        view.addSubview(nameLabel)
        
        profileView.translatesAutoresizingMaskIntoConstraints = false
        
        MaterialLayout.alignFromTopLeft(view, child: profileView, top: 30, left: (view.bounds.width - 72) / 2)
        MaterialLayout.size(view, child: profileView, width: 72, height: 72)
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        MaterialLayout.alignFromTop(view, child: nameLabel, top: 130)
        MaterialLayout.alignToParentHorizontally(view, child: nameLabel, left: 20, right: 20)
    }

    /// Prepares the tableView.
    private func prepareTableView() {
        
        tableView.registerClass(MaterialTableViewCell.self, forCellReuseIdentifier: "MaterialTableViewCell")
        tableView.backgroundColor = MaterialColor.clear
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .None
        
        // Use MaterialLayout to easily align the tableView.
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        MaterialLayout.alignToParent(view, child: tableView, top: 30)
    }
}

/// TableViewDataSource methods.
extension CurrencyViewController: UITableViewDataSource {
    /// Determines the number of rows in the tableView.
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count;
    }
    
    /// Prepares the cells within the tableView.
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: MaterialTableViewCell = tableView.dequeueReusableCellWithIdentifier("MaterialTableViewCell", forIndexPath: indexPath) as! MaterialTableViewCell
        cell.backgroundColor = MaterialColor.clear
        
        let item: Cell = items[indexPath.row]
        cell.textLabel!.text = item.text
        cell.textLabel!.font = RobotoFont.medium
        cell.imageView!.image = UIImage(named: item.imageName)?.imageWithRenderingMode(.AlwaysTemplate)
        cell.imageView!.tintColor = MaterialColor.grey.lighten2
        
        cell.textLabel!.textColor = item.selected ? MaterialColor.blue.lighten1 : MaterialColor.grey.lighten1
        //cell.detailTextLabel!.text = ";;"

        return cell
    }
}

/// UITableViewDelegate methods.
extension CurrencyViewController: UITableViewDelegate {
    /// Sets the tableView cell height.
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 64
    }
    
    /// Select item at row in tableView.
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("Cell selected")
        //self.view.superview.
    }

}
