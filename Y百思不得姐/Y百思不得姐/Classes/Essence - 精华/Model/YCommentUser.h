//
//  YCommentUser.h
//  Y百思不得姐
//
//  Created by wyw on 16/6/14.
//  Copyright © 2016年 qw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YCommentUser : NSObject

/** 评论用户名 */
@property (nonatomic, copy) NSString *username;

/** 评论用户性别 */
@property (nonatomic, copy) NSString *sex;

/** 评论用户头像 */
@property (nonatomic, copy) NSString *profile_image;

@end
