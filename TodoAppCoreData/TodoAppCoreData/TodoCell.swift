//
//  TodoCell.swift
//  TodoAppCoreData
//
//  Created by e2phus on 2022/12/24.
//

import UIKit

class TodoCell: UITableViewCell {

    @IBOutlet weak var priorityLevel: UIView! {
        didSet {
            priorityLevel.layer.cornerRadius = 15
        }
    }
    @IBOutlet weak var topTitle: UILabel!
    @IBOutlet weak var bottomDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
