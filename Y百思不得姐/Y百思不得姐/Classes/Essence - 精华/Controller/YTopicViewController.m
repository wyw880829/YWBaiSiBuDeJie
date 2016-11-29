//
//  YTopicViewController.m
//  Y百思不得姐
//
//  Created by wyw on 16/5/31.
//  Copyright © 2016年 qw. All rights reserved.
//

#import "YTopicViewController.h"
#import "AFNetworking.h"
#import "YTopic.h"
#import "MJExtension.h"
#import "MJRefresh.h"
#import "UIImageView+WebCache.h"
#import "YTopicCell.h"
#import "YCommentViewController.h"
#import "YNewViewController.h"

@interface YTopicViewController ()

/** 话题数组 */
@property (strong, nonatomic) NSMutableArray *topics;

/** 页码 */
@property (assign, nonatomic) NSInteger page;

/** maxtime */
@property (copy, nonatomic) NSString *maxtime;

/** 参数字典 */
@property (strong, nonatomic) NSDictionary *parmers;

/** 上次选中的索引(或者控制器) */
@property (nonatomic, assign) NSInteger lastSelectedIndex;

@end

@implementation YTopicViewController

static NSString *const YTpoicCellID = @"topiccell";

#pragma mark - lazy
- (NSMutableArray *)topics
{
    if (_topics == nil) {
        _topics = [NSMutableArray array];
    }
    return _topics;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 初始化tableview的配置
    [self setupTableView];
    
    // 设置刷新
    [self setupRefresh];
    
    [self loadNewData];
    
    // 添加通知监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tabbarSelected) name:YTabBarDidSelectNotification object:nil];
}


- (void)tabbarSelected
{
    // 如果是连续选中2次, 直接刷新
    if (self.lastSelectedIndex == self.tabBarController.selectedIndex && self.view.isShowingOnKeyWindow ) {
        [self.tableView.mj_header beginRefreshing];
    }
    
   // 赋值
    self.lastSelectedIndex = self.tabBarController.selectedIndex;
}

- (void)setupTableView
{
    // 设置内边距
    CGFloat top = YTitleViewH + YTitleViewY;
    CGFloat bottom = self.tabBarController.tabBar.height;
    // 设置tableview的内边距
    self.tableView.contentInset = UIEdgeInsetsMake(top, 0, bottom, 0);
    // 设置滚动指示器的内边距
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    
    // 去掉分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.view.backgroundColor = RANDOMCOLOR;
    
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([YTopicCell class]) bundle:nil] forCellReuseIdentifier:YTpoicCellID]; 
}

/**
 *  刷新
 */
- (void)setupRefresh
{
    // 下拉刷新
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    // 自动调节header的透明度
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    [self.tableView.mj_header beginRefreshing];
    
    // 上拉刷新
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    self.tableView.mj_footer.hidden = YES;
}

- (NSString *)a {
    return [self.parentViewController isKindOfClass:[YNewViewController class]] ? @"newlist" : @"list";
}

/**
 *  加载最新数据
 */
- (void)loadNewData
{
    // 页码赋值
    self.page = 0;
    
    // 请求参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"a"]    = self.a;
    parameters[@"c"]    = @"data";
    parameters[@"type"] = @(self.type);
    parameters[@"page"] = @(self.page);
    // 赋值
    self.parmers = parameters;
    
    // 向服务器请求数据
    [[AFHTTPSessionManager manager] GET:@"http://api.budejie.com/api/api_open.php" parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
//        YLog(@"responseObject -- %@",responseObject);
        // 判断是否上一次的参数（防止加载上一次数据，网络慢的时候使用，防止发生错误）
        if (self.parmers != parameters) return;
        
        // 存储maxtime
        self.maxtime = responseObject[@"info"][@"maxtime"];
        
        // 字典数组转换模型数组
        self.topics = [YTopic mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        
        [self.tableView reloadData];
        
        // 结束刷新
        [self.tableView.mj_header endRefreshing];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 判断是否上一次的参数（防止加载上一次数据，网络慢的时候使用，防止发生错误）
        if (self.parmers != parameters) return;
        // 结束刷新
        [self.tableView.mj_header endRefreshing];
    }];
}

/**
 *  加载更多数据
 */
- (void)loadMoreData
{
    // 页码+1
    self.page++;
    
    // 请求参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"a"]       = self.a;
    parameters[@"c"]       = @"data";
    parameters[@"type"]    = @(self.type);
    parameters[@"page"]    = @(self.page);
    parameters[@"maxtime"] = self.maxtime;
    self.parmers = parameters;
    
    // 向服务器请求数据
    [[AFHTTPSessionManager manager] GET:@"http://api.budejie.com/api/api_open.php" parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        // 判断是否上一次的参数（防止加载上一次数据，网络慢的时候使用，防止发生错误）
        if (self.parmers != parameters) return;
        
        // 存储maxtime
        self.maxtime = responseObject[@"info"][@"maxtime"];
        // 给数组添加数据
        NSArray *tempArray = [YTopic mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        [self.topics addObjectsFromArray:tempArray];
        
        [self.tableView reloadData];
        
        // 结束刷新
        [self.tableView.mj_footer endRefreshing];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 判断是否上一次的参数（防止加载上一次数据，网络慢的时候使用，防止发生错误）
        if (self.parmers != parameters) return;
        // 结束刷新
        [self.tableView.mj_footer endRefreshing];
        // 恢复页码
        self.page--;
    }];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    self.tableView.mj_footer.hidden = (self.topics.count == 0);

    return self.topics.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    YTopicCell *cell = [tableView dequeueReusableCellWithIdentifier:YTpoicCellID];
    cell.topic = self.topics[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YTopic *topic = self.topics[indexPath.row];

    return topic.cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    YCommentViewController *commentVC = [[YCommentViewController alloc] init];
    // 赋值
    commentVC.topic = self.topics[indexPath.row];
    [self.navigationController pushViewController:commentVC animated:YES];
}

@end
