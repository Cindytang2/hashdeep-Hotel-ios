//
//  HHOneCheckInView.m
//  HashdeepHotel
//
//  Created by Cindy on 2022/8/3.
//

#import "HHOneCheckInView.h"

@interface HHOneCheckInView ()
@property (nonatomic, strong) UIView *whiteView;
@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, strong) UILabel *numberLabel;
@property (nonatomic, assign) NSInteger number;
@property (nonatomic, copy) NSString *endString;

@property (nonatomic, copy) NSString *beginDateStr;
@property (nonatomic, copy) NSString *beginWeek;
@property (nonatomic, copy) NSString *endDateStr;
@property (nonatomic, copy) NSString *endWeek;
@end

@implementation HHOneCheckInView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.number = 1;
        
        [self _addSubViews];
    }
    return self;
}


- (void)_addSubViews{
    
    self.whiteView = [[UIView alloc] init];
    self.whiteView.backgroundColor = kWhiteColor;
    self.whiteView.layer.cornerRadius = 15;
    self.whiteView.layer.masksToBounds = YES;
    [self addSubview:self.whiteView];
    [self.whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(50);
        make.right.offset(-50);
        make.height.offset(200);
        make.centerY.equalTo(self);
    }];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = XLColor_mainTextColor;
    titleLabel.font = KBoldFont(16);
    titleLabel.text = @"一键续住";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.whiteView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.top.offset(15);
        make.height.offset(20);
        make.right.offset(-15);
    }];
    
    self.detailLabel = [[UILabel alloc] init];
    self.detailLabel.font = XLFont_subSubTextFont;
    self.detailLabel.textColor = XLColor_mainTextColor;
    self.detailLabel.textAlignment = NSTextAlignmentCenter;
    [self.whiteView addSubview:self.detailLabel];
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).offset(10);
        make.left.offset(0);
        make.right.offset(0);
        make.height.offset(20);
    }];
    
    UIView *grayView = [UIButton buttonWithType:UIButtonTypeCustom];
    grayView.backgroundColor = XLColor_mainColor;
    grayView.layer.cornerRadius = 45/2.0f;
    grayView.layer.masksToBounds = YES;
    grayView.layer.shadowColor = kBlackColor.CGColor;
    //shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用  (0,0)时是四周都有阴影
    grayView.layer.shadowOffset = CGSizeMake(0, 0);
    //阴影透明度，默认0
    grayView.layer.shadowOpacity = 0.3;
    //阴影半径，默认3
    grayView.clipsToBounds = NO;
    grayView.layer.shadowRadius = 3;
    [self.whiteView addSubview:grayView];
    [grayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(40);
        make.right.offset(-40);
        make.height.offset(45);
        make.top.equalTo(self.detailLabel.mas_bottom).offset(20);
    }];
    
    self.numberLabel = [[UILabel alloc] init];
    self.numberLabel.font = XLFont_mainTextFont;
    self.numberLabel.textColor = XLColor_mainTextColor;
    self.numberLabel.text = @"1";
    self.numberLabel.textAlignment = NSTextAlignmentCenter;
    [grayView addSubview:self.numberLabel];
    [self.numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.bottom.offset(0);
    }];
    
    UIButton *jianButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [jianButton setTitle:@"-" forState:UIControlStateNormal];
    [jianButton setTitleColor:XLColor_mainTextColor forState:UIControlStateNormal];
    jianButton.backgroundColor = kWhiteColor;
    jianButton.layer.cornerRadius = 45/2.0f;
    jianButton.layer.masksToBounds = YES;
    jianButton.titleLabel.font = XLFont_mainTextFont;
    jianButton.layer.shadowColor = kBlackColor.CGColor;
    //shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用  (0,0)时是四周都有阴影
    jianButton.layer.shadowOffset = CGSizeMake(0, 0);
    //阴影透明度，默认0
    jianButton.layer.shadowOpacity = 0.3;
    //阴影半径，默认3
    jianButton.clipsToBounds = NO;
    jianButton.layer.shadowRadius = 3;
    [jianButton addTarget:self action:@selector(jianButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [grayView addSubview:jianButton];
    [jianButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.offset(0);
        make.height.width.offset(45);
    }];
    
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [addButton setTitle:@"+" forState:UIControlStateNormal];
    [addButton setTitleColor:XLColor_mainTextColor forState:UIControlStateNormal];
    addButton.backgroundColor = kWhiteColor;
    addButton.layer.cornerRadius = 45/2.0f;
    addButton.layer.masksToBounds = YES;
    addButton.titleLabel.font = XLFont_mainTextFont;
    addButton.layer.shadowColor = kBlackColor.CGColor;
    //shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用  (0,0)时是四周都有阴影
    addButton.layer.shadowOffset = CGSizeMake(0, 0);
    //阴影透明度，默认0
    addButton.layer.shadowOpacity = 0.3;
    //阴影半径，默认3
    addButton.clipsToBounds = NO;
    addButton.layer.shadowRadius = 3;
    [addButton addTarget:self action:@selector(addButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [grayView addSubview:addButton];
    [addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.offset(0);
        make.height.width.offset(45);
    }];
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setTitleColor:XLColor_mainTextColor forState:UIControlStateNormal];
    cancelButton.backgroundColor = XLColor_mainColor;
    cancelButton.titleLabel.font = XLFont_subSubTextFont;
    [cancelButton addTarget:self action:@selector(cancelButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.whiteView addSubview:cancelButton];
    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.offset(0);
        make.height.offset(36);
        make.width.offset((kScreenWidth-100)/2);
    }];
    
    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [doneButton setTitle:@"确认" forState:UIControlStateNormal];
    [doneButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
    doneButton.backgroundColor = UIColorHex(b58e7f);
    doneButton.titleLabel.font = XLFont_subSubTextFont;
    [doneButton addTarget:self action:@selector(doneButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.whiteView addSubview:doneButton];
    [doneButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.offset(0);
        make.height.offset(36);
        make.width.offset((kScreenWidth-100)/2);
    }];
}

- (void)setCheck_in_and_out:(NSDictionary *)check_in_and_out {
    _check_in_and_out = check_in_and_out;
    
    NSArray *bArray = [_check_in_and_out[@"checkout_date_desc"] componentsSeparatedByString:@"("];
    self.beginDateStr = bArray.firstObject;
   
    NSString *str = [HHAppManage getDateWithString:self.beginDateStr];
    self.endDateStr = [self getOtherDay:str numDay:1];
    NSString *str2 = [HHAppManage getDateWithString:self.endDateStr];
    
    self.detailLabel.text = [NSString stringWithFormat:@"%@续租,%@离店",self.beginDateStr, self.endDateStr];
    
    self.beginWeek = [HHAppManage weekdayStringWithTime:str];
    self.endWeek = [HHAppManage weekdayStringWithTime:str2];
    [HashMainData shareInstance].selectedEndStr = str;
    
}
- (void)jianButtonAction {
    if (self.number == 1) {
        return;
    }
    
    self.number--;
    self.numberLabel.text = [NSString stringWithFormat:@"%ld",self.number];
    
    NSString *str = [HHAppManage getDateWithString:self.endDateStr];
    self.endString = [self getSmallOtherDay:str numDay:1];
    
    
    self.detailLabel.text = [NSString stringWithFormat:@"%@续租,%@离店", self.beginDateStr,self.endString];
    self.endDateStr = self.endString;
    NSString *str2 = [HHAppManage getDateWithString:self.endDateStr];
    self.endWeek = [HHAppManage weekdayStringWithTime:str2];
    
}

- (NSDate *)dateFromYMDStr:(NSString *)YMDStr{
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    return [fmt dateFromString:YMDStr];
}

- (NSString *)getSmallOtherDay:(NSString *)dayStr numDay:(NSInteger)numDay{
    
    NSDate *aDate =  [self dateFromYMDStr:dayStr];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDateComponents *components = [gregorian components:NSCalendarUnitWeekday | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:aDate];
        [components setDay:([components day]-numDay)];
        
        NSDate *beginningOfWeek = [gregorian dateFromComponents:components];
        NSDateFormatter *dateday = [[NSDateFormatter alloc] init];
        [dateday setDateFormat:@"MM月dd日"];
        return [dateday stringFromDate:beginningOfWeek];
}

- (NSString *)getOtherDay:(NSString *)dayStr numDay:(NSInteger)numDay{
    
    NSDate *aDate =  [self dateFromYMDStr:dayStr];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDateComponents *components = [gregorian components:NSCalendarUnitWeekday | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:aDate];
        [components setDay:([components day]+numDay)];
        
        NSDate *beginningOfWeek = [gregorian dateFromComponents:components];
        NSDateFormatter *dateday = [[NSDateFormatter alloc] init];
        [dateday setDateFormat:@"MM月dd日"];
        return [dateday stringFromDate:beginningOfWeek];
}

- (void)addButtonAction {
    if (self.number == 10) {
        return;
    }
    self.number = self.number+1;
    self.numberLabel.text = [NSString stringWithFormat:@"%ld",self.number];
    
    self.endString = [self getOtherDay:[HashMainData shareInstance].selectedEndStr numDay:self.number];
    
    self.detailLabel.text = [NSString stringWithFormat:@"%@续租,%@离店", self.beginDateStr,self.endString];
    self.endDateStr = self.endString;
    
    NSString *endDateString = [HHAppManage getDateWithString:self.endDateStr];
    
    self.endWeek = [HHAppManage weekdayStringWithTime:endDateString];
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

- (void)cancelButtonAction {
    
    if (self.clickCloseButton) {
        self.clickCloseButton();
    }
}

- (void)doneButtonAction {
    
    NSString *beginDateString = [HHAppManage getDateWithString:self.beginDateStr];
    NSString *beginTimeNumber = [HHAppManage getTimeStrWithString:[NSString stringWithFormat:@"%@ 00:00:00",beginDateString]];

    
    NSString *endDateString = [HHAppManage getDateWithString:self.endDateStr];
    NSString *endTimeNumber = [HHAppManage getTimeStrWithString:[NSString stringWithFormat:@"%@ 00:00:00",endDateString]];
    
    NSDictionary *dic = @{
        @"startDateStr":self.beginDateStr,
        @"checkInWeekStr":self.beginWeek,
        @"days":[NSString stringWithFormat:@"%ld晚",self.number],
        @"endDateStr":self.endDateStr,
        @"checkOutWeekStr":self.endWeek
    };
    
    if (self.clickDoneButton) {
        self.clickDoneButton(beginTimeNumber.integerValue, endTimeNumber.integerValue,dic);
    }
}

@end
