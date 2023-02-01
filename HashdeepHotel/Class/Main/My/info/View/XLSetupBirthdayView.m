//
//  XLSetupBirthdayView.m
//  linlinlin
//
//  Created by cindy on 2020/12/12.
//  Copyright © 2020 yqm. All rights reserved.
//

#import "XLSetupBirthdayView.h"
@interface XLSetupBirthdayView () {
    NSString *_birthday;
    UIDatePicker *_datePicker;
}
@end
@implementation XLSetupBirthdayView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self _addSubViews];
    }
    return self;
}

- (void)_addSubViews{
    
    UIView *blackView = [[UIView alloc] init];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cancelButtonAction)];
    [blackView addGestureRecognizer:tap];
    [self addSubview:blackView];
    [blackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.offset(0);
        if (UINavigateTop == 44) {
            make.bottom.offset(-270);
        }else {
            make.bottom.offset(-250);
        }
    }];
    
    UIView *bottomWhiteView = [[UIView alloc] init];
    bottomWhiteView.backgroundColor = kWhiteColor;
    [self addSubview:bottomWhiteView];
    [bottomWhiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.offset(0);
        if (UINavigateTop == 44) {
            make.height.offset(270);
        }else {
            make.height.offset(250);
        }
    }];
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setTitleColor:XLColor_mainTextColor forState:UIControlStateNormal];
    cancelButton.titleLabel.font = XLFont_mainTextFont;
    [cancelButton addTarget:self action:@selector(cancelButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [bottomWhiteView addSubview:cancelButton];
    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.top.offset(0);
        make.width.offset(50);
        make.height.offset(50);
    }];
    
    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [doneButton setTitle:@"完成" forState:UIControlStateNormal];
    [doneButton setTitleColor:UIColorHex(b58e7f) forState:UIControlStateNormal];
    doneButton.titleLabel.font = XLFont_mainTextFont;
    [doneButton addTarget:self action:@selector(doneButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [bottomWhiteView addSubview:doneButton];
    [doneButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-15);
        make.top.offset(0);
        make.width.offset(50);
        make.height.offset(50);
    }];
    
    UIView *bottomLineView = [[UIView alloc] init];
    bottomLineView.backgroundColor  = XL_lineColor;
    [bottomWhiteView addSubview:bottomLineView];
    [bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.offset(0);
        make.top.equalTo(doneButton.mas_bottom).offset(0);
        make.height.offset(1);
    }];
    
    _datePicker = [[UIDatePicker alloc] init];
    //设置地区: zh-中国
    _datePicker.locale = [NSLocale localeWithLocaleIdentifier:@"zh"];
    //设置日期模式(Displays month, day, and year depending on the locale setting)
    _datePicker.datePickerMode = UIDatePickerModeDate;
    
    // 设置当前显示时间
    [_datePicker addTarget:self action:@selector(changeValue)forControlEvents:UIControlEventValueChanged];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8]];//解决8小时时间差问题
    if ([UserInfoManager sharedInstance].birthday) {
        NSDate *birthdayDate = [dateFormatter dateFromString:[UserInfoManager sharedInstance].birthday];
        [_datePicker setDate:birthdayDate animated:YES];

    }
    if (@available(iOS 13.4, *)) {
        _datePicker.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];//新发现这里不会根据系统的语言变了
        _datePicker.preferredDatePickerStyle = UIDatePickerStyleWheels;
    }
    
    NSDate *date = [NSDate date];
    NSDateFormatter *format1=[[NSDateFormatter alloc] init];
    [format1 setDateFormat:@"yyyy-MM-dd"];
    _birthday = [format1 stringFromDate:date];
    
    NSDateFormatter* formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyy-MM-dd"];
    NSDate* endDate = [formater dateFromString:_birthday];
    _datePicker.maximumDate  = endDate;
    [bottomWhiteView addSubview:_datePicker];
    [_datePicker mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.top.equalTo(bottomLineView.mas_bottom).offset(10);
        make.bottom.offset(0);
        make.centerX.offset(0);
        make.right.offset(0);
    }];
    
}

- (void)changeValue{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //设置时间格式
    formatter.dateFormat = @"yyyy-MM-dd";
    _birthday = [formatter  stringFromDate:_datePicker.date];
}
- (void)doneButtonAction {
    
    if (self.clickDoneAction) {
        self.clickDoneAction([NSString stringWithFormat:@"%@",_birthday]);
    }
}

- (void)cancelButtonAction {
    if (self.clickCancelAction) {
        self.clickCancelAction();
    }
}
@end
