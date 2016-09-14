//
//  CommentsTableViewCell.swift
//  DribbleClient
//
//  Created by Pavel Popov on 14.09.16.
//  Copyright © 2016 Pavel Popov. All rights reserved.
//

import UIKit

class CommentsTableViewCell: UITableViewCell {

    @IBOutlet weak var iconView: IconView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var commentView: UITextView!
    
    weak var cellViewModel: CommentsTableViewCellViewModel!{
        didSet{
            commentView.text = cellViewModel.commentBody
            dateLabel.text = cellViewModel.date
            userLabel.text = cellViewModel.userName
            
            if let url = NSURL(string: cellViewModel.avatarLink) {
                iconView.sd_setImageWithURL(url)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = StyleKit.charcoalColor
    }
}

class IconView: UIImageView {
    override func awakeFromNib() {
        layer.cornerRadius = bounds.height/2
        clipsToBounds = true
    }
}

class CellContentView: UIView {
    override func drawRect(rect: CGRect) {
        StyleKit.drawComment(commentFrame: bounds)
    }
}
