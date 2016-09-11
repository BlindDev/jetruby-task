//
//  LoginViewController.swift
//  DribbleClient
//
//  Created by Pavel Popov on 09.09.16.
//  Copyright © 2016 Pavel Popov. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    weak var viewModel: LoginViewModel! {
        didSet{
            authURL = viewModel.authURL()
        }
    }
    
    var authURL: NSURL?
    
    var webView: UIWebView!
        
    @IBAction func loginAction(sender: UIButton) {
        webView.hidden = false
        loadAddressURL()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()


        webView = UIWebView(frame: view.bounds)
        webView.autoresizingMask = .FlexibleHeight
        webView.scalesPageToFit = true
        webView.hidden = true
        webView.delegate = self
        view.addSubview(webView)
    }
    
    func loadAddressURL() {
        if let targetURL =  authURL {
            let req = NSURLRequest(URL: targetURL)
            webView.loadRequest(req)
        }
    }
}

extension LoginViewController: UIWebViewDelegate {
    func webViewDidStartLoad(webView: UIWebView) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false

    }
}
