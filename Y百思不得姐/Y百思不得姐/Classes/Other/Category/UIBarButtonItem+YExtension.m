//
//  UIBarButtonItem+YExtension.m
//  Y百思不得姐
//
//  Created by wyw on 16/5/12.
//  Copyright © 2016年 qw. All rights reserved.
//

#import "UIBarButtonItem+YExtension.h"

@implementation UIBarButtonItem (YExtension)

+ (instancetype)itemWithImage:(NSString *)image HeightImage:(NSString *)heigitImage Target:(id)target Action:(SEL)action
{
    UIButton *Button = [[UIButton alloc] init];
    
    [Button setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [Button setBackgroundImage:[UIImage imageNamed:heigitImage] forState:UIControlStateHighlighted];
    
    Button.size = Button.currentBackgroundImage.size;
    
    [Button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];

    return [[self alloc] initWithCustomView:Button];
}

@end
