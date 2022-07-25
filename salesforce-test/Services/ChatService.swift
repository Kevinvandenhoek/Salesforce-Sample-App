//
//  ChatService.swift
//  salesforce-test
//
//  Created by Kevin van den Hoek on 20/07/2022.
//

import Foundation
import SMIClientCore
import SMIClientUI

final class ChatService: NSObject {
    
    private var coreClient: CoreClient?
    private var conversation: Conversation?
    
    // 8E4E1B97-525E-47B1-B202-C731BADB758F
    @UserDefault(key: "conversationId", defaultValue: UUID())
    var conversationId: UUID
    
    // MARK: Internal methods
    func makeViewController() async throws -> UIViewController {
        let coreClient = getCoreClient()
        coreClient.stop()
        let client = coreClient.conversationClient(with: conversationId)
        conversation = Conversation(client: client, profile: "someProfile")
        coreClient.start()
        let remoteConfiguration = try await coreClient.retrieveRemoteConfiguration()
        remoteConfiguration.preChatConfiguration?.forEach { preChatConfiguration in
            preChatConfiguration.preChatFields.forEach { field in
                self.updateField(field)
            }
            client.submit(preChatFields: preChatConfiguration.preChatFields)
        }
        print("🐛 conversationId: \(conversationId)")
        let configuration = UIConfiguration(
            serviceAPI: URL(string: "https://citizenm--dev2.sandbox.my.salesforce-scrt.com")!,
            organizationId: "00D1w0000000OcU",
            developerName: "LiveAgent_App",
            conversationId: conversationId
        )
        
        // TODO: Fix a better way to await the prechat submit
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        let vc = await InterfaceViewController(configuration)
        return vc
    }
    
    func setPushToken(_ token: String?) {
        CoreFactory.provide(deviceToken: token ?? "unknown")
        getCoreClient(forceRefresh: true)
    }
    
    func logout(completion: ((Bool) -> Void)?) {
        coreClient?.stop()
        conversation = nil
        completion?(true)
    }
}

// MARK: CoreDelegate
extension ChatService: CoreDelegate {
    
    func core(_ core: CoreClient!, didReceive entry: ConversationEntry!) {
        dump("🐛 did receive \(entry.type)")
        if let message = entry.payload as? TextMessage {
            dump("🐛 TextMessage.text \(message.text)")
        }
    }
}

// MARK: Helpers
private extension ChatService {
    
    /// Creates or returns existing CoreClient. Also updates the coreClient property with the newly created client if applicable.
    @discardableResult
    func getCoreClient(forceRefresh: Bool = false) -> CoreClient {
        if let coreClient = coreClient { return coreClient }
        let configuration = Configuration(
            serviceAPI: URL(string: "https://citizenm--dev2.sandbox.my.salesforce-scrt.com")!,
            organizationId: "00D1w0000000OcU",
            developerName: "LiveAgent_App"
        )
        let coreClient = CoreFactory.create(withConfig: configuration)
        coreClient.addDelegate(delegate: self)
        self.coreClient = coreClient
        return coreClient
    }
    
    func updateField(_ field: PreChatField) {
        switch field.name {
        default:
            field.value = "some dynamic value"
        }
    }
    
    struct Conversation {
        let client: ConversationClient
        let profile: String
    }
}

private extension CoreClient {
    
    func retrieveRemoteConfiguration() async throws -> RemoteConfiguration {
        return try await withCheckedThrowingContinuation { continuation in
            retrieveRemoteConfiguration(completion: { configuration, error in
                if let configuration = configuration {
                    continuation.resume(returning: configuration)
                } else {
                    continuation.resume(throwing: error ?? NSError(domain: "app", code: 0))
                }
            })
        }
    }
}
