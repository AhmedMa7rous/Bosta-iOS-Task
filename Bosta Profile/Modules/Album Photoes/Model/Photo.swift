//
//  Photo.swift
//  Bosta Profile
//
//  Created by Ma7rous on 08/02/2023.
//

import Foundation

// MARK: - Photo
struct Photo: Codable {
    let albumID, id: Int
    let title: String
    let url, thumbnailURL: String

    enum CodingKeys: String, CodingKey {
        case albumID = "albumId"
        case id, title, url
        case thumbnailURL = "thumbnailUrl"
    }
}
