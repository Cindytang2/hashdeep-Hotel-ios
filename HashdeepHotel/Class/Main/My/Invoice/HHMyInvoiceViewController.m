//
//  HHMyInvoiceViewController.m
//  HashdeepHotel
//
//  Created by Cindy on 2022/8/4.
//

#import "HHMyInvoiceViewController.h"

@interface HHMyInvoiceViewController ()

@end

@implementation HHMyInvoiceViewController

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
    
    [self _createdViews];
    
}

#pragma mark -----------------------自定义导航栏-----------------------
- (void)_createdNavigationBar {
    
    [self createdNavigationBackButton];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"我的发票";
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

- (void)_createdViews {
    UIImageView *imgView = [[UIImageView alloc] init];
    imgView.image = HHGetImage(@"icon_my_invoice_nodata");
    [self.view addSubview:imgView];
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(150);
        make.height.offset(100);
        make.centerX.equalTo(self.view);
        make.top.offset((kScreenHeight-UINavigateHeight-150)/2);
    }];
    
    UILabel *label = [[UILabel alloc] init];
    label.textColor = XLColor_mainTextColor;
    label.text = @"暂无发票信息";
    label.font = XLFont_mainTextFont;
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.height.offset(20);
        make.top.equalTo(imgView.mas_bottom).offset(15);
    }];
}

@end
