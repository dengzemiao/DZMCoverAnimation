//
//  DZMCoverController.h
//  DZMCoverDemo
//
//  Created by 邓泽淼 on 16/10/8.
//  Copyright © 2016年 DZM. All rights reserved.
//

/*
 
 可以用于小说覆盖翻页样式使用。 现在支持的是代理返回View 。
 
 Show Finder 该工程文件里面有 返回控制器的使用
 
 */

#import <UIKit/UIKit.h>

@class DZMCoverController;

@protocol DZMCoverControllerDelegate <NSObject>

@optional

/**
 *  切换是否完成
 *
 *  @param coverController   coverController
 *  @param currentView       当前正在显示的View
 *  @param isFinish          切换是否成功
 */
- (void)coverController:(DZMCoverController * _Nonnull)coverController currentView:(UIView * _Nullable)currentView finish:(BOOL)isFinish;

/**
 *  将要显示的View
 *
 *  @param coverController   coverController
 *  @param pendingView       将要显示的View
 */
- (void)coverController:(DZMCoverController * _Nonnull)coverController willTransitionToPendingView:(UIView * _Nullable)pendingView;

/**
 *  获取上一个View
 *
 *  @param coverController   coverController
 *  @param currentView       当前正在显示的View
 *
 *  @return 返回当前显示控制器的上一个View
 */
- (UIView * _Nullable)coverController:(DZMCoverController * _Nonnull)coverController getAboveControllerWithCurrentView:(UIView * _Nullable)currentView;

/**
 *  获取下一个View
 *
 *  @param coverController   coverController
 *  @param currentView       当前正在显示的View
 *
 *  @return 返回当前显示控制器的下一个View
 */
- (UIView * _Nullable)coverController:(DZMCoverController * _Nonnull)coverController getBelowControllerWithCurrentView:(UIView * _Nullable)currentView;

@end

@interface DZMCoverController : UIViewController

/**
 *  代理
 */
@property (nonatomic,weak,nullable) id<DZMCoverControllerDelegate> delegate;

/**
 *  手势启用状态 default:YES
 */
@property (nonatomic,assign) BOOL gestureRecognizerEnabled;

/**
 *  当前手势操作是否带动画效果 default: YES
 */
@property (nonatomic,assign) BOOL openAnimate;

/**
 *  当前显示的View
 */
@property (nonatomic,strong,readonly,nullable) UIView *currentView;

/**
 *  手动设置显示View 无动画
 *
 *  @param currentView 设置显示的View
 */
- (void)setCurrentView:(UIView * _Nullable)currentView;

/**
 *  手动设置显示View
 *
 *  @param currentView 设置显示的View
 *  @param animated    是否需要动画
 *  @param isAbove     动画是否从上面显示 YES   从下面显示 NO
 */
- (void)setCurrentView:(UIView * _Nullable)currentView animated:(BOOL)animated isAbove:(BOOL)isAbove;

@end
