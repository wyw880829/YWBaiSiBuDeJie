//
//  YMeFooterView.m
//  Y百思不得姐
//
//  Created by wyw on 16/7/4.
//  Copyright © 2016年 qw. All rights reserved.
//

#import "YMeFooterView.h"
#import "YSquare.h"
#import "AFNetworking.h"
#import "MJExtension.h"
#import "YSquareButton.h"
#import "YWebViewController.h"

@implementation YMeFooterView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor clearColor];
        
       // 获取网络数据
        [self getData];
    }
    return self;
}

- (void)getData
{
    // 参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"square";
    params[@"c"] = @"topic";
    
    [[AFHTTPSessionManager manager] GET:@"http://api.budejie.com/api/api_open.php" parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSArray *squares = [YSquare mj_objectArrayWithKeyValuesArray:responseObject[@"square_list"]];
        [self creatSquare:squares];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

- (void)creatSquare:(NSArray *)squares
{
  // 一行最多4列
    int maxCols = 4;
    
    CGFloat buttonW = SCREENWIDTH / maxCols;
    CGFloat buttonH = buttonW;
    
    for (int i = 0; i < squares.count; i++) {
        YSquareButton *button = [YSquareButton buttonWithType:UIButtonTypeCustom];
        button.square = squares[i];
        // 添加点击事件
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];

        // 计算frame
        int col = i % maxCols;
        int row = i / maxCols;
        
        button.x = col * buttonW;
        button.y = row * buttonH;
        button.width = buttonW;
        button.height = buttonH;
    }
    
    // 计算总行数
    NSUInteger rows = (squares.count + maxCols - 1) / maxCols;
    // 计算footer的高度
    self.height = rows * buttonH;
    
    // 重新绘制
    [self setNeedsDisplay];
}

- (void)buttonClick:(YSquareButton *)button
{
    // 假如字符串没有http前缀，略过不处理
    if (![button.square.url hasPrefix:@"http"]) return;
    
    YWebViewController *webVC = [[YWebViewController alloc] init];
    UITabBarController *tabBarC = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    UINavigationController *nav = tabBarC.selectedViewController;
    [nav pushViewController:webVC animated:YES];
    
    webVC.url = button.square.url;
    webVC.title = button.square.name;
}

@end
