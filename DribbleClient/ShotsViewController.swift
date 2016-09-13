//
//  ShotsViewController.swift
//  DribbleClient
//
//  Created by Pavel Popov on 09.09.16.
//  Copyright © 2016 Pavel Popov. All rights reserved.
//

import UIKit
import MBProgressHUD

class ShotsViewController: UIViewController {

    weak var viewModel: ShotsViewModel!{
        didSet{
            
            hasToken = viewModel.hasToken()
            viewModel.delegate = self
            //TODO: update data, refresh data through model
        }
    }
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func logoutAction(sender: UIBarButtonItem) {
        viewModel.logout()
        hasToken = viewModel.hasToken()
        checkToken()
    }
    
    private var hasToken: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Dribbble"
        
        tableView.backgroundColor = StyleKit.charcoalColor
        tableView.estimatedRowHeight = tableView.frame.height / 2
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        checkToken()
    }
    
    private func checkToken() {
     
        if !hasToken {
            
            if let loginViewController = storyboard?.instantiateViewControllerWithIdentifier("LoginViewController") as? LoginViewController {
                
                let loginViewModel = LoginViewModel()

                loginViewController.viewModel = loginViewModel
                
                presentViewController(loginViewController, animated: true, completion: nil)
            }
        }else{
            
            MBProgressHUD.showHUDAddedTo(view, animated: true)
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
            viewModel.updateShots(){
                MBProgressHUD.hideHUDForView(self.view, animated: true)
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                self.tableView.reloadData()
            }
        }
    }
}

extension ShotsViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfShots()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("Cell") as? ShotsTableViewCell
        
        if cell == nil {
            cell = ShotsTableViewCell(style: .Default, reuseIdentifier: "Cell")
        }
        
        cell?.cellViewModel = viewModel.cellViewModel(atIndex: indexPath.row)
        
        return cell!
    }
}

extension ShotsViewController: ShotsViewModelDelegate {
    
    func didEndAuth(success: Bool) {
        
        print("We have a token in login with status \(success)")
        
        hasToken = success
        
        if success {
            dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
}

