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

import AudioToolbox

class AudioServicesAudioSet: AudioSet {
    private let soundIDs: [SystemSoundID]

    private var idIterator: IndexingIterator<[SystemSoundID]>?

    /// Create an instance
    ///
    /// - Parameter assets: a list of the pair of the asset name and file type hint
    /// - Returns: an instance
    /// - Throws: throws error if failed to load assets
    class func create(assets: [(String, String)]) throws -> Self {
        let systemSoundIDs: [SystemSoundID] = try assets.map { (name, hint) in
            guard let ret = Bundle.main.path(forResource: name, ofType: hint) else {
                throw AudioSetError.assetNotFound("\((name, hint))")
            }

            var soundID = SystemSoundID(0)
            AudioServicesCreateSystemSoundID(NSURL(fileURLWithPath: ret) as CFURL, &soundID)
            return soundID
        }

        return Self(soundIDs: systemSoundIDs)
    }

    required init(soundIDs: [SystemSoundID]) {
        self.soundIDs = soundIDs
    }

    deinit {
        for soundID in soundIDs {
            AudioServicesDisposeSystemSoundID(soundID)
        }
    }

    func play() {
        if idIterator != nil || soundIDs.isEmpty {
            return
        }

        idIterator = soundIDs.makeIterator()
        playImpl()
    }

    func stop() {
        idIterator = nil
    }

    private func playImpl() {
        guard let soundID = idIterator?.next() else {
            idIterator = nil
            return
        }

        AudioServicesPlaySystemSoundWithCompletion(soundID) {
            self.playImpl()
        }
    }
}
