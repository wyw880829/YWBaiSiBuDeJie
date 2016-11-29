//
//  YShowPictureViewController.m
//  Y百思不得姐
//
//  Created by wyw on 16/6/7.
//  Copyright © 2016年 qw. All rights reserved.
//

#import "YShowPictureViewController.h"
#import "UIImageView+WebCache.h"
#import "SVProgressHUD.h"
#import "YProgressView.h"

@interface YShowPictureViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) UIImageView *imageView;
@property (weak, nonatomic) IBOutlet YProgressView *progressView;

@end

@implementation YShowPictureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 马上显示当前图片的下载进度
    [self.progressView setProgress:self.topic.pictureProgress animated:YES];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backAction:)];
    [imageView addGestureRecognizer:tap];
    
    [self.scrollView addSubview:imageView];
    self.imageView = imageView;
    
    CGFloat pictureW = SCREENWIDTH;
    CGFloat pictureH = pictureW * self.topic.height / self.topic.width;
    
    if (pictureH > SCREENHEIGHT) { // 图片尺寸超出屏幕
        imageView.frame = CGRectMake(0, 0, pictureW, pictureH);
        self.scrollView.contentSize = CGSizeMake(0, pictureH);
    } else { // 图片尺寸不超出屏幕
        imageView.size = CGSizeMake(pictureW, pictureH);
        imageView.centerY = SCREENHEIGHT * 0.5;
    }
    
    [imageView sd_setImageWithURL:[NSURL URLWithString:self.topic.large_image] placeholderImage:nil options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        // 显示下载进度
        self.progressView.hidden = NO;
        [self.progressView setProgress:1.0*receivedSize/expectedSize animated:YES];

    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        self.progressView.hidden = YES;
        
    }];
}

- (IBAction)backAction:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)saveAction:(id)sender {
    // 没下载完毕就不能保存
    if (self.imageView.image == nil) {
        [SVProgressHUD showErrorWithStatus:@"图片没下载完"];
        return;
    }
    
    // 保存图片
    UIImageWriteToSavedPhotosAlbum(self.imageView.image, self, @selector(image: didFinishSavingWithError: contextInfo:),nil);
}
 
// 保存图片回调
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error) {
        [SVProgressHUD showErrorWithStatus:@"保存失败"];
    } else {
        [SVProgressHUD showSuccessWithStatus:@"保存成功"];
    }
}

- (IBAction)shareAction:(id)sender {
    
}

@end
