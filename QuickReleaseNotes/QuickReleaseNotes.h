//
//  QuickReleaseNotes.h
//  QuickReleaseNotes
//
//  Created by pcjbird on 2018/3/28.
//  Copyright © 2018年 Zero Status. All rights reserved.
//
//  框架名称:QuickReleaseNotes
//  框架功能:Quick integrate release note check with your App. 一行代码让你的App快速集成应用商店版本更新检测功能。
//  修改记录:
//     pcjbird    2018-09-18  Version:1.0.3 Build:201809180001
//                            1.xcode 10 support
//
//     pcjbird    2018-08-30  Version:1.0.2 Build:201808300001
//                            1.remove build warnings
//
//     pcjbird    2018-03-29  Version:1.0.1 Build:201803290001
//                            1.修复继承QuickAppStoreReleaseNotesAlert无法指定的版本标记为强制更新版本的问题
//
//     pcjbird    2018-03-28  Version:1.0.0 Build:201803280001
//                            1.首次发布SDK版本
//

#import <UIKit/UIKit.h>

//! Project version number for QuickReleaseNotes.
FOUNDATION_EXPORT double QuickReleaseNotesVersionNumber;

//! Project version string for QuickReleaseNotes.
FOUNDATION_EXPORT const unsigned char QuickReleaseNotesVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <QuickReleaseNotes/PublicHeader.h>


#if __has_include("QuickReleaseCheckProtocol.h")
#import "QuickReleaseCheckProtocol.h"
#endif

#if __has_include("QuickReleaseCheckAppStore.h")
#import "QuickReleaseCheckAppStore.h"
#endif

#if __has_include("QuickAppStoreReleaseNotesAlert.h")
#import "QuickAppStoreReleaseNotesAlert.h"
#endif
