//
//  QRRecordSoundView.swift
//  52WorkHelper
//
//  Created by 秦榕 on 2019/4/26.
//  Copyright © 2019 chenqihang. All rights reserved.
//

import UIKit

class QRRecordSoundView: UIView {

    @IBOutlet weak var RecordBut: UIButton!
    
    @IBOutlet weak var textLab: UILabel!
    
    @IBOutlet weak var VoiceImg: UIImageView!
    
    @IBOutlet weak var voiceView: QRRecordStatusView!
    
    @IBOutlet weak var butView: UIView!
    
    @IBOutlet weak var upView: UIView!
    
    
    //点击回调
    //声明闭包
    typealias clickBtnClosure = (_ close : Int ) -> Void
    //把申明的闭包设置成属性
    var clickClosure: clickBtnClosure?
    
    var schedulePlanId : String = ""
    var timer : Timer?
    var screeView : UIWindow!
    var recordBut : UIButton?
    
    override func awakeFromNib() {
        self.backgroundColor = UIColor.init(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.7)
        RecordBut.setBackgroundImage(UIImage(named: "anzhu"), for: .highlighted)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissView))
        self.addGestureRecognizer(tapGesture)
        tapGesture.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(updateVoice(notification:)), name: NSNotification.Name("voiceChange"), object: nil)
        
     
        
        
    }
    
    
    @objc func updateVoice(notification:Notification){
        let voice = notification.userInfo?["voice"] as? String ?? "1"
        let count = Int(voice)
        voiceView.startAnimation(voice:count!)
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func dismissView(){
        clickClosure!(1)
        LGSoundRecorder.shareInstance()?.removeLiuYanFile()
        self.removeFromSuperview()
    }
    //上传语音留言
    func addCommentRequest(mod:QRSoundModel)  {
        SVProgressHUD.show()
        
        let userID = STUserTool.account().userID
        let urlUpload = "\(baseUrl)/schedule/saveScheduleComment"
        let headers = ["t_userId":userID,
                       "token":STUserTool.account().token]
        Alamofire.upload(multipartFormData: { formData in
            let param = ["userId":userID,
                         "schedulePlanId":self.schedulePlanId]
            //添加音频文件 audioFiles
                let vidioName = "liuYan" + String(Date().timeIntervalSince1970) + ".mp3"
                let url = URL(fileURLWithPath: mod.soundFilePath )
                formData.append(url, withName: "audioFile", fileName: vidioName, mimeType: "audio/mp3")
            
            for (key, value) in param {
                formData.append((value.data(using: .utf8)!), withName: key)
            }
            
        }, to: urlUpload, headers: headers, encodingCompletion: {encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    SVProgressHUD.dismiss()
                    guard let result = response.result.value else {
                        //请求失败
                        if let err = response.error{
                        }
                        SVProgressHUD.showError(withStatus: "服务器有点问题")
                        DLog(response.error)
                        return
                    }
                    //将结果回调出去
                    let json = JSON(result)
                    if json["success"].boolValue == true{
                        SVProgressHUD.showInfo(withStatus: json["message"].stringValue)
                      //  SVProgressHUD.showInfo(withStatus: "添加成功")
                    }else{
                        SVProgressHUD.showError(withStatus: json["message"].stringValue)
                    }
                    
                    self.dismissView()
                   
                }
            case .failure( _):
               SVProgressHUD.dismiss()
                self.dismissView()
            }
        })
    }
    
    
    
    @IBAction func recordTouchDown(_ sender: Any) {
        
        let isauthen = checkMicAuthen()
        if isauthen {
            let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
            let recordPath = (dirPath as String) + "/liuYanFile"  //String(Date().timeIntervalSince1970) + ".caf"
            print(recordPath)
            LGSoundRecorder.shareInstance()?.startSoundRecord(screeView, recordPath: recordPath )
            
            if let vTimer = self.timer{
                vTimer.invalidate()
                self.timer = nil
            }else{
                self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(sixtyTimeStopAndSendVedio), userInfo: nil, repeats: true)
            }
        }else{
            
            
        }
        
       
    }
    @objc func sixtyTimeStopAndSendVedio(){
        if (LGSoundRecorder.shareInstance()?.soundRecordTime())! >= TimeInterval(60) && (LGSoundRecorder.shareInstance()?.soundRecordTime())! <= TimeInterval(61){
            
            if let vTimer = self.timer{
                vTimer.invalidate()
                self.timer = nil
            }
            self.recordBut?.sendActions(for: UIControlEvents.touchUpInside)
        }
    }
    
    @IBAction func recordTouchUpOutside(_ sender: Any) {
        LGSoundRecorder.shareInstance()?.soundRecordFailed(screeView)
        if let vTimer = self.timer{
            vTimer.invalidate()
            self.timer = nil
        }
        
    }
    
    
    @IBAction func recordTouchUpinside(_ sender: Any) {
        if LGSoundRecorder.shareInstance()?.soundRecordTime() == TimeInterval(0){
            LGSoundRecorder.shareInstance()?.soundRecordFailed(screeView)
            return
        }
        
        if (LGSoundRecorder.shareInstance()?.soundRecordTime())! < TimeInterval(1){
            if let vTimer = self.timer{
                vTimer.invalidate()
                self.timer = nil
            }
            //显示太短
            LGSoundRecorder.shareInstance()?.soundRecordFailed(screeView)
            return
        }
        
        LGSoundRecorder.shareInstance()?.stopSoundRecord(screeView)
        let mod = QRSoundModel()
        mod.soundFilePath = LGSoundRecorder.shareInstance()?.soundFilePath
        transformTomp(sound:mod)
    }
    
    
    @IBAction func recordTouchDraginside(_ sender: Any) {
         LGSoundRecorder.shareInstance()?.resetNormalRecord()
    }
    
    
    
    @IBAction func recordTouchDragOutside(_ sender: Any) {
          LGSoundRecorder.shareInstance()?.readyCancelSound()
    }
    
    func transformTomp(sound:QRSoundModel){
        
        let start =  sound.soundFilePath
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let end = (dirPath as String) + "/liuYanFile/" + String(Date().timeIntervalSince1970) + ".mp3"
        LGSoundRecorder.shareInstance()?.transformCAF(toMP3: start, end)
        
        //加入模型
        let mod = QRSoundModel()
        mod.soundFilePath = end
       addCommentRequest(mod: mod)
    }
 
}
extension QRRecordSoundView : UIGestureRecognizerDelegate {
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        
        let poi = gestureRecognizer.location(in: self)
        let rec = self.butView?.convert((butView?.bounds)!, to: self)
        let recup = self.upView?.convert((upView?.bounds)!, to: self)
        if (rec?.contains(poi))! || (recup?.contains(poi))!{
            return false
        }else{
            return true
        }
      
    }
}
