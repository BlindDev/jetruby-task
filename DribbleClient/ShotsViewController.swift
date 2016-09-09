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
            //TODO: update data, refresh data through model
        }
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
        }
    }
}

