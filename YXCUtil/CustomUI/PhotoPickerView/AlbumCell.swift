//
//  AlbumCell.swift
//  SelectPhoto
//
//  Created by 杨新财 on 2018/2/27.
//  Copyright © 2018年 杨新财. All rights reserved.
//

import UIKit

class AlbumCell: UITableViewCell {

    @IBOutlet weak var img_cover: UIImageView!
    @IBOutlet weak var lb_title: UILabel!
    @IBOutlet weak var lb_subTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
