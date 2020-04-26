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

import UIKit

class ViewController: UIViewController {
    var audioSE1AudioSet: AudioSet!
    var audioSE2AudioSet: AudioSet!
    var queueSE1AudioSet: AudioSet!
    var queueSE2AudioSet: AudioSet!

    override func viewDidLoad() {
        super.viewDidLoad()

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
    func onAudioSE1Clicked() {
        log.debug("onAudioSE1Clicked")

        audioSE1AudioSet.stop()
        audioSE1AudioSet.play()
    }

    @IBAction
    func onAudioSE2Clicked() {
        log.debug("onAudioSE2Clicked")

        audioSE2AudioSet.stop()
        audioSE2AudioSet.play()
    }

    @IBAction
    func onQueueSE1Clicked() {
        log.debug("onQueueSE1Clicked")

        queueSE1AudioSet.stop()
        queueSE1AudioSet.play()
    }

    @IBAction
    func onQueueSE2Clicked() {
        log.debug("onQueueSE2Clicked")

        queueSE2AudioSet.stop()
        queueSE2AudioSet.play()
    }
}
