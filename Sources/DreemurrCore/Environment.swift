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
    public static func getDreemurrToken() -> String {
        return ProcessInfo.processInfo.environment["dreemurr.token"]
    }
    
    /**
        Get the name of the bot from environment variables.
     */
    public static func getDreemurrName() -> String {
        return ProcessInfo.processInfo.environment["dreemurr.name"]
    }
    
    /**
        Get the name of the current game they are playing from environment variables.
     */
    public static func getDreemurrCurrentGame() -> String {
        return ProcessInfo.processInfo.environment["dreemurr.currentGame"]
    }
    
    public static func createEnvironmentVariablesAsDecodableJSON() -> String {
        return """
        {
        \"name\": \"\(getDreemurrName())\",
        \"token\": \"\(getDreemurrToken())\",
        \"currentGame\":\"\(getDreemurrCurrentGame())\"
        }
        """
    }
}
