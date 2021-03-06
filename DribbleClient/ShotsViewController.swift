//
//  ShotsViewController.swift
//  DribbleClient
//
//  Created by Pavel Popov on 09.09.16.
//  Copyright © 2016 Pavel Popov. All rights reserved.
//

import UIKit
import MBProgressHUD

typealias VoidFunction = ()->()!

class ShotsViewController: UIViewController {

    weak var viewModel: ShotsViewModel!{
        didSet{
            
            logoutFunction = viewModel.logoutFunction
        }
    }
    
    var logoutFunction: VoidFunction!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func logoutAction(sender: UIBarButtonItem) {
        logoutFunction()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Shots"
        
        tableView.backgroundColor = StyleKit.charcoalColor
        tableView.estimatedRowHeight = tableView.bounds.height / 2
        
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshTableView(_:)), forControlEvents: .ValueChanged)
        tableView.addSubview(refreshControl)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if viewModel.numberOfShots() > 0 {
            tableView.reloadData()
        }else{
            updateShots()
        }
    }
    
    func refreshTableView(sender: UIRefreshControl){
        
        updateShots()
        
        sender.endRefreshing()
    }
    
    private func updateShots(){
        
        let hud = MBProgressHUD.showHUDAddedTo(view, animated: true)
        hud.labelText = "Loading shots"
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        viewModel.updateShots(){
            
            hud.hide(true)
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            self.tableView.reloadData()
        }
    }
}

extension ShotsViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfShots()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! ShotsTableViewCell
        
        cell.cellViewModel = viewModel.cellViewModel(atIndex: indexPath.row)
        
        cell.delegate = self
        
        cell.updateDisplay()
        
        return cell
    }
}

extension ShotsViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        guard let selectedRow = tableView.indexPathForSelectedRow?.row else{
            return
        }
        
        guard let shotID = viewModel.cellViewModel(atIndex: selectedRow)?.shotID else{
            return
        }
        
        if let commentsViewController = storyboard?.instantiateViewControllerWithIdentifier("CommentsViewController") as? CommentsViewController {
            
            let commentsViewModel = CommentsViewModel(withShotID: shotID)
            
            commentsViewController.viewModel = commentsViewModel
            
            navigationController?.pushViewController(commentsViewController, animated: true)
        }
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView == tableView{
            
            if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height){
                
                updateShots()
            }
        }
    }
}

extension ShotsViewController: ShotsCellDelegate {
    func didSelectUser(user: User) {
        if let userViewController = storyboard?.instantiateViewControllerWithIdentifier("UserViewController") as? UserViewController {
            
            let userViewModel = UserViewModel(withUser: user)
            
            userViewController.viewModel = userViewModel
            
            navigationController?.pushViewController(userViewController, animated: true)
        }
    }
}

