//
//  YTextField.m
//  Y百思不得姐
//
//  Created by wyw on 16/5/18.
//  Copyright © 2016年 qw. All rights reserved.
//

#import "YTextField.h"
#import <objc/runtime.h>

@implementation YTextField

static NSString *const _placeholderLabel_textColor =  @"_placeholderLabel.textColor";

- (void)awakeFromNib
{
    [self resignFirstResponder];
    
    // 改变光标颜色
    self.tintColor = self.textColor;
}

/**
 *  重写成为第一响应者和移除第一响应者
 */
- (BOOL)becomeFirstResponder
{
    // kvc赋值
    [self setValue:[UIColor whiteColor] forKeyPath:_placeholderLabel_textColor];
    return  [super becomeFirstResponder];
}

- (BOOL)resignFirstResponder
{
    // kvc赋值
    [self setValue:[UIColor grayColor] forKeyPath:_placeholderLabel_textColor];
    return [super resignFirstResponder];
}

/**
 *  打印所有成员变量的列表
 */
//+ (void)initialize
//{
//    unsigned count = 0;
//    
//    // 拷贝出所有成员变量的列表
//    Ivar *ivars = class_copyIvarList([UITextField class], &count);
//    
//    for (int i = 0; i < count; i++) {
//        // 取出成员变量
//        Ivar ivar = *(ivars + i);
//        
//        NSLog(@"%s",ivar_getName(ivar));
//    }
//    
//    // 释放
//    free(ivars);
//}

@end
