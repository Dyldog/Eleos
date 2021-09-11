//
//  Elios.swift
//  Eleos
//
//  Created by Dylan Elliott on 11/9/21.
//

import Foundation
import SlackKit

class EleosBot {
    let slack: SlackBot
    
    init() {
        slack = SlackBot()
        slack.start(
            onAuth: { _ in },
            onMessage: { event in self.handleMessage(event: event) }
        )
    }
    
    func handleMessage(event: Event) {
        guard let text = event.message?.text else { return }
        
        if let naughtyWord = MessageChecker.checkMessage(text) {
            sendNaughtyWordNotification(event: event, naughty: naughtyWord)
        }
    }

    func sendNaughtyWordNotification(event: Event, naughty: NaughtyWord) {
        guard let channel = event.channel, let user = event.user else { return }
        
        let message = """
        Hey, you've used a naughty word -- '\(naughty.word.capitalized)'. This word is less inclusive because \(naughty.reasoning). As an alternative, you can use '\(naughty.alternative).'
        """
        
        let ignoreAction = Action(name: "ignore_update", text: "Ignore", confirm: .init(text: "Are you sure? Using more inclusive language benefits everyone, including you!", title: "Ignore reccommendation?", okText: "Ignore") )
        let updateAction = Action(name: "update", text: "Update Message", style: .primary)
        
        slack.sendEphemeralMessage(
            message,
            channel: channel,
            user: user,
            attachment: Attachment(
                fallback: "Update message to be more inclusive",
                title: nil,
                text: "If you want, I can update your message to replace your words with more inclusive alternatives",
                actions: [
                    ignoreAction, updateAction
                ]
            )
        ) { result in
            //
        }
    }
}
