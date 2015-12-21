//
//  AttractionCell.swift
//  Queue
//
//  Created by Adam Binsz on 12/16/15.
//  Copyright © 2015 Adam Binsz. All rights reserved.
//

import UIKit

class AttractionCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        titleLabel.constraintWithAttribute(.Width, .GreaterThanOrEqual, to: detailLabel).active = true
    }
}
