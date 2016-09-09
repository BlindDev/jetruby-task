//
//  LoginViewController.swift
//  DribbleClient
//
//  Created by Pavel Popov on 09.09.16.
//  Copyright © 2016 Pavel Popov. All rights reserved.
//

import UIKit

protocol LoginViewDelegate {
    func authenticate()
}

class LoginViewController: UIViewController {

    weak var viewModel: LoginViewModel! {
        didSet{
            delegate = viewModel
        }
    }
    
    private var delegate: LoginViewDelegate?
    
    @IBAction func loginAction(sender: UIButton) {
        delegate?.authenticate()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()


        // Do any additional setup after loading the view.
    }
}
