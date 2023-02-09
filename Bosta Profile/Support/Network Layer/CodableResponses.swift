//
//  CodableResponses.swift
//  Bosta Profile
//
//  Created by Ma7rous on 07/02/2023.
//

import Foundation



struct ImgurResponse<T: Codable>: Codable {
  let data: T
}
