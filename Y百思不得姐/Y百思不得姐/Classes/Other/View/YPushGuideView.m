//
//  YPushGuideView.m
//  Y百思不得姐
//
//  Created by wyw on 16/5/19.
//  Copyright © 2016年 qw. All rights reserved.
//

#import "YPushGuideView.h"

@implementation YPushGuideView

+ (void)show
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    // 版本号key
    NSString *key = @"CFBundleShortVersionString";
    
    // 获取当前版本号
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[key];
    
    // 取出上一次的版本号
    NSString *sanboxVersion = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    
    //判断两次版本号是否相同
    if (![currentVersion isEqualToString:sanboxVersion]) {
        
        // 添加引导页
        YPushGuideView *guideView = [YPushGuideView viewFromXib];
        guideView.frame = window.bounds;
        [window addSubview:guideView];
        
        // 存储当前版本号
        [[NSUserDefaults standardUserDefaults] setObject:currentVersion forKey:key];
    }

}


- (IBAction)concelTap:(id)sender {
    [self removeFromSuperview];
}

@end
