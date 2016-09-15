//
//  ShotsTableViewCell.swift
//  DribbleClient
//
//  Created by Pavel Popov on 12.09.16.
//  Copyright © 2016 Pavel Popov. All rights reserved.
//

import UIKit
import SDWebImage
import MBProgressHUD

typealias BoolVoidFunction = (result: Bool) -> ()
typealias ShotLikeFunction = (method: HTTPMehod, completion: BoolVoidFunction) -> ()!

protocol ShotsCellDelegate {
    func didSelectUser(user: User)
}

class ShotsTableViewCell: UITableViewCell {

    @IBOutlet weak var shotView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var userButton: UserButton!
    @IBOutlet weak var likeButton: LikeButton!
    var delegate: ShotsCellDelegate?
    
    weak var cellViewModel: ShotsTableViewCellViewModel!{
        didSet{
            title = cellViewModel.shotTitle

            desc = cellViewModel.shotDescription
            
            user = cellViewModel.user
            
            liked = cellViewModel.shotLiked
            
            likeFunction = cellViewModel.shotLikeFunction
        }
    }
    
    private var likeFunction: ShotLikeFunction!
    private var title: String!
    private var desc: String!
    private var shotImageLink: String!
    private var user: User?
    private var liked: Bool!
    private var activityIndicator: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = UIColor.clearColor()
        shotView.contentMode = .ScaleAspectFit
        descriptionLabel.numberOfLines = 3
        descriptionLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
        
        activityIndicator = UIActivityIndicatorView()
        activityIndicator.activityIndicatorViewStyle = .WhiteLarge
        addSubview(activityIndicator)
    }
    
    override func drawRect(rect: CGRect) {
        activityIndicator.frame = bounds
    }
    
    @IBAction func likeAction(sender: LikeButton) {
        
        let action = sender.shotLiked == true ? HTTPMehod.DELETE : HTTPMehod.POST
        
        sender.enabled = false
        
        likeFunction(method: action) { (result) in
        
            sender.shotLiked = result
            sender.enabled = true
        }
    }
    @IBAction func userSelection(sender: UIButton) {
        guard let selectedUser = user else{
            return
        }
        
        delegate?.didSelectUser(selectedUser)
    }
    
    func updateDisplay(){
        
        titleLabel.text = title
                    
        descriptionLabel.text = desc
        
        likeButton.shotLiked = liked
        
        if let currentUser = user {
            userButton.setTitle(currentUser.username, forState: .Normal)
        }

        if let url = NSURL(string: cellViewModel.shotImageLink) {
            
//            let hud = MBProgressHUD.showHUDAddedTo(shotView, animated: true)
            activityIndicator.startAnimating()
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
            shotView.sd_setImageWithURL(url) { (image, error, casheType, url) in
//                hud.hide(true)
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                self.activityIndicator.stopAnimating()

            }
        }
        
    }
}

class LikeButton: UIButton {
    
    var shotLiked: Bool! = false {
        didSet{
            setNeedsDisplay()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setTitleColor(StyleKit.pinkColor, forState: .Normal)
        setTitleColor(UIColor.magentaColor(), forState: .Disabled)
    }
    
    override func drawRect(rect: CGRect) {
        
        StyleKit.drawLikeButtonHeart(heartFrame: bounds, shotLiked: shotLiked)
    }
}

class UserButton: UIButton {
    override func drawRect(rect: CGRect) {
        StyleKit.drawUserButton(loginButtonFrame: bounds)
        
        tintColor = UIColor.whiteColor()
    }
}
