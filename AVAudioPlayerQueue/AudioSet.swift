// Copyright 2020 sukawasatoru
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import AVFoundation
import UIKit

class AudioSet: NSObject, AVAudioPlayerDelegate {
    private var players: [AVAudioPlayer]
    private var currentPlayer: AVAudioPlayer?
    private var playerIterator: IndexingIterator<Array<AVAudioPlayer>>?

    var delegate: AudioSetDelegate?

    /// Create an instance
    ///
    /// - Parameter voiceList: a list of the pair of the asset name and file type hint
    /// - Returns: an instance
    /// - Throws: throws error if failed to load assets
    static func create(assets: [(String, String)]) throws -> AudioSet {
        let assets: [(NSDataAsset, String)] = try assets.map { (name, hint) in
            guard let asset = NSDataAsset(name: name) else {
                throw AudioSetError.AssetNotFound("\((name, hint))")
            }
            return (asset, hint)
        }

        let audioSet = AudioSet()
        do {
            let list: [AVAudioPlayer] = try assets.map { data in
                let (asset, hint) = data
                let player = try AVAudioPlayer(data: asset.data, fileTypeHint: hint)
                player.delegate = audioSet
                return player
            }

            audioSet.setPlayers(list: list)
            return audioSet
        } catch let err {
            throw AudioSetError.Player(err)
        }
    }

    override private init() {
        self.players = []
    }

    /// Start playback
    func play() {
        if playerIterator != nil || players.isEmpty {
            return
        }

        log.debug("play")

        playerIterator = players.makeIterator()
        currentPlayer = playerIterator?.next()
        currentPlayer?.play()
    }

    /// Stop playback
    func stop() {
        log.debug("stop")

        stopImpl()
    }

    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        log.debug("audioPlayerDidFinishPlaying")

        currentPlayer = playerIterator?.next()
        guard let player = currentPlayer else {
            stopImpl()
            delegate?.onComplete()
            return
        }
        player.play()
    }

    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        log.debug("audioPlayerDecodeErrorDidOccur error: \(error)")
    }

    func audioPlayerBeginInterruption(_ player: AVAudioPlayer) {
        log.debug("audioPlayerBeginInterruption")
    }

    func audioPlayerEndInterruption(_ player: AVAudioPlayer, withOptions flags: Int) {
        log.debug("audioPlayerEndInterruption")
    }

    private func setPlayers(list: [AVAudioPlayer]) {
        players = list
    }

    private func stopImpl() {
        currentPlayer?.stop()
        currentPlayer = nil
        playerIterator = nil
    }
}
