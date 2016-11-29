//
//  YMeViewController.m
//  Y百思不得姐
//
//  Created by wyw on 16/5/9.
//  Copyright © 2016年 qw. All rights reserved.
//

#import "YMeViewController.h"
#import "YMeCell.h"
#import "YMeFooterView.h"

@interface YMeViewController ()

@end

@implementation YMeViewController

static NSString *MeCellID = @"meCell";

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupNav];
    
    [self setupTableView];
}

- (void)setupNav
{
    // 设置标题
    self.navigationItem.title = @"我的";
    
    // 设置item
    UIBarButtonItem *moonItem = [UIBarButtonItem itemWithImage:@"mine-moon-icon" HeightImage:@"mine-moon-icon-click" Target:self Action:@selector(moonClick)];
    UIBarButtonItem *settingItem = [UIBarButtonItem itemWithImage:@"mine-setting-icon" HeightImage:@"mine-setting-icon-click" Target:self Action:@selector(settingClick)];
    self.navigationItem.rightBarButtonItems = @[settingItem,moonItem];
}

- (void)setupTableView
{
    // 设置背景颜色
    self.view.backgroundColor = YGlobalBG;
    
    // 注册cell
    [self.tableView registerClass:[YMeCell class] forCellReuseIdentifier:MeCellID];
    
    // 去掉线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // 调整header和footer
    self.tableView.sectionHeaderHeight = 0;
    self.tableView.sectionFooterHeight = YCellMargin;
    
    // 调整inset
    self.tableView.contentInset = UIEdgeInsetsMake(YCellMargin - 35, 0, 0, 0);
    
    // Footer
    self.tableView.tableFooterView = [[YMeFooterView alloc] init];
 
}

- (void)moonClick
{
    YLogFunc;
}
- (void)settingClick
{
    YLogFunc;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YMeCell *cell = [tableView dequeueReusableCellWithIdentifier:MeCellID];
    
    if (indexPath.section == 0) {
        cell.imageView.image = [UIImage imageNamed:@"mine_icon_nearby"];
        cell.textLabel.text = @"登录/注册";
    } else if (indexPath.section == 1) {
        cell.textLabel.text = @"离线下载";
    }
    
    return cell;
}


@end
