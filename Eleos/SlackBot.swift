//
//  EliosSlackBot.swift
//  Eleos
//
//  Created by Dylan Elliott on 11/9/21.
//

import Foundation
import SlackKit

class SlackBot {
    private let client: SlackKit
    
    init() {
        client = SlackKit()
        client.addWebAPIAccessWithToken(Secrets.botToken)
        client.addRTMBotWithAPIToken(Secrets.botToken)
    }
    
    func start(onAuth: @escaping (Result<Void, Error>) -> Void, onMessage: @escaping (Event) -> Void) {
        client.notificationForEvent(.message) { (event, _) in
            guard event.subtype != "bot_message" else { return }
            onMessage(event)
        }
        
        client.webAPI?.authenticationTest(success: { _, _ in
            onAuth(.success(()))
        }, failure: { error in
            onAuth(.failure(error))
        })
    }
    
    func sendMessage(_ text: String, channel: Channel, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let channelID = channel.id else { return }
        client.webAPI!.sendMessage(channel: channelID, text: text, success: { (ts, channel) in
            completion(.success(()))
        }, failure: { error in
            completion(.failure(error))
        })
    }
    
    func sendEphemeralMessage(_ text: String, channel: Channel, user: User, attachment: Attachment, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let channelID = channel.id, let userID = user.id else { return }
        client.webAPI?.sendEphemeral(
            channel: channelID,
            text: text,
            user: userID,
            attachments: [ attachment ],
            success: { _ in
                completion(.success(()))
            },
            failure: { error in
                completion(.failure(error))
            }
        )
    }
}
