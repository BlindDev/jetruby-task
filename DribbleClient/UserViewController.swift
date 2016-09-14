//
//  UserViewController.swift
//  DribbleClient
//
//  Created by Pavel Popov on 15.09.16.
//  Copyright © 2016 Pavel Popov. All rights reserved.
//

import UIKit

class UserViewController: UIViewController {

    weak var viewModel: UserViewModel!{
        didSet{
            print(viewModel.name)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "User"
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
