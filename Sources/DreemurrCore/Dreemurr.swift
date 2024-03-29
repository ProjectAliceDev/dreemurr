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
open class Dreemurr {
    
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
    
    /**
        Get the command's arguments, if any, as an array.
     
        - Important: This function splits the string by the _space_ character (`" "`) . If your command requires arguments when processing, keep this in mind.
     
        - parameter command: The command to dissect into its arguments.
        - parameter includeCommand: (Optional) Whether the original command should be included in the array.
        - returns: An array of `Substring` containing all of the arguments
     */
    public func asArguments(command: String, includeCommand: Bool?) -> [Substring] {
        var args = command.split(separator: " ")
        
        if (includeCommand == nil || !includeCommand!) {
            args.removeFirst()

        }
        
        return args
    }
    
    // MARK: Methods - Processing
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
        soul.editStatus(to: "Online", playing: determination.currentGame)
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
    
    // MARK: Methods - Messaging
    
    /**
        Send a message to a user.
        - parameter to: The user object to send to (`Snowflake`)
        - parameter content: The message to send to the user (`[String: Any]`)
     */
    public func sendMessage(to: Snowflake, content: [String: Any]) {
        soul.send(content, to: to)
    }
    
    /**
     Send a message to a user.
     - parameter to: The user object to send to (`Snowflake`)
     - parameter content: The message to send to the user (`Embed`)
     */
    public func sendMessage(to: Snowflake, content: Embed) {
        soul.send(content, to: to)
    }
    
    /**
     Send a message to a user.
     - parameter to: The user object to send to (`Snowflake`)
     - parameter content: The message to send to the user (`String`)
     */
    public func sendMessage(to: Snowflake, content: String) {
        soul.send(content, to: to)
    }
    
    // MARK: Constructor
    
    /**
        Constructs the `Dreemurr` class.
        - parameter determinedFrom: The configuration to build from.
     */
    public init(determinedFrom: Determination) {
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
