//
//  ProfileTableViewCell.swift
//  Bosta Profile
//
//  Created by Ma7rous on 08/02/2023.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {
    //MARK: Outlet Connections
    @IBOutlet private weak var albumNameLabel: UILabel!
    
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
    public func configure(album: Album) {
        albumNameLabel.text = "- \(album.title)"
    }
    
}
