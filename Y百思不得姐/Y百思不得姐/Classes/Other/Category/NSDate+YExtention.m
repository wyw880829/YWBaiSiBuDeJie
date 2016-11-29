//
//  NSDate+YExtention.m
//  Y百思不得姐
//
//  Created by wyw on 16/5/27.
//  Copyright © 2016年 qw. All rights reserved.
//

#import "NSDate+YExtention.h"

@implementation NSDate (YExtention)

- (NSDateComponents *)deltaFrom:(NSDate *)from
{
    // 日历
    NSCalendar *calendar = [NSCalendar currentCalendar]; 
    
    // 比较时间差
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth |NSCalendarUnitDay |NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    
    return [calendar components:unit fromDate:from toDate:self options:0];
}

- (BOOL)isThisYear
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
//    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth |NSCalendarUnitDay |NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    
//    NSDateComponents *timeCom = [calendar components:unit fromDate:self toDate:[NSDate date] options:0];
    NSInteger nowYear = [calendar component:NSCalendarUnitYear fromDate:[NSDate date]];
    NSInteger selfYear = [calendar component:NSCalendarUnitYear fromDate:self];
    
//    YLog(@"thisYear -- %ld-- %ld-- %ld-- %ld-- %ld-- %ld ",timeCom.year,timeCom.month,timeCom.day,timeCom.hour,timeCom.minute,timeCom.second);
//    YLog(@"now - self -- %ld -- %ld",nowYear,selfYear);
    
    return nowYear == selfYear;
}

//- (BOOL)isToday
//{
//    NSCalendar *calendar = [NSCalendar currentCalendar];
//    
//    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
//    NSDateComponents *nowDate = [calendar components:unit fromDate:[NSDate date]];
//    NSDateComponents *selfDate = [calendar components:unit fromDate:self];
//    
//    return nowDate.year == selfDate.year
//    && nowDate.month == selfDate.month
//    && nowDate.day == selfDate.day;
//}

- (BOOL)isToday
{
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    
    NSString *nowDate = [fmt stringFromDate:[NSDate date]];
    NSString *selfDate = [fmt stringFromDate:self];
    
    return nowDate == selfDate;
}

- (BOOL)isYesterday
{
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    
    NSDate *nowDate = [fmt dateFromString:[fmt stringFromDate:[NSDate date]]];
    NSDate *selfDate = [fmt dateFromString:[fmt stringFromDate:self]];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *cmts = [calendar components:unit fromDate:selfDate toDate:nowDate options:0];
    return cmts.year == 0 && cmts.month == 0 && cmts.day == 1;
}

@end
