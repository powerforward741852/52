//
//  52Bridge.h
//  52WorkHelper
//
//  Created by chenqihang on 2018/4/23.
//  Copyright © 2018年 chenqihang. All rights reserved.
//

#ifndef _2Bridge_h
#define _2Bridge_h
@import MLLabel;
@import Alamofire;
@import SwiftyJSON;
@import SVProgressHUD;
@import SDCycleScrollView;
@import MJRefresh;
@import SDWebImage;
@import DZNEmptyDataSet;
@import IQKeyboardManagerSwift;
@import TZImagePickerController;
@import Popover;
@import CVCalendar;
@import TangramKit;
@import Masonry;
@import JXPagingView;
@import JXCategoryView;
@import DateToolsSwift;
@import Bugly;
@import YNDropDownMenu;
@import FreeStreamer;
@import FSCalendar;
@import YYText;
//#import "FSCalendar.h"
//@import Pgyer;
//@import PgyUpdate;

#import "WZLBadgeImport.h"
@import SSKeychain;
//#import <UMSocialCore/UMSocialCore.h>
//#import <UShareUI/UShareUI.h>
//#import "ZHDocument.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import <AMapLocationKit/AMapLocationKit.h>

#import <CoreLocation/CoreLocation.h>
#import "UUButton.h"

//分享
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <ShareSDKConnector/ShareSDKConnector.h>

//腾讯SDK头文件
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>

//微信SDK头文件
#import "WXApi.h"

// 引入JPush功能所需头文件
#import "JPUSHService.h"
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
// 如果需要使用idfa功能所需要引入的头文件（可选）
#import <AdSupport/AdSupport.h>

#import "AFNetworking.h"
#import "MJExtension.h"
#import "SSSearchBar.h"
#import "UIImage+Tool.h"
#import "OCTool.h"
#import "CBTextView.h"
#import "MyTextField.h"
#import "UUIDHelper.h"
#import "EwenTextView.h"
#import "HDeviceIdentifier.h"
#import "SFHFKeychainUtils.h"
#import "LoadingAndRefreshView.h"


#import "UIView+Geometry.h"
#import "AILoadingView.h"
//瀑布流 XJWaterFallLayout
#import "XJWaterFallLayout.h"
//日期选择器
#import "XMTimePickerView.h"
//农历转换
#import "DAYUtils.h"

#import "StarHomeViewController.h"
#import "UIButton+actionBlock.h"
#import "StarViewModel.h"
//通讯录
#import "LJContactManager.h"
//名片识别图片截取
#import "UIImage+info.h"
//录音
#import "LGSoundRecorder.h"
#import "LGAudioPlayer.h"
#import "lame.h"

//百度地图
#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件
#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件
#import <BaiduMapAPI_Search/BMKSearchComponent.h>//引入检索功能所有的头文件
#import <BaiduMapAPI_Cloud/BMKCloudSearchComponent.h>//引入云检索功能所有的头文件
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>//引入计算工具所有的头文件
#import <BaiduMapAPI_Map/BMKMapView.h>//只引入所需的单个头文件

//时间选择器
#import "BRPickerView.h"
#import "BRPickerViewMacro.h"
//历史记录
#import "HistoryViewCell.h"
#import "JYEqualCellSpaceFlowLayout.h"

//飘花
 #import "FlowFlower.h"
//数据库
#import "NSObject+WHC_Model.h"
#import "WHC_ModelSqlite.h"
#import "Person.h"
#import "Item.h"
#import "QRSection.h"

//蒲公英
//#import <PgySDK/PgyManager.h>
//#import <PgyUpdate/PgyUpdateManager.h>

#endif /* _2Bridge_h */
