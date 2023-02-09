//
//  UsersTableViewCell.swift
//  Bosta Profile
//
//  Created by Ma7rous on 07/02/2023.
//

import UIKit

class UsersTableViewCell: UITableViewCell {
    
    //MARK: Outlet Connections
    @IBOutlet private weak var userNameLabel: UILabel!
    
/*=========================================================*/
    //MARK: LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
/*=========================================================*/
    //MARK: Support Functions
    public func configure(user: User) {
        userNameLabel.text = "\(user.id) - \(user.name)"
    }
    
}
