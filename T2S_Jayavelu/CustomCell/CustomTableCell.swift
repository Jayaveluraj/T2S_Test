//
//  CustomTableCell.swift
//  T2S_Jayavelu
//
//  Created by JAYAVELU R on 27/06/18.
//  Copyright © 2018 Jayavelu. All rights reserved.
//

import UIKit

class CustomTableCell: UITableViewCell {

    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var lblCount: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
