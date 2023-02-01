//
//  HHMyView.m
//  HashdeepHotel
//
//  Created by Cindy on 2022/7/12.
//

#import "HHMyView.h"
@interface HHMyView()
@property (nonatomic, strong) UIView *centerWhiteView;
@property (nonatomic, strong) UIView *bottomWhiteView;
@property (nonatomic, strong) UILabel *tipLabel;
@property (nonatomic, strong) UIView *progressNormalView;
@property (nonatomic, strong) UILabel *gradeEquityLabel;
@property (nonatomic, strong) UILabel *allLabel;
@property (nonatomic, strong) UIView *equityView;

@property (nonatomic, assign) CGFloat topWhiteHeight;
@property (nonatomic, assign) CGFloat equityHeight;
@property (nonatomic, strong) UIButton *allButton;
@property (nonatomic, strong) UIImageView *openImageView;
@end

@implementation HHMyView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self _addSubViews];
    }
    return self;
}

- (void)_addSubViews{
    UIView *topBGView = [[UIView alloc] init];
    CAGradientLayer *gradLayer = [CAGradientLayer layer];
    [gradLayer setStartPoint:CGPointMake(1,0)];
    [gradLayer setEndPoint:CGPointMake(1,1.0f)];
    [gradLayer setFrame:CGRectMake(0,0, kScreenWidth,kScreenHeight)];
    gradLayer.locations = @[@(0.0),@(1.0)];//渐变点
    [gradLayer setColors:@[(id)[RGBColor(243, 243, 243) CGColor],(id)[RGBColor(227, 199, 190) CGColor]]];//渐变数组
    [topBGView.layer insertSublayer:gradLayer atIndex:0];
    [self addSubview:topBGView];
    [topBGView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.offset(0);
    }];
    
    
    UIButton *noticeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [noticeButton setImage:HHGetImage(@"icon_home_notice_black") forState:UIControlStateNormal];
    [noticeButton addTarget:self action:@selector(noticeButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:noticeButton];
    [noticeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-60);
        make.top.offset(UINavigateTop+5);
        make.width.height.offset(20);
    }];
    
    self.unreadNumberLabel = [[UILabel alloc] init];
    self.unreadNumberLabel.textColor = kWhiteColor;
    self.unreadNumberLabel.backgroundColor = kRedColor;
    self.unreadNumberLabel.layer.cornerRadius = 7;
    self.unreadNumberLabel.font = XLFont_subSubTextFont;
    self.unreadNumberLabel.textAlignment = NSTextAlignmentCenter;
    self.unreadNumberLabel.layer.masksToBounds = YES;
    [noticeButton addSubview:self.unreadNumberLabel];
    [self.unreadNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(10);
        make.top.offset(-5);
        make.width.height.offset(0);
    }];
    
    UIButton *setupButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [setupButton setImage:HHGetImage(@"icon_my_setup") forState:UIControlStateNormal];
    [setupButton addTarget:self action:@selector(setupButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:setupButton];
    [setupButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-15);
        make.top.offset(UINavigateTop+5);
        make.width.height.offset(20);
    }];
    
    [self createdTopWhiteUI];
    
    [self createdCenterWhiteUI];
    
    [self createdBottomWhiteUI];
    
}

- (void)createdTopWhiteUI {
    self.topWhiteView = [[UIView alloc] init];
    self.topGradLayer = [CAGradientLayer layer];
    [self.topGradLayer setStartPoint:CGPointMake(1,1.0f)];
    [self.topGradLayer setEndPoint:CGPointMake(0,0)];
    [self.topGradLayer setFrame:CGRectMake(0,0,kScreenWidth,260)];
    self.topGradLayer.locations = @[@(0.1),@(1.1)];//渐变点
    [self.topGradLayer setColors:@[(id)[RGBColor(171, 217, 253) CGColor],(id)[RGBColor(233, 231, 239) CGColor]]];//渐变数组
    [self.topWhiteView.layer insertSublayer:self.topGradLayer atIndex:0];
    self.topWhiteView.layer.cornerRadius = 12;
    self.topWhiteView.layer.masksToBounds = YES;
    [self addSubview:self.topWhiteView];
    [self.topWhiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.offset(-15);
        make.top.offset(UINavigateHeight);
        make.height.offset(260);
    }];
    
    UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [infoButton addTarget:self action:@selector(infoButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.topWhiteView addSubview:infoButton];
    [infoButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.offset(0);
        make.height.offset(15+48);
    }];
    
    self.headerImageView = [[UIImageView alloc] init];
    self.headerImageView.layer.cornerRadius = 24;
    self.headerImageView.layer.masksToBounds = YES;
    self.headerImageView.contentMode = UIViewContentModeScaleAspectFill;
    [infoButton addSubview:self.headerImageView];
    [self.headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.top.offset(15);
        make.height.width.offset(48);
    }];
    
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.font = KBoldFont(20);
    self.nameLabel.textColor = XLColor_mainTextColor;
    [infoButton addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerImageView.mas_right).offset(12);
        make.top.offset(15);
        make.height.offset(20);
        make.width.offset(100);
    }];
    
    self.gradeImageView = [[UIImageView alloc] init];
    [infoButton addSubview:self.gradeImageView];
    [self.gradeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_right).offset(5);
        make.top.offset(15+2);
        make.height.offset(16);
        make.width.offset(27);
    }];
    
    self.gradeLabel = [[UILabel alloc] init];
    self.gradeLabel.font = XLFont_subSubTextFont;
    self.gradeLabel.layer.cornerRadius = 5;
    self.gradeLabel.layer.masksToBounds = YES;
    self.gradeLabel.layer.borderColor = XLColor_subTextColor.CGColor;
    self.gradeLabel.layer.borderWidth = 1;
    self.gradeLabel.textAlignment = NSTextAlignmentCenter;
    self.gradeLabel.textColor = XLColor_mainTextColor;
    [infoButton addSubview:self.gradeLabel];
    [self.gradeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerImageView.mas_right).offset(12);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(5);
        make.height.offset(17);
        make.width.offset(60);
    }];
    
    UILabel *permanentUnlockingLabel = [[UILabel alloc] init];
    permanentUnlockingLabel.text = @"永久解锁";
    permanentUnlockingLabel.textColor = XLColor_mainTextColor;
    permanentUnlockingLabel.font = XLFont_subSubTextFont;
    [self.topWhiteView addSubview:permanentUnlockingLabel];
    [permanentUnlockingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.offset(-15);
        make.height.offset(15);
        make.top.equalTo(infoButton.mas_bottom).offset(12);
    }];
    
    self.progressNormalView = [[UIView alloc] init];
    self.progressNormalView.backgroundColor = UIColorHex(E6F2FC);
    self.progressNormalView.layer.cornerRadius = 5;
    self.progressNormalView.layer.masksToBounds = YES;
    [self.topWhiteView addSubview:self.progressNormalView];
    [self.progressNormalView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.offset(-15);
        make.height.offset(10);
        make.top.equalTo(permanentUnlockingLabel.mas_bottom).offset(10);
    }];
    
    self.tipLabel = [[UILabel alloc] init];
    self.tipLabel.font = KFont(10);
    self.tipLabel.textColor = XLColor_mainTextColor;
    [self.topWhiteView addSubview:self.tipLabel];
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.top.equalTo(self.progressNormalView.mas_bottom).offset(7);
        make.height.offset(15);
        make.right.offset(-15);
    }];
    
    self.gradeEquityLabel = [[UILabel alloc] init];
    self.gradeEquityLabel.font = XLFont_subTextFont;
    self.gradeEquityLabel.textColor = XLColor_mainTextColor;
    [self.topWhiteView addSubview:self.gradeEquityLabel];
    [self.gradeEquityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.top.equalTo(self.tipLabel.mas_bottom).offset(10);
        make.height.offset(15);
        make.right.offset(-100);
    }];
    
    self.allButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.allButton addTarget:self action:@selector(allButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.topWhiteView addSubview:self.allButton];
    [self.allButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-15);
        make.width.offset(70);
        make.height.offset(20);
        make.top.equalTo(self.tipLabel.mas_bottom).offset(10);
    }];
    
    self.allLabel =  [[UILabel alloc] init];
    self.allLabel.font = XLFont_subSubTextFont;
    self.allLabel.textColor = XLColor_mainTextColor;
    [self.allButton addSubview:self.allLabel];
    [self.allLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.offset(0);
        make.width.offset(60);
    }];
    
    self.openImageView = [[UIImageView alloc] init];
    self.openImageView.image = HHGetImage(@"icon_my_member_down");
    self.openImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.allButton addSubview:self.openImageView];
    [self.openImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.allLabel.mas_right).offset(4);
        make.centerY.equalTo(self.allButton);
        make.height.offset(10);
        make.width.offset(15);
    }];
    
    self.equityView = [[UIView alloc] init];
    [self.topWhiteView addSubview:self.equityView];
    [self.equityView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.equalTo(self.gradeEquityLabel.mas_bottom).offset(10);
        make.height.offset(80);
    }];
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"isLogin"]) {
        self.nameLabel.text = @"注册/登录";
        CGFloat nameWidth = [LabelSize widthOfString:@"注册/登录" font:KBoldFont(20) height:20];
        [self.nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.offset(nameWidth+1);
        }];
        [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:[HashMainData shareInstance].user_head_img]];
        [self.topWhiteView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset(70);
        }];
        
    }else {
        self.nameLabel.text = [UserInfoManager sharedInstance].userNickName;
        CGFloat nameWidth = [LabelSize widthOfString:[UserInfoManager sharedInstance].userNickName font:KBoldFont(20) height:20];
        [self.nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.offset(nameWidth+1);
        }];
        
        [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:[UserInfoManager sharedInstance].headImageStr]];
        [self.topWhiteView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset(247);
        }];
    }
}

- (void)createdCenterWhiteUI {
    self.centerWhiteView = [[UIView alloc] init];
    self.centerWhiteView.backgroundColor = kWhiteColor;
    self.centerWhiteView.layer.cornerRadius = 12;
    self.centerWhiteView.layer.masksToBounds = YES;
    [self addSubview:self.centerWhiteView];
    [self.centerWhiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.offset(-15);
        make.top.equalTo(self.topWhiteView.mas_bottom).offset(15);
        make.height.offset(80);
    }];
    
    NSArray *titleArray = @[@"全部订单", @"待支付", @"待入住", @"待评价"];
    NSArray *imageArray = @[@"icon_my_order", @"icon_my_waitPayment", @"icon_my_goin", @"icon_my_waitCommen"];
    int xLeft = 0;
    for (int i=0; i<titleArray.count; i++) {
        NSString *title = titleArray[i];
        NSString *imageStr = imageArray[i];
        
        UIView *superView = [[UIView alloc] init];
        if (xLeft+(kScreenWidth-30)/4 > kScreenWidth-30) {
            xLeft = 0;
        }
        superView.frame = CGRectMake(xLeft, 10, (kScreenWidth-30)/4, 60);
        [self.centerWhiteView addSubview:superView];
        xLeft = xLeft+(kScreenWidth-30)/4;
        
        UIImageView *imgView = [[UIImageView alloc] init];
        imgView.userInteractionEnabled = YES;
        imgView.image = HHGetImage(imageStr);
        [superView addSubview:imgView];
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.offset(25);
            make.height.offset(25);
            make.top.offset(7);
            make.centerX.equalTo(superView);
        }];
        
        UILabel *label = [[UILabel alloc] init];
        label.text = title;
        label.userInteractionEnabled = YES;
        label.textColor = XLColor_mainTextColor;
        label.font = XLFont_subSubTextFont;
        label.textAlignment = NSTextAlignmentCenter;
        [superView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.offset(0);
            make.height.offset(15);
            make.top.equalTo(imgView.mas_bottom).offset(5);
        }];
    }
    
    int button_xLeft = 0;
    int button_yBottom = 10;
    for (int i=0; i<titleArray.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = i;
        if (button_xLeft+(kScreenWidth-30)/4 > kScreenWidth-30) {
            button_xLeft = 0;
            button_yBottom  = button_yBottom+5+60;
        }
        button.frame = CGRectMake(button_xLeft, button_yBottom, (kScreenWidth-30)/4, 60);
        [button addTarget:self action:@selector(centerButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.centerWhiteView addSubview:button];
        button_xLeft = button_xLeft+(kScreenWidth-30)/4;
    }
    
    
}

- (void)createdBottomWhiteUI {
    self.bottomWhiteView = [[UIView alloc] init];
    self.bottomWhiteView.backgroundColor = kWhiteColor;
    self.bottomWhiteView.layer.cornerRadius = 12;
    self.bottomWhiteView.layer.masksToBounds = YES;
    [self addSubview:self.bottomWhiteView];
    [self.bottomWhiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.offset(-15);
        make.top.equalTo(self.centerWhiteView.mas_bottom).offset(15);
        make.height.offset(150);
    }];
    
    NSArray *titleArray = @[@"收藏", @"最近浏览", @"意见反馈", @"我的发票", @"在线客服"];
    NSArray *imageArray = @[@"icon_my_collection", @"icon_my_browsing", @"icon_my_feedback", @"icon_my_invoice", @"icon_my_customer"];
    
    int xLeft = 0;
    int yBottom = 10;
    for (int i=0; i<titleArray.count; i++) {
        NSString *title = titleArray[i];
        NSString *imageStr = imageArray[i];
        
        UIView *superView = [[UIView alloc] init];
        if (xLeft+(kScreenWidth-30)/4 > kScreenWidth-30) {
            xLeft = 0;
            yBottom  = yBottom+5+60;
        }
        superView.frame = CGRectMake(xLeft, yBottom, (kScreenWidth-30)/4, 60);
        [self.bottomWhiteView addSubview:superView];
        xLeft = xLeft+(kScreenWidth-30)/4;
        
        UIImageView *imgView = [[UIImageView alloc] init];
        imgView.userInteractionEnabled = YES;
        imgView.image = HHGetImage(imageStr);
        [superView addSubview:imgView];
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.offset(25);
            make.height.offset(25);
            make.top.offset(7);
            make.centerX.equalTo(superView);
        }];
        
        UILabel *label = [[UILabel alloc] init];
        label.text = title;
        label.userInteractionEnabled = YES;
        label.textColor = XLColor_mainTextColor;
        label.font = XLFont_subSubTextFont;
        label.textAlignment = NSTextAlignmentCenter;
        [superView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.offset(0);
            make.height.offset(15);
            make.top.equalTo(imgView.mas_bottom).offset(5);
        }];
    }
    
    int button_xLeft = 0;
    int button_yBottom = 10;
    for (int i=0; i<titleArray.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = i;
        if (button_xLeft+(kScreenWidth-30)/4 > kScreenWidth-30) {
            button_xLeft = 0;
            button_yBottom  = button_yBottom+5+60;
        }
        button.frame = CGRectMake(button_xLeft, button_yBottom, (kScreenWidth-30)/4, 60);
        [button addTarget:self action:@selector(bottomButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.bottomWhiteView addSubview:button];
        button_xLeft = button_xLeft+(kScreenWidth-30)/4;
    }
}

- (void)infoButtonAction {
    if (self.clickGoinftButtonAction) {
        self.clickGoinftButtonAction();
    }
}

- (void)setupButtonAction {
    if (self.clickSetupButtonAction) {
        self.clickSetupButtonAction();
    }
}

- (void)noticeButtonAction {
    if (self.clickNoticeButtonAction) {
        self.clickNoticeButtonAction();
    }
}

- (void)centerButtonAction:(UIButton *)button {
    if (self.clickCenterButtonAction) {
        self.clickCenterButtonAction(button.tag);
    }
}

- (void)bottomButtonAction:(UIButton *)button {
    if (self.clickBottomButtonAction) {
        self.clickBottomButtonAction(button.tag);
    }
}


- (void)updateUIForData:(NSDictionary *)data {
    
    for (UIView *view in self.equityView.subviews) {
        [view removeFromSuperview];
    }
    
    [self.gradeImageView sd_setImageWithURL:[NSURL URLWithString:data[@"member_icon"]]];
    self.gradeLabel.text = data[@"member_level"];
    self.tipLabel.text = data[@"point_desc"];
    self.gradeEquityLabel.text = data[@"member_level_desc"];
    
    NSArray *benefits = data[@"benefits"];
    self.allLabel.text = [NSString stringWithFormat:@"全部%ld项",benefits.count];
    CGFloat allWidth = [LabelSize widthOfString:[NSString stringWithFormat:@"全部%ld项",benefits.count] font:XLFont_subSubTextFont height:20];
    [self.allLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.offset(allWidth+1);
    }];
    [self.allButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.offset(allWidth+20);
    }];
    
    if(benefits.count != 0){
        
        int xleft = 0;
        int ybottom = 0;
        int lineNumber = 1;
        for (int i=0; i<benefits.count; i++) {
            NSDictionary *dic = benefits[i];
            if(xleft >= kScreenWidth-50){
                xleft = 0;
                lineNumber++;
                ybottom = 80+15;
            }
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [self.equityView addSubview:button];
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.offset(xleft);
                make.width.offset((kScreenWidth-30)/5);
                make.height.offset(80);
                make.top.offset(ybottom);
            }];
            
            UIImageView *imgView = [[UIImageView alloc] init];
            [imgView sd_setImageWithURL:[NSURL URLWithString:dic[@"icon"]]];
            [button addSubview:imgView];
            [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(button);
                make.top.offset(0);
                make.width.height.offset(40);
            }];
            
            UILabel *centerLabel = [[UILabel alloc] init];
            centerLabel.text = dic[@"benefit_name"];
            centerLabel.font = XLFont_subSubTextFont;
            centerLabel.textColor = XLColor_mainTextColor;
            centerLabel.textAlignment = NSTextAlignmentCenter;
            [button addSubview:centerLabel];
            [centerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(imgView.mas_bottom).offset(5);
                make.height.offset(15);
                make.left.right.offset(0);
            }];
            
            UILabel *bottomLabel = [[UILabel alloc] init];
            bottomLabel.text = dic[@"benefit_title"];
            bottomLabel.font = XLFont_subSubTextFont;
            bottomLabel.textColor = XLColor_mainTextColor;
            bottomLabel.textAlignment = NSTextAlignmentCenter;
            [button addSubview:bottomLabel];
            [bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(centerLabel.mas_bottom).offset(5);
                make.height.offset(15);
                make.left.right.offset(0);
            }];
            
            UIView *bottomView = [[UIView alloc] init];
            bottomView.layer.cornerRadius = 7;
            bottomView.layer.masksToBounds = YES;
            bottomView.backgroundColor = [UIColor colorWithHexString:dic[@"icon_color"]];
            [button addSubview:bottomView];
            [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(centerLabel.mas_bottom).offset(5);
                make.height.offset(14);
                make.width.offset(50);
                make.centerX.equalTo(button);
            }];
            
            UIImageView *lockImageView = [[UIImageView alloc] init];
            lockImageView.image = HHGetImage(@"icon_my_lock");
            [bottomView addSubview:lockImageView];
            [lockImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.offset(7);
                make.centerY.equalTo(bottomView);
                make.width.offset(6);
                make.height.offset(8);
            }];
            
            UILabel *titleLabel = [[UILabel alloc] init];
            titleLabel.text = dic[@"benefit_title"];
            titleLabel.font = XLFont_subSubTextFont;
            titleLabel.textColor = XLColor_mainTextColor;
            titleLabel.textAlignment = NSTextAlignmentCenter;
            [bottomView addSubview:titleLabel];
            [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(lockImageView.mas_right).offset(3);
                make.top.bottom.offset(0);
                make.right.offset(0);
            }];
            
            BOOL is_lock = [NSString stringWithFormat:@"%@", dic[@"is_lock"]].boolValue;
            if(is_lock){
                bottomLabel.hidden = YES;
                bottomView.hidden = NO;
            }else {
                bottomLabel.hidden = NO;
                bottomView.hidden = YES;
            }
            xleft = xleft+(kScreenWidth-30)/5;
        }
        
        
        self.equityHeight = lineNumber*80;
        [self.equityView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset(lineNumber*80);
        }];
        
        [self layoutIfNeeded];
        self.topWhiteHeight = CGRectGetMaxY(self.equityView.frame);
        
    }
    
}

- (void)allButtonAction:(UIButton *)button {
    button.selected = !button.selected;
    if(button.selected){
        self.openImageView.image = HHGetImage(@"icon_my_member_up");
        [self.topWhiteView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset(self.topWhiteHeight+30);
        }];

        [self.topGradLayer setFrame:CGRectMake(0,0,kScreenWidth,self.topWhiteHeight+30)];
    }else {
        self.openImageView.image = HHGetImage(@"icon_my_member_down");
        [self.topWhiteView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset(260);
        }];

        [self.topGradLayer setFrame:CGRectMake(0,0,kScreenWidth,260)];
    }
}
@end
