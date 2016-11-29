//
//  YPostWordViewController.m
//  Y百思不得姐
//
//  Created by wyw on 16/7/4.
//  Copyright © 2016年 qw. All rights reserved.
//

#import "YPostWordViewController.h"
#import "YPlaceholderTextView.h"
#import "YAddTagToolBar.h"

@interface YPostWordViewController ()<UITextViewDelegate>

/** 文本输入控件 */
@property (nonatomic, weak) YPlaceholderTextView *textView;

/** 文本输入控件 */
@property (nonatomic, weak) YAddTagToolBar *toolBar;

@end

@implementation YPostWordViewController

- (void)viewDidLoad {
    
    self.view.backgroundColor = [UIColor redColor];
    
    [self setupNav];
    
    [self setupTextView];
    
    [self setupToolBar];

}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.textView becomeFirstResponder];
}

/**
 *  设置toolbar
 */
- (void)setupToolBar
{
    YAddTagToolBar *toolBar = [YAddTagToolBar viewFromXib];
    toolBar.width = self.view.width;
    toolBar.y = SCREENHEIGHT - toolBar.height;
    [self.view addSubview:toolBar];
    self.toolBar = toolBar;
    
    // 添加键盘通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)keyboardChange:(NSNotification *)note
{
    // 取出键盘最后状态的farme
   CGRect frame = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
   // 取出键盘状态改变的额动画时间
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView animateWithDuration:duration animations:^{
        self.toolBar.transform = CGAffineTransformMakeTranslation(0, frame.origin.y - SCREENHEIGHT);
    }];
}

/**
 *  配置textview
 */
- (void)setupTextView
{
    YPlaceholderTextView *textView = [[YPlaceholderTextView alloc] init];
    textView.frame = self.view.bounds;
    textView.delegate = self;
    textView.placeholder = @"把好玩的图片，好笑的段子或糗事发到这里，接受千万网友膜拜吧！发布违反国家法律内容的，我们将依法提交给有关部门处理。";
    [self.view addSubview:textView];
    
    self.textView = textView;
}

/**
 *  配置导航条
 */
- (void)setupNav
{
    self.title = @"发表文字";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(cancel)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发表" style:UIBarButtonItemStyleDone target:self action:@selector(post)];
    
    // 关闭发表按钮，强制刷新是为了使关闭生效，当使用了appearnce时，enabled效果会延迟
    self.navigationItem.rightBarButtonItem.enabled = NO;
    [self.navigationController.navigationBar layoutIfNeeded];
}

- (void)cancel
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)post
{

}

#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView
{
    self.navigationItem.rightBarButtonItem.enabled = textView.hasText;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

@end
