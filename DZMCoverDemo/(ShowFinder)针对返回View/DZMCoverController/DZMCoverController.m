//
//  DZMCoverController.m
//  DZMCoverDemo
//
//  Created by 邓泽淼 on 16/10/8.
//  Copyright © 2016年 DZM. All rights reserved.
//

// View宽
#define ViewWidth self.view.frame.size.width

// View高
#define ViewHeight self.view.frame.size.height

// 动画时间
#define AnimateDuration 0.20

#import "DZMCoverController.h"

@interface DZMCoverController ()<UIGestureRecognizerDelegate>

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
 *  判断执行pan手势
 */
@property (nonatomic,assign) BOOL isPan;

/**
 *  手势是否重新开始识别
 */
@property (nonatomic,assign) BOOL isPanBegin;

/**
 *  动画状态
 */
@property (nonatomic,assign) BOOL isAnimateChange;

/**
 *  临时View 通过代理获取回来的View 还没有完全展示出来的View
 */
@property (nonatomic,strong,nullable) UIView *pendingView;

/**
 *  移动中的触摸位置
 */
@property (nonatomic,assign) CGPoint moveTouchPoint;

/**
 *  移动中的差值
 */
@property (nonatomic,assign) CGFloat moveSpaceX;

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
    self.tap.delegate = self;
    
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
    
    // 比较获取差值
    if (!CGPointEqualToPoint(self.moveTouchPoint, CGPointZero) && (pan.state == UIGestureRecognizerStateBegan || pan.state == UIGestureRecognizerStateChanged)) {
        
        self.moveSpaceX = touchPoint.x - self.moveTouchPoint.x;
    }
    
    // 记录位置
    self.moveTouchPoint = touchPoint;
    
    if (pan.state == UIGestureRecognizerStateBegan) { // 手势开始
        
        // 正在动画
        if (self.isAnimateChange) { return; }
        
        self.isAnimateChange = YES;
        
        self.isPanBegin = YES;
        
        self.isPan = YES;
        
    }else if (pan.state == UIGestureRecognizerStateChanged) { // 手势移动
        
        if (fabs(tempPoint.x) > 0.01) { // 滚动有值了
            
            // 获取将要显示的控制器
            if (self.isPanBegin) {
                
                self.isPanBegin = NO;
                
                // 获取将要显示的View
                self.pendingView = [self GetPanViewWithTouchPoint:tempPoint];
                
                // 将要显示的View
                if ([self.delegate respondsToSelector:@selector(coverController:willTransitionToPendingView:)]) {
                    
                    [self.delegate coverController:self willTransitionToPendingView:self.pendingView];
                }
                
                // 添加
                [self addView:self.pendingView];
            }
            
            // 判断显示
            if (self.openAnimate && self.isPan) {
                
                if (self.pendingView) {
                    
                    if (self.isLeft) {
                        
                        self.pendingView.frame = CGRectMake(touchPoint.x - ViewWidth, 0, ViewWidth, ViewHeight);
                        
                    }else{
                        
                        self.currentView.frame = CGRectMake(tempPoint.x > 0 ? 0 : tempPoint.x, 0, ViewWidth, ViewHeight);
                    }
                }
            }
        }
    }else{ // 手势结束
        
        if (self.isPan) {
            
            // 结束Pan手势
            self.isPan = NO;
            
            if (self.openAnimate) { // 动画
                
                if (self.pendingView) {
                    
                    BOOL isSuccess = YES;
                    
                    if (self.isLeft) {
                        
                        if (self.pendingView.frame.origin.x <= -(ViewWidth - ViewWidth*0.18)) {
                            
                            isSuccess = NO;
                            
                        }else{
                            
                            if (self.moveSpaceX < 0) {
                                
                                isSuccess = NO;
                            }
                        }
                        
                    }else{
                        
                        if (self.currentView.frame.origin.x >= -1) {
                            
                            isSuccess = NO;
                        }
                    }
                    
                    // 手势结束
                    [self GestureSuccess:isSuccess animated:self.openAnimate];
                    
                }else{
                    
                    self.isAnimateChange = NO;
                }
                
            }else{
                
                // 手势结束
                [self GestureSuccess:YES animated:self.openAnimate];
            }
        }
        
        // 清空记录
        self.moveTouchPoint = CGPointZero;
        self.moveSpaceX = 0;
    }
}

- (void)touchTap:(UITapGestureRecognizer *)tap
{
    // 正在动画
    if (self.isAnimateChange) { return; }
    
    self.isAnimateChange = YES;
    
    CGPoint touchPoint = [tap locationInView:self.view];
    
    // 获取将要显示的View
    self.pendingView = [self GetTapViewWithTouchPoint:touchPoint];
    
    // 将要显示的View
    if ([self.delegate respondsToSelector:@selector(coverController:willTransitionToPendingView:)]) {
        
        [self.delegate coverController:self willTransitionToPendingView:self.pendingView];
    }
    
    // 添加
    [self addView:self.pendingView];
    
    // 手势结束
    [self GestureSuccess:YES animated:self.openAnimate];
}

/**
 *  手势结束
 */
- (void)GestureSuccess:(BOOL)isSuccess animated:(BOOL)animated
{
    if (self.pendingView) {
        
        if (self.isLeft) { // 左边
            
            if (animated) {
                
                __weak DZMCoverController *weakSelf = self;
                
                [UIView animateWithDuration:AnimateDuration animations:^{
                    
                    if (isSuccess) {
                        
                        weakSelf.pendingView.frame = CGRectMake(0, 0, ViewWidth, ViewHeight);
                        
                    }else{
                        
                        weakSelf.pendingView.frame = CGRectMake(-ViewWidth, 0, ViewWidth, ViewHeight);
                    }
                    
                } completion:^(BOOL finished) {
                    
                    [weakSelf animateSuccess:isSuccess];
                }];
                
            }else{
                
                if (isSuccess) {
                    
                    self.pendingView.frame = CGRectMake(0, 0, ViewWidth, ViewHeight);
                    
                }else{
                    
                    self.pendingView.frame = CGRectMake(-ViewWidth, 0, ViewWidth, ViewHeight);
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
        
        _currentView = self.pendingView;
        
        self.pendingView = nil;
        
        self.isAnimateChange = NO;
        
    }else{
        
        [self.pendingView removeFromSuperview];
        
        self.pendingView = nil;
        
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
    
    if (touchPoint.x < ViewWidth / 3) { // 左边
        
        self.isLeft = YES;
        
        // 获取上一个显示View
        if ([self.delegate respondsToSelector:@selector(coverController:getAboveControllerWithCurrentView:)]) {
            
            view = [self.delegate coverController:self getAboveControllerWithCurrentView:self.currentView];
        }
        
    }else if (touchPoint.x > (ViewWidth - ViewWidth / 3)){ // 右边
        
        self.isLeft = NO;
        
        // 获取下一个显示View
        if ([self.delegate respondsToSelector:@selector(coverController:getBelowControllerWithCurrentView:)]) {
            
            view = [self.delegate coverController:self getBelowControllerWithCurrentView:self.currentView];
        }
    }
    
    if (!view) {
        
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
    
    if (!view) {
        
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
- (void)setCurrentView:(UIView * _Nullable)currentView
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
- (void)setCurrentView:(UIView * _Nullable)currentView animated:(BOOL)animated isAbove:(BOOL)isAbove;
{
    if (currentView) { // 有值
        
        if (animated && self.currentView) { // 需要动画 同时有根View了
            
            // 正在动画
            if (self.isAnimateChange) { return; }
            
            self.isAnimateChange = YES;
            
            self.isLeft = isAbove;
            
            // 记录
            self.pendingView = currentView;
            
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

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if ([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]] && [gestureRecognizer isEqual:self.tap]) {
        
        CGFloat tempX = ViewWidth / 3;
        
        CGPoint touchPoint = [self.tap locationInView:self.view];
        
        if (touchPoint.x > tempX && touchPoint.x < (ViewWidth - tempX)) {
            
            return YES;
        }
    }
    
    return NO;
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
    if (self.pendingView) {
        [self.pendingView removeFromSuperview];
        self.pendingView = nil;
    }
}

@end
