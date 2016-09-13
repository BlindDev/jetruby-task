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
            let shot = cellViewModel.shot
            titleLabel.text = shot.title
            descriptionLabel.text = shot.desc
            userButton.setTitle(shot.user?.username, forState: .Normal)
            
            var link: String!
            
            if let hidpi = shot.images?.hidpi {
                link = hidpi
            }else{
                link = shot.images?.normal
            }
            
            if let url = NSURL(string: link) {
                
                shotView.sd_setImageWithURL(url) { (image, error, SDImageCacheType, url) in
                    
                    //TODO: add load indicator
                }
            }
            
            //TODO: add like checking
            cellViewModel.checkLike(){
                self.likeButton.shotLiked = shot.liked
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

}

class LikeButton: UIButton {
    
    var shotLiked: Bool! = false {
        didSet{
            setNeedsDisplay()
        }
    }
    
    override func drawRect(rect: CGRect) {
        
        let title = shotLiked == true ? "U" : "L"
        
        setTitle(title, forState: .Normal)
    }
}
