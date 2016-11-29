//
//  YConst.h
//  Y百思不得姐
//
//  Created by wyw on 16/5/25.
//  Copyright © 2016年 qw. All rights reserved.
//

#import <UIKit/UIKit.h>

/** 帖子类型 */
typedef enum {
    YTopicAll = 1,
    YTopicPicture = 10,
    YTopicWord = 29,
    YTopicVoice = 31,
    YTopicVideo = 41,
} YTopicType;

/** 精华-title-高度 */
UIKIT_EXTERN const CGFloat YTitleViewH;
/** 精华-title-Y */
UIKIT_EXTERN const CGFloat YTitleViewY;

/** 精华-cell-Margin */
UIKIT_EXTERN CGFloat const YCellMargin;
/** 精华-cell-bottomBar */
UIKIT_EXTERN CGFloat const YCellBottomBarH;
/** 精华-cell-TextY */
UIKIT_EXTERN CGFloat const YCellTextY;

/** 精华-cell- 设定图片过大的标志 */
UIKIT_EXTERN CGFloat const YCellPictureMaxH;
/** 精华-cell-设定图片过大,固定尺寸 */
UIKIT_EXTERN CGFloat const YCellPictureBreakH;

/** 精华-最热评论用户性别 */
UIKIT_EXTERN NSString * const YCellTopcmtUserSexMale;
UIKIT_EXTERN NSString * const YCellTopcmtUserSexFmale;

/** 精华-cell-最热评论titleH */
UIKIT_EXTERN CGFloat const YCellTopCmtTitleH;

/** tabBar被选中的通知名字 */
UIKIT_EXTERN NSString * const YTabBarDidSelectNotification;
/** tabBar被选中的通知 - 被选中的控制器的index key */
UIKIT_EXTERN NSString * const YSelectedControllerIndexKey;
/** tabBar被选中的通知 - 被选中的控制器 key */
UIKIT_EXTERN NSString * const YSelectedControllerKey;

/** tag标签按钮间隔 */
UIKIT_EXTERN CGFloat const YTagMargin;
/** 标签-高度 */
UIKIT_EXTERN CGFloat const YTagH;

