//
//  ItemTableViewCell.swift
//  ShoppingList
//
//  Created by tyson ericksen on 11/15/19.
//  Copyright © 2019 tyson ericksen. All rights reserved.
//

import UIKit

protocol itemTableViewCellDelegate: class {
    func isBoughtTapped(_ sender: ItemTableViewCell)
}

class ItemTableViewCell: UITableViewCell {
    
    weak var delegate: itemTableViewCellDelegate?

    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var isBoughtButton: UIButton!
    
    
    @IBAction func isBoughtButtonTapped(_ sender: UIButton) {
        delegate?.isBoughtTapped(self)
    }
}

extension ItemTableViewCell {
    func updateView(item: Item) {
        
        if item.isBought == true {
            isBoughtButton.titleLabel?.text = "Bought"
        } else {
            isBoughtButton.titleLabel?.text = "To Buy"
        }
    }
}
