//
//  File.swift
//  DreemurrCore
//
//  Created by Marquis Kurt on 6/16/19.
//  (C) 2019 Project Alice. All rights reserved.
//

import Foundation

/**
    Struct for getting environment details.
 */
public struct DreemurrEnvironment {
    
    /**
        Get the token from environment variables.
     */
    public static func getDreemurrToken() -> String? {
        return ProcessInfo.processInfo.environment["dreemurr.token"]
    }
    
    /**
        Get the name of the bot from environment variables.
     */
    public static func getDreemurrName() -> String? {
        return ProcessInfo.processInfo.environment["dreemurr.name"]
    }
    
    /**
        Get the name of the current game they are playing from environment variables.
     */
    public static func getDreemurrCurrentGame() -> String? {
        return ProcessInfo.processInfo.environment["dreemurr.currentGame"]
    }
    
    /**
        Create a string containing the JSON format of the environment variables.
        - parameter nameDefaultsTo: The name that should be the fallback if `dreemurr.name` is missing.
        - parameter gameDefaultsTo: The name of the game that should be the fallback if `dreemurr.currentGame` is missing.
     */
    public static func createEnvironmentVariablesAsDecodableJSON(nameDefaultsTo: String, gameDefaultsTo: String) -> String {
        return """
        {
        \"name\": \"\(getDreemurrName() ?? nameDefaultsTo)\",
        \"token\": \"\(getDreemurrToken() ?? "invalidtoken")\",
        \"currentGame\":\"\(getDreemurrCurrentGame() ?? gameDefaultsTo)\"
        }
        """
    }
}
