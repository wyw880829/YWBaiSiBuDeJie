//
//  YCategory.m
//  Y百思不得姐
//
//  Created by wyw on 16/5/13.
//  Copyright © 2016年 qw. All rights reserved.
//

#import "YCategory.h"
#import "MJExtension.h"

@implementation YCategory

/**
 *  把自己的命名替换成服务器的模式
 *
 *  @return
 */
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"ID":@"id"};
}

- (NSMutableArray *)users
{
    if (_users == nil) {
        _users = [NSMutableArray array];
    }
    return _users;
}

@end
