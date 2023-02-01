//
//  HHCountryView.m
//  HashdeepHotel
//
//  Created by Cindy on 2022/7/13.
//

#import "HHCountryView.h"
#import "NSDate+XZY.h"

@interface HHCountryView ()
@property (nonatomic, strong) UIButton *addressButton;
@end

@implementation HHCountryView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [[NSUserDefaults standardUserDefaults]setValue:@"0" forKey:@"countryCalendarOffsetY"];
        [[NSUserDefaults standardUserDefaults]setValue:@"0" forKey:@"hourlyCalendarOffsetY"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        //默认的今天入住，明天离店的数据处理
        NSString *beginData = [[NSDate date] getCurrentMonthday];
        NSString *beginWeek = [HHAppManage weekdayStringWithTime:[[NSDate date] getCurrentday]];
        [HashMainData shareInstance].hourCheckInWeekStr = beginWeek;
        NSString *begindateString = [HHAppManage getDateWithString:beginData];
        [HashMainData shareInstance].hourStartDateTimeStamp = [HHAppManage getTimeStrWithString:[NSString stringWithFormat:@"%@ 00:00:00",begindateString]];
        
        NSString *endData = [[NSDate date] getTomorrowMonthday];
        NSString *endWeek = [HHAppManage weekdayStringWithTime:[[NSDate date] getTomorrowDay]];
        
        [HashMainData shareInstance].startDateStr = beginData;
        [HashMainData shareInstance].checkInWeekStr = beginWeek;
        [HashMainData shareInstance].hourStartDateStr = beginData;
        [HashMainData shareInstance].hourCheckInWeekStr = beginWeek;
        
        [HashMainData shareInstance].endDateStr = endData;
        [HashMainData shareInstance].checkOutWeekStr = endWeek;
        [HashMainData shareInstance].day = 1;
        
        NSString *begindateString2 = [HHAppManage getDateWithString:beginData];
        [HashMainData shareInstance].startDateTimeStamp = [HHAppManage getTimeStrWithString:[NSString stringWithFormat:@"%@ 00:00:00",begindateString2]];
        
        NSString *endDateString = [HHAppManage getDateWithString:endData];
        [HashMainData shareInstance].endDateTimeStamp = [HHAppManage getTimeStrWithString:[NSString stringWithFormat:@"%@ 00:00:00",endDateString]];
        
        [HashMainData shareInstance].currentStartDateStr = beginData;
        [HashMainData shareInstance].currentCheckInWeekStr = beginWeek;
        [HashMainData shareInstance].currentEndDateStr = endData;
        [HashMainData shareInstance].currentCheckOutWeekStr = endWeek;
        [HashMainData shareInstance].currentDay = 1;
        [HashMainData shareInstance].currentStartDateTimeStamp = [HHAppManage getTimeStrWithString:[NSString stringWithFormat:@"%@ 00:00:00",begindateString2]];
        [HashMainData shareInstance].currentEndDateTimeStamp = [HHAppManage getTimeStrWithString:[NSString stringWithFormat:@"%@ 00:00:00",endDateString]];
        
        [self _addSubViews];
    }
    return self;
}


- (void)_addSubViews{
    
    self.addressButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.addressButton addTarget:self action:@selector(addressButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.addressButton];
    [self.addressButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.right.offset(-127);
        make.top.offset(0);
        make.height.offset(50);
    }];
    
    self.addressLabel = [[UILabel alloc] init];
    self.addressLabel.textColor = XLColor_mainTextColor;
    self.addressLabel.font = KBoldFont(16);
    self.addressLabel.text = [UserInfoManager sharedInstance].address;
    [self.addressButton addSubview:self.addressLabel];
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.top.bottom.right.offset(0);
    }];
    
    UIView *smallLineView = [[UIView alloc] init];
    smallLineView.backgroundColor = XLColor_mainColor;
    [self addSubview:smallLineView];
    [smallLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-117);
        make.width.offset(1);
        make.height.offset(20);
        make.top.offset(15);
    }];
    
    UIButton *currentLocationButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [currentLocationButton addTarget:self action:@selector(currentLocationButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:currentLocationButton];
    [currentLocationButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(0);
        make.top.offset(0);
        make.height.offset(50);
        make.width.offset(105);
    }];
    
    self.currentLocationLabel = [[UILabel alloc] init];
    self.currentLocationLabel.text = @"当前位置";
    self.currentLocationLabel.textColor = UIColorHex(b58e7f);
    self.currentLocationLabel.font = XLFont_mainTextFont;
    [currentLocationButton addSubview:self.currentLocationLabel];
    [self.currentLocationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.centerY.equalTo(currentLocationButton);
        make.height.offset(20);
    }];
    
    UIImageView *locationImageView = [[UIImageView alloc] init];
    locationImageView.image = HHGetImage(@"icon_home_currentLocation");
    [currentLocationButton addSubview:locationImageView];
    [locationImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.currentLocationLabel.mas_right).offset(5);
        make.width.height.offset(20);
        make.centerY.equalTo(currentLocationButton);
    }];
    
    UIView *locationBottomLineView = [[UIView alloc] init];
    locationBottomLineView.backgroundColor = XLColor_mainColor;
    [self addSubview:locationBottomLineView];
    [locationBottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.offset(-15);
        make.height.offset(1);
        make.top.equalTo(currentLocationButton.mas_bottom).offset(0);
    }];
    
    UIButton *dateButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [dateButton addTarget:self action:@selector(dateButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:dateButton];
    [dateButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.equalTo(locationBottomLineView.mas_bottom).offset(0);
        make.height.offset(60);
    }];
    
    UILabel *checkInLabel = [[UILabel alloc] init];
    checkInLabel.text = @"入住";
    checkInLabel.textColor = XLColor_subSubTextColor;
    checkInLabel.font = XLFont_subSubTextFont;
    [dateButton addSubview:checkInLabel];
    [checkInLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.width.offset((kScreenWidth-50)/3-30);
        make.top.offset(13.5);
        make.height.offset(15);
    }];
    
    self.checkInDateLabel =  [[UILabel alloc] init];
    self.checkInDateLabel.text = [[NSDate date] getCurrentMonthday];
    self.checkInDateLabel.textColor = XLColor_mainTextColor;
    self.checkInDateLabel.font = KBoldFont(14);
    [dateButton addSubview:self.checkInDateLabel];
    [self.checkInDateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.top.equalTo(checkInLabel.mas_bottom).offset(3);
        make.height.offset(20);
    }];
    
    self.checkInWeekLabel =  [[UILabel alloc] init];
    self.checkInWeekLabel.text = [HHAppManage weekdayStringWithTime:[[NSDate date] getCurrentday]];
    self.checkInWeekLabel.textColor = XLColor_mainTextColor;
    self.checkInWeekLabel.font = XLFont_subSubTextFont;
    [dateButton addSubview:self.checkInWeekLabel];
    [self.checkInWeekLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.checkInDateLabel.mas_right).offset(10);
        make.top.equalTo(checkInLabel.mas_bottom).offset(6);
        make.height.offset(15);
    }];
    
    self.leaveLabel = [[UILabel alloc] init];
    self.leaveLabel.text = @"离店";
    self.leaveLabel.textColor = XLColor_subSubTextColor;
    self.leaveLabel.font = XLFont_subSubTextFont;
    [dateButton addSubview:self.leaveLabel];
    [self.leaveLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset((kScreenWidth-50)/3+30);
        make.right.offset(-15);
        make.top.offset(13.5);
        make.height.offset(15);
    }];
    
    self.leaveDateLabel =  [[UILabel alloc] init];
    self.leaveDateLabel.text = [HashMainData shareInstance].endDateStr;
    self.leaveDateLabel.textColor = XLColor_mainTextColor;
    self.leaveDateLabel.font = KBoldFont(14);
    [dateButton addSubview:self.leaveDateLabel];
    [self.leaveDateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset((kScreenWidth-50)/3+30);
        make.top.equalTo(self.leaveLabel.mas_bottom).offset(3);
        make.height.offset(20);
    }];
    
    self.leaveWeekLabel =  [[UILabel alloc] init];
    self.leaveWeekLabel.text = [HashMainData shareInstance].checkOutWeekStr;
    self.leaveWeekLabel.textColor = XLColor_mainTextColor;
    self.leaveWeekLabel.font = XLFont_subSubTextFont;
    [dateButton addSubview:self.leaveWeekLabel];
    [self.leaveWeekLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leaveDateLabel.mas_right).offset(10);
        make.top.equalTo(checkInLabel.mas_bottom).offset(6);
        make.height.offset(15);
    }];
    
    self.numberDayLabel = [[UILabel alloc] init];
    self.numberDayLabel.text = @"共 1 晚";
    self.numberDayLabel.textColor = XLColor_mainTextColor;
    self.numberDayLabel.font = KBoldFont(13);
    self.numberDayLabel.textAlignment = NSTextAlignmentRight;
    [dateButton addSubview:self.numberDayLabel];
    [self.numberDayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-40);
        make.top.offset(0);
        make.height.offset(60);
        make.width.offset((kScreenWidth-50)/3);
    }];
    
    UIImageView *dateGetIntoImgView = [[UIImageView alloc] init];
    dateGetIntoImgView.image = HHGetImage(@"icon_home_gray_right");
    [self addSubview:dateGetIntoImgView];
    [dateGetIntoImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-15);
        make.top.equalTo(locationBottomLineView.mas_bottom).offset(25);
        make.width.offset(8);
        make.height.offset(10);
    }];
    
    UIView *dateBottomLineView = [[UIView alloc] init];
    dateBottomLineView.backgroundColor = XLColor_mainColor;
    [self addSubview:dateBottomLineView];
    [dateBottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.offset(-15);
        make.height.offset(1);
        make.top.equalTo(dateButton.mas_bottom).offset(0);
    }];
    
    UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchButton addTarget:self action:@selector(searchButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:searchButton];
    [searchButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.height.offset(50);
        make.top.equalTo(dateBottomLineView.mas_bottom).offset(0);
    }];
    
    self.searchImgView = [[UIImageView alloc] init];
    self.searchImgView.image = HHGetImage(@"icon_home_search");
    [searchButton addSubview:self.searchImgView];
    CGFloat w = [LabelSize widthOfString:@"关键字/位置/品牌/酒店名" font:XLFont_mainTextFont height:50];
    w = w+1;
    [self.searchImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset((kScreenWidth-50-w-19)/2);
        make.centerY.equalTo(searchButton);
        make.width.offset(17);
        make.height.offset(16);
    }];
    
    self.searchLabel = [[UILabel alloc] init];
    self.searchLabel.text = @"关键字/位置/品牌/酒店名";
    self.searchLabel.textColor = XLColor_subSubTextColor;
    self.searchLabel.font = XLFont_mainTextFont;
    self.searchLabel.textAlignment = NSTextAlignmentCenter;
    [searchButton addSubview:self.searchLabel];
    [self.searchLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.offset(0);
        make.left.equalTo(self.searchImgView.mas_right).offset(2);
    }];
    
    self.searchResultLabel = [[UILabel alloc] init];
    self.searchResultLabel.hidden = YES;
    self.searchResultLabel.textColor = XLColor_mainTextColor;
    self.searchResultLabel.font = KBoldFont(14);
    self.searchResultLabel.textAlignment = NSTextAlignmentCenter;
    [searchButton addSubview:self.searchResultLabel];
    [self.searchResultLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.offset(0);
        make.left.offset(15);
    }];
    
    self.closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.closeButton.hidden = YES;
    [self.closeButton setImage:HHGetImage(@"icon_home_search_close") forState:UIControlStateNormal];
    [self.closeButton addTarget:self action:@selector(closeButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [searchButton addSubview:self.closeButton];
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(15);
        make.right.offset(-50);
        make.centerY.equalTo(searchButton);
    }];
    
    UIImageView *searchGetIntoImgView = [[UIImageView alloc] init];
    searchGetIntoImgView.image = HHGetImage(@"icon_home_gray_right");
    [searchButton addSubview:searchGetIntoImgView];
    [searchGetIntoImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-15);
        make.centerY.equalTo(searchButton);
        make.width.offset(8);
        make.height.offset(10);
    }];
    
    UIView *searchBottomLineView = [[UIView alloc] init];
    searchBottomLineView.backgroundColor = XLColor_mainColor;
    [self addSubview:searchBottomLineView];
    [searchBottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.offset(-15);
        make.height.offset(1);
        make.top.equalTo(dateBottomLineView.mas_bottom).offset(50);
    }];
    
    UIButton *setupButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [setupButton addTarget:self action:@selector(setupButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:setupButton];
    [setupButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.height.offset(50);
        make.top.equalTo(searchBottomLineView.mas_bottom).offset(0);
    }];
    
    UIImageView *setupGetIntoImgView = [[UIImageView alloc] init];
    setupGetIntoImgView.image = HHGetImage(@"icon_home_gray_right");
    [setupButton addSubview:setupGetIntoImgView];
    [setupGetIntoImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-15);
        make.centerY.equalTo(setupButton);
        make.width.offset(8);
        make.height.offset(10);
    }];
    
    self.setupLabel = [[UILabel alloc] init];
    self.setupLabel.text = @"安全评分/检测时间/价格";
    self.setupLabel.textColor = XLColor_subSubTextColor;
    self.setupLabel.font = XLFont_mainTextFont;
    self.setupLabel.textAlignment = NSTextAlignmentCenter;
    [setupButton addSubview:self.setupLabel];
    [self.setupLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.offset(0);
        make.left.offset(15);
        make.right.offset(-15);
    }];
    
    UIView *setupBottomLineView = [[UIView alloc] init];
    setupBottomLineView.backgroundColor = XLColor_mainColor;
    [self addSubview:setupBottomLineView];
    [setupBottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.offset(-15);
        make.height.offset(1);
        make.top.equalTo(searchBottomLineView.mas_bottom).offset(50);
    }];
    
    UIButton *lookupButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [lookupButton setTitle:@"查 找" forState:UIControlStateNormal];
    [lookupButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
    lookupButton.backgroundColor = UIColorHex(b58e7f);
    lookupButton.layer.cornerRadius = 8;
    lookupButton.layer.masksToBounds = YES;
    lookupButton.titleLabel.font = XLFont_mainTextFont;
    lookupButton.layer.shadowColor = kBlackColor.CGColor;
    //shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用  (0,0)时是四周都有阴影
    lookupButton.layer.shadowOffset = CGSizeMake(0, 0);
    //阴影透明度，默认0
    lookupButton.layer.shadowOpacity = 0.3;
    //阴影半径，默认3
    lookupButton.clipsToBounds = NO;
    lookupButton.layer.shadowRadius = 3;
    [lookupButton addTarget:self action:@selector(lookupButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:lookupButton];
    [lookupButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(60);
        make.right.offset(-60);
        make.height.offset(45);
        make.top.equalTo(setupBottomLineView.mas_bottom).offset(20);
    }];
    
    
}

- (void)addressButtonAction {
    if (self.clickAddressAction) {
        self.clickAddressAction();
    }
}

- (void)currentLocationButtonAction {
    if (self.clickCurrentLocationAction) {
        self.clickCurrentLocationAction(self.currentLocationLabel);
    }
    
}

- (void)searchButtonAction {
    if (self.clickSearchAction) {
        self.clickSearchAction(self.searchResultLabel.text);
    }
}

- (void)closeButtonAction {
    
    if (self.clickDeleteSearchKey) {
        self.clickDeleteSearchKey();
    }
    
}

- (void)lookupButtonAction {
    if (self.clickLookupAction) {
        self.clickLookupAction();
    }
}

- (void)dateButtonAction {
    
    if(self.clickDateAction) {
        self.clickDateAction();
    }
}

- (void)setupButtonAction {
    if(self.selectedSetupSuccess){
        self.selectedSetupSuccess();
    }
    
}

- (void)updateCountrySearch:(NSString *)str{
    
    if(str.length == 0){
        self.searchLabel.hidden = NO;
        self.searchImgView.hidden = NO;
        self.searchResultLabel.hidden = YES;
        self.closeButton.hidden = YES;
        self.searchResultLabel.text = @"";
    }else {
        self.searchLabel.hidden = YES;
        self.searchImgView.hidden = YES;
        self.searchResultLabel.hidden = NO;
        self.closeButton.hidden = NO;
        self.searchResultLabel.text = str;
    }
    
}

@end
