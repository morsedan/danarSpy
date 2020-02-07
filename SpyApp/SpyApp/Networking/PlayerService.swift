//
//  PlayerService.swift
//  SpyApp
//
//  Created by morse on 2/4/20.
//  Copyright © 2020 morse. All rights reserved.
//

import UIKit
import MultipeerConnectivity

//enum MessageType: Int, Codable {
//    case assignRoles // dict "name": "role" from GM
//    
//    case guessSpy // "name" if GM, tally votes-when match activePlayers.count send verdict
//    case eliminatedPlayer // "name" or playerID or player if self name matches, display eliminated UI, everyone else eliminates it from activePlayers array
//    case gameOver // announce winner .spy/.defender (RoleType)
//    
//}

protocol PlayerServiceDelegate {
    // TODO get rid of the unused methods here
    func connectedDevicesChanged(manager : PlayerService, connectedDevices: [String])
    func playersChanged(manager : PlayerService, players: [Player])
    func newPlayerJoined(playerName: MCPeerID)
    func parseData(_ data: Data)
}


class PlayerService : NSObject {
    
    // Service type must be a unique string, at most 15 characters long
    // and can contain only ASCII lowercase letters, numbers and hyphens.
    private let PlayerServiceType = "spy-game"
    
    
    
    private let myPeerId = MCPeerID(displayName: UserDefaults.standard.string(forKey: PropertyKeys.displayNameKey) ?? "No Name")
    private let serviceAdvertiser : MCNearbyServiceAdvertiser
    private let serviceBrowser : MCNearbyServiceBrowser
    
    var delegate : PlayerServiceDelegate?
    
    lazy var session : MCSession = {
        let session = MCSession(peer: self.myPeerId, securityIdentity: nil, encryptionPreference: .required)
        session.delegate = self
        return session
    }()
    
    
    
    override init() {
        
        self.serviceAdvertiser = MCNearbyServiceAdvertiser(peer: myPeerId, discoveryInfo: nil, serviceType: PlayerServiceType)
        self.serviceBrowser = MCNearbyServiceBrowser(peer: myPeerId, serviceType: PlayerServiceType)
        
        super.init()
        
        self.serviceAdvertiser.delegate = self
        self.serviceAdvertiser.startAdvertisingPeer()
        
        self.serviceBrowser.delegate = self
        self.serviceBrowser.startBrowsingForPeers()
    }
    
    deinit {
        self.serviceAdvertiser.stopAdvertisingPeer()
        self.serviceBrowser.stopBrowsingForPeers()
        session.disconnect()
    }
    
    // MARK: - Send
    
    func send(message: Data) {
        
        
        if session.connectedPeers.count > 0 {
            do {
                try session.send(message, toPeers: session.connectedPeers, with: .reliable)
            }
            catch let error {
                print("Error sending message (\(message)): \(error)")
            }
        }
    }
}

extension PlayerService : MCNearbyServiceAdvertiserDelegate {
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
        //print("didNotStartAdvertisingPeer: \(error)")
    }
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        //print("didReceiveInvitationFromPeer \(peerID)")
        invitationHandler(true, self.session)
    }
    
}

extension PlayerService : MCNearbyServiceBrowserDelegate {
    
    func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
        //print("didNotStartBrowsingForPeers: \(error)")////print("didNotStartBrowsingForPeers: \(error)")
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        //print("foundPeer: \(peerID)") ////print("foundPeer: \(peerID)")
        //print("invitePeer: \(peerID)")////print("invitePeer: \(peerID)")
        browser.invitePeer(peerID, to: self.session, withContext: nil, timeout: 10)
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        print("lostPeer: \(peerID)")////print("lostPeer: \(peerID)")
//        session.cancelConnectPeer(<#T##peerID: MCPeerID##MCPeerID#>)
    }
    
}



extension PlayerService : MCSessionDelegate {
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        
        // TODO only do somethign if they connect
        
        switch state {
        case .connected:
            self.delegate?.newPlayerJoined(playerName: peerID)
            
//            self.delegate?.connectedDevicesChanged(manager: self, connectedDevices:
//                session.connectedPeers.map{$0.displayName})
                //print("peer \(peerID) didChangeState: connected")
        case .connecting:
            //print("Connecting")
            break
        case .notConnected:
            //print("not connected")
            break
        @unknown default:
            fatalError("Invalid state")
        }
        
    }
    
    // MARK: - Recieve
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        //print("didReceiveData: \(data)")
        
        delegate?.parseData(data)
        
//        let jsonDecoder = JSONDecoder()
//        do {
//            let players = try jsonDecoder.decode([Player].self, from: data)
//            self.delegate?.playersChanged(manager: self, players: players)
//            //            for player in players {
//            //                //print("Player name: \(player.name) Votes: \(player.voteCount)")
//            //            }
//        } catch {
//            //print("Error processing data: \(error)")
//        }
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        //print("didReceiveStream")
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        //print("didStartReceivingResourceWithName")
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        //print("didFinishReceivingResourceWithName")
    }
    
}
