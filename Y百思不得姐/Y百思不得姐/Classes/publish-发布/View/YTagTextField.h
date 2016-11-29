//
//  YTagTextField.h
//  Y百思不得姐
//
//  Created by wyw on 16/7/8.
//  Copyright © 2016年 qw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YTagTextField : UITextField

/** 删除block */
@property (nonatomic, copy) void (^deleteBlock)();

@end
