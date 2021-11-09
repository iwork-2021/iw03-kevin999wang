//
//  WebInfoTableViewCell.swift
//  ITSC
//
//  Created by kw9w on 11/9/21.
//

import UIKit

class WebInfoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var sumInfo: UILabel!
    @IBOutlet weak var reDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
