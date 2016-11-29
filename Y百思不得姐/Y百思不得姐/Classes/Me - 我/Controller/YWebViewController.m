//
//  YWebViewController.m
//  Y百思不得姐
//
//  Created by wyw on 16/7/4.
//  Copyright © 2016年 qw. All rights reserved.
//

#import "YWebViewController.h"
#import "NJKWebViewProgress.h"

@interface YWebViewController ()<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *goBack;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *goFoword;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;

/** 进度代理对象 */
@property (nonatomic, strong) NJKWebViewProgress *progress;

@end

@implementation YWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 进度条
    self.progress = [[NJKWebViewProgress alloc] init];
    self.webView.delegate = self.progress;
    __weak typeof(self) weakSelf = self;
    self.progress.progressBlock = ^(float progress){
        weakSelf.progressView.progress = progress;
    };
    self.progress.webViewProxyDelegate = self;
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
}

- (IBAction)goBack:(id)sender {
    [self.webView goBack];
    
}
- (IBAction)goFoword:(id)sender {
    
    [self.webView goForward];
}
- (IBAction)refresh:(id)sender {
    
    [self.webView reload];
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    YLogFunc;
    self.goBack.enabled = webView.canGoBack;
    self.goFoword.enabled = webView.canGoForward;
}

@end
