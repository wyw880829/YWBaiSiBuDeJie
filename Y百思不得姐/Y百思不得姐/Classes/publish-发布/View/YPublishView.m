//
//  YPublishView.m
//  Y百思不得姐
//
//  Created by wyw on 16/6/8.
//  Copyright © 2016年 qw. All rights reserved.
//

#import "YPublishView.h"
#import "YVerticalButton.h"
#import "POP.h"
#import "YNavigationController.h"
#import "YPostWordViewController.h"

#define YRootView [UIApplication sharedApplication].keyWindow.rootViewController.view

@implementation YPublishView

static CGFloat YAnimFtator = 10;
static CGFloat YAnimDelay = 0.1;


- (void)awakeFromNib
{
    [self setupSubViews];
    
}

- (void)setupSubViews
{
    YRootView.userInteractionEnabled = NO;
    self.userInteractionEnabled = NO;
    // 添加按钮
    // 数据
    NSArray *images = @[@"publish-video", @"publish-picture", @"publish-text", @"publish-audio", @"publish-review", @"publish-offline"];
    NSArray *titles = @[@"发视频", @"发图片", @"发段子", @"发声音", @"审帖", @"离线下载"];
    // 尺寸数据
    int maxCols = 3; // 最大列数3
    CGFloat buttonW = 72;
    CGFloat buttonH = buttonW + 30;
    CGFloat buttonEdgeMargin = 15;
    CGFloat buttonMargin = (SCREENWIDTH - 2*buttonEdgeMargin - 3*buttonW) / 2;
    CGFloat buttonOrginY = (SCREENHEIGHT - 2*buttonH) * 0.5;
    
    for (int i = 0; i < images.count; i++) {
        YVerticalButton *button = [YVerticalButton buttonWithType:UIButtonTypeCustom];
        button.tag = 100 + i;
        [self addSubview:button];
        // 设置文字图片
        button.titleLabel.font = [UIFont systemFontOfSize:12];
        [button setTitle:titles[i] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:images[i]] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        // 位置尺寸
        int row = i / maxCols;
        int col = i % maxCols;
        CGFloat buttonX = buttonEdgeMargin + col * (buttonMargin + buttonW);
        CGFloat buttonY = buttonOrginY + row * buttonH;
        CGFloat buttonBeginY = buttonY - SCREENHEIGHT;
        
        // 添加动画
        POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
        anim.fromValue = [NSValue valueWithCGRect:CGRectMake(buttonX, buttonBeginY, buttonW, buttonH)];
        anim.toValue = [NSValue valueWithCGRect:CGRectMake(buttonX, buttonY, buttonW, buttonH)];
        anim.springSpeed = YAnimFtator;
        anim.springBounciness = YAnimFtator;
        
        anim.beginTime = CACurrentMediaTime() + YAnimDelay*i;
        
//        anim.dynamicsMass    = 10;  // 大弹簧
//        anim.dynamicsTension  = 10; // 缓慢
//        anim.dynamicsFriction = 10; // 摩擦力大
        
        [button pop_addAnimation:anim forKey:nil];
    }
    
    // 添加标语
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"app_slogan"]];
    [self addSubview:imageView];
    
    // 标语动画
    POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPViewCenter];
    anim.fromValue = [NSValue valueWithCGPoint:CGPointMake(SCREENWIDTH * 0.5, -SCREENHEIGHT * 0.2)];
    anim.toValue   = [NSValue valueWithCGPoint:CGPointMake(SCREENWIDTH * 0.5, SCREENHEIGHT * 0.2)];
    anim.springSpeed = YAnimFtator;
    anim.springBounciness = YAnimFtator;
    anim.beginTime = CACurrentMediaTime() + YAnimDelay * images.count;
    [anim setCompletionBlock:^(POPAnimation * anim, BOOL finished) {
        YRootView.userInteractionEnabled = YES;
        self.userInteractionEnabled = YES;
    }];
    [imageView pop_addAnimation:anim forKey:nil];
}

/**
 *  按钮点击事件
 *
 *  @param button 按钮
 */
- (void)buttonClick:(UIButton *)button
{
    [self cancelWithCompletionBlock:^{
        if (button.tag == 100) {
            YLog(@"发视频");
        } else if (button.tag == 102) {
            
            YPostWordViewController *postwordVC = [[YPostWordViewController alloc] init];
            YNavigationController *nav = [[YNavigationController alloc] initWithRootViewController:postwordVC];
            UIViewController *rootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
            [rootVC presentViewController:nav animated:YES completion:nil];
            
        } else {
            YLog(@"其他");
        }
    }];
}

/**
 *  关闭页面
 *
 *  @param completionBlock 先执行动画，动画执行完毕后调用block
 */
- (void)cancelWithCompletionBlock:(void(^)())completionBlock
{
    YRootView.userInteractionEnabled = NO;
    self.userInteractionEnabled = NO;
    
    int beginIndex = 1;
    for (int i = beginIndex; i< self.subviews.count ; i++) {
        UIView *subview = self.subviews[i];
        
        // 动画（POP）
        POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPViewCenter];
        CGFloat centerY =  SCREENHEIGHT + subview.centerY;
        anim.fromValue = [NSValue valueWithCGPoint:CGPointMake(subview.centerX, subview.centerY)];
        anim.toValue   = [NSValue valueWithCGPoint:CGPointMake(subview.centerX, centerY)];
        
        anim.springSpeed = YAnimFtator;
        anim.springBounciness = YAnimFtator;
        
        anim.beginTime = CACurrentMediaTime() + i * YAnimDelay;
        
        [subview pop_addAnimation:anim forKey:nil];
        
        // 监听最后一个动画
        if (i == self.subviews.count - 1) {
            [anim setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
                
                YRootView.userInteractionEnabled = YES;
                
                [self removeFromSuperview];
                // 假如block不为空，就执行block传进来的参数
                !completionBlock ? nil : completionBlock() ;
            }];
        }
    }
}

// 点击取消按钮关闭页面
- (IBAction)cancelAction:(id)sender {
    
    [self cancelWithCompletionBlock:nil];
}

// 点击空白处关闭页面
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
  [self cancelWithCompletionBlock:nil];
}

@end
