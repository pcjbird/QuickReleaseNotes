//
//  QuickAppStoreReleaseNotesAlert.m
//  QuickReleaseNotes
//
//  Created by pcjbird on 2018/3/28.
//  Copyright © 2018年 Zero Status. All rights reserved.
//

#import "QuickAppStoreReleaseNotesAlert.h"
#import "QuickReleaseCheckAppStore.h"
#import "QRNAlertViewController.h"

#define SDK_BUNDLE [NSBundle bundleWithPath:[[NSBundle bundleForClass:[QuickAppStoreReleaseNotesAlert class]] pathForResource:@"QuickReleaseNotes" ofType:@"bundle"]]
#define QRNLocalizedString(key) NSLocalizedStringFromTableInBundle(key, @"Localizable", SDK_BUNDLE, nil)
#define KeyWindow                           [[UIApplication sharedApplication] keyWindow]
#define kIgnoredVersionKey @"kIgnoredVersionKey"

@implementation QuickAppStoreReleaseNotesAlert
{
    BOOL _isBecomeActiveWhenLaunch;
}

static QuickAppStoreReleaseNotesAlert *_sharedInstance = nil;

+ (QuickAppStoreReleaseNotesAlert *) sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_block_t block = ^{
        if(!_sharedInstance)
        {
            _sharedInstance = [[self class] new];
        }
    };
    if ([NSThread isMainThread])
    {
        dispatch_once(&onceToken, block);
    }
    else
    {
        dispatch_sync(dispatch_get_main_queue(), ^{
            dispatch_once(&onceToken, block);
        });
    }
    return _sharedInstance;
}

-(instancetype)init
{
    if(self = [super init])
    {
        _isBecomeActiveWhenLaunch = YES;
        [self registerNotificationObserver];
    }
    return self;
}

-(void) registerNotificationObserver
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(OnAppDidBecomeActiveNotification:) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(OnAppDidEnterBackgroundNotification:) name:UIApplicationDidEnterBackgroundNotification object:nil];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)OnAppDidBecomeActiveNotification:(NSNotification*)notification
{
    if(!_isBecomeActiveWhenLaunch)
    {
        [self checkWithFailureSilent:YES];
    }
}

-(void)OnAppDidEnterBackgroundNotification:(NSNotification*)notification
{
    _isBecomeActiveWhenLaunch = NO;
}

+(void) checkWithFailureSilent:(BOOL)bSilent
{
    [[[self class] sharedInstance] checkWithFailureSilent:bSilent];
}

-(NSString *)ignoredVersion
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:kIgnoredVersionKey];
}

-(void)setIgnoredVersion:(NSString *)ignoredVersionValue
{
    [[NSUserDefaults standardUserDefaults] setObject:ignoredVersionValue forKey:kIgnoredVersionKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void) checkWithFailureSilent:(BOOL)bSilent
{
    QuickReleaseCheckAppStore * check = [QuickReleaseCheckAppStore new];
    __weak typeof(self) weakSelf = self;
    [check checkAppNewRelease:^(BOOL hasNewVersion, NSString *version, NSString *releaseNotes, NSString* appUrl, BOOL force, NSError *error) {
       
       if([error isKindOfClass:[NSError class]])
       {
           if(!bSilent)
           {
               dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                   QRNAlertViewController * alertVC = [QRNAlertViewController alertControllerWithTitle:QRNLocalizedString(@"tips") message:error.localizedDescription];
                   alertVC.messageAlignment = NSTextAlignmentJustified;
                   
                   QRNAlertAction *cancel = [QRNAlertAction actionWithTitle:QRNLocalizedString(@"I Know") handler:^(QRNAlertAction *action) {
                   }];
                   
                   [alertVC addAction:cancel];
                   [KeyWindow.rootViewController presentViewController:alertVC animated:NO completion:nil];
               });
           }
           return;
       }
       if(!hasNewVersion)
       {
           if(!bSilent)
           {
               dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                   QRNAlertViewController * alertVC = [QRNAlertViewController alertControllerWithTitle:QRNLocalizedString(@"tips") message:NSLocalizedString(@"Current is the latest version.", nil)];
                   alertVC.messageAlignment = NSTextAlignmentJustified;
                   
                   QRNAlertAction *cancel = [QRNAlertAction actionWithTitle:QRNLocalizedString(@"I Know") handler:^(QRNAlertAction *action) {
                   }];
                   
                   [alertVC addAction:cancel];
                   [KeyWindow.rootViewController presentViewController:alertVC animated:NO completion:nil];
               });
           }
           return;
       }
        NSString* ignoreVersion = [weakSelf ignoredVersion];
       if ([ignoreVersion isKindOfClass:[NSString class]] && [ignoreVersion isEqualToString:version])
       {
           if(!bSilent)
           {
               dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                   QRNAlertViewController * alertVC = [QRNAlertViewController alertControllerWithTitle:QRNLocalizedString(@"tips") message:NSLocalizedString(@"Current is the ignored version.", nil)];
                   alertVC.messageAlignment = NSTextAlignmentJustified;
                   
                   QRNAlertAction *cancel = [QRNAlertAction actionWithTitle:QRNLocalizedString(@"I Know") handler:^(QRNAlertAction *action) {
                   }];
                   
                   [alertVC addAction:cancel];
                   [KeyWindow.rootViewController presentViewController:alertVC animated:NO completion:nil];
               });
           }
           return;
       }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            QRNAlertViewController * alertVC = [QRNAlertViewController alertControllerWithTitle:[NSString stringWithFormat:QRNLocalizedString(@"NewReleaseFormat"), version] message:releaseNotes];
            alertVC.messageAlignment = NSTextAlignmentJustified;
            
            if(![weakSelf shouldAlwaysMarkVersionAsForce:version] && !force)
            {
                QRNAlertAction *cancel = [QRNAlertAction actionWithTitle:QRNLocalizedString(@"Ignore") handler:^(QRNAlertAction *action) {
                    [weakSelf setIgnoredVersion:version];
                }];
                [alertVC addAction:cancel];
            }
            QRNAlertAction *update = [QRNAlertAction actionWithTitle:QRNLocalizedString(@"Update Now") handler:^(QRNAlertAction *action) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:appUrl]];
            }];
            [alertVC addAction:update];
            [KeyWindow.rootViewController presentViewController:alertVC animated:NO completion:nil];
        });
    }];
}

-(BOOL) shouldAlwaysMarkVersionAsForce:(NSString*)version
{
    return NO;
}
@end
