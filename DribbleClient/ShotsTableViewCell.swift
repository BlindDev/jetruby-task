//
//  ShotsTableViewCell.swift
//  DribbleClient
//
//  Created by Pavel Popov on 12.09.16.
//  Copyright © 2016 Pavel Popov. All rights reserved.
//

import UIKit
import SDWebImage

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
            
            if let url = NSURL(string: cellViewModel.shotImageLink) {
                
                shotView.sd_setImageWithURL(url) { (image, error, SDImageCacheType, url) in
                    
                    //TODO: add load indicator
                }
            }
            
            cellViewModel.shotLikeAction(ShotLikeAction.CHECK) { (result) in
                 self.likeButton.shotLiked = result
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = UIColor.clearColor()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func likeAction(sender: LikeButton) {
        
        let action = sender.shotLiked == true ? ShotLikeAction.UNLIKE : ShotLikeAction.LIKE
        
        sender.enabled = false
        
        cellViewModel.shotLikeAction(action) { (result) in
            sender.shotLiked = result
            sender.enabled = true
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
        
        let title = shotLiked == true ? "U" : "L"
        
        setTitle(title, forState: .Normal)
    }
}
