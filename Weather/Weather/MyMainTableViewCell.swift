//
//  MyMainTableViewCell.swift
//  Weather
//
//  Created by ts on 2016/11/27.
//  Copyright © 2016年 ts. All rights reserved.
//

import UIKit

class MyMainTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    ///返回cell的高度
    func heightForCell(status:HJCStatus)->(CGFloat){
        //设置数据
        self.status = status
        //刷新布局
        self.layoutIfNeeded()
        //返回最最下方控件的最大Y值，就是高度啦
        return  CGRectGetMaxY(bottomView.frame)
    }
    
//    class func identifierOfcell(status:HJCStatus)->(String){
//        
//        if 条件一 {
//                     return "homeCell"
//                     }
//                 return "retweetedCell"
//    }
}
