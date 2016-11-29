//
//  YCommentViewController.m
//  Y百思不得姐
//
//  Created by wyw on 16/6/15.
//  Copyright © 2016年 qw. All rights reserved.
//

#import "YCommentViewController.h"
#import "YTopicCell.h"
#import "MJRefresh.h"
#import "MJExtension.h"
#import "AFNetWorking.h"
#import "YComment.h"
#import "YCommentCell.h"

static NSString *const YCommentCellID = @"comment";

@interface YCommentViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *commentBarSpace;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

/** topcmt */
@property (nonatomic, strong) NSArray *topCmts;

/** newcmt */
@property (nonatomic, strong) NSMutableArray *lasestCmts;

/** 保存帖子的最热评论 */
@property (nonatomic, strong) NSArray *saved_top_cmt;

/** 当前页码 */
@property (nonatomic, assign) NSInteger page;

/** AFN管理器 */
@property (nonatomic, strong) AFHTTPSessionManager *manager;

@end

@implementation YCommentViewController

- (AFHTTPSessionManager *)manager
{
    if (!_manager) {
        _manager = [AFHTTPSessionManager manager];
    }
    return _manager;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 继续修改
    
    // 基本配置
    [self setupConfiguration];
    
    // 添加tableview的header
    [self setupHeader];
    
    // 设置刷新
    [self setupRefresh];
    
    // 添加键盘通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardChangeFrame:) name:UIKeyboardDidChangeFrameNotification object:nil];
}

/**
 *  设置刷新
 */
- (void)setupRefresh
{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    [self.tableView.mj_header beginRefreshing];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    self.tableView.mj_footer.hidden = YES;
}

/**
 *  下载数据
 */
- (void)loadNewData
{
    // 加载前停止之前所有任务
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    
    NSMutableDictionary *parmeters = [NSMutableDictionary dictionary];
    parmeters[@"a"] = @"dataList";
    parmeters[@"c"] = @"comment";
    parmeters[@"data_id"] = self.topic.ID;
    parmeters[@"hot"] = @"1";
    
    [self.manager GET:SEVERICEURL parameters:parmeters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        // 假如没有数据，responseObject为数组
        if (![responseObject isKindOfClass:[NSDictionary class]]) {
            
            [self.tableView.mj_header endRefreshing];
            return;
        }
        
        // 最热评论
        self.topCmts = [YComment mj_objectArrayWithKeyValuesArray:responseObject[@"hot"]];
        // 一般评论
        self.lasestCmts = [YComment mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        
        // 页码
        self.page = 1;
        
        // 刷新表格
        [self.tableView reloadData];
        
        // 结束刷新
        [self.tableView.mj_header endRefreshing];
        
        // footer状态
        if (self.lasestCmts.count >= [responseObject[@"total"] integerValue]) {
            self.tableView.mj_footer.hidden = YES;
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 结束刷新
        [self.tableView.mj_header endRefreshing];
//        YLog(@"haha");
    }];
}
/**
 *  下载跟过数据
 */
- (void)loadMoreData
{
    
    // 加载前停止之前所有任务
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    
    //取出页码
    NSInteger page = self.page + 1;
    
    // 评论id
    YComment *lastComment = self.lasestCmts.lastObject;
    
    NSMutableDictionary *parmeters = [NSMutableDictionary dictionary];
    parmeters[@"a"] = @"dataList";
    parmeters[@"c"] = @"comment";
    parmeters[@"data_id"] = self.topic.ID;
    parmeters[@"hot"] = @"1";
    parmeters[@"page"] = @(page);
    parmeters[@"lastcid"] = lastComment.ID;
    
    [self.manager GET:SEVERICEURL parameters:parmeters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        // 假如没有数据，responseObject为数组
        if (![responseObject isKindOfClass:[NSDictionary class]]) {
            self.tableView.mj_footer.hidden = YES;
            return;
        }
        
        // 一般评论
        NSArray *newArrary = [YComment mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        [self.lasestCmts addObjectsFromArray:newArrary];
        
        // 页码
        self.page = page;
        
        // 刷新表格
        [self.tableView reloadData];
        
        // 结束刷新
        [self.tableView.mj_header endRefreshing];
        
        // footer状态
        if (self.lasestCmts.count >= [responseObject[@"total"] integerValue]) {
            self.tableView.mj_footer.hidden = YES;
        } else {
            [self.tableView.mj_footer endRefreshing];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

/**
 *  设置header
 */
- (void)setupHeader
{
    UIView *headerView = [[UIView alloc] init];
    
    // 清空top_cmt
    if (self.topic.top_cmt.count) {
        self.saved_top_cmt = self.topic.top_cmt;
        self.topic.top_cmt = nil;
        [self.topic setValue:@0 forKey:@"cellHeight"];
    }
    
    YTopicCell *cell = [YTopicCell viewFromXib];
    cell.topic = self.topic;
    cell.size = CGSizeMake(SCREENWIDTH, self.topic.cellHeight);
    
    headerView.height = self.topic.cellHeight + YCellMargin;
    [headerView addSubview:cell];
    
    self.tableView.tableHeaderView = headerView;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

/**
 *  配置
 */
- (void)setupConfiguration
{
  self.title = @"评论";
  
  self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImage:@"comment_nav_item_share_icon" HeightImage:@"comment_nav_item_share_icon_click" Target:self Action:nil];
    
  // 注册评论cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([YCommentCell class]) bundle:nil] forCellReuseIdentifier:YCommentCellID];
    
  // cell的高度
    self.tableView.estimatedRowHeight = 44; // 估计高度
    self.tableView.rowHeight = UITableViewAutomaticDimension; // 自动计算尺寸
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 10, 0);
}

/**
 *  键盘改变回调
 *
 *  @param note 通知
 */
- (void)keyBoardChangeFrame:(NSNotification *)note
{
  // 取出键盘最终显示\隐藏frame
    CGRect frame = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
  // 改变commentBar底部约束
    self.commentBarSpace.constant = SCREENHEIGHT - frame.origin.y;
    
  // 取出键盘动画时间
    CGFloat animDuration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:animDuration animations:^{
        [self.view layoutIfNeeded];
    }];
}

/**
 *  判断最热评论是否存在
 *
 *  @param section 区号
 *
 *  @return 数组
 */
- (NSArray *)commentsInSection:(NSInteger) section
{
    if (section == 0) return self.topCmts.count ? self.topCmts : self.lasestCmts;
    
    return self.lasestCmts;
}
- (YComment *)commentInIndexPath:(NSIndexPath *)indexPath
{
    return [self commentsInSection:indexPath.section][indexPath.row];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    CGFloat hotCount = self.topCmts.count;
    CGFloat lastCount = self.lasestCmts.count;
    
    if (hotCount) return 2;
    if (lastCount) return 1;
    
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    CGFloat hotCount = self.topCmts.count;
    CGFloat lastCount = self.lasestCmts.count;
    // 当没有评论时，footer隐藏
    tableView.mj_footer.hidden = (lastCount == 0);
    
    if (section == 0) {
        return hotCount ? hotCount : lastCount;
    }
    
    return lastCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:YCommentCellID];
    
    cell.comment = [self commentInIndexPath:indexPath];
    
    return cell;
}

/**
 *  设置标题头
 */ 
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    CGFloat hotCount = self.topCmts.count;
    CGFloat lastCount = self.lasestCmts.count;
    
    if (section == 0) return hotCount ? @"最热评论" : @"最新评论";
    
    return lastCount ? @"最新评论" : nil;
}



#pragma mark - UIMenuController
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 创建menu
    UIMenuController *menu = [UIMenuController sharedMenuController];
    // 获得当前点击的cell
    YTopicCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    [menu setTargetRect:cell.bounds inView:cell];
    [menu setMenuVisible:YES animated:YES];
    
    // 当前cell成为第一响应者
    [cell becomeFirstResponder];
    
    UIMenuItem *copyItem = [[UIMenuItem alloc] initWithTitle:@"顶" action:@selector(ding:)];
    UIMenuItem *cutItem = [[UIMenuItem alloc] initWithTitle:@"回复" action:@selector(replay:)];
    UIMenuItem *pasteItem = [[UIMenuItem alloc] initWithTitle:@"举报" action:@selector(report:)];
    
    menu.menuItems = @[copyItem,cutItem,pasteItem];
    
}
// 可以成为第一响应者
- (BOOL)canBecomeFirstResponder
{
    return YES;
}
// 响应那些事件
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if (action == @selector(ding:) || action == @selector(replay:) || action == @selector(report:)) {
        return YES;
    }
    return NO;
}

- (void)ding:(UIMenuController *)menu
{
    NSIndexPath *indexpath = [self.tableView indexPathForSelectedRow];
    
    YLog(@"index -- %zd",indexpath.row);
    
}
- (void)replay:(UIMenuController *)menu
{
    NSIndexPath *indexpath = [self.tableView indexPathForSelectedRow];
    
    YLog(@"index -- %zd",indexpath.row);
}
- (void)report:(UIMenuController *)menu
{
    NSIndexPath *indexpath = [self.tableView indexPathForSelectedRow];
    
    YLog(@"index -- %zd",indexpath.row);
}

/**
 *  滚动cell关闭键盘 
 *
 *  @param scrollView
 */
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
    
    // 关闭menu
    UIMenuController *menu = [UIMenuController sharedMenuController];
    [menu setMenuVisible:NO animated:YES];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    // 恢复最热评论
    if (self.topic.top_cmt.count) {
        self.topic.top_cmt = self.saved_top_cmt;
        [self.topic setValue:@0 forKey:@"cellHeight"];
    }
    // 取消所有任务
    [self.manager invalidateSessionCancelingTasks:YES];
}

@end
