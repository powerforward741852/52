//
//  CQHTools.swift
//  LSByCQH
//
//  Created by chenqihang on 2017/10/30.
//  Copyright © 2017年 chenqihang. All rights reserved.
//

import UIKit
import Foundation

//高德key
public let gaodeKey = "7baf0d7c1cc5b7fbf58a79779a860513"//"cb84f6b811450dbcd9a5b928208999b2"
//融云key
//public let rongCloundKey = "lmxuhwagliumd"
//融云正式key
public let rongCloundKey = "z3v5yqkbz1530"
//Sharekey
public let ShareAppKey = "2635918feac33"
//微信key
public let wxAppKey = "wx5adf0a8c4ba768fa"
//"wx818b94ce6dc9b60d"//"wx818b94ce6dc9b60d"
//微信secret
public let wxAppSecret = "7bca6cb05f283c1ba40c2d9f70ff8b63" //"9487cb5527f8dacbeb1cdcd9695a98ff"//"cdf627e1e12bf26387ccf9ab712c8409"
//qqkey
public let qqAppKey =  "1106959533"//"1106959533"
//qqSecret
public let qqAppSecret = "8ntSX6E4CZXwJIe8"//"8ntSX6E4CZXwJIe8"
//试运行
//public let baseUrl = "http://47.106.206.254:8081/api/v1"
//正式
//public let baseUrl = "http://120.79.140.170:8081/api/v1"
//正式域名
public let baseUrl = "http://app.52zhushou.com/api/v1"
//测试
//public let baseUrl = "http://192.168.1.33:9094/api/v1"//"http://192.168.3.31:9094/api/v1"// "http://192.168.3.18:8080/api/v1"

//本地
//public let baseUrl = "http://192.168.3.30:8080/api/v1"
//image正式
public let imagePreUrl = "http://app.52zhushou.com"//"http://www.52zhushou.com:8081"
//image测试
//public let imagePreUrl = "http://192.168.1.33:9094"

//正式2维码url
let baseCodeUrl = "http://oa.52zhushou.com"
//测试2维码url
//let baseCodeUrl = "http://192.168.1.33:9093"

//版本号
public let CQVersion:String = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
//极光生产key
public let JPAPPKEY  = "92d2ff200c793a09dd6b89e1"//"fb8a60caa36249db474d0068"
//极光开发key
//public let JPAPPKEY  = "2cfad771421326714364144e"//"49ea4e9bb3394667da104c37"
//"92d2ff200c793a09dd6b89e1"//
////极光channel
public let JPCHANNEL = "Publish channel"
//是否为真实环境
public let isTrueEnvironment = true
//是否为管理员
public let isAdmin = true
//一些公共颜色，左边距，字体
public let kLeftDis = AutoGetWidth(width: 15)
public let kLyGrayColor = UIColor.colorWithHexString(hex: "#a9a9a9")
public let kProjectBgColor = UIColor.colorWithHexString(hex: "#f7f7f7")
public let kLightBlueColor = UIColor.colorWithHexString(hex: "#21afff")

public let kProjectDarkBgColor = UIColor.colorWithHexString(hex: "#ededee")

public let kOrangeColor = UIColor.colorWithHexString(hex: "#ff9000")
public let kLineColor = UIColor.colorWithHexString(hex: "#e5e5e5")
public let kGoldYellowColor = UIColor.colorWithHexString(hex: "#f89800")
public let kBlueColor = UIColor.colorWithHexString(hex: "#20afff")
public let kfilterBackColor = UIColor.colorWithHexString(hex: "#f0f0f0")
public let kfilterBlueColor = UIColor.colorWithHexString(hex: "#daf1fc")
public let kSignBlueColor = UIColor.colorWithHexString(hex: "#f2f6fc")
public let kSignGreyTextColor = UIColor.colorWithHexString(hex: "#9f9f9f")
public let kSignBlueTextColor = UIColor.colorWithHexString(hex: "#087fc2")
public let kSignLocationbtnColor = UIColor.colorWithHexString(hex: "#259fda")
public let kBlueC = kColorRGB(r: 44, g: 160, b: 255)
public let kContractBlueColor = UIColor.colorWithHexString(hex: "#d7f1fd")

public let kFontSize10 = UIFont.systemFont(ofSize: 10)
public let kFontSize11 = UIFont.systemFont(ofSize: 11)
public let kFontSize12 = UIFont.systemFont(ofSize: 12)
public let kFontSize13 = UIFont.systemFont(ofSize: 13)
public let kFontSize14 = UIFont.systemFont(ofSize: 14)
public let kFontSize15 = UIFont.systemFont(ofSize: 15)
public let kFontSize16 = UIFont.systemFont(ofSize: 16)
public let kFontSize17 = UIFont.systemFont(ofSize: 17)
public let kFontSize18 = UIFont.systemFont(ofSize: 18)
public let kFontSize20 = UIFont.systemFont(ofSize: 20)
public let kFontSize21 = UIFont.systemFont(ofSize: 21)

public let kFontBoldSize15 = UIFont.boldSystemFont(ofSize: 15)
public let kFontBoldSize17 = UIFont.boldSystemFont(ofSize: 17)
public let kFontBoldSize18 = UIFont.boldSystemFont(ofSize: 18)
public let kFontBoldSize19 = UIFont.boldSystemFont(ofSize: 19)
public let kFontBoldSize20 = UIFont.boldSystemFont(ofSize: 20)
public let kFontBoldSize24 = UIFont.boldSystemFont(ofSize: 24)
public let kFontBoldSize30 = UIFont.boldSystemFont(ofSize: 30)

let kScreenBouns = UIScreen.main.bounds
let kScreenSize = UIScreen.main.bounds.size
public let kWidth = UIScreen.main.bounds.size.width
public let kHaveLeftWidth = kWidth - AutoGetWidth(width: 30)
public let kHeight = UIScreen.main.bounds.size.height
public let SafeAreaTopHeight:CGFloat = ( kHeight == 812.0 || kHeight == 896 ? 88 : 64)
public let SafeAreaStateTopHeight:CGFloat = ( kHeight == 812.0 || kHeight == 896 ? 44 : 20)
public let SafeAreaBottomHeight:CGFloat = (kHeight == 812.0 || kHeight == 896 ? 34 : 0)
public let SafeTabbarBottomHeight:CGFloat = (kHeight == 812.0 || kHeight == 896 ? 83.0 : 49.0)


public func kView_width(view:UIView) -> CGFloat {
    return view.frame.size.width
}

public func kView_height(view:UIView) -> CGFloat{
    return view.frame.size.height
}

public func HHClassFromString(_ className:String) -> Swift.AnyClass? {
    
    let bundleName = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as! String
    return NSClassFromString("\(bundleName).\(className)")
}

// MARK: - 打印信息
//FIXME:修改我
//TODO:单调

public func DLog<T>(_ message:T,fileName:String = #file,method : String = #function,line : Int = #line){
    #if DEBUG
        let str = (fileName as NSString).pathComponents.last!.replacingOccurrences(of: ".swift", with: "")
        print("\(str) -> \(method) -> \(line)行 -> :\n \(message)")
    #else
        let array = fileName.components(separatedBy: "/")
            print(array.last ?? "")
    
    #endif
}

// MARK: - RGB

func kColorRGB (r: CGFloat,g:CGFloat,b:CGFloat) -> UIColor{
    return UIColor.init(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: 1.0)
}

// MARK: - HaveAlpaRGB

func kAlpaRGB (r: CGFloat,g:CGFloat,b:CGFloat,a:CGFloat) -> UIColor{
    return UIColor.init(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: a)
}

//创建纯色图片
func imageWithColor(color:UIColor ,size:CGSize) -> UIImage
{
    let rect = CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height)
    UIGraphicsBeginImageContext(rect.size)
    let context:CGContext = UIGraphicsGetCurrentContext()!
    context.setFillColor(color.cgColor);
    context.fill(rect);
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return image!
}
//计算str高度

func getTextHeight(text:String,font:UIFont,width:CGFloat) -> CGFloat {
    let str : NSString = text as NSString
    let size = CGSize(width:width,height:1000)
    // var dic = NSDictionary(objects: font, forKeys: NSFontAttributeName)
    let stringSize = str.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font : font], context: nil).size
    return stringSize.height
}

//计算宽度
func getTexWidth(textStr:String,font:UIFont,height:CGFloat) -> CGFloat {
    
    let normalText: String = textStr
    
    let size = CGSize.init(width: 1000, height: height)
    
    let dic = NSDictionary(object: font, forKey: NSAttributedStringKey.font as NSCopying)
    
    let stringSize = normalText.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: dic as? [NSAttributedStringKey : Any], context:nil).size
    
    return stringSize.width
    
}
//获取月
func getMonth() ->Int {
    let calendar = NSCalendar.current
    let date = Date()
    //这里注意 swift要用[,]这样方式写
    let com =  calendar.component(Calendar.Component.month, from: date)
    // let com = calendar.components([.Year,.Month,.Day], fromDate:self)
    return com
}
//获取当前nian
func getYear() ->Int {
    let calendar = NSCalendar.current
    let date = Date()
    //这里注意 swift要用[,]这样方式写
    let com =  calendar.component(Calendar.Component.year, from: date)
    // let com = calendar.components([.Year,.Month,.Day], fromDate:self)
    return com
}

//json转字典
public  func getDictionaryFromJSONString(jsonString:String) ->NSDictionary{
    
    let jsonData:Data = jsonString.data(using: .utf8)!
    let dict = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
    if dict != nil {
        return dict as! NSDictionary
    }
    return NSDictionary()
}
/**
 字典转换为JSONString
 - parameter dictionary: 字典参数
 - returns: JSONString
 */
func getJSONStringFromDictionary(dictionary:NSDictionary) -> String {
    if (!JSONSerialization.isValidJSONObject(dictionary)) {
        print("无法解析出JSONString")
        return ""
    }
    let data : NSData! = try? JSONSerialization.data(withJSONObject: dictionary, options: []) as NSData
    let JSONString = NSString(data:data as Data,encoding: String.Encoding.utf8.rawValue)
    return JSONString! as String
    
}
// MARK: 代码适配
public let AutoSizeScreenWidth_AutoSize = UIScreen.main.bounds.size.width

public let AutoSizeScreenHeight_AutoSize = UIScreen.main.bounds.size.height

public let AutoSizeScaleX_AutoSize = (AutoSizeScreenHeight_AutoSize>667.0) ? (AutoSizeScreenWidth_AutoSize/375.0) : 1.0

public func AutoGetWidth(width:CGFloat) -> CGFloat{
    return (width * AutoSizeScaleX_AutoSize)
}

public func AutoGetHeight(height:CGFloat) -> CGFloat{
    return (height * AutoSizeScaleX_AutoSize)
}

//去除str尾部空格
 public func recursive(urlstr:String) -> String{
    if urlstr.hasSuffix(" ") {
        var tempstr = urlstr
        tempstr.removeLast()
        let result = recursive(urlstr: tempstr)
        return result
    } else {
        return urlstr
    }
}

//适配结束

// MARK: colorHex
/*
 let newStr = String(str[..<index]) // = str.substring(to: index) In Swift 3
 let newStr = String(str[index...]) // = str.substring(from: index) In Swif 3
 let newStr = String(str[range]) // = str.substring(with: range) In Swift 3
 */
extension UIColor {
    public class func colorWithHexString(hex:String) ->UIColor {
        
        var cString = hex.trimmingCharacters(in:CharacterSet.whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            let index = cString.index(cString.startIndex, offsetBy:1)
//            cString = cString.substring(from: index)
            cString = String(cString[index...])
        }
        
        if (cString.count != 6) {
            return UIColor.red
        }
        
        let rIndex = cString.index(cString.startIndex, offsetBy: 2)
//        let rString = cString.substring(to: rIndex)
//        let otherString = cString.substring(from: rIndex)
//        let gIndex = otherString.index(otherString.startIndex, offsetBy: 2)
//        let gString = otherString.substring(to: gIndex)
//        let bIndex = cString.index(cString.endIndex, offsetBy: -2)
//        let bString = cString.substring(from: bIndex)
        let rString = String(cString[..<rIndex])
        let otherString = String(cString[rIndex...])
        let gIndex = otherString.index(otherString.startIndex, offsetBy: 2)
        let gString = String(otherString[..<gIndex])
        let bIndex = cString.index(cString.endIndex, offsetBy: -2)
        let bString = String(cString[bIndex...])
        
        var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0;
        Scanner(string: rString).scanHexInt32(&r)
        Scanner(string: gString).scanHexInt32(&g)
        Scanner(string: bString).scanHexInt32(&b)
        
        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(1))
    }
}


extension String {
    // base64编码
    func toBase64() -> String? {
        if let data = self.data(using: .utf8) {
            return data.base64EncodedString()
        }
        return nil
    }

    // base64解码
    func fromBase64() -> String? {
        if let data = Data(base64Encoded: self) {
            return String(data: data, encoding: .utf8)
        }
        return nil
    }
    
    
    var containsEmoji: Bool {
        for scalar in unicodeScalars {
            switch scalar.value {
            case
            0x00A0...0x00AF,
            0x2030...0x204F,
            0x2120...0x213F,
            0x2190...0x21AF,
            0x2310...0x329F,
            0x1F000...0x1F9CF:
                return true
            default:
                continue
            }
        }
        return false
    }
}

func getTopVC() -> (UIViewController?) {
    var window = UIApplication.shared.keyWindow
    //是否为当前显示的window
    if window?.windowLevel != UIWindowLevelNormal{
        let windows = UIApplication.shared.windows
        for  windowTemp in windows{
            if windowTemp.windowLevel == UIWindowLevelNormal{
                window = windowTemp
                break
            }
        }
    }
    let vc = window?.rootViewController
    return getTopVC(withCurrentVC: vc)
}

///根据控制器获取 顶层控制器
func getTopVC(withCurrentVC VC :UIViewController?) -> UIViewController? {
    if VC == nil {
        print("🌶： 找不到顶层控制器")
        return nil
    }
    if let presentVC = VC?.presentedViewController {
        //modal出来的 控制器
        return getTopVC(withCurrentVC: presentVC)
    }else if let tabVC = VC as? UITabBarController {
        // tabBar 的跟控制器
        if let selectVC = tabVC.selectedViewController {
            return getTopVC(withCurrentVC: selectVC)
        }
        return nil
    } else if let naiVC = VC as? UINavigationController {
        // 控制器是 nav
        return getTopVC(withCurrentVC:naiVC.visibleViewController)
    } else {
        // 返回顶控制器
        return VC
    }
}

//根据公历年、月、日获取对应的农历日期信息
func solarToLunar(year: Int, month: Int, day: Int) -> String {
    
    //初始化公历日历
    
    let solarCalendar = Calendar.init(identifier: .gregorian)
    
    var components = DateComponents()
    
    components.year = year
    
    components.month = month
    
    components.day = day
    
    components.hour = 12
    
    components.minute = 0
    
    components.second = 0
    
    components.timeZone = TimeZone.init(secondsFromGMT: 60 * 60 * 8)
    
    let solarDate = solarCalendar.date(from: components)
    
    
    //初始化农历日历
    
    let lunarCalendar = Calendar.init(identifier: .chinese)
    
    //日期格式和输出
    
    let formatter = DateFormatter()
    
    formatter.locale = Locale(identifier: "zh_CN")
    
    formatter.dateStyle = .medium
    
    formatter.calendar = lunarCalendar
    
    return formatter.string(from: solarDate!)
    
}


//弹窗
func alterTitle(title:String,message:String,okTitle:String ,cancelTitle:String,okAction:UIAlertAction,cancelAction:UIAlertAction){
    let alert = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
//    let ok = UIAlertAction.init(title: okTitle, style: .default) { (al) in
//        //打开定位设置
//        if let appSettings = NSURL(string: UIApplicationOpenSettingsURLString) {
//            UIApplication.shared.openURL(appSettings as URL)
//        }
//    }
//    let cancel = UIAlertAction.init(title: cancelTitle, style: .cancel) { (ca) in
//    }
    alert.addAction(okAction)
    alert.addAction(cancelAction)
    
    let vc:UIViewController = getTopVC()!
    vc.modalPresentationStyle = .fullScreen
    vc.present(alert, animated: true, completion: nil)
}




func checkMicAuthen()->Bool{
    if (  AVCaptureDevice.authorizationStatus(for: AVMediaType.audio) == .restricted ||  AVCaptureDevice.authorizationStatus(for: AVMediaType.audio) == .denied ) {
       //设置提示提醒用户打开定位服务
        let alert = UIAlertController.init(title: "无法访问麦克风", message: "请在设置中打开设置权限,以录制语音", preferredStyle: .alert)
        let ok = UIAlertAction.init(title: "去设置", style: .default) { (al) in
            //打开定位设置
            if let appSettings = NSURL(string: UIApplicationOpenSettingsURLString) {
                UIApplication.shared.openURL(appSettings as URL)
            }
        }
        let cancel = UIAlertAction.init(title: "取消", style: .cancel) { (ca) in
        }
        alert.addAction(ok)
        alert.addAction(cancel)
       
        let vc:UIViewController = getTopVC()!
        vc.modalPresentationStyle = .fullScreen
        vc.present(alert, animated: true, completion: nil)
        
        return false
    }else if  AVCaptureDevice.authorizationStatus(for: AVMediaType.audio) == .notDetermined {
        
        AVCaptureDevice.requestAccess(for: .audio, completionHandler: { (statusFirst) in
            if statusFirst {
                // print("允许APP访问麦克风")
            } else {
            }
        })
        return false
    }else{
        return true
    }
    
}


func getIndexIfInStr(str: String, nums: Int) -> Bool{
    if nums > (str.count - 1) {
        print("NSString+BDCreatString: 字符串位置错误")
        return false
    } else if nums < 0 {
        print("NSString+BDCreatString: 字符串位置错误")
        return false
    } else {
        return true
    }
}
extension String {
    /** 从头开始切,切到哪里你来定*/
    func bdSubString(to: Int) -> String {
        if getIndexIfInStr(str: self, nums: to) {
            let index = self.index(self.startIndex, offsetBy: to, limitedBy: self.endIndex)
            return (String(self[self.startIndex...index!]))
        } else {
            return ""
        }
        
    }
    
    /** 从哪开始,一直切到尾*/
    func bdSubString(from: Int) -> String {
        if getIndexIfInStr(str: self, nums: from) {
            let index = self.index(self.startIndex, offsetBy: from, limitedBy: self.endIndex)
            return (String(self[index!..<(self.endIndex)]))
        } else {
            return ""
        }
    }
    
    /** 从哪开始,切到哪里*/
    func bdSubString(from: Int, to: Int) -> String {
        if getIndexIfInStr(str: self, nums: from) && getIndexIfInStr(str: self, nums: to) {
            let indexFrom = self.index(self.startIndex, offsetBy: from, limitedBy: self.endIndex)
            let indexTo = self.index(self.startIndex, offsetBy: to, limitedBy: self.endIndex)
            return (String(self[indexFrom!...indexTo!]))
        } else {
            return ""
        }
    }
    
    /**从那个字符串开始切,切到那个字符串(需两个不同的字符串)*/
    func bdSubString(fromStr: String, toStr: String) -> String {
        let from = self.positionOf(sub: fromStr)
        let to = self.positionOf(sub: toStr)
        if getIndexIfInStr(str: self, nums: from) && getIndexIfInStr(str: self, nums: to) {
            let indexFrom = self.index(self.startIndex, offsetBy: from + fromStr.count, limitedBy: self.endIndex)
            let indexTo = self.index(self.startIndex, offsetBy: to, limitedBy: self.endIndex)
            return (String(self[indexFrom!..<indexTo!]))
        } else {
            return ""
        }
    }
    
    func positionOf(sub:String, backwards:Bool = false)->Int {
        var pos = -1
        if let range = range(of:sub, options: backwards ? .backwards : .literal ) {
            if !range.isEmpty {
                pos = self.distance(from:startIndex, to:range.lowerBound)
            }
        }
        return pos
    }
    
   
}


extension UIViewController{
    //主要作用是适配ios13，将present变为全屏
      static func swizzlePresent() {

        let orginalSelector = #selector(present(_: animated: completion:))
        let swizzledSelector = #selector(swizzledPresent)

        guard let orginalMethod = class_getInstanceMethod(self, orginalSelector), let swizzledMethod = class_getInstanceMethod(self, swizzledSelector) else{return}

        let didAddMethod = class_addMethod(self,
                                           orginalSelector,
                                           method_getImplementation(swizzledMethod),
                                           method_getTypeEncoding(swizzledMethod))

        if didAddMethod {
          class_replaceMethod(self,
                              swizzledSelector,
                              method_getImplementation(orginalMethod),
                              method_getTypeEncoding(orginalMethod))
        } else {
          method_exchangeImplementations(orginalMethod, swizzledMethod)
        }

      }

      @objc
      private func swizzledPresent(_ viewControllerToPresent: UIViewController,
                                   animated flag: Bool,
                                   completion: (() -> Void)? = nil) {
        if #available(iOS 13.0, *) {
          if viewControllerToPresent.modalPresentationStyle == .automatic || viewControllerToPresent.modalPresentationStyle == .pageSheet{
            viewControllerToPresent.modalPresentationStyle = .fullScreen
          }
        }
        swizzledPresent(viewControllerToPresent, animated: flag, completion: completion)
    }
}
