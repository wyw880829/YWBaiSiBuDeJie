//
//  YTopic.h
//  Y百思不得姐
//
//  Created by wyw on 16/5/25.
//  Copyright © 2016年 qw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YTopic : NSObject

/** 类型 */
@property (nonatomic, assign) YTopicType type;

/** ID */
@property (nonatomic, copy) NSString *ID;
/** 名称 */
@property (nonatomic, copy) NSString *name;
/** 头像url */
@property (nonatomic, copy) NSString *profile_image;
/** 发帖时间 */
@property (nonatomic, copy) NSString *create_time;
/** 文字内容 */
@property (nonatomic, copy) NSString *text;
/** 顶的数量 */
@property (nonatomic, assign) NSInteger ding;
/** 踩的数量 */
@property (nonatomic, assign) NSInteger cai;
/** 转发的数量 */
@property (nonatomic, assign) NSInteger repost;
/** 评论的数量 */
@property (nonatomic, assign) NSInteger comment;

/** 图片的宽度 */
@property (assign, nonatomic) CGFloat width;
/** 图片的高度 */
@property (assign, nonatomic) CGFloat height;
/** 小图片URL */
@property (copy, nonatomic) NSString *small_image;
/** 中图片URL */
@property (copy, nonatomic) NSString *middle_image;
/** 大图片URL */
@property (copy, nonatomic) NSString *large_image;

/** 声音的点击数 */
@property (assign, nonatomic) NSInteger playcount;
/** 声音的时长 */
@property (assign, nonatomic) NSInteger voicetime;

/** 最热评论(数组中存放YComment模型) */
@property (nonatomic, strong) NSArray *top_cmt;

/**** 额外的属性 ****/
/** cell的高度 */
@property (nonatomic, assign ,readonly) CGFloat cellHeight;

/** 图片的farme */
@property (nonatomic, assign ,readonly) CGRect pictureF;
/** 图片过大 */
@property (nonatomic, assign,getter=isLargePicture) BOOL largePicture;
/** 图片的下载进度 */
@property (nonatomic, assign) CGFloat pictureProgress;

/** 声音的frame */
@property (nonatomic, assign ,readonly) CGRect voiceF;
/** 视频的frame */
@property (nonatomic, assign ,readonly) CGRect videoF;

@end
