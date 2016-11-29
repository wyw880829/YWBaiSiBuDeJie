//
//  YAddTagToolBar.m
//  Y百思不得姐
//
//  Created by wyw on 16/7/5.
//  Copyright © 2016年 qw. All rights reserved.
//

#import "YAddTagToolBar.h"
#import "YAddTagViewController.h"

@interface YAddTagToolBar()

@property (weak, nonatomic) IBOutlet UIView *topView;

/** 存放所有Lable */
@property (nonatomic, strong) NSMutableArray *tagLables;

/** 添加按钮 */
@property (nonatomic, weak) UIButton *addButton;

@end

@implementation YAddTagToolBar

#pragma mark - lazy
- (NSArray *)tagLables
{
    if (!_tagLables) {
        _tagLables = [NSMutableArray array];
    }
    return _tagLables;
}

- (void)awakeFromNib
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"tag_add_icon"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    button.size = button.currentImage.size;
    button.x = YCellMargin;
    
    [self.topView addSubview:button];
    self.addButton = button;
}

- (void)buttonClick
{
    __weak typeof(self) weakSelf = self;
    YAddTagViewController *addTagVC = [[YAddTagViewController alloc] init];
    
    // 根据block传过来的标签文字创建标签Lable
    [addTagVC setTagsBlock:^(NSArray *tagButtons) {
        [weakSelf creatTagLable:tagButtons];
    }];
    
    addTagVC.tags = [self.tagLables valueForKey:@"text"];
    
    UIViewController *rootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UINavigationController *NAV = (UINavigationController *)rootVC.presentedViewController;
    [NAV pushViewController:addTagVC animated:YES];
}

/**
 *  创建标签按钮
 *
 *  @param tags 按钮
 */
- (void)creatTagLable:(NSArray *)tags
{
    // 数组中的对象都执行removeFromSuperview
    [self.tagLables makeObjectsPerformSelector:@selector(removeFromSuperview)];
    // 将数组清空
    [self.tagLables removeAllObjects];
    for (NSInteger i = 0; i < tags.count; i++) {
        // 取出标签按钮
        UILabel *lable = [[UILabel alloc] init];
        lable.text = tags[i];
        lable.backgroundColor = [UIColor blueColor];
        lable.textColor = [UIColor whiteColor];
        lable.font = [UIFont systemFontOfSize:14];
        [self.topView addSubview:lable];
        [self.tagLables addObject:lable];
        
        lable.width = [lable.text sizeWithAttributes:@{NSFontAttributeName : lable.font}].width;
        lable.height = 25;
        if (i == 0) {
            lable.x = YTagMargin;
            lable.y = 0;
        } else {
            // 取出最后按钮之前一个按钮
            UILabel *lastLable = self.tagLables[i - 1];
            // 计算当前行左边的宽度
            CGFloat leftWidth = CGRectGetMaxX(lastLable.frame) + YTagMargin;
            // 计算当前行右边的宽度
            CGFloat rightWidth = self.width - leftWidth;
            
            // 判断右边宽度是否够按钮使用
            if (rightWidth > lable.width) { // 够用
                lable.x = leftWidth;
                lable.y = lastLable.y;
            } else {
                lable.x = YTagMargin;
                lable.y = lastLable.y + YTagMargin + YTagH;
            }
        }
    }
    
    // 更新addbutton的frame
    UILabel *lastlable = self.tagLables.lastObject;
    // 计算当前行左边的宽度
    CGFloat leftWidth = CGRectGetMaxX(lastlable.frame) + YTagMargin;
    CGFloat rightWidth = self.width - leftWidth;
    if (rightWidth >= 100) {
        self.addButton.x = leftWidth;
        self.addButton.y = lastlable.y;
    } else {
        self.addButton.x = 0;
        self.addButton.y = self.addButton.y + YTagH;
    }
}


@end
