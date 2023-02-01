//
//  HashMainData.h
//  HashdeepHotel
//
//  Created by hashdeep on 2022/3/30.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "MonthModel.h"
NS_ASSUME_NONNULL_BEGIN


@interface HashMainData : NSObject

@property (nonatomic, copy) NSString *currentStartDateStr;
@property (nonatomic, copy) NSString *currentEndDateStr;
@property (nonatomic, copy) NSString *currentCheckInWeekStr;
@property (nonatomic, copy) NSString *currentCheckOutWeekStr;
@property (nonatomic, copy) NSString *currentStartDateTimeStamp;
@property (nonatomic, copy) NSString *currentEndDateTimeStamp;
@property (nonatomic, assign) NSInteger currentDay;

@property (nonatomic, assign) NSInteger day;
@property (nonatomic,copy) NSString *tel;
@property (nonatomic,copy) NSString *user_head_img;//

@property (nonatomic, copy) NSString *startDateStr;
@property (nonatomic, copy) NSString *endDateStr;
@property (nonatomic, copy) NSString *checkInWeekStr;
@property (nonatomic, copy) NSString *checkOutWeekStr;
@property (nonatomic, copy) NSString *startDateTimeStamp;
@property (nonatomic, copy) NSString *endDateTimeStamp;

@property (nonatomic, copy) NSString *longitude;
@property (nonatomic, copy) NSString *latitude;
@property (nonatomic, copy) NSString *selectedEndStr;
@property (nonatomic,assign) CGFloat selectedMinimum;
@property (nonatomic,assign) CGFloat selectedMaximum;
@property(nonatomic, copy) NSString *allPriceStr;
@property(nonatomic, copy) NSString *priceStr;
@property(nonatomic, copy) NSString *timeStr;
@property(nonatomic, copy) NSString *commentStr;
@property(nonatomic, copy) NSString *timeResult;
@property(nonatomic, assign) CGFloat detect_time;
@property(nonatomic, assign) CGFloat safe_star;
@property(nonatomic, copy) NSString *securityResult;
@property(nonatomic, strong) DayModel *startModel;
@property(nonatomic, strong) DayModel *endModel;

//时租房
@property(nonatomic,copy)NSString *hourStartDateStr;
@property(nonatomic,copy)NSString *hourStartDateTimeStamp;
@property(nonatomic,copy)NSString *hourCheckInWeekStr;
@property(nonatomic, strong) DayModel *hourlyStartModel;

@property(nonatomic, assign) NSInteger dormitoryPeopleNumber;
@property(nonatomic, assign) NSInteger dormitoryBedNumber;
+ (instancetype)shareInstance;

+ (BOOL)synchronize;

//更新国内/国际的日期
+ (void)updateDateWithDic:(NSDictionary *)dic;

//更新时租房的日期
+ (void)updateHourlyDateWithDic:(NSDictionary *)dic;


@end

NS_ASSUME_NONNULL_END
