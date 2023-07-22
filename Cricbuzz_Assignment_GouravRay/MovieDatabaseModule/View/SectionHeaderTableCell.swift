//
//  SectionHeaderTableCell.swift
//  Cricbuzz_Assignment_GouravRay
//
//  Created by Gourav Ray on 22/07/23.
//

import UIKit

class SectionHeaderTableCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var arrowImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
