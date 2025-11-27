//
//  PreviewPlayer.swift
//  StoreSearchST
//
//  Created by khamzaev on 27.11.2025.
//

import Foundation
import AVFoundation

protocol PreviewPlayerProtocol {
    var timeControlStatus: AVPlayer.TimeControlStatus { get }
    func play()
    func pause()
}

final class PreviewAudioPlayer: PreviewPlayerProtocol {
    private let player: AVPlayer
    
    init(url: URL) {
        self.player = AVPlayer(url: url)
    }
    
    var timeControlStatus: AVPlayer.TimeControlStatus {
        player.timeControlStatus
    }
    
    func play() {
        player.play()
    }
    
    func pause() {
        player.pause()
    }
    
    var currentItem: AVPlayerItem? {
        player.currentItem
    }
}
