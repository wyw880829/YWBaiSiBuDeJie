//
//  YTopWindow.m
//  Y百思不得姐
//
//  Created by wyw on 16/7/1.
//  Copyright © 2016年 qw. All rights reserved.
//

#import "YTopWindow.h"

@implementation YTopWindow
/** 全局变量window */
static UIWindow *window_;


+ (void)show
{
    
    window_.hidden = NO;
}

+ (void)initialize
{
    window_ = [[UIWindow alloc] init];
    CGRect frame = CGRectMake(0, 0, SCREENWIDTH, 20);
    window_.frame = frame;
    window_.windowLevel = UIWindowLevelAlert;
    window_.backgroundColor = [UIColor clearColor];
    
    // 给window添加点击事件
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(windowClick)];
    [window_ addGestureRecognizer:tap];
}

/**
 * 监听窗口点击
 */
+ (void)windowClick
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [self searchScrollViewInView:window];
}

+ (void)searchScrollViewInView:(UIView *)superview
{
    for (UIScrollView *subview in superview.subviews) {
        // 如果是scrollview, 滚动最顶部
        if ([subview isKindOfClass:[UIScrollView class]] && subview.isShowingOnKeyWindow) {
            CGPoint offset = subview.contentOffset;
            offset.y = - subview.contentInset.top;
            [subview setContentOffset:offset animated:YES];
        }
        
        // 继续查找子控件
        [self searchScrollViewInView:subview];
    }
}

@end
