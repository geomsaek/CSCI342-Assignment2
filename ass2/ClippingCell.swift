//
//  ClippingCell.swift
//  ass2
//
//  Created by Matthew Saliba on 1/05/2016.
//  Copyright © 2016 Matthew Saliba. All rights reserved.
//

import UIKit

class ClippingCell: UITableViewCell {

    @IBOutlet var photo: UIImageView!
    
    @IBOutlet var clipTitle: UILabel!
    
    @IBOutlet var clipNotes: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
}
