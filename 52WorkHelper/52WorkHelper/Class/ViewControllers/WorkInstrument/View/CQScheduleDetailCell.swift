//
//  CQScheduleDetailCell.swift
//  52WorkHelper
//
//  Created by chenqihang on 2018/5/10.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

protocol CQScheduleDetailAgreeOrNotDelegate : NSObjectProtocol{
    func agreeClick(index:IndexPath)
    func disAgreeClick(index:IndexPath)
    func deleteClick(index:IndexPath)
}

class CQScheduleDetailCell: UITableViewCell {

    weak var agreeDelegate:CQScheduleDetailAgreeOrNotDelegate?
    
    lazy var iconImg: UIImageView = {
        let iconImg = UIImageView.init(frame: CGRect.init(x: kLeftDis, y: AutoGetHeight(height: 17), width: AutoGetWidth(width: 32), height: AutoGetWidth(width: 32)))
        iconImg.image = UIImage.init(named: "personDefaultIcon")
        iconImg.layer.cornerRadius = AutoGetWidth(width: 16)
        iconImg.clipsToBounds = true
        return iconImg
    }()
    
    lazy var nameLab: UILabel = {
        let nameLab = UILabel.init(frame: CGRect.init(x: self.iconImg.right + kLeftDis, y: AutoGetHeight(height: 10.5), width: kWidth/3, height: AutoGetHeight(height: 15)))
        nameLab.text = "Alans"
        nameLab.textAlignment = .left
        nameLab.textColor = UIColor.black
        nameLab.font = kFontSize15
        return nameLab
    }()
    
    lazy var contentLab: UILabel = {
        let contentLab = UILabel.init(frame: CGRect.init(x: self.iconImg.right + kLeftDis, y:self.nameLab.bottom + AutoGetHeight(height: 6), width: kWidth - AutoGetWidth(width: 77), height: AutoGetHeight(height: 13)))
        contentLab.text = "Alans"
        contentLab.textAlignment = .left
        contentLab.textColor = kLyGrayColor
        contentLab.font = kFontSize13
        contentLab.numberOfLines = 0
        return contentLab
    }()
    
    lazy var timeLab: UILabel = {
        let timeLab = UILabel.init(frame: CGRect.init(x: kWidth - AutoGetWidth(width: 150), y: AutoGetHeight(height: 18), width: AutoGetWidth(width: 135), height: AutoGetHeight(height: 11)))
        timeLab.text = "01-01 08:00"
        timeLab.textAlignment = .right
        timeLab.textColor = kLyGrayColor
        timeLab.font = kFontSize11
        return timeLab
    }()
    
    lazy var agreeBtn: UIButton = {
        let agreeBtn = UIButton.init(type: .custom)
        agreeBtn.frame = CGRect.init(x: kWidth - AutoGetWidth(width: 180), y: AutoGetHeight(height: 18), width: AutoGetWidth(width: 73), height: AutoGetHeight(height: 34))
        agreeBtn.setTitle("同意", for: .normal)
        agreeBtn.setTitleColor(kLightBlueColor, for: .normal)
        agreeBtn.titleLabel?.font = kFontSize14
        agreeBtn.backgroundColor = UIColor.colorWithHexString(hex: "#d7f1fd")
        agreeBtn.addTarget(self, action: #selector(agreeClick(sender:)), for: .touchUpInside)
        return agreeBtn
    }()
    
    lazy var disAgreeBtn: UIButton = {
        let disAgreeBtn = UIButton.init(type: .custom)
        disAgreeBtn.frame = CGRect.init(x: self.agreeBtn.right + AutoGetWidth(width: 19), y: AutoGetHeight(height: 18), width: AutoGetWidth(width: 73), height: AutoGetHeight(height: 34))
        disAgreeBtn.setTitle("不同意", for: .normal)
        disAgreeBtn.setTitleColor(UIColor.black, for: .normal)
        disAgreeBtn.titleLabel?.font = kFontSize14
        disAgreeBtn.backgroundColor = UIColor.colorWithHexString(hex: "#f0f0f0")
        disAgreeBtn.addTarget(self, action: #selector(disAgreeClick(sender:)), for: .touchUpInside)
        return disAgreeBtn
    }()
    
    var timeCount : UILabel!
    var playImg : UIImageView!
    
    lazy var soundView : QRSoundView = {

        let soundView = Bundle.main.loadNibNamed("QRSoundView", owner: nil, options: nil)?.last as! QRSoundView
        soundView.frame =  CGRect(x: nameLab.left, y: nameLab.bottom+5, width: 130, height: 35)
        soundView.isHidden = true
        soundView.clickClosure = {[unowned self] play in
            if play{
                self.playSound()
            }else{
                self.stopPlaySound()
            }
        }
        return soundView
    }()
    
    lazy var deleteBtn: UIButton = {
        let deleteBtn = UIButton.init(type: .custom)
        deleteBtn.frame = CGRect.init(x: self.soundView.right + 10, y: AutoGetHeight(height: 18), width: AutoGetWidth(width: 13), height: AutoGetHeight(height: 13))
       // deleteBtn.backgroundColor = UIColor.colorWithHexString(hex: "#d7f1fd")
        deleteBtn.setBackgroundImage(UIImage(named: "guanbi"), for: UIControlState.normal)
        deleteBtn.addTarget(self, action: #selector(deleteClick(sender:)), for: .touchUpInside)
        deleteBtn.isHidden = true
        return deleteBtn
    }()
    //开始播放
    func playSound(){
        if soundModel!.soundFilePath.hasPrefix("http"){
            let dic = ["urlPath": soundModel!.soundFilePath]
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "soundAnimationST"), object: self, userInfo: dic)
            QRMusicPlay.shared.playMusic(URL: URL(string: soundModel!.soundFilePath)!)
             self.soundView.playImg.startAnimating()
            self.soundView.isPlay = true
            QRMusicPlay.shared.player?.onStateChange = {[unowned self] status in
                if status == FSAudioStreamState.fsAudioStreamPlaying{
                    self.soundView.playImg.startAnimating()
                    self.soundView.isPlay = true
                }else if status == FSAudioStreamState.fsAudioStreamPlaybackCompleted{
                    self.soundView.playImg.stopAnimating()
                    self.soundView.isPlay = false
                }else if status == FSAudioStreamState.fsAudioStreamFailed{
                    self.soundView.playImg.stopAnimating()
                    self.soundView.isPlay = false
                }else if status == FSAudioStreamState.fsAudioStreamStopped{
                        self.soundView.playImg.stopAnimating()
                        self.soundView.isPlay = false
                }
            }
        }else{
            let dic = ["urlPath": soundModel!.soundFilePath]
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "soundAnimationST"), object: self, userInfo: dic)
            
            LGAudioPlayer.share()?.playAudio(withURLString: soundModel!.soundFilePath, at: 0)
            LGAudioPlayer.share()?.delegate = self
            
            self.soundView.playImg.startAnimating()
            self.soundView.isPlay = true
            
        }

       // self.player?.play(from:URL(string: "http://www.ytmp3.cn/down/60910.mp3")!)
    }
    //停止播放
    func stopPlaySound()  {
        if soundModel!.soundFilePath.hasPrefix("http"){
           // self.player?.stop()
             QRMusicPlay.shared.stopMusic()
        }else{
            LGAudioPlayer.share()?.stop()
        }
    }
    
    
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        NotificationCenter.default.addObserver(self, selector: #selector(updateAnimation), name: NSNotification.Name(rawValue: "stopVoiveAnimation"), object: nil)
    }
    lazy var picView :QRNetImgPicView = {
        let picView =  QRNetImgPicView(width: kHaveLeftWidth-AutoGetWidth(width: 36+10))
        picView.isHidden = true
        return picView
    }()
    
    @objc func updateAnimation(){
        self.soundView.playImg.stopAnimating()
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setUp()  {
        self.addSubview(self.iconImg)
        self.addSubview(self.nameLab)
        self.addSubview(self.contentLab)
        self.addSubview(soundView)
        self.addSubview(self.timeLab)
        self.addSubview(agreeBtn)
        self.addSubview(disAgreeBtn)
        self.addSubview(deleteBtn)
        self.addSubview(picView)
//        let line = UIView.init(frame: CGRect.init(x: 0, y: AutoGetHeight(height: 70)  - 0.5, width: kWidth, height: 0.5))
//        line.backgroundColor = kLineColor
//        self.addSubview(line)
        agreeBtn.isHidden = true
        disAgreeBtn.isHidden = true
    }
    

    @objc func deleteClick(sender:UIButton)  {
        let btn = sender
        let cell = superUITableViewCell(of: btn)
        let table = superUITableView(of: btn)
        let index = table?.indexPath(for: cell!)
        DLog(index)
        
        if self.agreeDelegate != nil {
            self.agreeDelegate?.deleteClick(index: index!)
        }
    }
    
    @objc func agreeClick(sender:UIButton)  {
        let btn = sender
        let cell = superUITableViewCell(of: btn)
        let table = superUITableView(of: btn)
        let index = table?.indexPath(for: cell!)
        DLog(index)
        
        if self.agreeDelegate != nil {
            self.agreeDelegate?.agreeClick(index: index!)
        }
    }
    
    @objc func disAgreeClick(sender:UIButton)  {
        let btn = sender
        let cell = superUITableViewCell(of: btn)
        let table = superUITableView(of: btn)
        let index = table?.indexPath(for: cell!)
        DLog(index)
        
        if self.agreeDelegate != nil {
            self.agreeDelegate?.disAgreeClick(index: index!)
        }
    }
    
    //返回button所在的UITableViewCell
    func superUITableViewCell(of: UIButton) -> UITableViewCell? {
        for view in sequence(first: of.superview, next: { $0?.superview }) {
            if let cell = view as? UITableViewCell {
                return cell
            }
        }
        return nil
    }
    
    //返回button所在的UITableView
    func superUITableView(of: UIButton) -> UITableView? {
        for view in sequence(first: of.superview, next: { $0?.superview }) {
            if let table = view as? UITableView {
                return table
            }
        }
        return nil
    }
    
    
    var soundModel: QRSoundModel? {
        didSet {
            if String(soundModel!.second ) == "0" || String(soundModel!.second ) == ""{
                self.soundView.timeCount.text = "1s"
                self.soundView.playUrl = soundModel!.soundFilePath
            }else{
                self.soundView.timeCount.text = String(soundModel!.second+1) + "s"
                self.soundView.playUrl = soundModel!.soundFilePath
            }
            
        }
    }
    
    
    //定义模型属性
    var model: CQScheduleUserModel? {
        didSet {
  
            self.iconImg.sd_setImage(with: URL(string: model?.headImage ?? ""), placeholderImage:UIImage.init(named: "personDefaultIcon") )
            if model?.realName == STUserTool.account().realName {
                self.nameLab.text = "我"
            }else{
                self.nameLab.text = model?.realName
            }
            
            self.contentLab.text =  model?.unagreeReason
            self.timeLab.text = model?.agreeYesOrNoTime
            if model?.userId == STUserTool.account().userID {
                if model?.agreeSign == "3" || model?.agreeSign == "2"{
                    self.contentLab.isHidden = false
                    self.timeLab.isHidden = false
                    self.disAgreeBtn.isHidden = true
                    self.agreeBtn.isHidden = true
                }else{
                    self.contentLab.isHidden = true
                    self.timeLab.isHidden = true
                    self.disAgreeBtn.isHidden = false
                    self.agreeBtn.isHidden = false
                }
            }else{
                self.contentLab.isHidden = false
                self.timeLab.isHidden = false
                self.disAgreeBtn.isHidden = true
                self.agreeBtn.isHidden = true
            }
            
            if model?.agreeSign == "3"{
                self.contentLab.text = "已同意"
            }
            
        }
    }

    
    //定义模型属性
    var modelLeave: CQCommentModel? {
        didSet {
            
            self.iconImg.sd_setImage(with: URL(string: modelLeave?.headImage ?? ""), placeholderImage:UIImage.init(named: "personDefaultIcon") )
            if modelLeave?.realName == STUserTool.account().realName {
                self.nameLab.text = "我"
            }else{
                self.nameLab.text = modelLeave?.realName
            }
            
            self.contentLab.text =  modelLeave?.commentContent
            self.timeLab.text = modelLeave?.commentTime
          //计算高度
            let textHeight = getTextHeight(text: modelLeave!.commentContent, font: kFontSize16, width: kWidth - AutoGetWidth(width: 77))
            
            if modelLeave?.path == ""{
                 self.contentLab.frame =  CGRect(x: self.iconImg.right + kLeftDis, y: self.nameLab.bottom + AutoGetHeight(height: 6), width: kWidth - AutoGetWidth(width: 77), height: textHeight + 10)
                
                //图片
                let imgs = modelLeave?.imagePaths
                let count = imgs!.count
                if count>0{
                    picView.isHidden = false
                    picView.imags = imgs
                    let rowNum = (count - 1)/(cellLayout.numOfPerRow) + 1
                    let pictureViewHeight = CGFloat(rowNum) * cellLayout.imageHeight + cellLayout.margin * (CGFloat(rowNum)-1)
                    picView.frame =  CGRect(x: contentLab.left, y: self.contentLab.bottom + 10, width: picView.pictureViewWidth, height: pictureViewHeight)
                    modelLeave!.rowHeight = self.picView.bottom + 10
                }else{
                    picView.frame =  CGRect(x: contentLab.left, y: self.contentLab.bottom + 10, width: picView.pictureViewWidth, height: 0)
                    modelLeave!.rowHeight = self.picView.bottom+10
                    picView.isHidden = true
                }
                
            }else{
                 modelLeave!.rowHeight = self.soundView.bottom+10
            }
           
          
            
           
            
        }
    }
    
}
extension CQScheduleDetailCell : LGAudioPlayerDelegate{
    func audioPlayerStateDidChanged(_ audioPlayerState: LGAudioPlayerState, for index: UInt) {
        if audioPlayerState == .normal{
            self.soundView.playImg.stopAnimating()
        }else if audioPlayerState == .cancel{
            self.soundView.playImg.stopAnimating()
        }else if audioPlayerState == .playing{
          
        }
    }
    
    
}
