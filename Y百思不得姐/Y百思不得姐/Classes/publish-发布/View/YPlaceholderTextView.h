//
//  YPlaceholderTextView.h
//  Y百思不得姐
//
//  Created by wyw on 16/7/5.
//  Copyright © 2016年 qw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YPlaceholderTextView : UITextView

/** placeholder */
@property (nonatomic, copy) NSString *placeholder;

/** 占位文字的颜色 */
@property (nonatomic, strong) UIColor *placeholderColor;

@end
