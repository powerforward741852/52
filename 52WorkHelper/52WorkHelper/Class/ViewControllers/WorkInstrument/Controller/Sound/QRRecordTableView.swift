//
//  QRRecordTableView.swift
//  52WorkHelper
//
//  Created by 秦榕 on 2019/4/26.
//  Copyright © 2019 chenqihang. All rights reserved.
//

import UIKit

class QRRecordTableView: UIView {
    
    var dataArr = [QRSoundModel]()
    var uploadArr = [QRSoundModel]()
    var deleteArr = [QRSoundModel]()
    var timer : Timer?
    var screeView : UIWindow!
    var recordBut : UIButton?
    var isEdite : Bool = false
    
    @IBOutlet weak var table: UITableView!
    lazy var footView : UIView = {
        let backView = UIView(frame:  CGRect(x: 0, y: 0, width: kWidth, height:54))
        backView.backgroundColor = UIColor.white
        let recordBut = UIButton(frame:  CGRect(x: kLeftDis, y: 5, width: kHaveLeftWidth, height:  54 - 10))
        recordBut.titleLabel?.font = kFontSize14
        recordBut.setTitleColor(UIColor.colorWithHexString(hex: "#3e3e3e"), for: .normal)
        recordBut.setTitle("按住 说话", for:.normal)
        recordBut.backgroundColor = kProjectBgColor
        recordBut.setImage(UIImage(named: "y"), for: .normal)
        recordBut.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 10)
        recordBut.layer.cornerRadius = 8
        recordBut.clipsToBounds = true
        recordBut.addTarget(self, action: #selector(recordTouchDown), for: .touchDown)
        recordBut.addTarget(self, action: #selector(recordTouchUpInside), for: .touchUpInside)
        recordBut.addTarget(self, action: #selector(recordTouchUpOutside), for: .touchUpOutside)
        recordBut.addTarget(self, action: #selector(recordDragInside), for: .touchDragEnter)
        recordBut.addTarget(self, action: #selector(recordDragOutside), for: .touchDragExit)
        recordBut.addTarget(self, action: #selector(recordcancel), for: .touchCancel)
        backView.addSubview(recordBut)
        self.recordBut = recordBut
        return backView
    }()
    @objc func recordcancel(){
         LGSoundRecorder.shareInstance()?.soundRecordFailed(screeView)
    }
    
   //全部录音过程
    @objc func recordTouchDown(){
      let isauthen = checkMicAuthen()
        if isauthen {
            print("TouchDown")
            let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
            let recordPath = (dirPath as String) + "/SoundFile"  //String(Date().timeIntervalSince1970) + ".caf"
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
    
    
    
    //改变图片
    @objc func recordDragInside(){
        
         LGSoundRecorder.shareInstance()?.resetNormalRecord()
    }
    
    @objc func recordTouchUpInside(){
         print("TouchUpInside")
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
        addModel()
        let mod = QRSoundModel()
        mod.soundFilePath = LGSoundRecorder.shareInstance()?.soundFilePath
        transformTomp(sound:mod)
    }
    @objc func recordTouchUpOutside(){
        LGSoundRecorder.shareInstance()?.soundRecordFailed(screeView)
        if let vTimer = self.timer{
            vTimer.invalidate()
            self.timer = nil
        }
      
    }
   
    @objc func recordDragOutside(){
        LGSoundRecorder.shareInstance()?.readyCancelSound()
        
    }
    
    func addModel()  {
        let mod = QRSoundModel()
        mod.soundFilePath = LGSoundRecorder.shareInstance()?.soundFilePath
        mod.second = Int((LGSoundRecorder.shareInstance()!.audioDuration(fromURL: mod.soundFilePath)) ?? 1.0 )
        self.dataArr.append(mod)
        self.table.reloadData()
        NotificationCenter.default.post(name: NSNotification.Name.init("updateScheduleSoundHeight"), object: self, userInfo: nil)
    }
    
    func transformTomp(sound:QRSoundModel){
       // for (_,value) in dataArr.enumerated() {
            let start =  sound.soundFilePath
            let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
            let end = (dirPath as String) + "/SoundFile/" + String(Date().timeIntervalSince1970) + ".mp3"
             LGSoundRecorder.shareInstance()?.transformCAF(toMP3: start, end)
      
            //加入模型
            let mod = QRSoundModel()
            mod.soundFilePath = end
            uploadArr.append(mod)
      //  }
    }
    
    
    override func awakeFromNib() {

        table.isScrollEnabled = false
        table.register(CQScheduleDetailCell.self, forCellReuseIdentifier: "CQCreatScheduleCellId")
        table.separatorStyle = .none
        table.delegate = self
        table.dataSource = self
        table.backgroundColor = UIColor.white
        table.tableFooterView = footView
        
        table.allowsSelection = false
        table.separatorStyle = .none
        self.screeView = UIApplication.shared.keyWindow
    }

  
    
}
extension QRRecordTableView:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CQCreatScheduleCellId") as! CQScheduleDetailCell
        let model = self.dataArr[indexPath.row]
        cell.height = AutoGetHeight(height: 55)
        cell.iconImg.isHidden = true
        cell.nameLab.isHidden = true
        cell.contentLab.isHidden = true
        cell.timeLab.isHidden = true
        cell.soundView.isHidden = false
        cell.deleteBtn.isHidden = !isEdite
        cell.soundView.frame =  CGRect(x: kLeftDis, y: AutoGetHeight(height: 10), width: 130, height: AutoGetHeight(height: 35))
        cell.deleteBtn.frame = CGRect(x: kLeftDis + 145, y: AutoGetHeight(height: 20), width: AutoGetHeight(height: 13), height: AutoGetHeight(height: 13))
        cell.soundModel = model
        cell.soundView.timeCount.text = String(model.second) + "s"
        cell.agreeDelegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return AutoGetHeight(height: 55)
    }
    
    
    
//    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        return AutoGetHeight(height: 54)
//    }
//    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//       return recordBut
//    }
    
    

}
extension QRRecordTableView : CQScheduleDetailAgreeOrNotDelegate{
    func agreeClick(index: IndexPath) {
        
    }
    
    func disAgreeClick(index: IndexPath) {
    
    }
    
    func deleteClick(index: IndexPath) {
        
        if self.dataArr.count == self.uploadArr.count{
             self.dataArr.remove(at: index.row)
            self.uploadArr.remove(at: index.row)
        }else{
            let cha = self.dataArr.count - self.uploadArr.count
            if index.row - cha < 0{
                self.deleteArr.append(self.dataArr[index.row])
                 self.dataArr.remove(at: index.row)
                
            }else{
               self.uploadArr.remove(at: index.row - cha)
               self.dataArr.remove(at: index.row)
            }
            
        }
        
        self.table.reloadData()
         NotificationCenter.default.post(name: NSNotification.Name.init("updateScheduleSoundHeight"), object: self, userInfo: nil)
    }
    
    
}
