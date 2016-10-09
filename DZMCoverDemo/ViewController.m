//
//  ViewController.m
//  DZMCoverDemo
//
//  Created by 邓泽淼 on 16/10/8.
//  Copyright © 2016年 DZM. All rights reserved.
//

#import "ViewController.h"

#pragma mark - 针对控制器使用的

#import "ViewControllerBook.h"
#import "ViewControllerCustom.h"

#pragma mark - 针对View使用的

//#import "TestViewController.h"

@interface ViewController ()


@end

@implementation ViewController


/* 
 
    
    注意 : 以下 针对控制器跟View 切换文件之后 运行如果有奔溃  先 Clear 一下 可能是缓存导致 最好先在上面 Product->Clean 清理下
 
 
 */

#pragma mark - 针对控制器使用的

- (IBAction)clickBook:(id)sender {
    
    ViewControllerBook *bookVC = [[ViewControllerBook alloc] init];
    
    [self presentViewController:bookVC animated:YES completion:nil];
    
//    // 测试内存释放
//    [self presentViewController:bookVC animated:YES completion:^{
//        
//        [bookVC dismissViewControllerAnimated:YES completion:nil];
//    }];
}


- (IBAction)clickCustom:(id)sender {
    
    ViewControllerCustom *customVC = [[ViewControllerCustom alloc] init];
    
    [self presentViewController:customVC animated:YES completion:nil];

//    // 测试内存释放
//    [self presentViewController:customVC animated:YES completion:^{
//        
//        [customVC dismissViewControllerAnimated:YES completion:nil];
//    }];
}

#pragma mark - 针对View使用的  需要用返回View 的 右键 Show Finder 里面有针对View 的 拖进来即可 由于文件名一样 需要(Remove References)针对控制器

//- (IBAction)clickView:(id)sender {
//    
//    TestViewController *testVC = [[TestViewController alloc] init];
//    
//    [self presentViewController:testVC animated:YES completion:nil];
//}


- (void)viewDidLoad {
    
    [super viewDidLoad];
}
@end
