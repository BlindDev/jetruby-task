//
//  ListTableViewCell.swift
//  DribbleClient
//
//  Created by Pavel Popov on 15.09.16.
//  Copyright © 2016 Pavel Popov. All rights reserved.
//

import UIKit

class ListTableViewCell: UITableViewCell {

    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    
    weak var cellViewModel: ListCellModel!{
        didSet{
            detailLabel.text = cellViewModel.detailText
            userLabel.text = cellViewModel.userName
            
            if let url = NSURL(string: cellViewModel.avatarLink) {
                iconView.sd_setImageWithURL(url)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
