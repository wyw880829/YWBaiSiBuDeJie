//
//  YPlaceholderTextView.m
//  Y百思不得姐
//
//  Created by wyw on 16/7/5.
//  Copyright © 2016年 qw. All rights reserved.
//

#import "YPlaceholderTextView.h"

@interface YPlaceholderTextView()

/** 占位文字 */
@property (nonatomic, weak) UILabel *placeholderLable;

@end

@implementation YPlaceholderTextView

- (UILabel *)placeholderLable
{
    if (!_placeholderLable) {
        
        UILabel *placeholderLable = [[UILabel alloc] init];
        
        placeholderLable.numberOfLines = 0;
        placeholderLable.textColor = self.placeholderColor;
        
        [self addSubview:placeholderLable];
        
        self.placeholderLable = placeholderLable;
    }
    return _placeholderLable;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame]) {
        // 永远有弹簧效果
        self.alwaysBounceVertical = YES;
        
        // 默认字体大小
        self.font = [UIFont systemFontOfSize:15];
        
        // 默认占位文字颜色
        self.placeholderColor = [UIColor grayColor]; 
        
        // 添加文字区文字改变的通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChange) name:UITextViewTextDidChangeNotification object:nil];
    }
    return self;
}

- (void)textChange
{
    // 占位位子是否显示 -- 由textview是否有文字决定
    self.placeholderLable.hidden = self.hasText;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.placeholderLable.x = 4;
    self.placeholderLable.y = 7;
    self.placeholderLable.width = self.width - 2*self.placeholderLable.x;
    [self.placeholderLable sizeToFit];
}


#pragma mark - setter

- (void)setPlaceholderColor:(UIColor *)placeholderColor
{
    _placeholderColor = placeholderColor;
    self.placeholderLable.textColor = placeholderColor;
}
- (void)setPlaceholder:(NSString *)placeholder
{
    _placeholder = [placeholder copy];
    self.placeholderLable.text = placeholder;
    [self setNeedsLayout];
}
- (void)setFont:(UIFont *)font
{
    [super setFont: font];
    self.placeholderLable.font = font;
    [self setNeedsLayout];
}
- (void)setText:(NSString *)text
{
    [super setText: text];
    [self textChange];
}
- (void)setAttributedText:(NSAttributedString *)attributedText
{
    [super setAttributedText: attributedText];
    [self textChange];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/**
 *  将placeholder画出来，系统每次抵用darwRect，都会先擦除工作区的内容，然后再画内容
 *
 *  @param rect 工作区
 */
//- (void)drawRect:(CGRect)rect
//{
//    // 假如textview中有文字，直接返回，不画placeholder
//    if (self.hasText) return;
//
//    // 设置尺寸
//    rect.origin.x = 3;
//    rect.origin.y = 7;
//    rect.size.width -= 2*rect.origin.x;
//
//    // 设置属性
//    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
//    attrs[NSFontAttributeName] = self.font;
//    attrs[NSForegroundColorAttributeName] = self.placeholderColor;
//
//    [self.placeholder drawInRect:rect withAttributes:attrs];
//}


@end
