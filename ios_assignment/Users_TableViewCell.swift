//
//  Users_TableViewCell.swift
//  ios_assignment
//
//  Created by Sai Naveen Katla on 16/02/21.
//

import UIKit

protocol UsersTableViewCellDelegate {
    func didTapButton(at docId: String)
}

class Users_TableViewCell: UITableViewCell {

    @IBOutlet weak var profile_imag: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var details: UILabel!
    
    var docId: String = ""
    
    @IBOutlet weak var delete_button: UIButton!
    
    var delegate: UsersTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        profile_imag.layer.cornerRadius = profile_imag.frame.height/2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func deleteTapped() {
        delegate?.didTapButton(at: docId)
    }
    
}
