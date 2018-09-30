//
//  PseudoHeaderTableViewCell.swift
//  daehung
//
//  Created by 유상현 on 2018. 9. 30..
//  Copyright © 2018년 유상현. All rights reserved.
//

import UIKit

class PseudoHeaderTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var statusButton: UIButton!
    
    func setExpanded() {
        statusButton.setImage(#imageLiteral(resourceName: "icArrow1UpMain32"), for: .normal)
    }
    
    func setCollapsed() {
        statusButton.setImage(#imageLiteral(resourceName: "icArrow1DownDark32"), for: .normal)
    }

}
