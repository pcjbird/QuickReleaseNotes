//
//  QuickReleaseCheckProtocol.h
//  QuickReleaseNotes
//
//  Created by pcjbird on 2018/3/28.
//  Copyright © 2018年 Zero Status. All rights reserved.
//

#ifndef QuickReleaseCheckProtocol_h
#define QuickReleaseCheckProtocol_h

/**
 *@brief 版本检测结果回调
 *@param hasNewVersion 是否有新版本
 *@param version 当前应用在商店中的版本号
 *@param releaseNotes 版本更新日志
 *@param appUrl App在应用商店的地址
 *@param force 是否强制更新
 *@param error 检测过程发生的错误
 */
typedef void(^QuickReleaseNotesBlock)(BOOL hasNewVersion, NSString* version, NSString* releaseNotes, NSString* appUrl, BOOL force, NSError* error);

/**
 *@brief 版本检测协议
 */
@protocol QuickReleaseCheckProtocol<NSObject>
@required

/**
 *@brief 检查 App 新版本
 *@param complete 版本检测回调
 */
-(void) checkAppNewRelease:(QuickReleaseNotesBlock)complete;

@end

#endif /* QuickReleaseCheckProtocol_h */
