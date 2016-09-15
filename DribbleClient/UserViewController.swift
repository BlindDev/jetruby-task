//
//  UserViewController.swift
//  DribbleClient
//
//  Created by Pavel Popov on 15.09.16.
//  Copyright © 2016 Pavel Popov. All rights reserved.
//

import UIKit
import MBProgressHUD

class UserViewController: UIViewController {

    @IBOutlet weak var avatarView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var bioView: UITextView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var listControl: UISegmentedControl!
    
    @IBAction func listSelectionAction(sender: UISegmentedControl) {
        updateList()
    }
    
    private var userName: String!
    private var userBio: String!
    private var avatarLink: String!
    
    weak var viewModel: UserViewModel!{
        didSet{
            
            userName = viewModel.name
            
            userBio = viewModel.bio
            
            avatarLink = viewModel.avatarLink
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "User"
        listControl.tintColor = StyleKit.pinkColor
        
        nameLabel.text = userName
        bioView.text = userBio
        
        if let url = NSURL(string: avatarLink) {
            avatarView.sd_setImageWithURL(url)
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        updateList()
    }
    
    private func updateList(){
        
        let hud = MBProgressHUD.showHUDAddedTo(tableView, animated: true)
        hud.labelText = listControl.selectedSegmentIndex == 0 ? "Loading followers" : "Loading likes"
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        viewModel.updateValuesForSegment(listControl.selectedSegmentIndex){
            
            hud.hide(true)
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            self.tableView.reloadData()
        }
    }
}

extension UserViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItems(listControl.selectedSegmentIndex)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("ListCell", forIndexPath: indexPath) as? ListTableViewCell
        
        cell?.cellViewModel = viewModel.cellViewModel(atIndex: indexPath.row)

        return cell!
    }
    
}
