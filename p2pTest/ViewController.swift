//
//  ViewController.swift
//  p2pTest
//
//  Created by Heather Kemp on 11/11/17.
//  Copyright © 2017 Heather Kemp. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class ViewController: UIViewController, MCSessionDelegate, MCBrowserViewControllerDelegate {
    
    @IBOutlet weak var text: UILabel!
    
    var peerID: MCPeerID!
    var mcSession: MCSession!
    var mcAdvertiserAssistant: MCAdvertiserAssistant!

    override func viewDidLoad() {
        super.viewDidLoad()
        peerID = MCPeerID(displayName: UIDevice.current.name)
        mcSession = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .optional)
        mcSession.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        
    }
    
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true)
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true)
    }
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
        case MCSessionState.connected:
            print("Connected: \(peerID.displayName)")
            setText("Connected")
            
        case MCSessionState.connecting:
            print("Connecting: \(peerID.displayName)")
            setText("Connecting")
            
        case MCSessionState.notConnected:
            print("Not Connected: \(peerID.displayName)")
            setText("Not Connected")
        }
    }
    
    func setText(_ input : String){
        DispatchQueue.main.async { // Correct
            self.text.text = input
        }
    }
    
    func sendText() {
        print("Sending Data")
        if mcSession.connectedPeers.count > 0 {
            print("Sending Data 2")
            if let data = Data(base64Encoded: "This is some data"){
                do {
                    print("Sending Data 3")
                    try mcSession.send(data, toPeers: mcSession.connectedPeers, with: .reliable)
                    
                } catch let error as NSError {
                    let ac = UIAlertController(title: "Send error", message: error.localizedDescription, preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .default))
                    present(ac, animated: true)
                }
            }
        }
    }

    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        let textData = data.base64EncodedString()
        print("Got Data")
        
        if !textData.isEmpty {
            DispatchQueue.main.async { [unowned self] in
                print(textData)
                
            }
        }
    }
    
    func startHosting(action: UIAlertAction!) {
        self.text.text = "Connecting"
        mcAdvertiserAssistant = MCAdvertiserAssistant(serviceType: "hws-kb", discoveryInfo: nil, session: mcSession)
        mcAdvertiserAssistant.start()
    }
    
    func joinSession(action: UIAlertAction!) {
        let mcBrowser = MCBrowserViewController(serviceType: "hws-kb", session: mcSession)
        mcBrowser.delegate = self
        present(mcBrowser, animated: true)
    }
    
    @IBAction func createRoomClick(_ sender: Any) {
        let joinGameConfirmation = UIAlertAction(title: "Join room #1", style: UIAlertActionStyle.default)

        startHosting(action: joinGameConfirmation)
    }
    
    @IBAction func joinRoomClick(_ sender: Any) {
        let joinGameConfirmation = UIAlertAction(title: "Join room #1", style: UIAlertActionStyle.default)
        joinSession(action: joinGameConfirmation)
    }
    
    @IBAction func sendText(_ sender: Any) {
        sendText()
    }
}

