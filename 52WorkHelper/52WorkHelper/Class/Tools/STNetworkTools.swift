//
//  NetworkTools.swift
//  LayerAssistance
//
//  Created by 浮生若梦 on 2016/12/16.
//  Copyright © 2016年 四美达. All rights reserved.
//

import UIKit


/// 请求方法枚举
enum MethodType {
    case get
    case post
}

private let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0] + "/account.archive"


class STNetworkTools {
    
//    lazy var netmanager: SessionManager = {
//        let configuration = URLSessionConfiguration.default
//        configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
//        let sessionManager = Alamofire.SessionManager(configuration: configuration)
//        return Alamofire.SessionManager(configuration: configuration)
//    }()
   
    static let sharedSessionManager: Alamofire.SessionManager = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 10
        configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        return Alamofire.SessionManager(configuration: configuration)
    }()
    
    
    //类方法
    class func requestData(URLString: String,
                                type: MethodType,
                               param: [String : Any]? = nil,
                     successCallBack: @escaping (_ result: JSON) -> (),
                        failCallBack: @escaping (_ error: JSON) -> ()) {
        
        let mhd = type == .get ? HTTPMethod.get : HTTPMethod.post
//        let v:String = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
//        let udid:String = UUIDHelper.getUUID()! as String
//        let uId = udid.replacingOccurrences(of: "-", with: "") as String
//        let equipmentName:String = UIDevice.current.systemName
        let headers = ["t_userId": STUserTool.account().userID,
                       "token": STUserTool.account().token]
        Alamofire.request(URLString, method: mhd, parameters: param,  headers: headers).responseJSON { (
            response) in
            //校验是否有值
            guard let result = response.result.value else {
                //请求失败
                failCallBack("error")
//                if let err = response.error{
//                    let aferror = err as! AFError
//                    if aferror.errorDescription == AFError.responseSerializationFailed(reason: AFError.ResponseSerializationFailureReason.inputDataNilOrZeroLength).errorDescription {
//                    }else{
//                        SVProgressHUD.showError(withStatus: "网络异常，请检查连接")
//                    }
//                }
              //  SVProgressHUD.showError(withStatus: "网络异常，请检查连接")
                print(response.error)
                return
            }
            
            
            
            //将结果回调出去
            let json = JSON(result)
                //错误回调
                if json["code"].stringValue == "0" || json["code"].stringValue=="200" || json["code"].stringValue=="" || json["code"].stringValue=="nil"{
                    
                }else{
                    let me = type == .get ? "get" : "post"
                    let v:String = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
                    let equipmentName:String = UIDevice.current.systemName
                    var dicStr = ""
                    if param == nil{
                         dicStr = ""
                    }else{
                         dicStr = getJSONStringFromDictionary(dictionary: param! as NSDictionary)
                    }
                    
                    self.reporterBackground(equitment: equipmentName+v, method:me, params: dicStr, url: URLString)
                }
            
            
            
            if json["success"].boolValue {
                //将结果回调出去
                successCallBack(json)
                print(URLString,param as Any,headers,mhd)
                print(response)
            } else {
               // failCallBack("error")
                failCallBack(json)
                print(URLString,param as Any,headers,mhd)
                print(json["code"])
                if json["code"].stringValue == "-1"{
                }else{
                SVProgressHUD.showInfo(withStatus: json["message"].stringValue)
                }
                print(response.error)
            }

            if json["code"].numberValue == 100301 || json["code"].numberValue == 100302{
                SVProgressHUD.showInfo(withStatus: json["message"].stringValue)
                let bool = FileManager.default.fileExists(atPath: path)
                if bool {
                    do {
                        // 删除路径下存储的数据，做了错误处理，运用do-catch处理，不太理解do-catch的我的文章中有
                        try FileManager.default.removeItem(atPath: path)
                        // 下边两行代码是界面转换和一些数据的处理  可以根据自己的需求来做
                        UserDefaults.standard.set("default", forKey: "userStatus")
                        //设置为未登陆
                        UserDefaults.standard.set(false, forKey: "APPIsLogin")
                        let vc = LoginVC()
                        vc.modalPresentationStyle = .fullScreen
                        UIApplication.shared.keyWindow?.rootViewController?.present(vc, animated: true, completion: nil)
                    }catch {
                        SVProgressHUD.showInfo(withStatus: "退出失败")
                    }
                }
            }
            
        }
    }
    
    //
    class func reporterBackground(equitment:String,method:String,params:String,url:String){
        
//        STNetworkTools.requestData(URLString: baseUrl+"/submitException", type: MethodType.post, param: ["equitment":equitment,
//                                     "method":method,
//                                     "params":params,
//                                     "url":url,], successCallBack: { (result) in
//
//
//        }) { (error) in
//
//        }
     
        let headers = ["t_userId": STUserTool.account().userID,
        "token": STUserTool.account().token]
        Alamofire.request(baseUrl+"/submitException", method: .post, parameters: ["equitment":equitment,
        "method":method,
        "params":params,
        "url":url,],  headers: headers).responseJSON { (
                    response) in
                    
                }
  
    }
    
    
    
    class func requestDataNoNeedToken(URLString: String,
                                         type: MethodType,
                                        param: [String : Any]? = nil,
                              successCallBack: @escaping (_ result: JSON) -> (),
                                 failCallBack: @escaping (_ error: JSON) -> ()) {
        let mhd = type == .get ? HTTPMethod.get : HTTPMethod.post
        Alamofire.request(URLString, method: mhd, parameters: param).responseJSON { (response) in
            //校验是否有值
            guard let result = response.result.value else {
                //请求失败
                failCallBack("error")
                SVProgressHUD.showError(withStatus: "网络异常，请检查连接")
                print(URLString,param as Any,mhd)
                DLog(response.error)
                return
            }
            //将结果回调出去
            let json = JSON(result)
            if json["success"].boolValue {
                //将结果回调出去
                successCallBack(json)
                print(URLString,param as Any,mhd)
                DLog(response)
            } else {
                failCallBack("error")
                SVProgressHUD.showInfo(withStatus: json["message"].stringValue)
                print(URLString,param as Any,mhd)
                DLog(response.error)
            }
            
            if json["code"].numberValue == 100301 || json["code"].numberValue == 100302{
                SVProgressHUD.showInfo(withStatus: json["message"].stringValue)
                let bool = FileManager.default.fileExists(atPath: path)
                if bool {
                    do {
                        // 删除路径下存储的数据，做了错误处理，运用do-catch处理，不太理解do-catch的我的文章中有
                        try FileManager.default.removeItem(atPath: path)
                        // 下边两行代码是界面转换和一些数据的处理  可以根据自己的需求来做
                        UserDefaults.standard.set("default", forKey: "userStatus")
                        //设置为未登陆
                        UserDefaults.standard.set(false, forKey: "APPIsLogin")
                        let vc = LoginVC()
                        vc.modalPresentationStyle = .fullScreen
                        UIApplication.shared.keyWindow?.rootViewController?.present(vc, animated: true, completion: nil)
                    }catch {
                        SVProgressHUD.showInfo(withStatus: "退出失败")
                    }
                }
            }
            
        }
    }
    
}
