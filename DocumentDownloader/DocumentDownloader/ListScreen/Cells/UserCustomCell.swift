//
//  UserCustomCell.swift
//  DocumentDownloader
//
//  Created by Rahul Narang on 2/4/17.
//  Copyright © 2017 rahul. All rights reserved.
//

import UIKit

class UserCustomCell: UITableViewCell {

    @IBOutlet private weak var imgUser: UIImageView!
    @IBOutlet private weak var lbluserName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: - Configure Cell
    func configureCell(objUser: User) {
        if let strUrl = objUser.getUserImageUrl() {
            self.imgUser.setImageUrl(str: strUrl)
        }
        if let name = objUser.name {
            self.lbluserName.text = name
        }
    }
    
    // MARK: - Animating Cells
    func animateCells(objUser: User, isScrollingUp: Bool) {
        self.transform = CGAffineTransform(translationX: 0, y: isScrollingUp ? -self.frame.size.height : self.frame.size.height)
        UIView.animate(withDuration: 0.3) { 
            self.transform = CGAffineTransform(translationX: 0, y: 0)
        }
    }

}
