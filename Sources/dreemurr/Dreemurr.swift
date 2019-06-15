//
// Dreemurr.swift
// Project Dreemurr
//
// Created by Project Alice on 6/15/19.
// (C) 2019 Project Alice. All rights reserved.
//

import Foundation
import Sword

/**
    Class for connecting to Discord and watching for key events.
 */
public class Dreemurr {
    
    // MARK: Properties
    
    private var determination: Determination
    private var soul: Sword
    
    // MARK: Methods
    
    /**
        Convert a string into a parseable command.
     
        This should apply to the basic Dreemurr commands available and may need an additional lexer from another source if extended.
        - parameter command: The command to parse from
     */
    public func toDreemurrCommand(command: String) throws -> DreemurrCommands {
        switch command {
        case "!ping":
            return .ping
        case "!introduce":
            return .introduce
        default:
            throw DreemurrError.invalidCommand
        }
    }
    
    /**
        Run a command when receiving new messages in chat.
        - parameter doThis: The function to run, typically a lexer/parser command sequence.
     */
    public func onWatchMessages(doThis: @escaping ((Any) -> ())) {
        soul.on(.messageCreate, do: doThis)
    }
    
    /**
        Connect to the Discord service and start listening.
     */
    public func connect() {
        soul.connect()
    }
    
    /**
        Creates and embed of the bot's information.
        - returns: An `Embed` containing the bot's information
     */
    public func introduceSelf() -> Embed {
        var selfIntroduction = Embed()
        selfIntroduction.title = "About \(determination.name) (A Project Dreemurr-based bot)"
        selfIntroduction.description = """
        Dreemurr Version: v1.0.0
        
        (C) 2019 Project Alice. All rights reserved.
        """
        return selfIntroduction
    }
    
    /**
        Creates an embed containing the help information.
        - parameter description: (Optional) The help information to display
        - returns: An `Embed` containing the help information
     */
    public func showHelp(description: String?) -> Embed {
        var help = Embed()
        help.title = "Help"
        help.description = description != nil ? description: """
        !ping - Pings the bot
        !introduce - Provides information about this screen.
        !help - Shows this screen.
        """
        return help
    }
    
    // MARK: Constructor
    
    /**
        Constructs the `Dreemurr` class.
        - parameter determinedFrom: The configuration to build from.
     */
    init(determinedFrom: Determination) {
        determination = determinedFrom
        soul = Sword(token: determination.token)
    }
}

// MARK: Command Tokens

public enum DreemurrCommands {
    case ping
    case introduce
    case help
}

// MARK: Class Errors

public enum DreemurrError: Error {
    /**
        Used when the configuration is incomplete (eg. missing a token, name, game, etc.)
     */
    case partialOrIncompleteSoul
    
    /**
        Used when given a command that the lexer cannot understand (results from `toDreemurrCommand`)
     */
    case invalidCommand
}
