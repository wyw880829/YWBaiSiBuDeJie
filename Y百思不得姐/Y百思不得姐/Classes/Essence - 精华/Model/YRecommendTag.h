//
//  YRecommendTag.h
//  Y百思不得姐
//
//  Created by wyw on 16/5/17.
//  Copyright © 2016年 qw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YRecommendTag : NSObject

/** 图片list */
@property (copy, nonatomic) NSString *image_list;

/** 图片list */
@property (copy, nonatomic) NSString *theme_name;

/** 订阅数 */
@property (assign, nonatomic) NSInteger sub_number;

/*image_list : http://img.spriteapp.cn/ugc/2015/10/15/134220_27775.jpg,
	theme_id : 473,
	theme_name : 社会新闻,
	is_sub : 0,
	is_default : 0,
	sub_number : 87743*/

@end
