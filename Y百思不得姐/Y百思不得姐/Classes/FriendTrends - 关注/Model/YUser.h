//
//  YUser.h
//  Y百思不得姐
//
//  Created by wyw on 16/5/16.
//  Copyright © 2016年 qw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YUser : NSObject

/** 昵称 */
@property (copy, nonatomic) NSString *screen_name;

/** 头像 */
@property (copy, nonatomic) NSString *header;

/** 粉丝数 */
@property (assign, nonatomic) NSInteger fans_count;

/*introduction : ,
	uid : 16369304,
	header : http://wimg.spriteapp.cn/profile/20151210101901.png,
	gender : 2,
	is_vip : 0,
	fans_count : 18731,
	tiezi_count : 167,
	is_follow : 0,
	screen_name : 百思哥哥*/

@end
