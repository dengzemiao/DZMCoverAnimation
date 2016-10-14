//
//  ViewControllerBook.m
//  DZMCoverDemo
//
//  Created by 邓泽淼 on 16/10/8.
//  Copyright © 2016年 DZM. All rights reserved.
//

#define ViewColor [UIColor colorWithRed:arc4random()%255/255.0 green:arc4random()%255/255.0 blue:arc4random()%255/255.0 alpha:1.0]

#import "ViewControllerBook.h"
#import "DZMCoverController.h"
#import "TempViewController.h"

@interface ViewControllerBook ()<DZMCoverControllerDelegate>

/**
 *  DZMCoverController
 */
@property (nonatomic,weak) DZMCoverController *coverVC;

/**
 *  记录数字
 */
@property (nonatomic,assign) int number;

@end

@implementation ViewControllerBook

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 创建 内存已测试无内存泄漏
    DZMCoverController *coverVC = [[DZMCoverController alloc] init];
    coverVC.delegate = self;
    [self.view addSubview:coverVC.view];
    [self addChildViewController:coverVC];
    
    // 可以设置无动画
//    coverVC.openAnimate = NO;
    
    self.coverVC = coverVC;
    
    // 初始化显示控制器
    TempViewController *vc = [[TempViewController alloc] init];
    vc.view.backgroundColor = [UIColor greenColor];
    vc.textLabel.text = [NSString stringWithFormat:@"%d",self.number];
    
    // 显示
    [coverVC setController:vc];
}

#pragma mark - DZMCoverControllerDelegate

// 切换结果
- (void)coverController:(DZMCoverController *)coverController currentController:(UIViewController *)currentController finish:(BOOL)isFinish
{
    if (!isFinish) { // 切换失败
        
        TempViewController *vc = (TempViewController *)currentController;
        
        self.number = vc.textLabel.text.intValue;
    }
}

// 上一个控制器
- (UIViewController *)coverController:(DZMCoverController *)coverController getAboveControllerWithCurrentController:(UIViewController *)currentController
{
    self.number -= 1;
    
    TempViewController *vc = [[TempViewController alloc] init];
    
    vc.view.backgroundColor = ViewColor;
    
    vc.textLabel.text = [NSString stringWithFormat:@"%d",self.number];
    
    return vc;
}

// 下一个控制器
- (UIViewController *)coverController:(DZMCoverController *)coverController getBelowControllerWithCurrentController:(UIViewController *)currentController
{
    self.number += 1;
    
    TempViewController *vc = [[TempViewController alloc] init];
    
    vc.view.backgroundColor = ViewColor;
    
    vc.textLabel.text = [NSString stringWithFormat:@"%d",self.number];
    
    return vc;
}

- (void)dealloc
{
    NSLog(@"ViewControllerBook 释放了");
}

@end
