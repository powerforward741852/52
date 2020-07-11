//
//  QRSoundviewCell.swift
//  52WorkHelper
//
//  Created by 秦榕 on 2019/5/10.
//  Copyright © 2019 chenqihang. All rights reserved.
//

import UIKit

class QRSoundviewCell: UITableViewCell {

//    override func awakeFromNib() {
//        super.awakeFromNib()
//
//    }
//
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//    }
//
//    var timeCount : UILabel!
//    var playImg : UIImageView!
//
//    lazy var soundView : QRSoundView = {
//
//        let soundView = Bundle.main.loadNibNamed("QRSoundView", owner: nil, options: nil)?.last as! QRSoundView
//        soundView.frame =  CGRect(x: nameLab.left, y: nameLab.bottom+5, width: 130, height: 35)
//        soundView.isHidden = true
//        soundView.clickClosure = {[unowned self] play in
//            if play{
//                self.playSound()
//            }else{
//                self.stopPlaySound()
//            }
//        }
//        return soundView
//    }()
//
//
//    //开始播放
//    func playSound(){
//        if soundModel!.soundFilePath.hasPrefix("http"){
//            let dic = ["urlPath": soundModel!.soundFilePath]
//            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "soundAnimationST"), object: self, userInfo: dic)
//            QRMusicPlay.shared.playMusic(URL: URL(string: soundModel!.soundFilePath)!)
//            self.soundView.playImg.startAnimating()
//            self.soundView.isPlay = true
//            QRMusicPlay.shared.player?.onStateChange = {[unowned self] status in
//                if status == FSAudioStreamState.fsAudioStreamPlaying{
//                    self.soundView.playImg.startAnimating()
//                    self.soundView.isPlay = true
//                }else if status == FSAudioStreamState.fsAudioStreamPlaybackCompleted{
//                    self.soundView.playImg.stopAnimating()
//                    self.soundView.isPlay = false
//                }else if status == FSAudioStreamState.fsAudioStreamFailed{
//                    self.soundView.playImg.stopAnimating()
//                    self.soundView.isPlay = false
//                }else if status == FSAudioStreamState.fsAudioStreamStopped{
//                    self.soundView.playImg.stopAnimating()
//                    self.soundView.isPlay = false
//                }
//            }
//        }else{
//            let dic = ["urlPath": soundModel!.soundFilePath]
//            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "soundAnimationST"), object: self, userInfo: dic)
//
//            LGAudioPlayer.share()?.playAudio(withURLString: soundModel!.soundFilePath, at: 0)
//            LGAudioPlayer.share()?.delegate = self
//
//            self.soundView.playImg.startAnimating()
//            self.soundView.isPlay = true
//
//        }
//
//        // self.player?.play(from:URL(string: "http://www.ytmp3.cn/down/60910.mp3")!)
//    }
//    //停止播放
//    func stopPlaySound()  {
//        if soundModel!.soundFilePath.hasPrefix("http"){
//            // self.player?.stop()
//            QRMusicPlay.shared.stopMusic()
//        }else{
//            LGAudioPlayer.share()?.stop()
//        }
//    }
//
//
//
//
//    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        setUp()
//    }
//
//
//
//    override func layoutIfNeeded() {
//        super.layoutIfNeeded()
//    }
//    deinit {
//        NotificationCenter.default.removeObserver(self)
//    }
//
//    @objc func updateAnimation(){
//        self.soundView.playImg.stopAnimating()
//    }
//
//
//
//    func setUp()  {
//
//    }
//
//
//    //返回button所在的UITableViewCell
//    func superUITableViewCell(of: UIButton) -> UITableViewCell? {
//        for view in sequence(first: of.superview, next: { $0?.superview }) {
//            if let cell = view as? UITableViewCell {
//                return cell
//            }
//        }
//        return nil
//    }
//
//    //返回button所在的UITableView
//    func superUITableView(of: UIButton) -> UITableView? {
//        for view in sequence(first: of.superview, next: { $0?.superview }) {
//            if let table = view as? UITableView {
//                return table
//            }
//        }
//        return nil
//    }
//
//
//    var soundModel: QRSoundModel? {
//        didSet {
//            if String(soundModel!.second ) == "0" || String(soundModel!.second ) == ""{
//                self.soundView.timeCount.text = "1s''"
//                self.soundView.playUrl = soundModel!.soundFilePath
//            }else{
//                self.soundView.timeCount.text = String(soundModel!.second) + "s''"
//                self.soundView.playUrl = soundModel!.soundFilePath
//            }
//
//        }
//    }
//
//}
//
//extension QRSoundviewCell : LGAudioPlayerDelegate{
//    func audioPlayerStateDidChanged(_ audioPlayerState: LGAudioPlayerState, for index: UInt) {
//        if audioPlayerState == .normal{
//            self.soundView.playImg.stopAnimating()
//        }else if audioPlayerState == .cancel{
//            self.soundView.playImg.stopAnimating()
//        }else if audioPlayerState == .playing{
//
//        }
//    }
//
//
}
