//
//  CommentsViewController.swift
//  DribbleClient
//
//  Created by Pavel Popov on 14.09.16.
//  Copyright © 2016 Pavel Popov. All rights reserved.
//

import UIKit
import MBProgressHUD

typealias CommentFunction = (body: String, completion: VoidFunction) -> ()!

class CommentsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var commentView: UIView!
    @IBOutlet weak var commentField: UITextField!
    
    weak var viewModel: CommentsViewModel!{
        didSet{
         
            commentAction = viewModel.commentAction
        }
    }
    
    var commentAction: CommentFunction!
    
    @IBAction func sendCommentAction(sender: UIButton) {
        if let text = commentField.text {
            commentAction(body: text){
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Comments"
        
        tableView.backgroundColor = StyleKit.charcoalColor
        
        tableView.rowHeight = UITableViewAutomaticDimension
        
        tableView.estimatedRowHeight = tableView.bounds.height / 2
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshTableView(_:)), forControlEvents: .ValueChanged)
        tableView.addSubview(refreshControl)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if viewModel.numberOfComments() > 0 {
            tableView.reloadData()
        }else{
            updateComments()
        }
    }
    
    func refreshTableView(sender: UIRefreshControl){
        
        updateComments()
        
        sender.endRefreshing()
    }
    
    private func updateComments(){
        
        let hud = MBProgressHUD.showHUDAddedTo(view, animated: true)
        hud.labelText = "Loading shots"
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        viewModel.updateComments(){
            
            hud.hide(true)
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            self.tableView.reloadData()
        }
    }
}

extension CommentsViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfComments()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("CommentCell") as? CommentsTableViewCell
        
        if cell == nil {
            cell = CommentsTableViewCell(style: .Default, reuseIdentifier: "CommentCell")
        }
                
        cell?.cellViewModel = viewModel.cellViewModel(atIndex: indexPath.row)
        
        return cell!
    }
}

