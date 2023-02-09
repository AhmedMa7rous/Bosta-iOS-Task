//
//  Imgur.swift
//  Bosta Profile
//
//  Created by Ma7rous on 08/02/2023.
//

import Foundation
import UIKit
import Moya


public enum Imgur {
  static private let clientId = "422a8d6dd29008b"

  case upload(UIImage)
}

extension Imgur: TargetType {
  public var baseURL: URL {
    return URL(string: "https://api.imgur.com/3")!
  }

  public var path: String {
    switch self {
    case .upload: return "/image"
    }
  }

  public var method: Moya.Method {
    switch self {
    case .upload: return .post
    }
  }

  public var sampleData: Data {
    return Data()
  }

  public var task: Task {
    switch self {
    case .upload(let image):
        let imgData = image.jpegData(compressionQuality: 1.0)!
        return .uploadMultipart([MultipartFormData(provider: .data(imgData),
                                                 name: "image",
                                                 fileName: "card.jpg",
                                                 mimeType: "image/jpg")])
    }
  }

  public var headers: [String: String]? {
    return [
      "Authorization": "Client-ID \(Imgur.clientId)",
      "Content-Type": "application/json"
    ]
  }

  public var validationType: ValidationType {
    return .successCodes
  }
}
