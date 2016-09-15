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
        checkData()
    }
    
    private var userName: String!
    private var userBio: String!
    private var avatarLink: String!
    
    var viewModel: UserViewModel!{
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
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshTableView(_:)), forControlEvents: .ValueChanged)
        tableView.addSubview(refreshControl)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        checkData()
    }
    
    private func checkData(){
        if viewModel.numberOfItems(listControl.selectedSegmentIndex) > 0 {
            tableView.reloadData()
        }else{
            updateList()
        }
    }
    
    private func updateList(){
        
        let hud = MBProgressHUD.showHUDAddedTo(view, animated: true)
        hud.labelText = listControl.selectedSegmentIndex == 0 ? "Loading followers" : "Loading likes"
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        viewModel.updateValuesForSegment(listControl.selectedSegmentIndex){
            
            hud.hide(true)
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            self.tableView.reloadData()
        }
    }
    
    func refreshTableView(sender: UIRefreshControl){
        
        updateList()
        
        sender.endRefreshing()
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

extension UserViewController: UITableViewDelegate {
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView == tableView{
            
            if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height){
                
                updateList()
            }
        }
    }
}
