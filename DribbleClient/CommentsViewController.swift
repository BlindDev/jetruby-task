//
//  CommentsViewController.swift
//  DribbleClient
//
//  Created by Pavel Popov on 14.09.16.
//  Copyright © 2016 Pavel Popov. All rights reserved.
//

import UIKit
import MBProgressHUD

typealias CommentFunction = (body: String, completion: ()->()) -> ()!

class CommentsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var commentView: CommentsBottomView!
    @IBOutlet weak var commentField: UITextField!
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    weak var viewModel: CommentsViewModel!{
        didSet{
         
            commentAction = viewModel.commentAction
        }
    }
    
    var commentAction: CommentFunction!
    
    @IBAction func sendCommentAction(sender: UIButton) {
        if let text = commentField.text {
            
            let hud = MBProgressHUD.showHUDAddedTo(view, animated: true)
            hud.labelText = "Sending comment"
            
            commentAction(body: text){
                hud.hide(true)
                self.updateComments()
            }
        }
        
        commentField.text = ""
        
        commentField.resignFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Comments"
        
        tableView.backgroundColor = StyleKit.charcoalColor
        
        tableView.rowHeight = UITableViewAutomaticDimension
        
        tableView.estimatedRowHeight = tableView.bounds.height / 2
        
        bottomConstraint.constant = 0
        
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
    
    override func viewWillAppear(animated: Bool) {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            bottomConstraint.constant = keyboardSize.height
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        bottomConstraint.constant = 0
    }
    
    func refreshTableView(sender: UIRefreshControl){
        
        updateComments()
        
        sender.endRefreshing()
    }
    
    private func updateComments(){
        
        let hud = MBProgressHUD.showHUDAddedTo(view, animated: true)
        hud.labelText = "Loading comments"
        
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
        
        let cell = tableView.dequeueReusableCellWithIdentifier("CommentCell", forIndexPath: indexPath) as? CommentsTableViewCell
                
        cell?.cellViewModel = viewModel.cellViewModel(atIndex: indexPath.row)
        
        return cell!
    }
}

extension CommentsViewController: UITableViewDelegate {
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView == tableView{
            
            if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height){
                
                updateComments()
            }
        }
    }
}

class CommentsBottomView: UIView {
    override func awakeFromNib() {
        backgroundColor = StyleKit.pinkColor
    }
}

