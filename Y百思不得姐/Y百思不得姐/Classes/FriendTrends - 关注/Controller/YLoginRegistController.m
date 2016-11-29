//
//  YLoginRegistController.m
//  Y百思不得姐
//
//  Created by wyw on 16/5/17.
//  Copyright © 2016年 qw. All rights reserved.
//

#import "YLoginRegistController.h"

@interface YLoginRegistController ()

@property (weak, nonatomic) IBOutlet UITextField *phoneField;
@property (weak, nonatomic) IBOutlet UITextField *pwdFiewd;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *loginViewLeftMargin;
@property (weak, nonatomic) IBOutlet UIView *loginBgView;

@end

@implementation YLoginRegistController

- (void)viewDidLoad {
    [super viewDidLoad];

//    NSMutableAttributedString *placeholder = [[NSMutableAttributedString alloc] initWithString:@"手机号哈哈"];
//    
//    [placeholder setAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]} range:NSMakeRange(0, 2)];
//    [placeholder setAttributes:@{NSForegroundColorAttributeName : [UIColor greenColor],
//                                 NSFontAttributeName:[UIFont systemFontOfSize:22]
//                                 } range:NSMakeRange(3, 2)];
//    
//    self.phoneField.attributedPlaceholder = placeholder;
    
}

- (IBAction)showLoginRegist:(UIButton *)sender {
    
    if (self.loginViewLeftMargin.constant == 0) {
        self.loginViewLeftMargin.constant = - self.view.width;
        sender.selected = YES;

    } else if (self.loginViewLeftMargin.constant == - self.view.width){
        self.loginViewLeftMargin.constant = 0;
        sender.selected = NO;
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutIfNeeded];
    }];
}

@end
