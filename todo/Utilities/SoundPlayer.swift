//
//  SoundPlayer.swift
//  todo
//
//  Created by Feng Yuan Yap on 2022/07/16.
//

import Foundation
import AVFoundation

var audioPlayer: AVAudioPlayer?

func playSound(fileName: String, type: String) {
  if let path = Bundle.main.path(forResource: fileName, ofType: type) {
    do {
      audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
      audioPlayer?.play()
    } catch {
      print("Error while playing sound: \(fileName).\(type)")
    }
  }
}
