//
//  ShotsViewController.swift
//  DribbleClient
//
//  Created by Pavel Popov on 09.09.16.
//  Copyright © 2016 Pavel Popov. All rights reserved.
//

import UIKit

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
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        checkToken()
    }
    
    private func checkToken() {
     
        if !hasToken {
            
            if let loginViewController = storyboard?.instantiateViewControllerWithIdentifier("LoginViewController") as? LoginViewController {
                
                let loginViewModel = LoginViewModel(withTokenStatus: hasToken)

                loginViewController.viewModel = loginViewModel
                
                presentViewController(loginViewController, animated: true, completion: nil)
            }
        }else{
            
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
            viewModel.updateShots(){
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                self.tableView.reloadData()
            }
        }
    }
}

extension ShotsViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.shots.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell")
        
        cell!.textLabel?.text = viewModel.shots[indexPath.row].title
                
        cell!.detailTextLabel?.text = viewModel.shots[indexPath.row].created?.convertedString
        
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

