//
//  MatchesTableViewController.swift
//  AppLikeTinder
//
//  Created by Marko Budal on 04/09/15.
//  Copyright (c) 2015 Marko Budal. All rights reserved.
//

import UIKit

class MatchesTableViewController: UITableViewController {

    var matches: [Match] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationItem.titleView = UIImageView(image: UIImage(named: "chat-header"))
        
        let leftBarButtomItem = UIBarButtonItem(image: UIImage(named: "nav-back-button"), style: UIBarButtonItemStyle.Plain, target: self, action: "goToPreviousVC:")
        navigationItem.setLeftBarButtonItem(leftBarButtomItem, animated: true)
        
        fetchMatches { (matches) -> () in
            self.matches = matches
            self.tableView.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func goToPreviousVC(button: UIBarButtonItem){
        pageController.goToPreviousVC()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matches.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("UserCell", forIndexPath: indexPath) as! UserCell
        
        let user = matches[indexPath.row].user
        cell.nameLabel.text = user.name
        user.getPhoto { (image) -> () in
            cell.avatarImageView.image = image
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let vc = ChatViewController()
        vc.matchID = matches[indexPath.row].id
        vc.title = matches[indexPath.row].user.name
        navigationController?.pushViewController(vc, animated: true)
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

}
