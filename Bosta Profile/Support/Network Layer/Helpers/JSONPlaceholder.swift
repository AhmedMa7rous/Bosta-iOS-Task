//
//  JSONPlaceholder.swift
//  Bosta Profile
//
//  Created by Ma7rous on 07/02/2023.
//

import Foundation
import Moya

public enum JSONPlaceholder {
    static var userId = 2
    static var albumId = 2
    
    case users
    case albums
    case photos
}

extension JSONPlaceholder: TargetType {
    public var baseURL: URL {
        return URL(string: "https://jsonplaceholder.typicode.com/")!
    }
    
    public var path: String {
        switch self {
        case .users:
            return "users"
        case .albums:
            return "albums"
        case .photos:
            return "photos"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .users:
            return .get
        case .albums:
            return .get
        case .photos:
            return .get
        }
    }
    
    public var task: Task {
        switch self {
        case .users:
            return .requestPlain
        case .albums:
            return .requestParameters(parameters: ["userId": JSONPlaceholder.userId], encoding: URLEncoding.default)
        case .photos:
            return .requestParameters(parameters: ["albumId": JSONPlaceholder.albumId], encoding: URLEncoding.default)
        }
    }
    
    public var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }
    
    public var validationType: ValidationType {
        return .successCodes
    }
}
