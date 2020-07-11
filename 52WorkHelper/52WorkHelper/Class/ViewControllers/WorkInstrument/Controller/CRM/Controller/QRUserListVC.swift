//
//  QRUserListVC.swift
//  52WorkHelper
//
//  Created by 秦榕 on 2018/9/24.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

import UIKit

class QRUserListVC: UIViewController {
   //部门id //searchmode为3时departmentId为用户所在的部门id
    var departmentId = ""
    //聊天群组id  //    searchmode为2时必填
   var groupId = ""
    //公海的搜索mode
   var searchmode = "3"
   var userId = ""
   var dataArr = [CQDepartMentUserListModel]()
  
    override func viewDidLoad() {
        super.viewDidLoad()
       self.userId = STUserTool.account().userID
        
//        // 创建调度组
//        let workingGroup = DispatchGroup()
//        // 创建多列
//        let workingQueue = DispatchQueue(label: "request_queue")
//        // 模拟异步发送网络请求 A
//        // 入组
//        workingGroup.enter()
//        workingQueue.async {
//            self.loadFatherDepartMent()
//            print("接口 A 数据请求完成")
//            // 出组
//            workingGroup.leave()
//        }
//        
//        workingGroup.notify(queue: workingQueue) {
//            print("接口 A 和接口 B 的数据请求都已经完毕！, 开始合并两个接口的数据")
//            
//            self.loadFenPeiList()
//        }
        
        loadFatherDepartMent()
    }
    func loadFatherDepartMent(){
        
        STNetworkTools.requestData(URLString: "\(baseUrl)/mailList/getPersonDetails", type: .get, param: ["userId":self.userId], successCallBack: { (result) in
            
                self.departmentId = result["data"]["departmentId"].stringValue
                self.title = result["data"]["departmentId"].stringValue
            
            
            DispatchQueue.main.async {
                //self.loadFenPeiList()
                //vc.title = model.departmentName
                //vc.groupId = self.groupId
                
                let vc = CQDepartmentVC.init()
                vc.departmentId = self.departmentId
                vc.toType = .fromContact
               // vc.hasSelectModelArr = self.hasSelectModelArr
                self.navigationController?.pushViewController(vc, animated: true)

            }
            
        }) { (error) in
            SVProgressHUD.showInfo(withStatus: "网络加载失败")
        }
    }
    
    
    

//    func loadFenPeiList() {
//        STNetworkTools.requestData(URLString: "\(baseUrl)/mailList/getChildDepartmentList", type: .get, param: ["departmentId":"44","userId":"91","searchmode":searchmode], successCallBack: { (result) in
//            if result["success"] == true{
//                self.departmentId = result["departmentId"].stringValue
//                var temp = [CQDepartMentUserListModel]()
//                for xx in result["data"]["userData"].arrayValue{
//                    let mod = CQDepartMentUserListModel(jsonData: xx)
//                    temp.append(mod!)
//                }
//                self.dataArr = temp
//            }
//
//        }) { (error) in
//            SVProgressHUD.showInfo(withStatus: "网络加载失败")
//        }
//    }
    
}
