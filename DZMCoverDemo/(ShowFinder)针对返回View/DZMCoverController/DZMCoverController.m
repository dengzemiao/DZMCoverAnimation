//
//  DZMCoverController.m
//  DZMCoverDemo
//
//  Created by 邓泽淼 on 16/10/8.
//  Copyright © 2016年 DZM. All rights reserved.
//

// 屏幕宽
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
// 屏幕高
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
// View宽
#define ViewWidth self.view.frame.size.width
// View高
#define ViewHeight self.view.frame.size.height
// View中间X
#define CenterX (self.view.frame.size.width / 2)
// 动画时间
#define AnimateDuration 0.25

#import "DZMCoverController.h"

@interface DZMCoverController ()

/**
 *  左拉右拉手势
 */
@property (nonatomic,strong) UIPanGestureRecognizer *pan;

/**
 *  点击手势
 */
@property (nonatomic,strong) UITapGestureRecognizer *tap;

/**
 *  手势触发点在左边 辨认方向 左边拿上一个View  右边拿下一个View
 */
@property (nonatomic,assign) BOOL isLeft;

/**
 *  正在动画 default:NO
 */
@property (nonatomic,assign) BOOL isAnimateChange;

/**
 *  判断执行pan手势
 */
@property (nonatomic,assign) BOOL isPan;

/**
 *  临时View 通过代理获取回来的View 还没有完全展示出来的View
 */
@property (nonatomic,strong,nullable) UIView *tempView;

@end

@implementation DZMCoverController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 完成初始化
    [self didInit];
}

/**
 *  初始化
 */
- (void)didInit
{
    // 动画效果开启
    self.openAnimate = YES;
    
    // 设置背景颜色
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 添加手势
    self.pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(touchPan:)];
    self.tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchTap:)];
    [self.view addGestureRecognizer:self.pan];
    [self.view addGestureRecognizer:self.tap];
    
    // 启用手势
    self.gestureRecognizerEnabled = YES;
    
    // 开启裁剪
    self.view.layer.masksToBounds = YES;
}

/**
 *  手势开关
 */
- (void)setGestureRecognizerEnabled:(BOOL)gestureRecognizerEnabled
{
    _gestureRecognizerEnabled = gestureRecognizerEnabled;
    
    self.pan.enabled = gestureRecognizerEnabled;
    
    self.tap.enabled = gestureRecognizerEnabled;
}


#pragma mark - 手势处理

- (void)touchPan:(UIPanGestureRecognizer *)pan
{
    // 用于辨别方向
    CGPoint tempPoint = [pan translationInView:self.view];
    
    // 用于计算位置
    CGPoint touchPoint = [pan locationInView:self.view];
    
    if (pan.state == UIGestureRecognizerStateBegan) { // 手势开始
        
        // 正在动画
        if (self.isAnimateChange) { return; }
        
        self.isAnimateChange = YES;
        
        self.isPan = YES;
        
        // 获取将要显示的View
        self.tempView = [self GetPanViewWithTouchPoint:tempPoint];
        
        // 添加
        [self addView:self.tempView];
        
    }else if (pan.state == UIGestureRecognizerStateChanged) { // 手势移动
        
        if (self.openAnimate && self.isPan) {
            
            if (self.tempView) {
                
                if (self.isLeft) {
                    
                    self.tempView.frame = CGRectMake(touchPoint.x - ViewWidth, 0, ViewWidth, ViewHeight);
                    
                }else{
                    
                    self.currentView.frame = CGRectMake(tempPoint.x > 0 ? 0 : tempPoint.x, 0, ViewWidth, ViewHeight);
                }
            }
        }
        
    }else{ // 手势结束
        
        if (self.isPan) {
            
            // 结束Pan手势
            self.isPan = NO;
            
            if (self.openAnimate) { // 动画
                
                if (self.tempView) {
                    
                    BOOL isSuccess = YES;
                    
                    if (self.isLeft) {
                        
                        if (self.tempView.frame.origin.x <= -(ViewWidth - ViewWidth*0.18)) {
                            
                            isSuccess = NO;
                        }
                        
                    }else{
                        
                        if (self.currentView.frame.origin.x >= -1) {
                            
                            isSuccess = NO;
                        }
                    }
                    
                    // 手势结束
                    [self GestureSuccess:isSuccess animated:self.openAnimate];
                }
                
            }else{
                
                // 手势结束
                [self GestureSuccess:YES animated:self.openAnimate];
                
            }
        }
    }
    
}

- (void)touchTap:(UITapGestureRecognizer *)tap
{
    // 正在动画
    if (self.isAnimateChange) { return; }
    
    self.isAnimateChange = YES;
    
    CGPoint touchPoint = [tap locationInView:self.view];
    
    // 获取将要显示的View
    self.tempView = [self GetTapViewWithTouchPoint:touchPoint];
    
    // 添加
    [self addView:self.tempView];
    
    // 手势结束
    [self GestureSuccess:YES animated:self.openAnimate];
}

/**
 *  手势结束
 */
- (void)GestureSuccess:(BOOL)isSuccess animated:(BOOL)animated
{
    if (self.tempView) {
        
        if (self.isLeft) { // 左边
            
            if (animated) {
                
                __weak DZMCoverController *weakSelf = self;
                
                [UIView animateWithDuration:AnimateDuration animations:^{
                    
                    if (isSuccess) {
                        
                        weakSelf.tempView.frame = CGRectMake(0, 0, ViewWidth, ViewHeight);
                        
                    }else{
                        
                        weakSelf.tempView.frame = CGRectMake(-ViewWidth, 0, ViewWidth, ViewHeight);
                    }
                    
                } completion:^(BOOL finished) {
                    
                    [weakSelf animateSuccess:isSuccess];
                }];
                
            }else{
                
                if (isSuccess) {
                    
                    self.tempView.frame = CGRectMake(0, 0, ViewWidth, ViewHeight);
                    
                }else{
                    
                    self.tempView.frame = CGRectMake(-ViewWidth, 0, ViewWidth, ViewHeight);
                }
                
                [self animateSuccess:isSuccess];
            }
            
        }else{ // 右边
            
            if (animated) {
                
                __weak DZMCoverController *weakSelf = self;
                
                [UIView animateWithDuration:AnimateDuration animations:^{
                    
                    if (isSuccess) {
                        
                        weakSelf.currentView.frame = CGRectMake(-ViewWidth, 0, ViewWidth, ViewHeight);
                        
                    }else{
                        
                        weakSelf.currentView.frame = CGRectMake(0, 0, ViewWidth, ViewHeight);
                    }
                    
                } completion:^(BOOL finished) {
                    
                    [weakSelf animateSuccess:isSuccess];
                }];
                
            }else{
                
                if (isSuccess) {
                    
                    self.currentView.frame = CGRectMake(-ViewWidth, 0, ViewWidth, ViewHeight);
                    
                }else{
                    
                    self.currentView.frame = CGRectMake(0, 0, ViewWidth, ViewHeight);
                }
                
                [self animateSuccess:isSuccess];
            }
        }
    }
}

/**
 *  动画结束
 */
- (void)animateSuccess:(BOOL)isSuccess
{
    if (isSuccess) {
        
        [self.currentView removeFromSuperview];
        
        _currentView = self.tempView;
        
        self.tempView = nil;
        
        self.isAnimateChange = NO;
        
    }else{
        
        [self.tempView removeFromSuperview];
        
        self.tempView = nil;
        
        self.isAnimateChange = NO;
    }
    
    // 代理回调
    if ([self.delegate respondsToSelector:@selector(coverController:currentView:finish:)]) {
        
        [self.delegate coverController:self currentView:self.currentView finish:isSuccess];
    }
}

/**
 *  根据手势触发的位置获取View
 *
 *  @param touchPoint 手势触发位置
 *
 *  @return 需要显示的View
 */
- (UIView * _Nullable)GetTapViewWithTouchPoint:(CGPoint)touchPoint
{
    UIView *view = nil;
    
    if (touchPoint.x < CenterX) { // 左边
        
        self.isLeft = YES;
        
        // 获取上一个显示View
        if ([self.delegate respondsToSelector:@selector(coverController:getAboveControllerWithCurrentView:)]) {
            
            view = [self.delegate coverController:self getAboveControllerWithCurrentView:self.currentView];
        }
        
    }else{ // 右边
        
        self.isLeft = NO;
        
        // 获取下一个显示View
        if ([self.delegate respondsToSelector:@selector(coverController:getBelowControllerWithCurrentView:)]) {
            
            view = [self.delegate coverController:self getBelowControllerWithCurrentView:self.currentView];
        }
    }
    
    if (!vc) {
        
        self.isAnimateChange = NO;
    }
    
    return view;
}

/**
 *  根据手势触发的位置获取View
 *
 *  @param touchPoint 手势触发位置
 *
 *  @return 需要显示的View
 */
- (UIView * _Nullable)GetPanViewWithTouchPoint:(CGPoint)touchPoint
{
    UIView *view = nil;
    
    if (touchPoint.x > 0) { // 左边
        
        self.isLeft = YES;
        
        // 获取上一个显示View
        if ([self.delegate respondsToSelector:@selector(coverController:getAboveControllerWithCurrentView:)]) {
            
            view = [self.delegate coverController:self getAboveControllerWithCurrentView:self.currentView];
        }
        
    }else{ // 右边
        
        self.isLeft = NO;
        
        // 获取下一个显示View
        if ([self.delegate respondsToSelector:@selector(coverController:getBelowControllerWithCurrentView:)]) {
            
            view = [self.delegate coverController:self getBelowControllerWithCurrentView:self.currentView];
        }
    }
    
    if (!vc) {
        
        self.isAnimateChange = NO;
    }
    
    return view;
}

#pragma mark - 设置显示View

/**
 *  手动设置显示View 无动画
 *
 *  @param currentView 设置显示的View
 */
- (void)setCurrentView:(UIView * _Nonnull)currentView
{
    [self setCurrentView:currentView animated:NO isAbove:YES];
}

/**
 *  手动设置显示View
 *
 *  @param currentView 设置显示的View
 *  @param animated    是否需要动画
 *  @param isAbove     动画是否从上面显示 YES   从下面显示 NO
 */
- (void)setCurrentView:(UIView * _Nonnull)currentView animated:(BOOL)animated isAbove:(BOOL)isAbove;
{
    if (animated && self.currentView) { // 需要动画 同时有根View了
        
        // 正在动画
        if (self.isAnimateChange) { return; }
        
        self.isAnimateChange = YES;
        
        self.isLeft = isAbove;
        
        // 记录
        self.tempView = currentView;
        
        // 添加
        [self addView:currentView];
        
        // 手势结束
        [self GestureSuccess:YES animated:YES];
        
    }else{
        
        // 添加
        [self addView:currentView];
        
        // 修改frame
        currentView.frame = self.view.bounds;
        
        // 当前View有值 进行删除
        if (_currentView) {
            
            [_currentView removeFromSuperview];
            
            _currentView = nil;
        }
        
        // 赋值记录
        _currentView = currentView;
    }
}

/**
 *  添加View
 *
 *  @param view 显示View
 */
- (void)addView:(UIView * _Nullable)view
{
    if (view) {
        
        if (self.isLeft) { // 左边
            
            [self.view addSubview:view];
            
            view.frame = CGRectMake(-ViewWidth, 0, ViewWidth, ViewHeight);
            
        }else{ // 右边
            
            if (self.currentView) { // 有值
                
                [self.view insertSubview:view belowSubview:self.currentView];
                
            }else{ // 没值
                
                [self.view addSubview:view];
            }
            
            view.frame = CGRectMake(0, 0, ViewWidth, ViewHeight);
        }
        
        // 添加阴影
        [self setShadowView:view];
    }
}

/**
 *  给View添加阴影
 */
- (void)setShadowView:(UIView * _Nullable)view
{
    if (view) {
        
        view.layer.shadowColor = [UIColor blackColor].CGColor; // 阴影颜色
        view.layer.shadowOffset = CGSizeMake(0, 0); // 偏移距离
        view.layer.shadowOpacity = 0.5; // 不透明度
        view.layer.shadowRadius = 10.0; // 半径
    }
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    
    // 移除手势
    [self.view removeGestureRecognizer:self.pan];
    [self.view removeGestureRecognizer:self.tap];
    
    // 移除当前View
    if (self.currentView) {
        [self.currentView removeFromSuperview];
        _currentView = nil;
    }
    
    // 移除临时View
    if (self.tempView) {
        [self.tempView removeFromSuperview];
        self.tempView = nil;
    }
}

@end
