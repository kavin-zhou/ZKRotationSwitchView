//
//  ZKMainViewController.m
//  ZKRotationSwitchView
//
//  Created by ZK on 16/5/24.
//  Copyright © 2016年 ZK. All rights reserved.
//

#import "ZKMainViewController.h"
#import "ZKRotationViewController.h"

@interface ZKMainViewController ()

@end

@implementation ZKMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (IBAction)switchButtonClick
{
    [ZKRotationViewController showInController:self];
}

@end
