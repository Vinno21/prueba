//
//  TableViewCell.swift
//  prueba
//
//  Created by David on 07/05/20.
//  Copyright © 2020 David. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var txtnombreContacto: UILabel!
    @IBOutlet weak var txtcelularContacto: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
