//
//  UIImage+YExtention.m
//  Y百思不得姐
//
//  Created by wyw on 16/7/2.
//  Copyright © 2016年 qw. All rights reserved.
//

#import "UIImage+YExtention.h"

@implementation UIImage (YExtention)

/**
 *  将图片变成圆形的
 *
 *  @return 图片
 */
- (UIImage *)circleImage
{
  // 开启图片上下文 NO代表透明
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0);
    
    // 获得当前上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // 添加一个圆
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    CGContextAddEllipseInRect(ctx, rect);
    
    // 裁剪
    CGContextClip(ctx);
    
    // 将图片画上去
    [self drawInRect:rect];
    
    
  // 获取图片
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    // 结束上下文
    UIGraphicsEndImageContext();
    
    return image;
}

@end
