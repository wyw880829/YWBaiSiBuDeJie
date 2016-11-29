//
//  YComment.h
//  Y百思不得姐
//
//  Created by wyw on 16/6/14.
//  Copyright © 2016年 qw. All rights reserved.
//

#import <Foundation/Foundation.h>
@class YCommentUser;

@interface YComment : NSObject
/** 用户名 */
@property (nonatomic, strong) YCommentUser *user;

/** 内容 */
@property (nonatomic, copy) NSString *content;

/** 声音评论时长 */
@property (nonatomic, assign) NSInteger voicetime;

/** 点赞数量 */
@property (nonatomic, assign) NSInteger like_count;

/** 音频文件的路径 */
@property (nonatomic, copy) NSString *voiceuri;

/** ID */
@property (nonatomic, copy) NSString *ID;

@end
