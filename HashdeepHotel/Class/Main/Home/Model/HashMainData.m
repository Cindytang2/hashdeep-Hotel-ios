//
//  HashMainData.m
//  HashdeepHotel
//
//  Created by hashdeep on 2022/3/30.
//

#import "HashMainData.h"

@implementation HashMainData

#define kEncodedObjectPath_User ([[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"HashMainData"])
+ (instancetype)shareInstance
{
    static HashMainData *_sharedManager = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _sharedManager = [[HashMainData alloc] init];
    });
    return _sharedManager;
}

+ (BOOL)synchronize  {
   return [NSKeyedArchiver archiveRootObject:[HashMainData shareInstance] toFile:kEncodedObjectPath_User];
}

//把一个对象从解码器中取出
- (id)initWithCoder:(NSCoder *)aDecoder  {
   self = [super init];
    if(self) {
       [self yy_modelInitWithCoder:aDecoder];
    }
   return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder  {
   [self yy_modelEncodeWithCoder:aCoder];
}

+ (void)updateDateWithDic:(NSDictionary *)dic {
    //修改开始/结束 日期，星期与天数
    [HashMainData shareInstance].startDateStr = dic[@"startDate"];
    [HashMainData shareInstance].checkInWeekStr = dic[@"checkInWeek"];
    [HashMainData shareInstance].endDateStr = dic[@"endDate"];
    [HashMainData shareInstance].checkOutWeekStr = dic[@"checkOutWeek"];
    [HashMainData shareInstance].day = [NSString stringWithFormat:@"%@ ",dic[@"days"]].integerValue;
    
    //修改开始/结束 日期的时间戳
    NSArray *array = [[HashMainData shareInstance].startDateStr componentsSeparatedByString:@"月"];
    NSString *lastStr = array.lastObject;
    NSArray *riArray = [lastStr componentsSeparatedByString:@"日"];
    [HashMainData shareInstance].startDateTimeStamp = [HHAppManage getTimeStrWithString:[NSString stringWithFormat:@"%@-%@-%@ 00:00:00",dic[@"start_year"],array.firstObject,riArray.firstObject]];
    
    NSArray *end_array = [[HashMainData shareInstance].endDateStr componentsSeparatedByString:@"月"];
    NSString *end_lastStr = end_array.lastObject;
    NSArray *end_riArray = [end_lastStr componentsSeparatedByString:@"日"];
    
    [HashMainData shareInstance].endDateTimeStamp = [HHAppManage getTimeStrWithString:[NSString stringWithFormat:@"%@-%@-%@ 00:00:00",dic[@"end_year"],end_array.firstObject,end_riArray.firstObject]];
    
    [HashMainData shareInstance].currentStartDateStr = [HashMainData shareInstance].startDateStr;
    [HashMainData shareInstance].currentCheckInWeekStr = [HashMainData shareInstance].checkInWeekStr;
    [HashMainData shareInstance].currentEndDateStr = [HashMainData shareInstance].endDateStr;
    [HashMainData shareInstance].currentCheckOutWeekStr = [HashMainData shareInstance].checkOutWeekStr;
    [HashMainData shareInstance].currentDay = [HashMainData shareInstance].day;
    [HashMainData shareInstance].currentStartDateTimeStamp = [HashMainData shareInstance].startDateTimeStamp;
    [HashMainData shareInstance].currentEndDateTimeStamp = [HashMainData shareInstance].endDateTimeStamp;
}

+ (void)updateHourlyDateWithDic:(NSDictionary *)dic{
    [HashMainData shareInstance].hourStartDateStr = dic[@"startDate"];
    
    [HashMainData shareInstance].hourCheckInWeekStr = dic[@"checkInWeek"];
    //修改开始/结束 日期的时间戳
    NSArray *array = [[HashMainData shareInstance].hourStartDateStr componentsSeparatedByString:@"月"];
    NSString *lastStr = array.lastObject;
    NSArray *riArray = [lastStr componentsSeparatedByString:@"日"];
    [HashMainData shareInstance].hourStartDateTimeStamp = [HHAppManage getTimeStrWithString:[NSString stringWithFormat:@"%@-%@-%@ 00:00:00",dic[@"start_year"],array.firstObject,riArray.firstObject]];
    
    
    [HashMainData shareInstance].currentStartDateStr = [HashMainData shareInstance].hourStartDateStr;
    [HashMainData shareInstance].currentCheckInWeekStr = [HashMainData shareInstance].hourCheckInWeekStr;
    [HashMainData shareInstance].currentEndDateStr = @"";
    [HashMainData shareInstance].currentCheckOutWeekStr = @"";
    [HashMainData shareInstance].currentDay = 0;
    [HashMainData shareInstance].currentStartDateTimeStamp = [HashMainData shareInstance].hourStartDateTimeStamp;
    [HashMainData shareInstance].currentEndDateTimeStamp = [NSString stringWithFormat:@"%ld", [HashMainData shareInstance].hourStartDateTimeStamp.integerValue+1];
}

@end
