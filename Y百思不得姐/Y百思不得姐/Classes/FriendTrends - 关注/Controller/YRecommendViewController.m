//
//  YRecommendViewController.m
//  Y百思不得姐
//
//  Created by wyw on 16/5/13.
//  Copyright © 2016年 qw. All rights reserved.
//

#import "YRecommendViewController.h"
#import "AFNetworking.h"
#import "SVProgressHUD.h"
#import "MJExtension.h"
#import "YRecommendCategoryCell.h"
#import "YUserCategoryCell.h"
#import "YCategory.h"
#import "MJRefresh.h"

/** 选中的行的类别 */
#define YSelectedCategory self.categories[self.CategoryTableView.indexPathForSelectedRow.row]

@interface YRecommendViewController ()<UITableViewDelegate,UITableViewDataSource>

/** 左侧tableview */
@property (weak, nonatomic) IBOutlet UITableView *CategoryTableView;
/** 右侧tableview */
@property (weak, nonatomic) IBOutlet UITableView *userTableView;

/** 左侧模型数组 */
@property (strong, nonatomic) NSArray *categories;

/** 请求参数字典 */
@property (strong, nonatomic) NSMutableDictionary *parmeters;

/** AFN请求管理者 */
@property (strong, nonatomic) AFHTTPSessionManager *manager;


@end

@implementation YRecommendViewController

static NSString * const YCategorycellID = @"CategoryCell";
static NSString * const YUsercellID = @"UserCell";

#pragma mark - lazy
- (AFHTTPSessionManager *)manager
{
    if (_manager == nil) {
        _manager = [AFHTTPSessionManager manager];
    }
    return _manager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 初始化配置
    [self setupTableView];
    
    // 下载左侧数据
    [self loadLeftData];
    
    // 上拉刷新
    [self setupRefresh];
}

/**
 *  初始化tableview
 */
- (void)setupTableView
{
    self.title = @"推荐关注";
    
    // 注册左侧cell
    [self.CategoryTableView registerNib:[UINib nibWithNibName:@"YRecommendCategoryCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:YCategorycellID];
    // 注册右侧cell
    [self.userTableView registerNib:[UINib nibWithNibName:@"YUserCategoryCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:YUsercellID];
    
    self.userTableView.rowHeight = 70;
    
    //设置页边距
//    self.automaticallyAdjustsScrollViewInsets = NO;
//    self.CategoryTableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    self.userTableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
}

/**
 *  刷新
 */
- (void)setupRefresh
{
    // 下拉刷新
    self.userTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewUsers)];
    
    // 上拉刷新
    self.userTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreUsers)];
    
    self.userTableView.mj_footer.hidden = YES;
}

/**
 *  下载左侧数据
 */
- (void)loadLeftData
{
    [SVProgressHUD show];
    
    // 请求参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"a"] = @"category";
    parameters[@"c"] = @"subscribe";

    // 向服务器请求数据
    [self.manager GET:@"http://api.budejie.com/api/api_open.php" parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        self.categories = [YCategory mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        
        [self.CategoryTableView reloadData];
        
        // 默认选中第一行
        [self.CategoryTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
        
        // 进入下拉刷新状态
        [self.userTableView.mj_header beginRefreshing];
        
        [SVProgressHUD dismiss];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:@"加载推荐信息失败!"];
        
    }];
}

/**
 *   下载新数据（下拉刷新）
 */
- (void)loadNewUsers
{
    // 获取点击分类
    YCategory *category = YSelectedCategory;
    // 当前页码
    category.currentPage = 1;
    
    // 请求参数
    NSMutableDictionary *parmeters = [NSMutableDictionary dictionary];
    parmeters[@"a"] = @"list";
    parmeters[@"c"] = @"subscribe";
    parmeters[@"category_id"] = @(category.ID);
    parmeters[@"page"] = @(category.currentPage);
    
    // 参数赋值
    self.parmeters = parmeters;
    
    // 向服务器请求数据
    [self.manager GET:@"http://api.budejie.com/api/api_open.php" parameters:parmeters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        NSArray *users = [YUser mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        
        // 清空所有旧数据
        [category.users removeAllObjects];
        
        // 将下载的数组数据赋值给分类模型数组
        [category.users addObjectsFromArray:users];
        
        // 保存总数
        category.total = [responseObject[@"total"] integerValue];
        
        // 假如请求参数不是这次发送的请求参数，(防止一个表格没加载完，又点击另一个表格时数据混乱)
        // 先把请求下来的数据存储起来，等待下次使用，但是不刷新表格
        if (self.parmeters != parmeters) return;
        
        // 刷新表格
        [self.userTableView reloadData];

        // 结束刷新
        [self.userTableView.mj_header endRefreshing];
        
        // 检测footer状态
        [self checkFooterState];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        // 提示错误
        [SVProgressHUD showErrorWithStatus:@"加载数据失败"];
        
        // 结束刷新
        [self.userTableView.mj_header endRefreshing];
        
    }];
}

/**
 *  下载更多数据(上拉刷新)
 */
- (void)loadMoreUsers
{
    // 获取分类
    YCategory *category = YSelectedCategory;
    
    // 请求参数
    NSMutableDictionary *parmeters = [NSMutableDictionary dictionary];
    parmeters[@"a"] = @"list";
    parmeters[@"c"] = @"subscribe";
    parmeters[@"category_id"] = @(category.ID);
    parmeters[@"page"] = @(++category.currentPage);
    
    self.parmeters = parmeters;
    
    // 向服务器请求数据
    [self.manager GET:@"http://api.budejie.com/api/api_open.php" parameters:parmeters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSArray *users = [YUser mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        
        // 将下载的数组数据赋值给分类模型数组
        [category.users addObjectsFromArray:users];
        
        // 假如请求参数不是这次发送的请求参数，储数据(防止一个表格没加载完，又点击另一个表格时数据混乱)
        if (self.parmeters != parmeters) return;
        
        // 刷新表格
        [self.userTableView reloadData];
        
        // 检测footer状态
        [self checkFooterState];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 假如请求参数不是这次发送的请求参数，不存储数据(防止一个表格没加载完，又点击另一个表格时数据混乱)
        if (self.parmeters != parmeters) return;
        
        [SVProgressHUD showErrorWithStatus:@"加载数据失败"];
        
        // 结束刷新
        [self.userTableView.mj_footer endRefreshing];
    }];
}

/**
 *  检测footer状态
 */
- (void)checkFooterState
{
    // 获取分类
    YCategory *category = YSelectedCategory;
    
    NSInteger count = category.users.count;
    
    // 判断当前页面是否已经加载完毕(底部)
    if (count == category.total) { // 已经加载完毕
        // 结束刷新,提示没有更多数据
        [self.userTableView.mj_footer endRefreshingWithNoMoreData];
    } else {
        // 结束刷新状态，等待下次刷新
        [self.userTableView.mj_footer endRefreshing];
    }
    
    // 刷新footer的开启关闭
    self.userTableView.mj_footer.hidden = (count == 0);
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // 左边用户表格
    if (tableView == self.CategoryTableView) return self.categories.count;
    
    // 检测footer状态
    [self checkFooterState];
    
    // 右边用户表格
    return [YSelectedCategory users].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 重新加载表格前结束之前的刷新状态
    [self.userTableView.mj_header endRefreshing];
    [self.userTableView.mj_footer endRefreshing];
    
    if (tableView == self.CategoryTableView) {
        YRecommendCategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:YCategorycellID];
        
        cell.category = self.categories[indexPath.row];
        
        // 检测footer状态
        [self checkFooterState];
        
        return cell;
        
    } else {
        YUserCategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:YUsercellID];
        
        cell.user = [YSelectedCategory users][indexPath.row];
        
        // 检测footer状态
        [self checkFooterState];
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 获取点击分类
    YCategory *category = YSelectedCategory;
    if (category.users.count) { // 假如缓存中有数据，直接刷新表格获取数据
        
        [self.userTableView reloadData];
        
    } else {
        // 立即刷新，作用：立即刷新当前页面，防止出现上一个页面的数据
        [self.userTableView reloadData];
        
        // 下拉刷新
        [self.userTableView.mj_header beginRefreshing];
    }
}

#pragma mark - 销毁控制器
- (void)dealloc
{
   // 停止所有网络请求,防止页面销毁后，因为请求来的数据调用控制器方法而导致程序崩溃
    [self.manager.operationQueue cancelAllOperations];
    
    [SVProgressHUD dismiss];
}

@end
