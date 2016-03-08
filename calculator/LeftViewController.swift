//
//  LeftViewController.swift
//  calculator
//
//  Created by 徐岩 on 16/3/8.
//  Copyright © 2016年 xuyan. All rights reserved.
//



import UIKit
import Material

private struct Cell {
    var text: String
    var imageName: String
    var selected: Bool
}

class LeftViewController: UIViewController {
    /// A tableView used to display navigation items.
    private let tableView: UITableView = UITableView()
    
    /// A list of all the navigation items.
    private var items: Array<Cell> = Array<Cell>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareView()
        prepareCells()
        prepareTableView()
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
        view.backgroundColor = MaterialColor.blueGrey.darken4
    }
    
    /// Prepares the items that are displayed within the tableView.
    private func prepareCells() {
        items.append(Cell(text: "计算器", imageName: "ic_inbox", selected: true))
        items.append(Cell(text: "汇率计算", imageName: "ic_today", selected: false))
        items.append(Cell(text: "Bookmarks", imageName: "ic_book", selected: false))
        items.append(Cell(text: "Work", imageName: "ic_work", selected: false))
        items.append(Cell(text: "Contacts", imageName: "ic_contacts", selected: false))
        items.append(Cell(text: "Settings", imageName: "ic_settings", selected: false))
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
extension LeftViewController: UITableViewDataSource {
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
        
        cell.textLabel!.textColor = item.selected ? MaterialColor.cyan.lighten5 : MaterialColor.grey.lighten3
        
        return cell
    }
}

/// UITableViewDelegate methods.
extension LeftViewController: UITableViewDelegate {
    /// Sets the tableView cell height.
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 64
    }
    
    /// Select item at row in tableView.
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("Cell selected")
        //self.view.superview.
    }
    func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        let item = items[indexPath.row]
        
        /**
        An example of loading a new UIViewController in the AppNavigationBarViewController
        if the UIViewController is not already loaded. This is a bit of a tricky example, as
        we are diving deeper into the view hierarchy to transition only the mainViewController of the
        AppNavigationBarViewController.
        
        Accessing the mainViewController of: SideNavigationViewController -> MenuViewController -> NavigationBarViewController.
        */
        if let a: NavigationController = sideNavigationViewController?.mainViewController as? NavigationController {
            //if let b: NavigationBarViewController = a.mainViewController as? NavigationBarViewController {
                if "计算器" == item.text && !(a.mainViewController is ViewController) {
                    a.transitionFromMainViewController(ViewController(), options: [.TransitionCrossDissolve]) { [weak self] _ in
                        self?.sideNavigationViewController?.closeLeftView()
                    }
                } else if "汇率计算" == item.text && !(a.mainViewController is CurrencyViewController) {
                    a.transitionFromMainViewController(CurrencyViewController(), options: [.TransitionCrossDissolve]) { [weak self] _ in
                        self?.sideNavigationViewController?.closeLeftView()
                    }
                }
            //}
        }
        return indexPath
    }
}
