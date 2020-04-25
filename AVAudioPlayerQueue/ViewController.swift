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
    var se1AudioSet: AudioSet!
    var se2AudiSet: AudioSet!

    override func viewDidLoad() {
        super.viewDidLoad()

        do {
            let se1List = (1...10).map { data in
                ("se1-\(data)", "mp3")
            }
            se1AudioSet = try AudioSet.create(assets: se1List)

            let se2List = (1...10).map { data in
                ("se2-\(data)", "mp3")
            }
            se2AudiSet = try AudioSet.create(assets: se2List)
        } catch let err {
            fatalError("failed to load assets: \(err)")
        }
    }

    @IBAction
    func onSE1Clicked() {
        log.debug("onSE1Clicked")

        se1AudioSet.stop()
        se1AudioSet.play()
    }

    @IBAction
    func onSE2Clicked() {
        log.debug("onSE2Clicked")

        se2AudiSet.stop()
        se2AudiSet.play()
    }
}
