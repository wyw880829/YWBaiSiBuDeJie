//
//  YCategory.h
//  Y百思不得姐
//
//  Created by wyw on 16/5/13.
//  Copyright © 2016年 qw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YCategory : NSObject

/** id */
@property (assign, nonatomic) NSInteger ID;
/** name */
@property (copy, nonatomic) NSString *name;
/** count */
@property (assign, nonatomic) NSInteger count;


/** 右侧数据数组 */
@property (strong, nonatomic) NSMutableArray *users;
/** 总数 */
@property (assign, nonatomic) NSInteger total;
/** 当前页 */
@property (assign, nonatomic) NSInteger currentPage;

@end
