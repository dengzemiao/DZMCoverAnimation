//
//  TestViewController.m
//  DZMCoverDemo
//
//  Created by 邓泽淼 on 16/10/9.
//  Copyright © 2016年 DZM. All rights reserved.
//

#define ViewColor [UIColor colorWithRed:arc4random()%255/255.0 green:arc4random()%255/255.0 blue:arc4random()%255/255.0 alpha:1.0]

#import "TestViewController.h"

@interface TestViewController ()<DZMCoverControllerDelegate>

/**
 *  记录数字
 */
@property (nonatomic,assign) int number;

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置代理
    self.delegate = self;
    
    // 可以设置动画是否开启
//    self.openAnimate = NO;
    
    // 初始化显示View
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = ViewColor;
    [self setCurrentView:view];
}

#pragma mark - DZMCoverControllerDelegate

- (void)coverController:(DZMCoverController *)coverController currentView:(UIView *)currentView finish:(BOOL)isFinish
{
    
}

- (UIView *)coverController:(DZMCoverController *)coverController getBelowControllerWithCurrentView:(UIView *)currentView
{
    UIView *view = [[UIView alloc] init];
    
    view.backgroundColor = ViewColor;
    
    return view;
}

- (UIView *)coverController:(DZMCoverController *)coverController getAboveControllerWithCurrentView:(UIView *)currentView
{
    UIView *view = [[UIView alloc] init];
    
    view.backgroundColor = ViewColor;
    
    return view;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
