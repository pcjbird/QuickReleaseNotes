//
//  QuickReleaseCheckAppStore.m
//  QuickReleaseNotes
//
//  Created by pcjbird on 2018/3/28.
//  Copyright © 2018年 Zero Status. All rights reserved.
//

#import "QuickReleaseCheckAppStore.h"
#import "QuickReleaseNotesDefine.h"
#import <SystemConfiguration/SystemConfiguration.h>

@implementation QuickReleaseCheckAppStore


-(void)checkAppNewRelease:(QuickReleaseNotesBlock)complete
{
    BOOL hasConnection = [self hasConnection];
    if (!hasConnection)
    {
        if(complete)complete(NO, nil, nil, nil, NO, QUICKRELEASENOTES_ERROR(10000, @"无法连接到 AppStore。"));
        return;
    }
    
    NSString* urlStr = [NSString stringWithFormat:@"https://itunes.apple.com/%@/lookup?bundleId=%@", [[[NSLocale currentLocale] objectForKey:NSLocaleCountryCode] lowercaseString], QRN_APP_BUNDLEID];
    NSURLRequest* request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:urlStr]];
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if(error)
        {
            if(complete)complete(NO, nil, nil, nil, NO, QUICKRELEASENOTES_ERROR(10000, error.localizedDescription));
            return;
        }
        if (![data isKindOfClass:[NSData class]])
        {
            if(complete)complete(NO, nil, nil, nil, NO, QUICKRELEASENOTES_ERROR(10000, @"无法解析 AppStore 返回的数据。"));
            return;
        }
        NSDictionary* jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        if (![NSJSONSerialization isValidJSONObject:jsonObject] || [error isKindOfClass:[NSError class]])
        {
            if(complete)complete(NO, nil, nil, nil, NO, QUICKRELEASENOTES_ERROR(10000, @"无法解析 AppStore 返回的数据。"));
            return;
        }
        NSArray* results = [jsonObject objectForKey:@"results"];
        if([results count] < 1)
        {
            if(complete)complete(NO, nil, nil, nil, NO, QUICKRELEASENOTES_ERROR(10000, @"未能获取到 AppStore 上该应用的信息。"));
            return;
        }
        NSDictionary* result0 = [results objectAtIndex:0];
        NSString* storeVersion = [result0 objectForKey:@"version"];
        NSString*whatsNew = [result0 objectForKey:@"releaseNotes"];
        NSString *appUrl = [result0[@"trackViewUrl"] stringByReplacingOccurrencesOfString:@"&uo=4" withString:@""];
        NSString *bundleVersion = QRN_APP_VERSION;
        if (storeVersion && [bundleVersion compare:storeVersion options:NSNumericSearch] == NSOrderedAscending)
        {
            if(complete)complete(YES, storeVersion, whatsNew, appUrl, NO, nil);
        }
        else
        {
            if(complete)complete(NO, storeVersion, whatsNew, appUrl, NO, nil);
        }
    }];
    
    [task resume];
}

#pragma mark - 私有方法
- (BOOL)hasConnection
{
    const char *host = "itunes.apple.com";
    BOOL reachable;
    BOOL success;
    
    SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithName(NULL, host);
    SCNetworkReachabilityFlags flags;
    success = SCNetworkReachabilityGetFlags(reachability, &flags);
    reachable = success && (flags & kSCNetworkFlagsReachable) && !(flags & kSCNetworkFlagsConnectionRequired);
    CFRelease(reachability);
    return reachable;
}

@end
