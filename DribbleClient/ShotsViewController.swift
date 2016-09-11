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
    
    @IBAction func logoutAction(sender: UIBarButtonItem) {
        viewModel.logout()
        hasToken = viewModel.hasToken()
        checkToken()
    }
    
    private var hasToken: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        checkToken()
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
            
            print("Hura! We have a token in SHOTS")
        }
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

