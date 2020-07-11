//
//  QRMusicPlay.swift
//  52WorkHelper
//
//  Created by 秦榕 on 2019/5/6.
//  Copyright © 2019 chenqihang. All rights reserved.
//

import UIKit
public enum QRAudioPlayerState: NSInteger {
    case QRAudioPlayerStateNormal/** 未播放状态 */
    case QRAudioPlayerStatePlaying/** 正在播放 */
    case QRAudioPlayerStateCancel/** 播放被取消 */
}
class QRMusicPlay: NSObject {
     var audioPlayerState = QRAudioPlayerState.QRAudioPlayerStateNormal
     static let shared = QRMusicPlay()
     public var URLString: NSString = ""
     var playUrl = ""
    
    
    lazy var player : FSAudioStream? = {
        let config = FSStreamConfiguration()
        config.enableTimeAndPitchConversion = true
        let player = FSAudioStream(configuration: config)
        player!.strictContentTypeChecking = false
        player!.defaultContentType = "audio/mpeg"
//        player!.onCompletion = { [unowned self] in
//            self.soundView.playImg.stopAnimating()
//        }
//        player?.onStateChange = {[unowned self] status in
//            if status == FSAudioStreamState.fsAudioStreamPlaying{
//                self.soundView.playImg.startAnimating()
//            }
//        }
        player!.volume = 0.5
        return player
    }()
    func playMusic(URL:URL)  {
        if (self.player?.isPlaying())!{
            self.player?.stop()
        }
        self.playUrl = URL.absoluteString
      //   LGAudioPlayer.share()?.stop()
        
     //   NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "stopVoiveAnimation")))
        
        self.player?.play(from: URL)
    }
    func stopMusic()  {
        self.player?.stop()
    }
    func pauseMusic()  {
        
    }
    
}
