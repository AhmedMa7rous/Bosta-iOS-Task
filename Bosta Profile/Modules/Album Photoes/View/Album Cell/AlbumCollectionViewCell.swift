//
//  AlbumCollectionViewCell.swift
//  Bosta Profile
//
//  Created by Ma7rous on 08/02/2023.
//

import UIKit
import SDWebImage

class AlbumCollectionViewCell: UICollectionViewCell {

    //MARK: - Outlet Connections
    @IBOutlet weak var photoImageView: UIImageView!
    
    
    //MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
/*=========================================================*/
    //MARK: Support Functions
    public func configure(photo: Photo) {
        let imageUrl = URL(string: photo.url)
        photoImageView.sd_setImage(with: imageUrl, completed: nil)
    }

}
