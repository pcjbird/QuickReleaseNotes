//
//  QuickAppStoreReleaseNotesAlert.h
//  QuickReleaseNotes
//
//  Created by pcjbird on 2018/3/28.
//  Copyright © 2018年 Zero Status. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *@brief 快速检测AppStore版本更新，含提示
 */
@interface QuickAppStoreReleaseNotesAlert : NSObject


/**
 *@brief 检测新版本
 *@param bSilent 当检测过程发生错误或没有版本更新时是否屏蔽提示。 YES, 不提示; NO, 弹窗提示。
 */
+(void) checkWithFailureSilent:(BOOL)bSilent;

/**
 *@brief 是否应该始终将指定的版本标记为强制更新版本
 *@param version 版本号
 *@return YES,强制更新版本 NO,非强制更新版本
 */
-(BOOL) shouldAlwaysMarkVersionAsForce:(NSString*)version;

@end
