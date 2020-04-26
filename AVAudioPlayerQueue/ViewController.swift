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

class ViewController: UIViewController {
    @IBOutlet
    var audioCategoryButton: UIButton!

    private var audioCategorySheet: UIAlertController!
    private var audioSE1AudioSet: AudioSet!
    private var audioSE2AudioSet: AudioSet!
    private var queueSE1AudioSet: AudioSet!
    private var queueSE2AudioSet: AudioSet!

    override func viewDidLoad() {
        super.viewDidLoad()

        audioCategoryButton.setTitle(AudioCategory.soloAmbient.rawValue, for: .normal)
        audioCategorySheet = UIAlertController(title: "AudioCategory", message: nil, preferredStyle: .actionSheet)

        AudioCategory.allCases.makeIterator().map { entry in
            UIAlertAction(title: entry.rawValue, style: .default) { _ in
                do {
                    try AVAudioSession.sharedInstance().setCategory(entry.getCategory(), mode: .default, options: [])
                    self.audioCategoryButton.setTitle(entry.rawValue, for: .normal)
                } catch let err {
                    log.warning("failed to set audio category: \(err)")
                }
            }
        }.forEach { data in
            audioCategorySheet.addAction(data)
        }

        audioCategorySheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        do {
            let se1List = (1...10).map { data in
                ("sounds/se1-\(data)", "mp3")
            }
            audioSE1AudioSet = try AVAudioPlayerAudioSet.create(assets: se1List)
            queueSE1AudioSet = try AVQueuePlayerAudioSet.create(assets: se1List)

            let se2List = (1...10).map { data in
                ("sounds/se2-\(data)", "mp3")
            }
            audioSE2AudioSet = try AVAudioPlayerAudioSet.create(assets: se2List)
            queueSE2AudioSet = try AVQueuePlayerAudioSet.create(assets: se2List)
        } catch let err {
            fatalError("failed to load assets: \(err)")
        }
    }

    @IBAction
    private func onAudioCategoryClicked() {
        log.debug("onAudioCategoryClicked")

        present(audioCategorySheet, animated: true)
    }

    @IBAction
    private func onAudioSE1Clicked() {
        log.debug("onAudioSE1Clicked")

        audioSE1AudioSet.stop()
        audioSE1AudioSet.play()
    }

    @IBAction
    private func onAudioSE2Clicked() {
        log.debug("onAudioSE2Clicked")

        audioSE2AudioSet.stop()
        audioSE2AudioSet.play()
    }

    @IBAction
    private func onQueueSE1Clicked() {
        log.debug("onQueueSE1Clicked")

        queueSE1AudioSet.stop()
        queueSE1AudioSet.play()
    }

    @IBAction
    private func onQueueSE2Clicked() {
        log.debug("onQueueSE2Clicked")

        queueSE2AudioSet.stop()
        queueSE2AudioSet.play()
    }
}

private enum AudioCategory: String, CaseIterable {
    case ambient = "ambient"
    case soloAmbient = "soloAmbient"
    case playback = "playback"
    case record = "record"
    case playAndRecord = "playAndRecord"
    case multiRoute = "multiRoute"

    func getCategory() -> AVAudioSession.Category {
        switch self {
        case .ambient:
            return AVAudioSession.Category.ambient
        case .soloAmbient:
            return AVAudioSession.Category.soloAmbient
        case .playback:
            return AVAudioSession.Category.playback
        case .record:
            return AVAudioSession.Category.record
        case .playAndRecord:
            return AVAudioSession.Category.playAndRecord
        case .multiRoute:
            return AVAudioSession.Category.multiRoute
        }
    }
}
