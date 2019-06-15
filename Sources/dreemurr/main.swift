//
// Main.swift
// Project Dreemurr
//
// Created by Project Alice on 6/15/19.
// (C) 2019 Project Alice. All rights reserved.
//

import Sword

print("""
Project Dreemurr
v1.0.0
(C) 2019 Project Alice. All rights reserved.
""")

let testString = """
{
\"token\": \"NTg5NTc2MzMxNzA0OTI2MjA4.XQVr7Q.K-8iW0luEhpqbnjczF2JFxD1g-M\",
\"currentGame\": \"Undertale\",
\"name\": \"Asriel\"
}
"""

print("Received JSON input: \(testString)")
print("Attempting to create a new soul from this determination...")

let newSoul = Determination(fromJson: testString)

if newSoul != nil {
    print("Soul creation from determination successful.")
    print("Attempting to create a new Dreemurr class...")
    let asriel = Dreemurr(determinedFrom: newSoul!)
    asriel.onWatchMessages(doThis: {data in
        let message = data as! Message
        
        if message.content.starts(with: "!") {
            do {
                switch try asriel.toDreemurrCommand(command: message.content) {
                case .introduce:
                    message.reply(with: asriel.introduceSelf())
                case .ping:
                    message.reply(with: "Pong.")
                case .help:
                    message.reply(with: asriel.showHelp(description: nil))
                }
            } catch {
                message.reply(with: """
                    **Error:** The command `\(message.content)` is invalid or cannot be parsed.
                    _Is this a bug?_ File an issue: https://github.com/ProjectAliceDev/dreemurr
                    """)
            }
        }
    })
    asriel.connect()
} else {
    print("Error! This determination is broken and cannot be used.\nAborting...")
}
