//
//  YRecommendTagController.m
//  Y百思不得姐
//
//  Created by wyw on 16/5/17.
//  Copyright © 2016年 qw. All rights reserved.
//

#import "YRecommendTagController.h"
#import "AFNetworking.h"
#import "MJRefresh.h"
#import "MJExtension.h"
#import "SVProgressHUD.h"
#import "YRecommendTag.h"
#import "YRecommendTagCell.h"

@interface YRecommendTagController ()

/** 模型数组 */
@property (strong, nonatomic) NSArray *recommendTags;

@end

@implementation YRecommendTagController

// cellID
static NSString * const recommendTagID = @"recommendTag";

- (void)viewDidLoad {
    [super viewDidLoad];

    
    [self setupTableView];
    
    // 下载数据
    [self loadRecommendTagData];

}

/**
 *   初始化配置
 */
- (void)setupTableView
{
    self.title = @"推荐标签";
    
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"YRecommendTagCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:recommendTagID];
    
    self.tableView.rowHeight = 70;
}

/**
 *   下载数据
 */
- (void)loadRecommendTagData
{
    // 开启指示器
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    
    // 请求参数
    NSMutableDictionary *parmters = [NSMutableDictionary dictionary];
    parmters[@"a"]      = @"tag_recommend";
    parmters[@"c"]      = @"topic";
    parmters[@"action"] = @"sub";
    
    // 请求数据
    [[AFHTTPSessionManager manager] GET:SEVERICEURL parameters:parmters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        self.recommendTags = [YRecommendTag mj_objectArrayWithKeyValuesArray:responseObject];
        
        // 刷新数据
        [self.tableView reloadData];
        
        // 关闭指示器
        [SVProgressHUD dismiss];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        // 关闭指示器
        [SVProgressHUD showErrorWithStatus:@"加载数据失败"];
        
    }];
    
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.recommendTags.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    YRecommendTagCell *cell = [tableView dequeueReusableCellWithIdentifier:recommendTagID];
    
    cell.recommendTag = self.recommendTags[indexPath.row];
    
    return cell;
}

 
@end
