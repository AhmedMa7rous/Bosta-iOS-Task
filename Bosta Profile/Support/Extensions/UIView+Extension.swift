//
//  UIView+Extension.swift
//  Bosta Profile
//
//  Created by Ma7rous on 06/02/2023.
//

import Foundation
import UIKit

extension UIView {
    static var identifier: String {
        return String(describing: self)
    }
    
    static var nib : UINib {
        return UINib(nibName : "\(self)",bundle : nil)
    }
}
