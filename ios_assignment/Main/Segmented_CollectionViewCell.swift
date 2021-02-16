//
//  Segmented_CollectionViewCell.swift
//  ios_assignment
//
//  Created by Sai Naveen Katla on 16/02/21.
//

import UIKit

class Segmented_CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var bottomBar: UIView!
    
    override var isHighlighted: Bool {
        didSet {
            name.textColor = isHighlighted ? #colorLiteral(red: 0.09928951412, green: 0.6090357304, blue: 0.8274083138, alpha: 1) : #colorLiteral(red: 0.4980838895, green: 0.4951269031, blue: 0.5003594756, alpha: 1)
            bottomBar.backgroundColor = isHighlighted ? #colorLiteral(red: 0.09928951412, green: 0.6090357304, blue: 0.8274083138, alpha: 1) : .clear
        }
    }
    
    override var isSelected: Bool {
        didSet {
            name.textColor = isSelected ? #colorLiteral(red: 0.09928951412, green: 0.6090357304, blue: 0.8274083138, alpha: 1) : #colorLiteral(red: 0.4980838895, green: 0.4951269031, blue: 0.5003594756, alpha: 1)
            bottomBar.backgroundColor = isSelected ? #colorLiteral(red: 0.09928951412, green: 0.6090357304, blue: 0.8274083138, alpha: 1) : .clear
        }
    }
}
