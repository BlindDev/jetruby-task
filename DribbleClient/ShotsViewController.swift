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

        navigationItem.title = "Dribbble"
        
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
        
        var cell = tableView.dequeueReusableCellWithIdentifier("Cell") as? ShotsTableViewCell
        
        if cell == nil {
            cell = ShotsTableViewCell(style: .Default, reuseIdentifier: "Cell")
        }
        
        cell?.cellViewModel = viewModel.cellViewModel(atIndex: indexPath.row)
        
        return cell!
    }
}

