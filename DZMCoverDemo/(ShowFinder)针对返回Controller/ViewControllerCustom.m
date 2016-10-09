//
//  ViewControllerCustom.m
//  DZMCoverDemo
//
//  Created by 邓泽淼 on 16/10/8.
//  Copyright © 2016年 DZM. All rights reserved.
//

#define ViewColor [UIColor colorWithRed:arc4random()%255/255.0 green:arc4random()%255/255.0 blue:arc4random()%255/255.0 alpha:1.0]

#import "ViewControllerCustom.h"
#import "DZMCoverController.h"
#import "TempViewController.h"

@interface ViewControllerCustom ()<DZMCoverControllerDelegate>

/**
 *  DZMCoverController
 */
@property (nonatomic,weak) DZMCoverController *coverVC;

/**
 *  记录数字
 */
@property (nonatomic,assign) int number;

@property (nonatomic,weak) UIButton *lastButton;
@property (nonatomic,weak) UIButton *nextButton;
@end

@implementation ViewControllerCustom

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 创建 内存已测试无内存泄漏
    DZMCoverController *coverVC = [[DZMCoverController alloc] init];
    coverVC.delegate = self;
    [self.view addSubview:coverVC.view];
    [self addChildViewController:coverVC];
    self.coverVC = coverVC;
    
    // 可自定义frame
    coverVC.view.frame = CGRectMake(100, 100, 100, 100);
    
    // 初始化显示控制器
    TempViewController *vc = [[TempViewController alloc] init];
    vc.view.backgroundColor = [UIColor greenColor];
    vc.textLabel.text = [NSString stringWithFormat:@"%d",self.number];
    
    // 显示
    [coverVC setController:vc];
    
    // 添加手动按钮
    [self creatUI];
}

// 创建按钮
- (void)creatUI
{
    UIButton *lastButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [lastButton setTitle:@"上一页" forState:UIControlStateNormal];
    [lastButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    lastButton.backgroundColor = [UIColor redColor];
    lastButton.frame = CGRectMake(30, 250, 100, 100);
    [self.view addSubview:lastButton];
    [lastButton addTarget:self action:@selector(clickLast) forControlEvents:UIControlEventTouchUpInside];
    self.lastButton = lastButton;
    
    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextButton setTitle:@"下一页" forState:UIControlStateNormal];
    [nextButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    nextButton.backgroundColor = [UIColor redColor];
    nextButton.frame = CGRectMake(150, 250, 100, 100);
    [self.view addSubview:nextButton];
    [nextButton addTarget:self action:@selector(clickNext) forControlEvents:UIControlEventTouchUpInside];
    self.nextButton = nextButton;
}

// 点击上一页
- (void)clickLast
{
    self.number -= 1;
    
    TempViewController *vc = [[TempViewController alloc] init];
    
    vc.view.backgroundColor = ViewColor;
    
    vc.textLabel.text = [NSString stringWithFormat:@"%d",self.number];
    
    [self.coverVC setController:vc animated:YES isAbove:YES];
}

// 点击下一页
- (void)clickNext
{
    self.number += 1;
    
    TempViewController *vc = [[TempViewController alloc] init];
    
    vc.view.backgroundColor = ViewColor;
    
    vc.textLabel.text = [NSString stringWithFormat:@"%d",self.number];
    
    [self.coverVC setController:vc animated:YES isAbove:NO];
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
    NSLog(@"ViewControllerCustom 释放了");
}

@end
