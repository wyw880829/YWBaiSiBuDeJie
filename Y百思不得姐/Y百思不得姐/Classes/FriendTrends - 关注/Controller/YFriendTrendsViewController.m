//
//  YFriendTrendsViewController.m
//  Y百思不得姐
//
//  Created by wyw on 16/5/9.
//  Copyright © 2016年 qw. All rights reserved.
//

#import "YFriendTrendsViewController.h"
#import "YRecommendViewController.h"
#import "YLoginRegistController.h"

@interface YFriendTrendsViewController ()

@end

@implementation YFriendTrendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"我的关注";
    
    UIBarButtonItem *friendsItem = [UIBarButtonItem itemWithImage:@"friendsRecommentIcon" HeightImage:@"friendsRecommentIcon-click" Target:self Action:@selector(friendsClick)];
    
    self.navigationItem.leftBarButtonItem = friendsItem; 
    self.view.backgroundColor = YGlobalBG;
}

- (void)friendsClick
{
    YRecommendViewController *recommendVC = [[YRecommendViewController alloc] init ];
    [self.navigationController pushViewController:recommendVC animated:NO];
}

/**
 *  brief 登录注册
 *
 *  @param sender
 */
- (IBAction)loginRegistTap:(id)sender {
    
    YLoginRegistController *loginRegistVC = [[YLoginRegistController alloc] init];
    
    [self presentViewController:loginRegistVC animated:YES completion:nil];
}

@end
