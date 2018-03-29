//
//  ViewController.m
//  QuickReleaseNotesDemo
//
//  Created by pcjbird on 2018/3/29.
//  Copyright © 2018年 Zero Status. All rights reserved.
//

#import "ViewController.h"
#import <QuickReleaseNotes/QuickReleaseNotes.h>

@interface ViewController ()

- (IBAction)OnCheckAppNewReleaseBtnClick:(id)sender;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)OnCheckAppNewReleaseBtnClick:(id)sender {
    [QuickAppStoreReleaseNotesAlert checkWithFailureSilent:NO];
}
@end
