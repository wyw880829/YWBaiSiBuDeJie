//
//  YAddTagViewController.m
//  Y百思不得姐
//
//  Created by wyw on 16/7/5.
//  Copyright © 2016年 qw. All rights reserved.
//

#import "YAddTagViewController.h"
#import "YTagButton.h"
#import "SVProgressHUD.h"
#import "YTagTextField.h"

@interface YAddTagViewController ()<UITextFieldDelegate>
/** 内容view */
@property (nonatomic, weak) UIView *contentView;

/** 输入框 */
@property (nonatomic, weak) UITextField *textField;

/** 添加按钮 */
@property (nonatomic, weak) UIButton *addButton;

/** 所有的标签按钮 */
@property (nonatomic, strong) NSMutableArray *tagButtons;

@end

@implementation YAddTagViewController

#pragma mark - lazy
- (NSMutableArray *)tagButtons
{
    if (!_tagButtons) {
        _tagButtons = [NSMutableArray array];
    }
    return _tagButtons;
}

/**
 *  addbutton get方法
 */
- (UIButton *)addButton
{
    if (!_addButton) {
        UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        addButton.width = self.contentView.width;
        addButton.height = YTagH;
        addButton.y = CGRectGetMaxY(self.textField.frame) + YTagMargin;
        [addButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [addButton addTarget:self action:@selector(addButtonClick) forControlEvents:UIControlEventTouchUpInside];
        addButton.titleLabel.font = YTagFont;
        addButton.contentEdgeInsets = UIEdgeInsetsMake(0, YTagMargin, 0, YTagMargin);
        // 让按钮内部的文字和图片都左对齐
        addButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        addButton.backgroundColor = YTagBG;
        [self.contentView addSubview:addButton];
        _addButton = addButton;
    }
    return _addButton;
}

#pragma mark - 初始化
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNav];
    
    [self setupContentView];
    
    [self setupTextField];
    
    // 根据标签创建标签按钮
    [self setupTags];
    
}

/**
 *  根据上个页面传进来的标签创建标签按钮
 */
- (void)setupTags
{
    for (NSString *text in self.tags) {
        self.textField.text = text;
        [self addButtonClick];
    }
}

/**
 *  初始化根页面
 */
- (void)setupContentView
{
    UIView *contentView = [[UIView alloc] init];
    contentView.x = YCellMargin;
    contentView.y = 64 + YCellMargin;
    contentView.width = self.view.width - 2*contentView.x;
    contentView.height = SCREENHEIGHT;
    
    [self.view addSubview:contentView];
    self.contentView = contentView;
}

/**
 *  初始化文本输入框
 */
- (void)setupTextField
{
    YTagTextField *textField = [[YTagTextField alloc] init];
    textField.width = self.contentView.width;
    textField.height = 25;
    
    textField.delegate = self;
    
    __weak typeof(self) weakSelf = self;
    [textField setDeleteBlock:^{
        if (weakSelf.textField.hasText) return ;
        // 获取最后一个按钮
        UIButton *lastButton = weakSelf.tagButtons.lastObject;
        [weakSelf tagButtonClick:lastButton];
    }];
    
    textField.backgroundColor = [UIColor redColor];
    [textField addTarget:self action:@selector(textFieldChange) forControlEvents:UIControlEventEditingChanged];
    textField.backgroundColor = [UIColor greenColor];
    [self.contentView addSubview:textField];
    self.textField = textField;
    [self.textField becomeFirstResponder];
}

/**
 *  初始化导航栏
 */
- (void)setupNav
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"添加标签";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(done)];
}

/**
 *  点击完成按钮事件
 */
- (void)done
{
    // 传递按钮上的文字给tagBlock
    NSArray *tags = [self.tagButtons valueForKey:@"currentTitle"];
    !self.tagsBlock ? : self.tagsBlock(tags);
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 监听textfield文字改变
/**
 *  textField文字改变
 */
- (void)textFieldChange
{
    if (self.textField.hasText) {
        self.addButton.hidden = NO;
        [self.addButton setTitle:[NSString stringWithFormat:@"添加标签:%@",self.textField.text] forState:UIControlStateNormal];
        
    } else {
        self.addButton.hidden = YES;
    }
}

#pragma mark - 按钮点击事件
/**
 *  添加标签按钮
 */
- (void)addButtonClick
{
    if (self.tagButtons.count >= 5) {
        [SVProgressHUD showErrorWithStatus:@"最多添加5个标签"];
        return;
    }
    
    YTagButton *tagButton = [YTagButton buttonWithType:UIButtonTypeCustom];
    [tagButton setTitle:self.textField.text forState:UIControlStateNormal];
    
    [tagButton addTarget:self action:@selector(tagButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.contentView addSubview: tagButton];
    [self.tagButtons addObject:tagButton];
    
    // 更新按钮的尺寸
    [UIView animateWithDuration:0.25 animations:^{
        [self updateTagButtonFrame];
        [self updateTextFieldFrame];
        [self updateAddButtonFrame];
    }];
    [self.addButton setTitle:@"" forState:UIControlStateNormal];
    self.textField.text = @"";
    self.addButton.hidden = YES;
}

- (void)tagButtonClick:(UIButton *)tagButton
{
    [UIView animateWithDuration:0.25 animations:^{
        [tagButton removeFromSuperview];
        [self.tagButtons removeObject:tagButton];
        [self updateTagButtonFrame];
        [self updateTextFieldFrame];
        [self updateAddButtonFrame];
    }];
}

#pragma mark - 更新frame

/**
 *  更新tagbutton的尺寸
 */
- (void)updateTagButtonFrame
{
    for (NSInteger i = 0; i < self.tagButtons.count; i++) {
        
        // 取出标签按钮
        UIButton *button = self.tagButtons[i];
        button.height = 25;
        if (i == 0) {
            button.x = 0;
            button.y = 0;
        } else {
            // 取出最后按钮之前一个按钮
            UIButton *lastButton = self.tagButtons[i - 1];
            // 计算当前行左边的宽度
            CGFloat leftWidth = CGRectGetMaxX(lastButton.frame) + YTagMargin;
            // 计算当前行右边的宽度
            CGFloat rightWidth = self.contentView.width - leftWidth;
            
            // 判断右边宽度是否够按钮使用
            if (rightWidth > button.width) { // 够用
                button.x = leftWidth;
                button.y = lastButton.y;
            } else {
                button.x = 0;
                button.y = lastButton.y + YTagMargin + YTagH;
            }
        }
    }
}

/**
 *  更新textField的尺寸
 */
- (void)updateTextFieldFrame
{
    YTagButton *lastTagButton = self.tagButtons.lastObject;
    CGFloat leftWidth = CGRectGetMaxX(lastTagButton.frame) + YTagMargin;
    
    if ((self.contentView.width - leftWidth) > [self textFieldWidth] ) {
        self.textField.x = leftWidth + YTagMargin;
        self.textField.y = lastTagButton.y;
        self.textField.width = self.contentView.width - leftWidth;
    } else {
        self.textField.x = 0;
        self.textField.y = CGRectGetMaxY(lastTagButton.frame) + YTagMargin;
    }
}

/**
 *  textField的宽度（最少为100）
 */
- (CGFloat)textFieldWidth
{
    CGFloat width = [self.textField.text sizeWithAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]}].width;
    return MAX(100, width);
}

/**
 *  addButton的y值
 */
- (void)updateAddButtonFrame
{
  self.addButton.y = CGRectGetMaxY(self.textField.frame) + YTagMargin;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.hasText) {
        [self addButtonClick];
    }
    return YES;
    
}

@end

















