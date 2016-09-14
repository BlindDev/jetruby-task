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
    @IBOutlet weak var userButton: UIButton!
    @IBOutlet weak var likeButton: LikeButton!
    
    weak var cellViewModel: ShotsTableViewCellViewModel!{
        didSet{
            titleLabel.text = cellViewModel.shotTitle

            descriptionLabel.text = cellViewModel.shotDescription

            userButton.setTitle(cellViewModel.shotUsername, forState: .Normal)
            
            user = cellViewModel.user
            
            if let url = NSURL(string: cellViewModel.shotImageLink) {
                
                let hud = MBProgressHUD.showHUDAddedTo(shotView, animated: true)
                shotView.sd_setImageWithURL(url) { (image, error, casheType, url) in
                    hud.hide(true)
                }
            }
            
            cellViewModel.shotLikeAction(HTTPMehod.GET) { (result) in
                 self.likeButton.shotLiked = result
            }
            
            likeFunction = cellViewModel.shotLikeFunction
        }
    }
    
    var likeFunction: ShotLikeFunction!
    
    private var user: User?
    
    var delegate: ShotsCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = UIColor.clearColor()
        shotView.contentMode = .ScaleAspectFit
        descriptionLabel.numberOfLines = 3
        descriptionLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
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
