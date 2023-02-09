//
//  Albums.swift
//  Bosta Profile
//
//  Created by Ma7rous on 08/02/2023.
//

import Foundation


// MARK: - Album
struct Album: Codable {
    let userID, id: Int
    let title: String

    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case id, title
    }
}
