//
//  YCommentCell.h
//  Y百思不得姐
//
//  Created by wyw on 16/6/28.
//  Copyright © 2016年 qw. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YComment;

@interface YCommentCell : UITableViewCell

/** 评论模型 */
@property (nonatomic, strong) YComment *comment;

@end
