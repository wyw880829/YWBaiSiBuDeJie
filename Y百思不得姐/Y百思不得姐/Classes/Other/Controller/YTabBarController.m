//
//  YTabBarController.m
//  Y百思不得姐
//
//  Created by wyw on 16/5/9.
//  Copyright © 2016年 qw. All rights reserved.
//

#import "YTabBarController.h"
#import "YEssenceViewController.h"
#import "YFriendTrendsViewController.h"
#import "YNewViewController.h"
#import "YMeViewController.h"
#import "YTabBar.h"
#import "YNavigationController.h"

@interface YTabBarController ()

@end

@implementation YTabBarController

+ (void)initialize
{
    // 设置item文字属性
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = [UIFont systemFontOfSize:12];
    attrs[NSForegroundColorAttributeName] = [UIColor grayColor];
    // 选中文字属性
    NSMutableDictionary *selectAttrs = [NSMutableDictionary dictionary];
    selectAttrs[NSFontAttributeName] = attrs[NSFontAttributeName];
    selectAttrs[NSForegroundColorAttributeName] = [UIColor darkGrayColor];
    
    UITabBarItem *item = [UITabBarItem appearance];
    [item setTitleTextAttributes:attrs forState:UIControlStateNormal];
    [item setTitleTextAttributes:selectAttrs forState:UIControlStateHighlighted];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 添加控制器
    YEssenceViewController *Essence = [[YEssenceViewController alloc] init];
    [self setupVc:Essence Title:@"精华" Image:@"tabBar_essence_icon" selectImage:@"tabBar_essence_click_icon"];
    
    YNewViewController *New = [[YNewViewController alloc] init];
    [self setupVc:New Title:@"新帖" Image:@"tabBar_new_icon" selectImage:@"tabBar_new_click_icon"];
    
    YFriendTrendsViewController *FriendTrends = [[YFriendTrendsViewController alloc] init];
    [self setupVc:FriendTrends Title:@"关注" Image:@"tabBar_friendTrends_icon" selectImage:@"tabBar_friendTrends_click_icon"];
    
    YMeViewController *Me = [[YMeViewController alloc] initWithStyle:UITableViewStyleGrouped];
    [self setupVc:Me Title:@"我" Image:@"tabBar_me_icon" selectImage:@"tabBar_me_click_icon"];
    
    // 自定义tabbar
    [self setValue:[[YTabBar alloc]init] forKey:@"tabBar"];
}

/**
 *  brief 创建子页面
 *
 *  @param VC          Controller
 *  @param title       标题
 *  @param image       图片
 *  @param selectImage 选中时图片
 */
- (void)setupVc:(UIViewController *)VC Title:(NSString *)title Image:(NSString *)image selectImage:(NSString *)selectImage
{
    VC.tabBarItem.title = title;
    VC.navigationItem.title = title;
    VC.tabBarItem.image = [UIImage imageNamed:image];
    VC.tabBarItem.selectedImage = [UIImage imageNamed:selectImage];
    
    
    YNavigationController *nav = [[YNavigationController alloc] initWithRootViewController:VC];
    
    [self addChildViewController:nav];
}

@end
