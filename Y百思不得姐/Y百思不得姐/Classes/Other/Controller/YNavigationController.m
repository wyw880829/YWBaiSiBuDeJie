//
//  YNavigationController.m
//  Y百思不得姐
//
//  Created by wyw on 16/5/12.
//  Copyright © 2016年 qw. All rights reserved.
//

#import "YNavigationController.h"

@implementation YNavigationController

// 只会在调用一次
+ (void)initialize
{
    // 通过appearnce设置导航栏的全局属性
    UINavigationBar *bar = [UINavigationBar appearance];
    [bar setBackgroundImage:[UIImage imageNamed:@"navigationbarBackgroundWhite"] forBarMetrics:UIBarMetricsDefault];
    
    [bar setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:20]}];
    
    // 设置文字属性
    UIBarButtonItem *item = [UIBarButtonItem appearance];
    // 正常的时候
    NSMutableDictionary *attrNormal = [NSMutableDictionary dictionary];
    attrNormal[NSForegroundColorAttributeName] = [UIColor blackColor];
    attrNormal[NSFontAttributeName] = [UIFont systemFontOfSize:17];
    [item setTitleTextAttributes:attrNormal forState:UIControlStateNormal];
    // 未使能的时候
    NSMutableDictionary *attrSelected = [NSMutableDictionary dictionary];
    attrSelected[NSForegroundColorAttributeName] = [UIColor lightGrayColor];
    attrSelected[NSFontAttributeName] = [UIFont systemFontOfSize:17];
    [item setTitleTextAttributes:attrSelected forState:UIControlStateDisabled];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 如果发现滑动移除控制器功能失效，清空代理（让导航控制器重新设置代理）
    self.navigationController.interactivePopGestureRecognizer.delegate = nil;
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.childViewControllers.count > 0) { 
        // 创建一个按钮
        UIButton *Btu = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [Btu setImage:[UIImage imageNamed:@"navigationButtonReturn"] forState:UIControlStateNormal];
        [Btu setImage:[UIImage imageNamed:@"navigationButtonReturnClick"] forState:UIControlStateHighlighted];
        [Btu setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [Btu setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
        
        [Btu setTitle:@"返回" forState:UIControlStateNormal];
        
        Btu.size = CGSizeMake(80, 45);
        Btu.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        Btu.contentEdgeInsets = UIEdgeInsetsMake(0, -12, 0, 0);
         
        [Btu addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:Btu];
        
        viewController.hidesBottomBarWhenPushed = YES;
    }
    
    
    
    [super pushViewController:viewController animated:NO];
}

- (void)back
{
    [self popViewControllerAnimated:NO];
}

@end
