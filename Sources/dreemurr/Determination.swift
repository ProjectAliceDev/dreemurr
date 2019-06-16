//
//  Determination.swift
//  Project Dreemurr
//
//  Created by Marquis Kurt on 6/15/19.
//  (C) 2019 Project Alice. All rights reserved.
//

import Foundation

/**
    Struct containing configuration information such as the access token, name, etc.
 */
public struct Determination: DeterminationProtocol {
    var token: String
    var currentGame: String
    var name: String
}

protocol DeterminationProtocol : Codable {
    init?(fromJson: String)
}

extension DeterminationProtocol {
    init?(fromJson: String) {
        guard let data = fromJson.data(using: .utf8) else {
            return nil
        }
        
        self = try! JSONDecoder().decode(Self.self, from: data)
    }
}
