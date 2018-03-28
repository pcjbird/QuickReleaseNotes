//
//  QuickReleaseNotesDefine.h
//  QuickReleaseNotes
//
//  Created by pcjbird on 2018/3/28.
//  Copyright © 2018年 Zero Status. All rights reserved.
//

#ifndef QuickReleaseNotesDefine_h
#define QuickReleaseNotesDefine_h

#define QUICKRELEASENOTES_ERROR(ecode, msg)  [NSError errorWithDomain:@"QuickReleaseNotes" code:(ecode) userInfo:([NSDictionary dictionaryWithObjectsAndKeys:(msg), @"message", nil])]

#define QRN_APP_NAME ([[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"CFBundleDisplayName"] ? [[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"CFBundleDisplayName"]:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"])
#define QRN_APP_VERSION ([[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"])
#define QRN_APP_BUILD ([[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"])
#define QRN_APP_BUNDLEID ([[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"])

#endif /* QuickReleaseNotesDefine_h */
