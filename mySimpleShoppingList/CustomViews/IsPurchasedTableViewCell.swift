//
//  IsPurchasedTableViewCell.swift
//  mySimpleShoppingList
//
//  Created by Uzo on 1/17/20.
//  Copyright © 2020 Uzo. All rights reserved.
//

import UIKit

protocol PurchasedButtonCellDelegate: class {
    func cellButtonTapped(_ sender: IsPurchasedTableViewCell)
}

class IsPurchasedTableViewCell: UITableViewCell {
    
    var delegate: PurchasedButtonCellDelegate?
    
    //MARK:- Outlets
    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var isPurchasedButton: UIButton!
    
    //MARK:- Actions
    @IBAction func isPurchasedButtonIsTapped(_ sender: UIButton) {
        delegate?.cellButtonTapped(self)
    }
    
    func updateIsPurchasedButtonImage(_ isPurchased: Bool) {
        let imageName = isPurchased ? "complete" : "incomplete"
        isPurchasedButton.setImage(UIImage(named: imageName), for:  .normal)
    }
    
    func updateCell(WithItem item: Item?) {
        guard let existingItem = item else { return }
        itemNameLabel.text = existingItem.name
        updateIsPurchasedButtonImage(existingItem.isPurchased)
    }
}
