//
//  EditCityListTableViewCell.swift
//  WhetherProject
//
//  Created by ts on 2016/11/26.
//  Copyright © 2016年 ts. All rights reserved.
//

import UIKit

class EditCityListTableViewCell: UITableViewCell {
    @IBOutlet weak var locationImageView:UIImageView!
    @IBOutlet weak var whetherImageView:UIImageView!
    @IBOutlet weak var cityLabel:UILabel!
    @IBOutlet weak var tempretureLabel:UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
