//
//  HHBackView.m
//  HashdeepHotel
//
//  Created by Cindy on 2022/11/29.
//

#import "HHBackView.h"
@interface HHBackView ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *detailLabel;
;

@end
@implementation HHBackView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self _createdViews];
    }
    return self;
}

- (void)_createdViews {
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton addTarget:self action:@selector(backButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [leftButton setImage:HHGetImage(@"icon_my_setup_back") forState:UIControlStateNormal];
    [self addSubview:leftButton];
    [leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.offset(0);
        make.width.offset(50);
        make.height.offset(44);
    }];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.text = @"绑定手机号";
    self.titleLabel.textColor = XLColor_mainTextColor;
    self.titleLabel.font = KFont(22);
    self.titleLabel.hidden = YES;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.equalTo(leftButton.mas_bottom).offset(30);
        make.height.offset(30);
    }];
    
    self.detailLabel = [[UILabel alloc] init];
    self.detailLabel.text = @"根据法律规定，同时为保护您的账户安全，请您绑定手机号码";
    self.detailLabel.textColor = XLColor_mainTextColor;
    self.detailLabel.font = XLFont_subTextFont;
    self.detailLabel.numberOfLines = 0;
    self.detailLabel.hidden = YES;
    self.detailLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.detailLabel];
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(25);
        make.right.offset(-25);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(20);
        make.height.offset(40);
    }];
    
}

- (void)setType:(NSString *)type {
    _type = type;
    if([_type isEqualToString:@"bindMobileNumber"]) {
        self.detailLabel.hidden = NO;
        self.titleLabel.hidden = NO;
    }else {
        self.detailLabel.hidden = YES;
        self.titleLabel.hidden = YES;
    }
}
- (void)backButtonAction {
    if(self.clickBackAction){
        self.clickBackAction();
    }
}
@end
