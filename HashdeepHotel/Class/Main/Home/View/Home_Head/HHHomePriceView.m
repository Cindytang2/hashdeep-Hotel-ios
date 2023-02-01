//
//  HHHomePriceView.m
//  HashdeepHotel
//
//  Created by Cindy on 2022/7/15.
//

#import "HHHomePriceView.h"
#import "TTRangeSlider.h"
#import "HashMainData.h"
@interface HHHomePriceView ()<TTRangeSliderDelegate>
@property (nonatomic, strong) UIView *whiteView;
@property (nonatomic, strong) UIView *dormitoryTopView;
@property (nonatomic, strong) UILabel *peopleNumberResultLabel;
@property (nonatomic, strong) UILabel *bedNumberResultLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) TTRangeSlider *rangeSlider;
@property (nonatomic, weak) UIButton *priceSelectedBt;
@property (nonatomic, weak) UIButton *timeSelectedBt;
@property (nonatomic, weak) UIButton *securitySelectedBt;
@property (nonatomic, strong) UIButton *againButton;
@property (nonatomic, strong) UIButton *queryButton;
@property (nonatomic, copy) NSString *resultPriceStr;
@property (nonatomic, copy) NSString *resultTimeStr;
@property (nonatomic, copy) NSString *resultsecurityStr;
@property (nonatomic, assign) CGFloat begin;
@property (nonatomic, assign) CGFloat end;
@property (nonatomic, assign) NSInteger detect_time;
@property (nonatomic, assign) CGFloat safe_star;
@property (nonatomic, strong) NSDictionary *dictionary;
@property (nonatomic, strong) UIView *priceSuperView;
@property (nonatomic, assign) BOOL isSlider;
@property (nonatomic, assign) BOOL isAgain;
@property (nonatomic, assign) NSInteger peopleNumber;
@property (nonatomic, assign) NSInteger bedNumber;
@end
@implementation HHHomePriceView
- (void)updateResultTimeStr:(NSString *)resultTimeStr detect_time:(NSInteger )detect_time {
    self.resultTimeStr = resultTimeStr;
    self.detect_time = detect_time;
}

- (void)updateResultsecurityStr:(NSString *)resultsecurityStr safe_star:(CGFloat )safe_star {
    self.resultsecurityStr = resultsecurityStr;
    self.safe_star = safe_star;
}

- (void)updateEnd:(CGFloat )end begin:(CGFloat )begin resultPriceStr:(NSString *)resultPriceStr{
    self.end = end;
    self.begin = begin;
    self.resultPriceStr = resultPriceStr;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = XLColor_mainColor;
        
        if([HashMainData shareInstance].timeStr.length != 0){
            [self updateResultTimeStr:[HashMainData shareInstance].timeResult detect_time:[HashMainData shareInstance].detect_time];
        }else {
            [self updateResultTimeStr:@"" detect_time:0];
        }
        
        if([HashMainData shareInstance].commentStr.length != 0){
            [self updateResultsecurityStr:[HashMainData shareInstance].securityResult safe_star:[HashMainData shareInstance].safe_star];
        }else {
            [self updateResultsecurityStr:@"" safe_star:0];
        }
        
        if([HashMainData shareInstance].allPriceStr.length != 0){
            if ([[HashMainData shareInstance].allPriceStr localizedCaseInsensitiveContainsString:@"~"]) {
                NSArray *array = [[HashMainData shareInstance].allPriceStr componentsSeparatedByString:@"~"]; //从字符A中分隔成2个元素的数组
                NSString *first = array.firstObject;
                NSString *last = array.lastObject;
                [self updateEnd:last.floatValue begin:first.floatValue resultPriceStr:[HashMainData shareInstance].allPriceStr];
                
            } else {
                NSArray *array = [[HashMainData shareInstance].allPriceStr componentsSeparatedByString:@"以上"]; //从字符A中分隔成2个元素的数组
                NSString *first = array.firstObject;
                [self updateEnd:0 begin:first.floatValue resultPriceStr:[HashMainData shareInstance].allPriceStr];
            }
        }else {
            [self updateEnd:0 begin:0 resultPriceStr:@""];
        }
        
        self.isAgain = NO;
        [self _addSubViews];
    }
    return self;
}
- (void)setType:(NSString *)type {
    _type = type;
    WeakSelf(weakSelf)
    [self createdUI];
    
    if ([_type isEqualToString:@"bottom"]) {
        [self.whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
            CGFloat h;
            if (UINavigateTop == 44) {
                h = weakSelf.isDormitory ? 565+60 : 565;
            }else {
                h = weakSelf.isDormitory ? 545+60 : 545;
            }
            make.height.offset(h);
            make.left.right.bottom.offset(0);
        }];
        
        if (UINavigateTop == 44) {
            CGFloat h = weakSelf.isDormitory ? 565+60 : 565;
            [HHAppManage mq_setRect:CGRectMake(0, 0, kScreenWidth, h) cornerRect:UIRectCornerTopLeft|UIRectCornerTopRight radius:20 view:self.whiteView];
            
        }else {
            CGFloat h = weakSelf.isDormitory ? 565+60 : 565;
            [HHAppManage mq_setRect:CGRectMake(0, 0, kScreenWidth, h) cornerRect:UIRectCornerTopLeft|UIRectCornerTopRight radius:20 view:self.whiteView];
        }
        
        self.againButton.layer.cornerRadius = 45/2.0;
        self.againButton.layer.masksToBounds = YES;
        self.againButton.backgroundColor = RGBColor(73, 73, 75);
        [self.againButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
        [self.againButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.offset(15);
            make.width.offset((kScreenWidth-60)/2);
            if (UINavigateTop == 44) {
                make.bottom.offset(-35);
            }else{
                make.bottom.offset(-15);
            }
            make.height.offset(45);
        }];
        
        self.queryButton.layer.cornerRadius = 45/2.0;
        self.queryButton.layer.masksToBounds = YES;
        self.queryButton.backgroundColor = XLColor_mainHHTextColor;
        [self.queryButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
        [self.queryButton setTitle:@"确定" forState:UIControlStateNormal];
        self.queryButton.titleLabel.font = KBoldFont(14);
        [self.queryButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.offset(-15);
            make.width.offset((kScreenWidth-60)/2);
            if (UINavigateTop == 44) {
                make.bottom.offset(-35);
            }else{
                make.bottom.offset(-15);
            }
            make.height.offset(45);
        }];
        self.lineView.hidden = YES;
    }else {
        [self.whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
            CGFloat h;
            if (UINavigateTop == 44) {
                h = weakSelf.isDormitory ? 535+60 : 535;
            }else {
                h = weakSelf.isDormitory ? 515+60 : 515;
            }
            make.height.offset(h);
            make.left.right.top.offset(0);
        }];
        self.lineView.hidden = NO;
        self.againButton.layer.cornerRadius = 0;
        self.againButton.layer.masksToBounds = YES;
        self.againButton.backgroundColor = kWhiteColor;
        [self.againButton setTitleColor:UIColorHex(b58e7f) forState:UIControlStateNormal];
        [self.againButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.offset(0);
            make.width.offset(150);
            make.bottom.offset(0);
            make.height.offset(50);
        }];
        self.queryButton.layer.cornerRadius = 0;
        self.queryButton.layer.masksToBounds = YES;
        [self.queryButton setTitle:@"查询" forState:UIControlStateNormal];
        self.queryButton.backgroundColor = UIColorHex(b58e7f);
        [self.queryButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
        [self.queryButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.offset(0);
            make.width.offset(kScreenWidth-150);
            make.bottom.offset(0);
            make.height.offset(50);
        }];
    }
    
}

- (void)_addSubViews{
    self.whiteView = [[UIView alloc] init];
    self.whiteView.backgroundColor = kWhiteColor;
    [self addSubview:self.whiteView];
    
}

- (void)createdUI {
    
    self.dormitoryTopView = [[UIView alloc] init];
    [self.whiteView addSubview:self.dormitoryTopView];
    [self.dormitoryTopView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.offset(15);
        if(self.isDormitory){
            make.height.offset(70);
        }else {
            make.height.offset(0);
        }
    }];
    
    if(self.isDormitory){
        self.dormitoryTopView.hidden = NO;
        if([HashMainData shareInstance].dormitoryPeopleNumber == 0){
            self.peopleNumber = 0;
        }else {
            self.peopleNumber = [HashMainData shareInstance].dormitoryPeopleNumber;
        }
        
        if([HashMainData shareInstance].dormitoryBedNumber == 0){
            self.bedNumber = 0;
            
        }else {
            self.bedNumber = [HashMainData shareInstance].dormitoryBedNumber;
        }
    }else {
        self.dormitoryTopView.hidden = YES;
    }
    
    UILabel *peopleLabel = [[UILabel alloc] init];
    peopleLabel.text = @"人/床数";
    peopleLabel.font = KBoldFont(16);
    peopleLabel.textColor = XLColor_mainTextColor;
    [self.dormitoryTopView addSubview:peopleLabel];
    [peopleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.top.offset(0);
        make.height.offset(25);
        make.width.offset(80);
    }];
    
    UILabel *peopleNumberLabel = [[UILabel alloc] init];
    peopleNumberLabel.text = @"人数";
    peopleNumberLabel.font = XLFont_subTextFont;
    peopleNumberLabel.textColor = XLColor_mainTextColor;
    [self.dormitoryTopView addSubview:peopleNumberLabel];
    [peopleNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.top.equalTo(peopleLabel.mas_bottom).offset(12);
        make.height.offset(15);
        make.width.offset(40);
    }];
    
    UIButton *peopleReduceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [peopleReduceButton setImage:HHGetImage(@"icon_home_dormitory_jian") forState:UIControlStateNormal];
    [peopleReduceButton addTarget:self action:@selector(peopleJianButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.dormitoryTopView addSubview:peopleReduceButton];
    [peopleReduceButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(peopleNumberLabel.mas_right).offset(15);
        make.top.equalTo(peopleNumberLabel).offset(0);
        make.height.offset(15);
        make.width.offset(15);
    }];
    
    self.peopleNumberResultLabel = [[UILabel alloc] init];
    self.peopleNumberResultLabel.text = [NSString stringWithFormat:@"%ld",[HashMainData shareInstance].dormitoryPeopleNumber];
    self.peopleNumberResultLabel.font = XLFont_subTextFont;
    self.peopleNumberResultLabel.textColor = XLColor_mainTextColor;
    self.peopleNumberResultLabel.textAlignment = NSTextAlignmentCenter;
    [self.dormitoryTopView addSubview:self.peopleNumberResultLabel];
    [self.peopleNumberResultLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(peopleReduceButton.mas_right).offset(5);
        make.top.equalTo(peopleReduceButton).offset(0);
        make.height.offset(15);
        make.width.offset(30);
    }];
    
    UIButton *peopleAddButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [peopleAddButton setImage:HHGetImage(@"icon_home_dormitory_add") forState:UIControlStateNormal];
    [peopleAddButton addTarget:self action:@selector(peopleAddButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.dormitoryTopView addSubview:peopleAddButton];
    [peopleAddButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.peopleNumberResultLabel.mas_right).offset(5);
        make.top.equalTo(peopleNumberLabel).offset(0);
        make.height.offset(15);
        make.width.offset(15);
    }];
    
    UILabel *bedNumberLabel = [[UILabel alloc] init];
    bedNumberLabel.text = @"床铺数";
    bedNumberLabel.font = XLFont_subTextFont;
    bedNumberLabel.textColor = XLColor_mainTextColor;
    [self.dormitoryTopView addSubview:bedNumberLabel];
    [bedNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(kScreenWidth/2);
        make.top.equalTo(peopleLabel.mas_bottom).offset(12);
        make.height.offset(15);
        make.width.offset(60);
    }];
    
    UIButton *bedReduceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [bedReduceButton setImage:HHGetImage(@"icon_home_dormitory_jian") forState:UIControlStateNormal];
    [bedReduceButton addTarget:self action:@selector(bedJianButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.dormitoryTopView addSubview:bedReduceButton];
    [bedReduceButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bedNumberLabel.mas_right).offset(15);
        make.top.equalTo(bedNumberLabel).offset(0);
        make.height.offset(15);
        make.width.offset(15);
    }];
    
    self.bedNumberResultLabel = [[UILabel alloc] init];
    self.bedNumberResultLabel.text = [NSString stringWithFormat:@"%ld",[HashMainData shareInstance].dormitoryBedNumber];
    self.bedNumberResultLabel.font = XLFont_subTextFont;
    self.bedNumberResultLabel.textColor = XLColor_mainTextColor;
    self.bedNumberResultLabel.textAlignment = NSTextAlignmentCenter;
    [self.dormitoryTopView addSubview:self.bedNumberResultLabel];
    [self.bedNumberResultLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bedReduceButton.mas_right).offset(5);
        make.top.equalTo(bedReduceButton).offset(0);
        make.height.offset(15);
        make.width.offset(30);
    }];
    
    UIButton *bedAddButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [bedAddButton setImage:HHGetImage(@"icon_home_dormitory_add") forState:UIControlStateNormal];
    [bedAddButton addTarget:self action:@selector(bedAddButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.dormitoryTopView addSubview:bedAddButton];
    [bedAddButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bedNumberResultLabel.mas_right).offset(5);
        make.top.equalTo(bedNumberLabel).offset(0);
        make.height.offset(15);
        make.width.offset(15);
    }];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"价格";
    titleLabel.font = KBoldFont(16);
    titleLabel.textColor = XLColor_mainTextColor;
    [self.whiteView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.top.equalTo(self.dormitoryTopView.mas_bottom).offset(0);
        make.height.offset(25);
        make.width.offset(50);
    }];
    
    self.priceLabel = [[UILabel alloc] init];
    self.priceLabel.font = XLFont_mainTextFont;
    self.priceLabel.textColor = UIColorHex(b58e7f);
    [self.whiteView addSubview:self.priceLabel];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLabel.mas_right).offset(0);
        make.top.equalTo(self.dormitoryTopView.mas_bottom).offset(0);
        make.height.offset(25);
        make.right.offset(-15);
    }];
    
    UILabel *zeroLabel = [[UILabel alloc] init];
    zeroLabel.text = @"￥0";
    zeroLabel.font = XLFont_subTextFont;
    zeroLabel.textColor = XLColor_mainTextColor;
    [self.whiteView addSubview:zeroLabel];
    [zeroLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.top.equalTo(titleLabel.mas_bottom).offset(15);
        make.height.offset(20);
        make.width.offset(60);
    }];
    
    UILabel *maxPriceLabel = [[UILabel alloc] init];
    maxPriceLabel.text = @"￥1000以上";
    maxPriceLabel.font = XLFont_subTextFont;
    maxPriceLabel.textAlignment = NSTextAlignmentRight;
    maxPriceLabel.textColor = XLColor_mainTextColor;
    [self.whiteView addSubview:maxPriceLabel];
    [maxPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-15);
        make.top.equalTo(titleLabel.mas_bottom).offset(15);
        make.height.offset(20);
        make.width.offset(130);
    }];
    
    self.rangeSlider = [[TTRangeSlider alloc]init];
    self.rangeSlider.lineHeight = 3;
    self.rangeSlider.minValue = 0;
    self.rangeSlider.maxValue = 1000;
    self.rangeSlider.delegate = self;
    self.rangeSlider.hideLabels = YES;
    self.rangeSlider.handleImage = HHGetImage(@"icon_home_price_slider");
    [self.whiteView addSubview:self.rangeSlider];
    [self.rangeSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(16);
        make.right.offset(-16);
        make.top.equalTo(zeroLabel.mas_bottom).offset(5);
        make.height.offset(60);
    }];
    
    if ([HashMainData shareInstance].selectedMinimum > 0 ||[HashMainData shareInstance].selectedMaximum < 1000) {
        self.rangeSlider.selectedMinimum = [HashMainData shareInstance].selectedMinimum;
        NSString *str;
        if ([HashMainData shareInstance].selectedMinimum >= 1000) {
            str = @"￥1000以上";
        }else{
            
            if ([HashMainData shareInstance].selectedMaximum >= 1000) {
                str = [NSString stringWithFormat:@"￥%.0f以上",[HashMainData shareInstance].selectedMinimum];
            }else{
                CGFloat max = [HashMainData shareInstance].selectedMaximum;
                str = [NSString stringWithFormat:@"￥%.0f~%.0f",[HashMainData shareInstance].selectedMinimum,max];
            }
            
        }
        if ([HashMainData shareInstance].selectedMaximum == 0) {
            
            if([HashMainData shareInstance].allPriceStr.length == 0){
                self.priceLabel.text = @"";
            }else {
                self.priceLabel.text = [HashMainData shareInstance].allPriceStr;
            }
        }else {
            self.priceLabel.text = str;
        }
        
    }else{
        
        self.rangeSlider.selectedMinimum = 0;
    }
    if ([HashMainData shareInstance].selectedMaximum > 0) {
        self.rangeSlider.selectedMaximum = [HashMainData shareInstance].selectedMaximum;
    }else{
        self.rangeSlider.selectedMaximum = 1000;
    }
    
    self.rangeSlider.shadowRadius = 2;
    self.rangeSlider.step = 50;
    self.rangeSlider.enableStep = YES;
    self.rangeSlider.tintColor = kLightGrayColor;
    self.rangeSlider.tintColorBetweenHandles = UIColorHex(b58e7f);
    self.rangeSlider.handleColor = kWhiteColor;
    
    NSNumberFormatter *customFormatter = [[NSNumberFormatter alloc] init];
    customFormatter.positiveSuffix = @"元";
    self.rangeSlider.numberFormatterOverride = customFormatter;
    
    [self layoutIfNeeded];
    CGFloat h = CGRectGetMaxY(self.rangeSlider.frame);
    
    self.priceSuperView = [[UIView alloc] init];
    self.priceSuperView.tag = 999;
    [self.whiteView addSubview:self.priceSuperView];
    [self.priceSuperView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(100);
        make.left.right.offset(0);
        make.top.offset(h);
    }];
    
    NSArray *priceArray = @[@"￥0~150",@"￥150~300",@"￥300~450",@"￥450~600",@"￥600~1000",@"￥1000以上", @"不限"];
    int xLeft = 15;
    int yBottom = 0;
    for (int i = 0; i<priceArray.count; i++) {
        if (xLeft+(kScreenWidth-30-21)/4 > kScreenWidth-15) {
            xLeft = 15;
            yBottom = yBottom+10+45;
        }
        UIButton *priceButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [priceButton setTitle:priceArray[i] forState:UIControlStateNormal];
        [priceButton setTitleColor:XLColor_mainTextColor forState:UIControlStateNormal];
        priceButton.backgroundColor = UIColorHex(F2EEE8);
        priceButton.titleLabel.font = XLFont_subSubTextFont;
        priceButton.layer.cornerRadius = 8;
        priceButton.layer.masksToBounds = YES;
        priceButton.tag = i;
        
        if([HashMainData shareInstance].priceStr.length != 0){
            if([HashMainData shareInstance].priceStr.intValue == i){
                priceButton.selected = YES;
                self.priceSelectedBt = priceButton;
                self.priceSelectedBt.backgroundColor = UIColorHex(EDDDC3);
            }
        }
        
        [priceButton addTarget:self action:@selector(priceButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.priceSuperView addSubview:priceButton];
        [priceButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(xLeft);
            make.height.offset(45);
            make.width.offset((kScreenWidth-30-21)/4);
            make.top.offset(yBottom);
        }];
        xLeft = xLeft+(kScreenWidth-30-21)/4+7;
    }
    
    // 检测时间
    UILabel *timeLabel = [[UILabel alloc]init];
    timeLabel.text = @"检测时间";
    timeLabel.font = KBoldFont(16);
    timeLabel.textColor = XLColor_mainTextColor;
    [self.whiteView addSubview:timeLabel];
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.top.equalTo(self.priceSuperView.mas_bottom).offset(15);
        make.height.offset(30);
        make.width.offset(100);
    }];
    
    //    UILabel *tipLabel = [[UILabel alloc]init];
    //    tipLabel.text = @"检测时间说明、安全评分说明";
    //    tipLabel.font = KBoldFont(14);
    //    tipLabel.textAlignment = NSTextAlignmentRight;
    //    tipLabel.textColor = UIColorHex(b58e7f);
    //    [self.whiteView addSubview:tipLabel];
    //    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.right.offset(-15);
    //        make.top.equalTo(priceSuperView.mas_bottom).offset(15);
    //        make.height.offset(30);
    //        make.left.offset(0);
    //    }];
    
    UIView *timeSuperView = [[UIView alloc] init];
    [self.whiteView addSubview:timeSuperView];
    [timeSuperView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(45);
        make.left.right.offset(0);
        make.top.equalTo(timeLabel.mas_bottom).offset(10);
    }];
    
    NSArray *timeArray = @[@"5天以内",@"10天以内",@"15天以内",@"30天以内"];
    int time_xLeft = 15;
    for (int i = 0; i<timeArray.count; i++) {
        UIButton *timeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [timeButton setTitle:timeArray[i] forState:UIControlStateNormal];
        [timeButton setTitleColor:XLColor_mainTextColor forState:UIControlStateNormal];
        timeButton.backgroundColor = UIColorHex(F2EEE8);
        timeButton.titleLabel.font = XLFont_subSubTextFont;
        timeButton.layer.cornerRadius = 8;
        timeButton.layer.masksToBounds = YES;
        timeButton.tag = i;
        
        if([HashMainData shareInstance].timeStr.length != 0){
            if([HashMainData shareInstance].timeStr.intValue == i){
                timeButton.selected = YES;
                self.timeSelectedBt = timeButton;
                self.timeSelectedBt.backgroundColor = UIColorHex(EDDDC3);
            }
        }
        [timeButton addTarget:self action:@selector(timeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [timeSuperView addSubview:timeButton];
        [timeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(time_xLeft);
            make.height.offset(45);
            make.width.offset((kScreenWidth-30-21)/4);
            make.top.offset(0);
        }];
        time_xLeft = time_xLeft+(kScreenWidth-30-21)/4+7;
    }
    
    UILabel *securityLabel = [[UILabel alloc]init];
    securityLabel.text = @"安全评分";
    securityLabel.font = KBoldFont(16);
    securityLabel.textColor = XLColor_mainTextColor;
    [self.whiteView addSubview:securityLabel];
    [securityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.top.equalTo(timeSuperView.mas_bottom).offset(15);
        make.height.offset(30);
        make.width.offset(100);
    }];
    
    UIView *securitySuperView = [[UIView alloc] init];
    [self.whiteView addSubview:securitySuperView];
    [securitySuperView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(45);
        make.left.right.offset(0);
        make.top.equalTo(securityLabel.mas_bottom).offset(10);
    }];
    
    NSArray *securityArray = @[@"3星",@"4星",@"4.5星",@"5星"];
    int security_xLeft = 15;
    for (int i = 0; i<securityArray.count; i++) {
        UIButton *securityButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [securityButton setTitle:securityArray[i] forState:UIControlStateNormal];
        [securityButton setTitleColor:XLColor_mainTextColor forState:UIControlStateNormal];
        securityButton.backgroundColor = UIColorHex(F2EEE8);
        securityButton.titleLabel.font = XLFont_subSubTextFont;
        securityButton.layer.cornerRadius = 8;
        securityButton.layer.masksToBounds = YES;
        securityButton.tag = i;
        
        if([HashMainData shareInstance].commentStr.length != 0){
            if([HashMainData shareInstance].commentStr.intValue == i){
                securityButton.selected = YES;
                self.securitySelectedBt = securityButton;
                self.securitySelectedBt.backgroundColor = UIColorHex(EDDDC3);
            }
        }
        [securityButton addTarget:self action:@selector(securityButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [securitySuperView addSubview:securityButton];
        [securityButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(security_xLeft);
            make.height.offset(45);
            make.width.offset((kScreenWidth-30-21)/4);
            make.top.offset(0);
        }];
        security_xLeft = security_xLeft+(kScreenWidth-30-21)/4+7;
    }
    
    self.againButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.againButton.layer.cornerRadius = 45/2.0;
    self.againButton.layer.masksToBounds = YES;
    self.againButton.backgroundColor = RGBColor(73, 73, 75);
    [self.againButton setTitle:@"重置" forState:UIControlStateNormal];
    [self.againButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
    self.againButton.titleLabel.font = KBoldFont(14);
    [self.againButton addTarget:self action:@selector(againButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.whiteView addSubview:self.againButton];
    [self.againButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.height.offset(45);
        make.width.offset((kScreenWidth-60)/2);
        make.bottom.offset(-15);
    }];
    
    self.queryButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.queryButton.layer.cornerRadius = 45/2.0;
    self.queryButton.layer.masksToBounds = YES;
    self.queryButton.backgroundColor = XLColor_mainHHTextColor;
    [self.queryButton setTitle:@"查询" forState:UIControlStateNormal];
    [self.queryButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
    self.queryButton.titleLabel.font = KBoldFont(14);
    [self.queryButton addTarget:self action:@selector(queryButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.whiteView addSubview:self.queryButton];
    [self.queryButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-15);
        make.height.offset(45);
        make.width.offset((kScreenWidth-60)/2);
        make.bottom.offset(-15);
    }];
    
    self.lineView = [[UIView alloc] init];
    self.lineView.backgroundColor = XLColor_mainColor;
    [self.whiteView addSubview:self.lineView];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.height.offset(1);
        make.top.equalTo(self.againButton.mas_top).offset(0);
    }];
}

- (void)againCreatedUI {
    
    self.dormitoryTopView = [[UIView alloc] init];
    [self.whiteView addSubview:self.dormitoryTopView];
    [self.dormitoryTopView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.offset(15);
        if(self.isDormitory){
            make.height.offset(70);
        }else {
            make.height.offset(0);
        }
    }];
    
    if(self.isDormitory){
        self.dormitoryTopView.hidden = NO;
        self.peopleNumber = 0;
        self.bedNumber = 0;
    }else {
        self.dormitoryTopView.hidden = YES;
    }
    
    UILabel *peopleLabel = [[UILabel alloc] init];
    peopleLabel.text = @"人/床数";
    peopleLabel.font = KBoldFont(16);
    peopleLabel.textColor = XLColor_mainTextColor;
    [self.dormitoryTopView addSubview:peopleLabel];
    [peopleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.top.offset(0);
        make.height.offset(25);
        make.width.offset(80);
    }];
    
    UILabel *peopleNumberLabel = [[UILabel alloc] init];
    peopleNumberLabel.text = @"人数";
    peopleNumberLabel.font = XLFont_subTextFont;
    peopleNumberLabel.textColor = XLColor_mainTextColor;
    [self.dormitoryTopView addSubview:peopleNumberLabel];
    [peopleNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.top.equalTo(peopleLabel.mas_bottom).offset(12);
        make.height.offset(15);
        make.width.offset(40);
    }];
    
    UIButton *peopleReduceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [peopleReduceButton setImage:HHGetImage(@"icon_home_dormitory_jian") forState:UIControlStateNormal];
    [peopleReduceButton addTarget:self action:@selector(peopleJianButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.dormitoryTopView addSubview:peopleReduceButton];
    [peopleReduceButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(peopleNumberLabel.mas_right).offset(15);
        make.top.equalTo(peopleNumberLabel).offset(0);
        make.height.offset(15);
        make.width.offset(15);
    }];
    
    self.peopleNumberResultLabel = [[UILabel alloc] init];
    self.peopleNumberResultLabel.text = @"0";
    self.peopleNumberResultLabel.font = XLFont_subTextFont;
    self.peopleNumberResultLabel.textColor = XLColor_mainTextColor;
    self.peopleNumberResultLabel.textAlignment = NSTextAlignmentCenter;
    [self.dormitoryTopView addSubview:self.peopleNumberResultLabel];
    [self.peopleNumberResultLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(peopleReduceButton.mas_right).offset(5);
        make.top.equalTo(peopleReduceButton).offset(0);
        make.height.offset(15);
        make.width.offset(30);
    }];
    
    UIButton *peopleAddButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [peopleAddButton setImage:HHGetImage(@"icon_home_dormitory_add") forState:UIControlStateNormal];
    [peopleAddButton addTarget:self action:@selector(peopleAddButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.dormitoryTopView addSubview:peopleAddButton];
    [peopleAddButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.peopleNumberResultLabel.mas_right).offset(5);
        make.top.equalTo(peopleNumberLabel).offset(0);
        make.height.offset(15);
        make.width.offset(15);
    }];
    
    UILabel *bedNumberLabel = [[UILabel alloc] init];
    bedNumberLabel.text = @"床铺数";
    bedNumberLabel.font = XLFont_subTextFont;
    bedNumberLabel.textColor = XLColor_mainTextColor;
    [self.dormitoryTopView addSubview:bedNumberLabel];
    [bedNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(kScreenWidth/2);
        make.top.equalTo(peopleLabel.mas_bottom).offset(12);
        make.height.offset(15);
        make.width.offset(60);
    }];
    
    UIButton *bedReduceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [bedReduceButton setImage:HHGetImage(@"icon_home_dormitory_jian") forState:UIControlStateNormal];
    [bedReduceButton addTarget:self action:@selector(bedJianButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.dormitoryTopView addSubview:bedReduceButton];
    [bedReduceButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bedNumberLabel.mas_right).offset(15);
        make.top.equalTo(bedNumberLabel).offset(0);
        make.height.offset(15);
        make.width.offset(15);
    }];
    
    self.bedNumberResultLabel = [[UILabel alloc] init];
    self.bedNumberResultLabel.text = @"0";
    self.bedNumberResultLabel.font = XLFont_subTextFont;
    self.bedNumberResultLabel.textColor = XLColor_mainTextColor;
    self.bedNumberResultLabel.textAlignment = NSTextAlignmentCenter;
    [self.dormitoryTopView addSubview:self.bedNumberResultLabel];
    [self.bedNumberResultLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bedReduceButton.mas_right).offset(5);
        make.top.equalTo(bedReduceButton).offset(0);
        make.height.offset(15);
        make.width.offset(30);
    }];
    
    UIButton *bedAddButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [bedAddButton setImage:HHGetImage(@"icon_home_dormitory_add") forState:UIControlStateNormal];
    [bedAddButton addTarget:self action:@selector(bedAddButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.dormitoryTopView addSubview:bedAddButton];
    [bedAddButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bedNumberResultLabel.mas_right).offset(5);
        make.top.equalTo(bedNumberLabel).offset(0);
        make.height.offset(15);
        make.width.offset(15);
    }];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"价格";
    titleLabel.font = KBoldFont(16);
    titleLabel.textColor = XLColor_mainTextColor;
    [self.whiteView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.top.equalTo(self.dormitoryTopView.mas_bottom).offset(0);
        make.height.offset(25);
        make.width.offset(50);
    }];
    
    self.priceLabel = [[UILabel alloc] init];
    self.priceLabel.font = XLFont_mainTextFont;
    self.priceLabel.textColor = UIColorHex(b58e7f);
    [self.whiteView addSubview:self.priceLabel];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLabel.mas_right).offset(0);
        make.top.equalTo(self.dormitoryTopView.mas_bottom).offset(0);
        make.height.offset(25);
        make.right.offset(-15);
    }];
    
    UILabel *zeroLabel = [[UILabel alloc] init];
    zeroLabel.text = @"￥0";
    zeroLabel.font = XLFont_subTextFont;
    zeroLabel.textColor = XLColor_mainTextColor;
    [self.whiteView addSubview:zeroLabel];
    [zeroLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.top.equalTo(titleLabel.mas_bottom).offset(15);
        make.height.offset(20);
        make.width.offset(60);
    }];
    
    UILabel *maxPriceLabel = [[UILabel alloc] init];
    maxPriceLabel.text = @"￥1000以上";
    maxPriceLabel.font = XLFont_subTextFont;
    maxPriceLabel.textAlignment = NSTextAlignmentRight;
    maxPriceLabel.textColor = XLColor_mainTextColor;
    [self.whiteView addSubview:maxPriceLabel];
    [maxPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-15);
        make.top.equalTo(titleLabel.mas_bottom).offset(15);
        make.height.offset(20);
        make.width.offset(130);
    }];
    
    self.rangeSlider = [[TTRangeSlider alloc]init];
    self.rangeSlider.lineHeight = 3;
    self.rangeSlider.minValue = 0;
    self.rangeSlider.maxValue = 1000;
    self.rangeSlider.delegate = self;
    self.rangeSlider.hideLabels = YES;
    self.rangeSlider.handleImage = HHGetImage(@"icon_home_price_slider");
    [self.whiteView addSubview:self.rangeSlider];
    [self.rangeSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(16);
        make.right.offset(-16);
        make.top.equalTo(zeroLabel.mas_bottom).offset(5);
        make.height.offset(60);
    }];
    
    self.priceLabel.text = @"";
    self.rangeSlider.selectedMinimum = 0;
    self.rangeSlider.selectedMaximum = 1000;
    
    
    self.rangeSlider.shadowRadius = 2;
    self.rangeSlider.step = 50;
    self.rangeSlider.enableStep = YES;
    self.rangeSlider.tintColor = kLightGrayColor;
    self.rangeSlider.tintColorBetweenHandles = UIColorHex(b58e7f);
    self.rangeSlider.handleColor = kWhiteColor;
    
    NSNumberFormatter *customFormatter = [[NSNumberFormatter alloc] init];
    customFormatter.positiveSuffix = @"元";
    self.rangeSlider.numberFormatterOverride = customFormatter;
    
    [self layoutIfNeeded];
    CGFloat h = CGRectGetMaxY(self.rangeSlider.frame);
    
    
    self.priceSuperView = [[UIView alloc] init];
    self.priceSuperView.tag = 999;
    [self.whiteView addSubview:self.priceSuperView];
    [self.priceSuperView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(100);
        make.left.right.offset(0);
        make.top.offset(h);
    }];
    
    NSArray *priceArray = @[@"￥0~150",@"￥150~300",@"￥300~450",@"￥450~600",@"￥600~1000",@"￥1000以上", @"不限"];
    int xLeft = 15;
    int yBottom = 0;
    for (int i = 0; i<priceArray.count; i++) {
        if (xLeft+(kScreenWidth-30-21)/4 > kScreenWidth-15) {
            xLeft = 15;
            yBottom = yBottom+10+45;
        }
        UIButton *priceButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [priceButton setTitle:priceArray[i] forState:UIControlStateNormal];
        [priceButton setTitleColor:XLColor_mainTextColor forState:UIControlStateNormal];
        priceButton.backgroundColor = UIColorHex(F2EEE8);
        priceButton.titleLabel.font = XLFont_subSubTextFont;
        priceButton.layer.cornerRadius = 8;
        priceButton.layer.masksToBounds = YES;
        priceButton.tag = i;
        [priceButton addTarget:self action:@selector(priceButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.priceSuperView addSubview:priceButton];
        [priceButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(xLeft);
            make.height.offset(45);
            make.width.offset((kScreenWidth-30-21)/4);
            make.top.offset(yBottom);
        }];
        xLeft = xLeft+(kScreenWidth-30-21)/4+7;
    }
    
    // 检测时间
    UILabel *timeLabel = [[UILabel alloc]init];
    timeLabel.text = @"检测时间";
    timeLabel.font = KBoldFont(16);
    timeLabel.textColor = XLColor_mainTextColor;
    [self.whiteView addSubview:timeLabel];
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.top.equalTo(self.priceSuperView.mas_bottom).offset(15);
        make.height.offset(30);
        make.width.offset(100);
    }];
    
    //    UILabel *tipLabel = [[UILabel alloc]init];
    //    tipLabel.text = @"检测时间说明、安全评分说明";
    //    tipLabel.font = KBoldFont(14);
    //    tipLabel.textAlignment = NSTextAlignmentRight;
    //    tipLabel.textColor = UIColorHex(b58e7f);
    //    [self.whiteView addSubview:tipLabel];
    //    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.right.offset(-15);
    //        make.top.equalTo(priceSuperView.mas_bottom).offset(15);
    //        make.height.offset(30);
    //        make.left.offset(0);
    //    }];
    
    UIView *timeSuperView = [[UIView alloc] init];
    [self.whiteView addSubview:timeSuperView];
    [timeSuperView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(45);
        make.left.right.offset(0);
        make.top.equalTo(timeLabel.mas_bottom).offset(10);
    }];
    
    NSArray *timeArray = @[@"5天以内",@"10天以内",@"15天以内",@"30天以内"];
    int time_xLeft = 15;
    for (int i = 0; i<timeArray.count; i++) {
        UIButton *timeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [timeButton setTitle:timeArray[i] forState:UIControlStateNormal];
        [timeButton setTitleColor:XLColor_mainTextColor forState:UIControlStateNormal];
        timeButton.backgroundColor = UIColorHex(F2EEE8);
        timeButton.titleLabel.font = XLFont_subSubTextFont;
        timeButton.layer.cornerRadius = 8;
        timeButton.layer.masksToBounds = YES;
        timeButton.tag = i;
        [timeButton addTarget:self action:@selector(timeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [timeSuperView addSubview:timeButton];
        [timeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(time_xLeft);
            make.height.offset(45);
            make.width.offset((kScreenWidth-30-21)/4);
            make.top.offset(0);
        }];
        time_xLeft = time_xLeft+(kScreenWidth-30-21)/4+7;
    }
    
    UILabel *securityLabel = [[UILabel alloc]init];
    securityLabel.text = @"安全评分";
    securityLabel.font = KBoldFont(16);
    securityLabel.textColor = XLColor_mainTextColor;
    [self.whiteView addSubview:securityLabel];
    [securityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.top.equalTo(timeSuperView.mas_bottom).offset(15);
        make.height.offset(30);
        make.width.offset(100);
    }];
    
    UIView *securitySuperView = [[UIView alloc] init];
    [self.whiteView addSubview:securitySuperView];
    [securitySuperView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(45);
        make.left.right.offset(0);
        make.top.equalTo(securityLabel.mas_bottom).offset(10);
    }];
    
    NSArray *securityArray = @[@"3星",@"4星",@"4.5星",@"5星"];
    int security_xLeft = 15;
    for (int i = 0; i<securityArray.count; i++) {
        UIButton *securityButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [securityButton setTitle:securityArray[i] forState:UIControlStateNormal];
        [securityButton setTitleColor:XLColor_mainTextColor forState:UIControlStateNormal];
        securityButton.backgroundColor = UIColorHex(F2EEE8);
        securityButton.titleLabel.font = XLFont_subSubTextFont;
        securityButton.layer.cornerRadius = 8;
        securityButton.layer.masksToBounds = YES;
        securityButton.tag = i;
        [securityButton addTarget:self action:@selector(securityButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [securitySuperView addSubview:securityButton];
        [securityButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(security_xLeft);
            make.height.offset(45);
            make.width.offset((kScreenWidth-30-21)/4);
            make.top.offset(0);
        }];
        security_xLeft = security_xLeft+(kScreenWidth-30-21)/4+7;
    }
    
    self.againButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.againButton.layer.cornerRadius = 45/2.0;
    self.againButton.layer.masksToBounds = YES;
    self.againButton.backgroundColor = RGBColor(73, 73, 75);
    [self.againButton setTitle:@"重置" forState:UIControlStateNormal];
    [self.againButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
    self.againButton.titleLabel.font = KBoldFont(14);
    [self.againButton addTarget:self action:@selector(againButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.whiteView addSubview:self.againButton];
    [self.againButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.height.offset(45);
        make.width.offset((kScreenWidth-60)/2);
        make.bottom.offset(-15);
    }];
    
    self.queryButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.queryButton.layer.cornerRadius = 45/2.0;
    self.queryButton.layer.masksToBounds = YES;
    self.queryButton.backgroundColor = XLColor_mainHHTextColor;
    [self.queryButton setTitle:@"查询" forState:UIControlStateNormal];
    [self.queryButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
    self.queryButton.titleLabel.font = KBoldFont(14);
    [self.queryButton addTarget:self action:@selector(queryButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.whiteView addSubview:self.queryButton];
    [self.queryButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-15);
        make.height.offset(45);
        make.width.offset((kScreenWidth-60)/2);
        make.bottom.offset(-15);
    }];
    
    self.lineView = [[UIView alloc] init];
    self.lineView.backgroundColor = XLColor_mainColor;
    [self.whiteView addSubview:self.lineView];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.height.offset(1);
        make.top.equalTo(self.againButton.mas_top).offset(0);
    }];
}

- (void)isAgainWithQuery{
    
    [HashMainData shareInstance].allPriceStr = @"";
    [HashMainData shareInstance].priceStr = @"";
    [HashMainData shareInstance].timeStr = @"";
    [HashMainData shareInstance].commentStr = @"";
    [HashMainData shareInstance].selectedMaximum = 0;
    [HashMainData shareInstance].selectedMinimum = 0;
    
    self.resultsecurityStr = @"";
    self.resultTimeStr = @"";
    self.resultPriceStr = @"";
    self.begin = 0;
    self.end = 0;
}

- (void)resultPriceStrHasLength {
    
    if(self.isSlider){
        [HashMainData shareInstance].priceStr = @"";
    }else {
        if(self.priceSelectedBt.tag == 6){
            [HashMainData shareInstance].priceStr = @"";
        }else {
            [HashMainData shareInstance].priceStr = [NSString stringWithFormat:@"%ld",self.priceSelectedBt.tag];
        }
    }
}
- (void)resultPriceStrDontHasLength {
    
    [HashMainData shareInstance].allPriceStr = @"";
    [HashMainData shareInstance].priceStr = @"";
    [HashMainData shareInstance].selectedMaximum = 0;
    [HashMainData shareInstance].selectedMinimum = 0;
}
- (void)priceLabelHasLength{
    NSArray *array = [self.priceLabel.text componentsSeparatedByString:@"￥"]; //从字符A中分隔成2个元素的数组
    NSString *first = array.lastObject;
    
    
    [HashMainData shareInstance].allPriceStr = first;
    [HashMainData shareInstance].selectedMinimum = self.rangeSlider.selectedMinimum;
    [HashMainData shareInstance].selectedMaximum = self.rangeSlider.selectedMaximum;
}

- (void)priceLabelDontHasLength{
    
    [HashMainData shareInstance].allPriceStr = @"";
    [HashMainData shareInstance].selectedMinimum = self.rangeSlider.selectedMinimum;
    [HashMainData shareInstance].selectedMaximum = self.rangeSlider.selectedMaximum;
}

- (void)queryButtonAction {
    
    if(self.isAgain){
        [self isAgainWithQuery];
    }
    
    [HashMainData shareInstance].dormitoryPeopleNumber = self.peopleNumber;
    [HashMainData shareInstance].dormitoryBedNumber = self.bedNumber;
    
    if (self.resultPriceStr.length != 0) {
        [self resultPriceStrHasLength];
        
        if(self.priceLabel.text.length != 0){
            [self priceLabelHasLength];
        }else {
            [self priceLabelDontHasLength];
        }
    }else {
        [self resultPriceStrDontHasLength];
    }
    
    if (self.resultTimeStr.length != 0) {
        
        [HashMainData shareInstance].timeStr = [NSString stringWithFormat:@"%ld", self.timeSelectedBt.tag];
        [HashMainData shareInstance].timeResult = self.resultTimeStr;
        [HashMainData shareInstance].detect_time = self.detect_time;
    }else {
        
        [HashMainData shareInstance].timeStr = @"";
        [HashMainData shareInstance].timeResult = @"";
        [HashMainData shareInstance].detect_time = 0;;
    }
    
    if (self.resultsecurityStr.length != 0) {
        
        
        [HashMainData shareInstance].commentStr = [NSString stringWithFormat:@"%ld", self.securitySelectedBt.tag];
        [HashMainData shareInstance].securityResult = self.resultsecurityStr;
        [HashMainData shareInstance].safe_star = self.safe_star;
    }else {
        
        [HashMainData shareInstance].commentStr = @"";
        [HashMainData shareInstance].securityResult = @"";
        [HashMainData shareInstance].safe_star = 0;
    }
    
    
    if(self.isDormitory) {
        if (self.selectedWithDormitorySuccess) {
            NSString *dormitStr;
            if([HashMainData shareInstance].dormitoryPeopleNumber == 0){
                if([HashMainData shareInstance].dormitoryBedNumber == 0){
                    dormitStr = @"";
                    
                }else {
                    dormitStr = [NSString stringWithFormat:@"%ld床",[HashMainData shareInstance].dormitoryBedNumber];
                }
                
            }else {
                if([HashMainData shareInstance].dormitoryBedNumber == 0){
                    
                    dormitStr = [NSString stringWithFormat:@"%ld人",[HashMainData shareInstance].dormitoryPeopleNumber];
                }else {
                    dormitStr = [NSString stringWithFormat:@"%ld人/%ld床",[HashMainData shareInstance].dormitoryPeopleNumber,[HashMainData shareInstance].dormitoryBedNumber];
                }
            }
            
            if (self.resultPriceStr.length == 0) {
                if (self.resultTimeStr.length == 0) {
                    if (self.resultsecurityStr.length == 0) {
                        self.dictionary = @{};
                        self.selectedWithDormitorySuccess(dormitStr,@"",@{});
                    }else {
                        self.dictionary =@{
                            @"safe_star" : @(self.safe_star)
                        };
                        
                        self.selectedWithDormitorySuccess(dormitStr,[NSString stringWithFormat:@"%@",self.resultsecurityStr], self.dictionary);
                    }
                    
                }else {
                    if (self.resultsecurityStr.length == 0) {
                        self.dictionary = @{
                            @"detect_time" : @(self.detect_time)
                        };
                        
                        self.selectedWithDormitorySuccess(dormitStr,[NSString stringWithFormat:@"%@",self.resultTimeStr],self.dictionary);
                        
                    }else {
                        self.dictionary = @{
                            @"detect_time" : @(self.detect_time),
                            @"safe_star" : @(self.safe_star)
                        };
                        self.selectedWithDormitorySuccess(dormitStr,[NSString stringWithFormat:@"%@,%@",self.resultTimeStr,self.resultsecurityStr], self.dictionary);
                        
                    }
                }
                
            }else {
                if (self.resultTimeStr.length == 0) {
                    if (self.resultsecurityStr.length == 0) {
                        self.dictionary = @{
                            @"begin" : @(self.begin),
                            @"end" : @(self.end)
                        };
                        
                        self.selectedWithDormitorySuccess(dormitStr,[NSString stringWithFormat:@"￥%@",self.resultPriceStr],self.dictionary);
                    }else {
                        self.dictionary = @{
                            @"begin" : @(self.begin),
                            @"end" : @(self.end),
                            @"safe_star" : @(self.safe_star)
                        };
                        
                        self.selectedWithDormitorySuccess(dormitStr,[NSString stringWithFormat:@"￥%@,%@",self.resultPriceStr,self.resultsecurityStr],self.dictionary);
                    }
                }else {
                    if (self.resultsecurityStr.length == 0) {
                        self.dictionary = @{
                            @"begin" : @(self.begin),
                            @"end" : @(self.end),
                            @"detect_time" : @(self.detect_time)
                        };
                        self.selectedWithDormitorySuccess(dormitStr,[NSString stringWithFormat:@"￥%@,%@",self.resultPriceStr,self.resultTimeStr], self.dictionary);
                        
                    }else {
                        self.dictionary = @{
                            @"begin" : @(self.begin),
                            @"end" : @(self.end),
                            @"detect_time" : @(self.detect_time),
                            @"safe_star" : @(self.safe_star)
                        };
                        
                        self.selectedWithDormitorySuccess(dormitStr,[NSString stringWithFormat:@"￥%@,%@,%@",self.resultPriceStr,self.resultTimeStr,self.resultsecurityStr],self.dictionary);
                    }
                }
            }
        }
    }else {
        if (self.selectedSuccess) {
            if (self.resultPriceStr.length == 0) {
                if (self.resultTimeStr.length == 0) {
                    if (self.resultsecurityStr.length == 0) {
                        self.dictionary = @{};
                        self.selectedSuccess(@"",@{});
                    }else {
                        self.dictionary =@{
                            @"safe_star" : @(self.safe_star)
                        };
                        
                        self.selectedSuccess([NSString stringWithFormat:@"%@",self.resultsecurityStr], self.dictionary);
                    }
                    
                }else {
                    if (self.resultsecurityStr.length == 0) {
                        self.dictionary = @{
                            @"detect_time" : @(self.detect_time)
                        };
                        
                        self.selectedSuccess([NSString stringWithFormat:@"%@",self.resultTimeStr],self.dictionary);
                        
                    }else {
                        self.dictionary = @{
                            @"detect_time" : @(self.detect_time),
                            @"safe_star" : @(self.safe_star)
                        };
                        self.selectedSuccess([NSString stringWithFormat:@"%@,%@",self.resultTimeStr,self.resultsecurityStr], self.dictionary);
                        
                    }
                }
                
            }else {
                if (self.resultTimeStr.length == 0) {
                    if (self.resultsecurityStr.length == 0) {
                        self.dictionary = @{
                            @"begin" : @(self.begin),
                            @"end" : @(self.end)
                        };
                        
                        self.selectedSuccess([NSString stringWithFormat:@"￥%@",self.resultPriceStr],self.dictionary);
                    }else {
                        self.dictionary = @{
                            @"begin" : @(self.begin),
                            @"end" : @(self.end),
                            @"safe_star" : @(self.safe_star)
                        };
                        
                        self.selectedSuccess([NSString stringWithFormat:@"%@,%@",[NSString stringWithFormat:@"￥%@",self.resultPriceStr],self.resultsecurityStr],self.dictionary);
                    }
                }else {
                    if (self.resultsecurityStr.length == 0) {
                        self.dictionary = @{
                            @"begin" : @(self.begin),
                            @"end" : @(self.end),
                            @"detect_time" : @(self.detect_time)
                        };
                        self.selectedSuccess([NSString stringWithFormat:@"%@,%@",[NSString stringWithFormat:@"￥%@",self.resultPriceStr],self.resultTimeStr], self.dictionary);
                        
                    }else {
                        self.dictionary = @{
                            @"begin" : @(self.begin),
                            @"end" : @(self.end),
                            @"detect_time" : @(self.detect_time),
                            @"safe_star" : @(self.safe_star)
                        };
                        
                        self.selectedSuccess([NSString stringWithFormat:@"%@,%@,%@",[NSString stringWithFormat:@"￥%@",self.resultPriceStr],self.resultTimeStr,self.resultsecurityStr],self.dictionary);
                    }
                }
            }
        }
    }
    
    
}

- (void)againButtonAction {
    for (UIView *view in self.whiteView.subviews) {
        [view removeFromSuperview];
    }
    self.isAgain = YES;
    [self againCreatedUI];
    
    if ([self.type isEqualToString:@"bottom"]) {
        [self.whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
            CGFloat h;
            if (UINavigateTop == 44) {
                h = self.isDormitory ? 565+60 : 565;
            }else {
                h = self.isDormitory ? 545+60 : 545;
            }
            make.height.offset(h);
            make.left.right.bottom.offset(0);
        }];
        
        if (UINavigateTop == 44) {
            CGFloat h = self.isDormitory ? 565+60 : 565;
            [HHAppManage mq_setRect:CGRectMake(0, 0, kScreenWidth, h) cornerRect:UIRectCornerTopLeft|UIRectCornerTopRight radius:20 view:self.whiteView];
            
        }else {
            CGFloat h = self.isDormitory ? 565+60 : 565;
            [HHAppManage mq_setRect:CGRectMake(0, 0, kScreenWidth, h) cornerRect:UIRectCornerTopLeft|UIRectCornerTopRight radius:20 view:self.whiteView];
        }
        
        
        self.againButton.layer.cornerRadius = 45/2.0;
        self.againButton.layer.masksToBounds = YES;
        self.againButton.backgroundColor = RGBColor(73, 73, 75);
        [self.againButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
        [self.againButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.offset(15);
            make.width.offset((kScreenWidth-60)/2);
            if (UINavigateTop == 44) {
                make.bottom.offset(-35);
            }else{
                make.bottom.offset(-15);
            }
            make.height.offset(45);
        }];
        
        [self.queryButton setTitle:@"确定" forState:UIControlStateNormal];
        self.queryButton.layer.cornerRadius = 45/2.0;
        self.queryButton.layer.masksToBounds = YES;
        self.queryButton.backgroundColor = XLColor_mainHHTextColor;
        [self.queryButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
        self.queryButton.titleLabel.font = KBoldFont(14);
        [self.queryButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.offset(-15);
            make.width.offset((kScreenWidth-60)/2);
            if (UINavigateTop == 44) {
                make.bottom.offset(-35);
            }else{
                make.bottom.offset(-15);
            }
            make.height.offset(45);
        }];
        self.lineView.hidden = YES;
    }else {
        [self.whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
            CGFloat h;
            if (UINavigateTop == 44) {
                h = self.isDormitory ? 535+60 : 535;
            }else {
                h = self.isDormitory ? 515+60 : 515;
            }
            make.height.offset(h);
            make.left.right.top.offset(0);
        }];
        self.lineView.hidden = NO;
        self.againButton.layer.cornerRadius = 0;
        self.againButton.layer.masksToBounds = YES;
        self.againButton.backgroundColor = kWhiteColor;
        [self.againButton setTitleColor:UIColorHex(b58e7f) forState:UIControlStateNormal];
        [self.againButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.offset(0);
            make.width.offset(150);
            make.bottom.offset(0);
            make.height.offset(50);
        }];
        [self.queryButton setTitle:@"查询" forState:UIControlStateNormal];
        self.queryButton.layer.cornerRadius = 0;
        self.queryButton.layer.masksToBounds = YES;
        self.queryButton.backgroundColor = UIColorHex(b58e7f);
        [self.queryButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
        [self.queryButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.offset(0);
            make.width.offset(kScreenWidth-150);
            make.bottom.offset(0);
            make.height.offset(50);
        }];
    }
}

- (void)priceButtonAction:(UIButton *)button {
    
    if (button.tag == 0) {
        self.rangeSlider.selectedMinimum = 0;
        self.rangeSlider.selectedMaximum = 150;
    }else if (button.tag == 1){
        self.rangeSlider.selectedMinimum = 150;
        self.rangeSlider.selectedMaximum = 300;
        
    }else if (button.tag == 2){
        self.rangeSlider.selectedMinimum = 300;
        self.rangeSlider.selectedMaximum = 450;
    }else if (button.tag == 3){
        self.rangeSlider.selectedMinimum = 450;
        self.rangeSlider.selectedMaximum = 600;
    }else if (button.tag == 4){
        self.rangeSlider.selectedMinimum = 600;
        self.rangeSlider.selectedMaximum = 1000;
    }else if (button.tag == 5){
        self.rangeSlider.selectedMinimum = 1000;
        self.rangeSlider.selectedMaximum = 1000;
    }else{
        self.rangeSlider.selectedMinimum = 0;
        self.rangeSlider.selectedMaximum = 1000;
    }
    if (button.tag == 5) {
        self.priceLabel.text = @"￥1000以上";
    }else if(button.tag == 6){
        self.priceLabel.text = @"";
    }else {
        self.priceLabel.text = [NSString stringWithFormat:@"￥%.0f~%.0f",self.rangeSlider.selectedMinimum,self.rangeSlider.selectedMaximum];
    }
    
    NSArray *priceArray = @[@"0~150",@"150~300",@"300~450",@"450~600",@"600~1000",@"1000", @"0~0"];
    NSString *str = priceArray[button.tag];
    
    if ([str isEqualToString:@"0~0"]) {
        self.resultPriceStr = @"";
    }else {
        if (button.tag == 5) {
            self.begin = 1000;
            self.end = 0;
            self.resultPriceStr = @"1000以上";
        }else {
            NSArray *array = [str componentsSeparatedByString:@"~"]; //从字符A中分隔成2个元素的数组
            NSString *first = array.firstObject;
            NSString *last = array.lastObject;
            self.begin = first.floatValue;
            self.end = last.floatValue;
            self.resultPriceStr = [NSString stringWithFormat:@"%@", str];
        }
        
    }
    
    button.selected = !button.selected;
    if(self.priceSelectedBt != nil) {
        self.priceSelectedBt.backgroundColor = UIColorHex(F2EEE8);
        self.priceSelectedBt.selected = NO;
    }
    self.priceSelectedBt = button;
    if (button.selected == YES) {
        self.priceSelectedBt.backgroundColor = UIColorHex(EDDDC3);
    }else{
        self.rangeSlider.selectedMinimum = 0;
        self.rangeSlider.selectedMaximum = 1000;
        self.priceLabel.text = @"";
        self.priceSelectedBt.backgroundColor = UIColorHex(F2EEE8);
        self.priceSelectedBt = nil;
        self.resultPriceStr = @"";
        self.begin = 0;
        self.end = 0;
    }
    
}

- (void)timeButtonAction:(UIButton *)button {
    
    
    NSArray *timeArray = @[@"5",@"10",@"15",@"30"];
    NSArray *timeArray2 = @[@"5天以内",@"10天以内",@"15天以内",@"30天以内"];
    NSString *t = timeArray[button.tag];
    self.detect_time = t.floatValue;
    self.resultTimeStr = timeArray2[button.tag];
    
    button.selected = !button.selected;
    if(self.timeSelectedBt != nil) {
        self.timeSelectedBt.backgroundColor = UIColorHex(F2EEE8);
        self.timeSelectedBt.selected = NO;
    }
    self.timeSelectedBt = button;
    if (button.selected == YES) {
        self.timeSelectedBt.backgroundColor = UIColorHex(EDDDC3);
    }else{
        self.timeSelectedBt.backgroundColor = UIColorHex(F2EEE8);
        self.timeSelectedBt = nil;
        self.resultTimeStr = @"";
        self.detect_time = 0;
    }
    
    
}

- (void)securityButtonAction:(UIButton *)button {
    
    
    NSArray *securityArray = @[@"3星",@"4星",@"4.5星",@"5星"];
    NSArray *securityArray2 = @[@"3",@"4",@"4.5",@"5"];
    
    NSString *t = securityArray2[button.tag];
    self.safe_star = t.floatValue;
    self.resultsecurityStr = securityArray[button.tag];
    
    button.selected = !button.selected;
    if(self.securitySelectedBt != nil) {
        self.securitySelectedBt.backgroundColor = UIColorHex(F2EEE8);
        self.securitySelectedBt.selected = NO;
    }
    self.securitySelectedBt = button;
    if (button.selected == YES) {
        self.securitySelectedBt.backgroundColor = UIColorHex(EDDDC3);
    }else{
        self.securitySelectedBt.backgroundColor = UIColorHex(F2EEE8);
        self.securitySelectedBt = nil;
        self.safe_star = 0;
        self.resultsecurityStr = @"";
    }
}

- (void)closeButtonAction {
    if (self.clickCloseButton) {
        self.clickCloseButton();
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches.allObjects lastObject];
    BOOL result = [touch.view isDescendantOfView:self.whiteView];
    if (!result) {
        
        if (self.clickCloseButton) {
            self.clickCloseButton();
        }
    }
    
}

- (void)rangeSlider:(TTRangeSlider *)sender didChangeSelectedMinimumValue:(float)selectedMinimum andMaximumValue:(float)selectedMaximum {
    
    NSString *priceText = @"";
    if (selectedMinimum == 0 && selectedMaximum < 1000) { //则认为滑竿左边的没有滑动
        priceText = [NSString stringWithFormat:@"￥0~%.0f",selectedMaximum];
        self.resultPriceStr = [NSString stringWithFormat:@"0~%.0f",selectedMaximum];
    }else if (selectedMinimum > 0 && selectedMaximum == 1000) { /// 右边滑块没滑动
        priceText = [NSString stringWithFormat:@"￥%.0f以上",selectedMinimum];
        self.resultPriceStr = [NSString stringWithFormat:@"%.0f以上",selectedMinimum];
    }else{
        priceText = [NSString stringWithFormat:@"￥ %.0f~%.0f",selectedMinimum,selectedMaximum];
        self.resultPriceStr = [NSString stringWithFormat:@"%.0f~%.0f",selectedMinimum,selectedMaximum];
    }
    self.priceLabel.text = priceText;
    
    self.begin = selectedMinimum;
    self.end = selectedMaximum;
    self.isSlider = YES;
    
    [self updatePriceUI];
    
}

- (void)updatePriceUI{
    for (UIView *view in self.priceSuperView.subviews) {
        [view removeFromSuperview];
    }
    
    NSArray *priceArray = @[@"￥0~150",@"￥150~300",@"￥300~450",@"￥450~600",@"￥600~1000",@"￥1000以上", @"不限"];
    int xLeft = 15;
    int yBottom = 0;
    for (int i = 0; i<priceArray.count; i++) {
        if (xLeft+(kScreenWidth-30-21)/4 > kScreenWidth-15) {
            xLeft = 15;
            yBottom = yBottom+10+45;
        }
        UIButton *priceButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [priceButton setTitle:priceArray[i] forState:UIControlStateNormal];
        [priceButton setTitleColor:XLColor_mainTextColor forState:UIControlStateNormal];
        priceButton.backgroundColor = UIColorHex(F2EEE8);
        priceButton.titleLabel.font = XLFont_subSubTextFont;
        priceButton.layer.cornerRadius = 8;
        priceButton.layer.masksToBounds = YES;
        priceButton.tag = i;
        [priceButton addTarget:self action:@selector(priceButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.priceSuperView addSubview:priceButton];
        [priceButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(xLeft);
            make.height.offset(45);
            make.width.offset((kScreenWidth-30-21)/4);
            make.top.offset(yBottom);
        }];
        xLeft = xLeft+(kScreenWidth-30-21)/4+7;
    }
}

- (void)peopleJianButtonAction {
    if (self.peopleNumber == 0) {
        return;
    }
    self.peopleNumber--;
    self.peopleNumberResultLabel.text = [NSString stringWithFormat:@"%ld",self.peopleNumber];
    
}

- (void)peopleAddButtonAction {
    self.peopleNumber = self.peopleNumber+1;
    self.peopleNumberResultLabel.text = [NSString stringWithFormat:@"%ld",self.peopleNumber];
    
}

- (void)bedJianButtonAction {
    if (self.bedNumber == 0) {
        return;
    }
    self.bedNumber--;
    self.bedNumberResultLabel.text = [NSString stringWithFormat:@"%ld",self.bedNumber];
    
}

- (void)bedAddButtonAction {
    self.bedNumber = self.bedNumber+1;
    self.bedNumberResultLabel.text = [NSString stringWithFormat:@"%ld",self.bedNumber];
}
@end
