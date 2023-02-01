//
//  HHThirdListViewController.m
//  HashdeepHotel
//
//  Created by Cindy on 2022/8/3.
//

#import "HHThirdListViewController.h"

@interface HHThirdListViewController ()

@end

@implementation HHThirdListViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = kWhiteColor;
    
    //自定义导航栏
    [self _createdNavigationBar];
    
    
    // 获取路径
    NSString * path = [[NSBundle mainBundle] pathForResource:@"anzhuhuiSDK" ofType:@"html"];

    // 创建URL
    NSURL * url = [NSURL fileURLWithPath:path];

    // 创建NSURLRequest
    NSURLRequest * request = [NSURLRequest requestWithURL:url];

    WKWebView *webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, UINavigateHeight, kScreenWidth, kScreenHeight-UINavigateHeight)];
    webView.scrollView.bounces = NO; //不要有反弹效果
    [self.view addSubview:webView];
    
    // 加载
    [webView loadRequest:request];
    
}

#pragma mark -----------------------自定义导航栏-----------------------
- (void)_createdNavigationBar {
    
    [self createdNavigationBackButton];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"安住会与第三方共享个人信息清单";
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

@end
