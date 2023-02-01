//
//  HHLoginPrivacyViewController.m
//  HashdeepHotel
//
//  Created by Cindy on 2022/11/24.
//

#import "HHLoginPrivacyViewController.h"

@interface HHLoginPrivacyViewController ()

@end

@implementation HHLoginPrivacyViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = kWhiteColor;
    
    //自定义导航栏
    [self _createdNavigationBar];
    
    WKWebView *webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, UINavigateHeight, kScreenWidth, kScreenHeight-UINavigateHeight)];
    webView.scrollView.bounces = NO; //不要有反弹效果
    [self.view addSubview:webView];
    
    NSURL *url = [NSURL URLWithString:@"https://www.anzhuhui.com/protocol4.html"];
    NSURLRequest *reuqest = [NSURLRequest requestWithURL:url];
    [webView loadRequest:reuqest];
    
}

#pragma mark -----------------------自定义导航栏-----------------------
- (void)_createdNavigationBar {
    
    [self createdNavigationBackButton];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"安住会隐私政策";
    titleLabel.textColor = XLColor_mainTextColor;
    titleLabel.font = KBoldFont(18);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.offset(UINavigateTop+10);
        make.height.offset(20);
    }];
}

- (void)backButtonAction {
    if ([self.type isEqualToString:@"1"]) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else {
        [self.navigationController popViewControllerAnimated:YES];
        if(self.backAction){
            self.backAction();
        }
    }
    
}

@end
