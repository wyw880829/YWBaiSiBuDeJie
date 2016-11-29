//
//  YTabBar.m
//  Y百思不得姐
//
//  Created by wyw on 16/5/10.
//  Copyright © 2016年 qw. All rights reserved.
//

#import "YTabBar.h"
#import "YPublishView.h"
#import "YNavigationController.h"
#import "YPostWordViewController.h"

@interface YTabBar()

/** 发布按钮 */
@property (strong, nonatomic) UIButton *publishButton;

@end

@implementation YTabBar

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self setBackgroundImage:[UIImage imageNamed:@"tabbar-light"]];
        
        // 创建+按钮
        self.publishButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.publishButton setBackgroundImage:[UIImage imageNamed:@"tabBar_publish_icon"] forState:UIControlStateNormal];
        [self.publishButton setBackgroundImage:[UIImage imageNamed:@"tabBar_publish_click_icon"] forState:UIControlStateSelected];
        self.publishButton.size = self.publishButton.currentBackgroundImage.size;
        
        // 添加事件
        [self.publishButton addTarget:nil action:@selector(publishAction) forControlEvents:UIControlEventTouchUpInside];
    
        [self addSubview:self.publishButton];
    }
    return self;
}

/**
 *   跳转到发布界面
 */
- (void)publishAction
{
   // 创建发布view
/*    YPublishView *publishView = [YPublishView publishView];
   // 获取当前window
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    publishView.frame = window.bounds;
    [window addSubview:publishView];
*/
    YPostWordViewController *postwordVC = [[YPostWordViewController alloc] init];
    YNavigationController *nav = [[YNavigationController alloc] initWithRootViewController:postwordVC];
    UIViewController *rootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    [rootVC presentViewController:nav animated:YES completion:nil];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 标记按钮是否已经添加过监听器
    static BOOL added = NO;

    // 布局tabbar
    self.publishButton.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);

    CGFloat buttonY = 0;
    CGFloat buttonW = self.frame.size.width / 5;
    CGFloat buttonH = self.frame.size.height;
    
    NSInteger index = 0;
    
    for (UIControl *button in self.subviews) {
        
        if (![button isKindOfClass:NSClassFromString(@"UITabBarButton")]) continue;
        
        CGFloat buttonX = buttonW * ((index > 1) ? index + 1 : index);
        button.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
        
        index++;
        
        if (added == NO) {
            [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
}

- (void)buttonClick:(UIButton *)button
{
    [[NSNotificationCenter defaultCenter] postNotificationName:YTabBarDidSelectNotification object:nil];
}

@end
