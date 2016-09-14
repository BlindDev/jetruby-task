//
//  CommentsTableViewCell.swift
//  DribbleClient
//
//  Created by Pavel Popov on 14.09.16.
//  Copyright © 2016 Pavel Popov. All rights reserved.
//

import UIKit

class CommentsTableViewCell: UITableViewCell {

    weak var cellViewModel: CommentsTableViewCellViewModel!{
        didSet{
            textLabel?.text = cellViewModel.commentBody
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
