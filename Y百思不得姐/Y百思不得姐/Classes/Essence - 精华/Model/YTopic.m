//
//  YTopic.m
//  Y百思不得姐
//
//  Created by wyw on 16/5/25.
//  Copyright © 2016年 qw. All rights reserved.
//

#import "YTopic.h"
#import "MJExtension.h"
#import "YComment.h"
#import "YCommentUser.h"

@interface YTopic()
{
    CGFloat _cellHeight;
    CGRect _pictureF;
}

@end

@implementation YTopic

/**
 *  替换属性名
 *
 *  @return
 */
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{     @"small_image":@"image0",
              @"middle_image":@"image2",
              @"large_image":@"image1",
              @"ID":@"id"
             };
}
/**
 *  数组中需要转换的模型类
 *
 *  @return 字典中的key是数组属性名，value是数组中存放模型的Class（Class类型或者NSString类型）
 */
+(NSDictionary *)mj_objectClassInArray
{
    return @{@"top_cmt" : @"YComment"};
}

/**
 *  时间的get方法
 *
 *  @return 时间字符喘
 */
- (NSString *)create_time
{
    // 时间判断
    NSDateFormatter *fmt = [[ NSDateFormatter alloc] init];
    [fmt setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *creatTime = [fmt dateFromString:_create_time];
    
    if (creatTime.isThisYear) { // 今年
        if (creatTime.isToday) { // 今天
            NSDateComponents *cmts = [[NSDate date] deltaFrom:creatTime];
            
            if (cmts.hour >= 1) { // 1小时前
                return [NSString stringWithFormat:@"%zd小时前",cmts.hour];
            } else if (cmts.minute >= 1) { // 1分钟前
                return [NSString stringWithFormat:@"%zd分钟前",cmts.minute];
            } else { // 1分钟以内
                return @"刚刚";
            }
            
        } else if (creatTime.isYesterday) { // 昨天
            [fmt setDateFormat:@"昨天 HH:mm:ss"];
            return [fmt stringFromDate:creatTime];
        } else { // 昨天以前
            [fmt setDateFormat:@"MM-dd HH:mm:ss"];
            return [fmt stringFromDate:creatTime];
        }
        
    } else { // 不是今年
        return _create_time;
    }
}

/**
 *  cell的高度
 */
- (CGFloat)cellHeight
{
    if (!_cellHeight) {
        
        CGSize maxSize = CGSizeMake(SCREENWIDTH - 4*YCellMargin, MAXFLOAT);
        
        CGFloat textH = [self.text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]} context:nil].size.height;
        // 2. 文字高度
        _cellHeight += YCellTextY + textH + YCellMargin;
        
        if (self.type == YTopicPicture) { // 图片类型
            CGFloat pictureX = YCellMargin;
            CGFloat pictureY = YCellTextY + textH + YCellMargin;
            
            // 图片宽度为屏幕宽度减去间隔
            CGFloat pictureW = maxSize.width;
            // 图片高度
            CGFloat pictureH = pictureW * self.height / self.width;
            // 判断图片是否过大
            if (pictureH >= YCellPictureMaxH) { // 图片过大
                pictureH = YCellPictureBreakH; // 设置固定尺寸
                self.largePicture = YES;    // 图片过大标志置位
            }
            // 图片的farme
            _pictureF = CGRectMake(pictureX, pictureY, pictureW, pictureH);
            
            // cell高度
            _cellHeight += pictureH + YCellMargin;
            
        } else if (self.type == YTopicVoice) {  // 声音
            CGFloat voiceX = YCellMargin;
            CGFloat voiceY = YCellTextY + textH + YCellMargin;
            CGFloat voiceW = maxSize.width;
            CGFloat voiceH = voiceW * self.height / self.width;
            
            _voiceF = CGRectMake(voiceX, voiceY, voiceW, voiceH);
            _cellHeight += voiceH + YCellMargin;
        } else if (self.type == YTopicVideo) { // 视频
            CGFloat videoX = YCellMargin;
            CGFloat videoY = YCellTextY + textH + YCellMargin;
            CGFloat videoW = maxSize.width;
            CGFloat videoH = videoW * self.height / self.width;
            
            _videoF = CGRectMake(videoX, videoY, videoW, videoH);
            _cellHeight += videoH + YCellMargin;
        }
        
        // 最热评论
        YComment *topCmt = self.top_cmt.firstObject;
        if (topCmt) { // 假如最热评论存在
            
            NSString *text = [NSString stringWithFormat:@"%@ : %@",topCmt.user.username,topCmt.content];
            CGFloat textH = [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13]} context:nil].size.height;
            _cellHeight += YCellTopCmtTitleH + textH + YCellMargin;
        }
        
        _cellHeight += YCellBottomBarH + YCellMargin;
    }
    
    return _cellHeight;
}

@end
