//
//  HHCancelOrderToastView.m
//  HashdeepHotel
//
//  Created by Cindy on 2022/7/22.
//

#import "HHCancelOrderToastView.h"
@interface HHCancelOrderToastView ()
@property (nonatomic, strong) UIView *whiteView;

@end
@implementation HHCancelOrderToastView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self _createdViews];
    }
    return self;
}
- (void)_createdViews {
    
    self.whiteView = [[UIView alloc] init];
    self.whiteView.backgroundColor = kWhiteColor;
    self.whiteView.layer.cornerRadius = 15;
    self.whiteView.layer.masksToBounds = YES;
    [self addSubview:self.whiteView];
    [self.whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(55);
        make.right.offset(-55);
        make.height.offset(140);
        make.top.offset((kScreenHeight-140)/2);
    }];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"订单取消成功!";
    titleLabel.textColor = XLColor_mainTextColor;
    titleLabel.font = KBoldFont(16);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.whiteView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.offset(0);
        make.height.offset(50);
    }];
    
    UILabel *subTitleLabel = [[UILabel alloc] init];
    subTitleLabel.text = @"已发退款，将在1-3个工作日内到帐";
    subTitleLabel.textColor = XLColor_mainTextColor;
    subTitleLabel.font = XLFont_subTextFont;
    subTitleLabel.textAlignment = NSTextAlignmentCenter;
    [self.whiteView addSubview:subTitleLabel];
    [subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.height.offset(20);
        make.top.equalTo(titleLabel.mas_bottom).offset(0);
    }];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.backgroundColor = XLColor_mainColor;
    [backButton setTitle:@"返回" forState:UIControlStateNormal];
    [backButton setTitleColor:XLColor_subTextColor forState:UIControlStateNormal];
    backButton.titleLabel.font = KBoldFont(14);
    [backButton addTarget:self action:@selector(backButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.whiteView addSubview:backButton];
    [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.offset(0);
        make.height.offset(45);
        make.width.offset((kScreenWidth-110)/2);
    }];
    
    UIButton *againButton = [UIButton buttonWithType:UIButtonTypeCustom];
    againButton.backgroundColor = UIColorHex(b58e7f);
    [againButton setTitle:@"重新预定该酒店" forState:UIControlStateNormal];
    [againButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
    againButton.titleLabel.font = KBoldFont(14);
    [againButton addTarget:self action:@selector(againButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.whiteView addSubview:againButton];
    [againButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.offset(0);
        make.height.offset(45);
        make.width.offset((kScreenWidth-110)/2);
    }];
    
}

- (void)againButtonAction {
    
    if(self.clickAgainAction){
        self.clickAgainAction();
    }
}

- (void)backButtonAction {
    
    if(self.clickBackAction){
        self.clickBackAction();
    }
}
@end
