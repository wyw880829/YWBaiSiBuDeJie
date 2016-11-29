//
//  YEssenceViewController.m
//  Y百思不得姐
//
//  Created by wyw on 16/5/9.
//  Copyright © 2016年 qw. All rights reserved.
//

#import "YEssenceViewController.h"
#import "YTopicViewController.h"
#import "YRecommendTagController.h"
#import "YTopWindow.h"

@interface YEssenceViewController ()<UIScrollViewDelegate>

/** 指示器view */
@property (weak, nonatomic) UIView *indicatorView;

/** titleview */
@property (weak, nonatomic) UIView *titleView;

/** contentView */
@property (weak, nonatomic) UIScrollView *contentView;

/** 被选中的按钮 */
@property (strong, nonatomic) UIButton *selectedButton;



@end

@implementation YEssenceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置nav
    [self setupNav];
    
    // 初始化子控制器
    [self setupChildViewController];
    
    // 设置标题头
    [self setupTitlesView];
    
    // 设置scrollview
    [self setupContentView];

}

/**
 *  设置导航栏
 */
- (void)setupNav
{
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MainTitle"]];
    
    // 左菜单
    UIBarButtonItem *menuItem = [UIBarButtonItem itemWithImage:@"MainTagSubIcon" HeightImage:@"MainTagSubIconClick" Target:self Action:@selector(menuClick)];
    
    self.navigationItem.leftBarButtonItem = menuItem;
    
    self.view.backgroundColor = YGlobalBG;
    
    // 添加一个window, 点击这个window, 可以让屏幕上的scrollView滚到最顶部
    [YTopWindow show];
}

- (void)menuClick
{
    YRecommendTagController *RTVC = [[YRecommendTagController alloc] init];
    
    [self.navigationController pushViewController:RTVC animated:NO];
    
}

/**
 *  设置子控制器
 */
- (void)setupChildViewController
{
    YTopicViewController *allC = [[YTopicViewController alloc] init];
    allC.title = @"全部";
    allC.type = YTopicAll;
    [self addChildViewController:allC];
    
    YTopicViewController *videoC = [[YTopicViewController alloc] init];
    videoC.title = @"视频";
    videoC.type = YTopicVideo;
    [self addChildViewController:videoC];
    
    YTopicViewController *voiceC = [[YTopicViewController alloc] init];
    voiceC.title = @"声音";
    voiceC.type = YTopicVoice;
    [self addChildViewController:voiceC];
    
    YTopicViewController *pictureC = [[YTopicViewController alloc] init];
    pictureC.title = @"图片";
    pictureC.type = YTopicPicture;
    [self addChildViewController:pictureC];
    
    YTopicViewController *workC = [[YTopicViewController alloc] init];
    workC.title = @"段子";
    workC.type = YTopicWord;
    [self addChildViewController:workC];
}



/**
 *  设置title
 */
- (void)setupTitlesView
{
    // 添加标题view
    UIView *titleView = [[UIView alloc] init];
    titleView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    titleView.width = self.view.width;
    titleView.height = YTitleViewH;
    titleView.y = YTitleViewY;
    [self.view addSubview:titleView];
    self.titleView = titleView;
    
    // 添加指示器view
    UIView *indicatorView = [[UIView alloc] init];
    indicatorView.height = 2;
    indicatorView.y = titleView.height - indicatorView.height;
    indicatorView.backgroundColor = [UIColor redColor];
    [titleView addSubview:indicatorView];
    self.indicatorView = indicatorView;
    
    NSArray *titleArray = @[@"全部",@"视频",@"声音",@"图片",@"段子"];
    
    CGFloat width = titleView.width / titleArray.count;
    
    for (NSInteger i = 0; i < titleArray.count; i++) {
        UIButton *button = [[UIButton alloc] init];
        button.tag = i + 100;
        
        button.x = i * width;
        //        button.y = 0;
        button.width = width;
        button.height = titleView.height;
        
        button.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.5];
        
        [button setTitle:titleArray[i] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor redColor] forState:UIControlStateDisabled];
        
        [button addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [titleView addSubview:button];
        
        if (i == 0) {
            
            [button.titleLabel sizeToFit];
            [self titleClick:button];
        }
    }
}

/**
 *  title点击
 */
- (void)titleClick:(UIButton *)button
{
    self.selectedButton.enabled = YES;
    button.enabled = NO;
    self.selectedButton = button;
    
    [UIView animateWithDuration:0.25 animations:^{
        self.indicatorView.width = button.titleLabel.width;
        self.indicatorView.centerX = button.centerX;
    }];
    
    // 滚动tableview
    CGPoint offset = self.contentView.contentOffset;
    offset.x = (button.tag - 100) * self.contentView.width;
    [self.contentView setContentOffset:offset animated:YES];
}

/**
 *  设置contentview
 */
- (void)setupContentView
{
    // 设置不自动适应尺寸
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIScrollView *contentView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    
    contentView.delegate = self;
    contentView.pagingEnabled = YES;

    contentView.contentSize = CGSizeMake(contentView.width * self.childViewControllers.count, 0);
    
    [self.view insertSubview:contentView atIndex:0];
    self.contentView = contentView;
    
    // 添加第一个控制器
    [self scrollViewDidEndScrollingAnimation:contentView];
    
}

#pragma mark - UIScrollViewDelegate 代理事件
/**
 *  拖动动画结束时调用
 */
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    NSInteger index = scrollView.contentOffset.x / scrollView.width;
    UITableViewController *VC = self.childViewControllers[index];
    
    VC.view.x = scrollView.width * index;
    VC.view.y = 0;
    VC.view.height = self.view.height;
    
    [self.contentView addSubview:VC.view];
}

/**
 *  减速时调用
 *
 *  @param scrollView
 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self scrollViewDidEndScrollingAnimation:scrollView];
    
    // 标题栏按钮移动
    NSInteger index = scrollView.contentOffset.x / scrollView.width;
    [self titleClick:(UIButton *)[self.view viewWithTag:index + 100]];
}

@end












