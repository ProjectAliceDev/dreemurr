//
// Main.swift
// Project Dreemurr
//
// Created by Project Alice on 6/15/19.
// (C) 2019 Project Alice. All rights reserved.
//

import Sword

let bot = Sword(token: "NTg5NTc2MzMxNzA0OTI2MjA4.XQVr7Q.K-8iW0luEhpqbnjczF2JFxD1g-M")

bot.editStatus(to: "online", playing: "Portal 2")

bot.on(.messageCreate) { data in
    let msg = data as! Message
    
    if msg.content == "!ping" {
        msg.reply(with: "EXCUSE ME?!")
    }
}

bot.connect()

