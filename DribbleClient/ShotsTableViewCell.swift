//
//  ShotsTableViewCell.swift
//  DribbleClient
//
//  Created by Pavel Popov on 12.09.16.
//  Copyright © 2016 Pavel Popov. All rights reserved.
//

import UIKit

class ShotsTableViewCell: UITableViewCell {

    @IBOutlet weak var shotView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var userButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    
    weak var cellViewModel: ShotsTableViewCellViewModel!{
        didSet{
            let shot = cellViewModel.shot
            titleLabel.text = shot.title
            descriptionLabel.text = shot.desc
            userButton.setTitle(shot.user?.username, forState: .Normal)
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
