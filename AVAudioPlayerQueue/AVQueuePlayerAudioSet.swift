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

class AVQueuePlayerAudioSet: AudioSet {
    private let bundlePaths: [String]

    private var player: AVQueuePlayer?

    /// Create an instance
    ///
    /// - Parameter assets: a list of the pair of the asset name and file type hint
    /// - Returns: an instance
    /// - Throws: throws error if failed to load assets
    class func create(assets: [(String, String)]) throws -> AVQueuePlayerAudioSet {
        let paths: [String] = try assets.map { data in
            let (name, hint) = data

            guard let ret = Bundle.main.path(forResource: name, ofType: hint) else {
                throw AudioSetError.assetNotFound("\((name, hint))")
            }

            return ret
        }

        return AVQueuePlayerAudioSet(bundlePaths: paths)
    }

    private init(bundlePaths: [String]) {
        self.bundlePaths = bundlePaths
    }

    func play() {
        if player != nil {
            return
        }

        log.debug("play")

        let playerItems = bundlePaths.map { entry in
            AVPlayerItem(
                asset: AVURLAsset(url: NSURL.fileURL(withPath: entry)), automaticallyLoadedAssetKeys: ["playable"])
        }

        guard let lastPlayerItem = playerItems.last else {
            return
        }

        NotificationCenter.default.addObserver(
            self, selector: #selector(AVQueuePlayerAudioSet.playerDidFinishPlaying),
            name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: lastPlayerItem)

        player = AVQueuePlayer(items: playerItems)
        player?.play()
    }

    func stop() {
        log.debug("stop")

        player?.pause()
        player = nil
    }

    @objc private func playerDidFinishPlaying(note: NSNotification) {
        log.debug("playerDidFinishPlaying")
    }
}