//
//  NSDate+YExtention.h
//  Y百思不得姐
//
//  Created by wyw on 16/5/27.
//  Copyright © 2016年 qw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (YExtention)

/**
 *  时间差
 *
 *  @param from 时间参数
 *
 *  @return dateComponents
 */
- (NSDateComponents *)deltaFrom:(NSDate *)from;

/**
 *  是否是今年
 *
 *  @return
 */
- (BOOL)isThisYear;

/**
 *  是否是今天
 *
 *  @return
 */
- (BOOL)isToday;

/**
 *  是否是昨天
 *
 *  @return
 */
- (BOOL)isYesterday;

@end
