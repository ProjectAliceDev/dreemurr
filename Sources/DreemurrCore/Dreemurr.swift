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
public struct Dreemurr {
    
    // MARK: Properties
    
    private var determination: Determination
    private var soul: Sword
    
    // MARK: Methods - Tokenizers
    /**
        Converts a given string into a parseable token used for command processing.
     
        This function accepts an additional lexer that can tokenize any new tokens that don't exist in the base `DreemurrCommands` enumeration. When this option is provided, it will run the additional lexer instead of the base lexer, `toDreemurrCommand`.
     
        - Important: The additional lexer should account for any base `DreemurrCommands` enumeration cases: `.ping`, `.introduce`, and `.help`.
     
        - parameter input: The input to tokenize.
        - parameter additionalLexer: (Optional) Any additional lexers to run.
     */
    public func tokenize(_ input: String, additionalLexer: ((String) throws -> (DreemurrCommands))?) throws -> DreemurrCommands {
        if (additionalLexer != nil) {
            do {
                return try additionalLexer!(input)
            } catch {
                throw DreemurrError.invalidCommand
            }
        } else {
            do {
                return try toDreemurrCommand(command: input)
            } catch {
                throw DreemurrError.invalidCommand
            }
            
        }
    }
    
    /**
        Convert a string into a parseable command.
     
        This should apply to the basic Dreemurr commands available.
     
        - Important: If you need to tokenize other commands, use the `tokenize` function instead.
        - parameter command: The command to parse from
     */
    public func toDreemurrCommand(command: String) throws -> DreemurrCommands {
        switch command {
        case "!ping":
            return .ping
        case "!introduce":
            return .introduce
        case "!help":
            return .help
        default:
            throw DreemurrError.invalidCommand
        }
    }
    
    // MARK: Methods - Discord Processing
    /**
        Runs a command when a new member joins the server.
        - parameter doThis: The function to run, typically a command that welcomes the new user.
     */
    public func onNewMemberAdded(doThis: @escaping ((Any) -> ())) {
        soul.on(.guildMemberAdd, do: doThis)
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
    
    // MARK: Methods - Bot Info
    /**
        Creates and embed of the bot's information.
        - returns: An `Embed` containing the bot's information
     */
    public func introduceSelf() -> Embed {
        var selfIntroduction = Embed()
        selfIntroduction.color = 0x5c578e
        selfIntroduction.title = "About Me"
        selfIntroduction.description = """
        **\(self.determination.name)**
        Dreemurr Version: v1.0.0
        
        (C) 2019 Project Alice. All rights reserved.
        GitHub: https://github.com/projectalicedev/dreemurr
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
        help.color = 0x5c578e
        help.title = "Help"
        help.description = description != nil ? description: """
        **Base Commands**
        - !ping - Pings the bot
        - !introduce - Provides information about this screen.
        - !help - Shows this screen.
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
