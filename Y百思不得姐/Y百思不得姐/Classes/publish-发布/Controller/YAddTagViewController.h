//
//  YAddTagViewController.h
//  Y百思不得姐
//
//  Created by wyw on 16/7/5.
//  Copyright © 2016年 qw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YAddTagViewController : UIViewController

/** 获取按钮的block */
@property (nonatomic, copy) void (^tagsBlock)(NSArray *tags);

/** 标签 */
@property (nonatomic, strong) NSArray *tags;

@end
