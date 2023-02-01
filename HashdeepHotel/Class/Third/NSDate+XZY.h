//
//  NSDate+XZY.h
//  HashdeepHotel
//
//  Created by hashdeep on 2022/3/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDate (XZY)
- (NSString *)nowTimeInterval;
//获取今天时间
- (NSString *)getCurrentday;
- (NSString *)getCurrentMonthday;
//获取明天时间
- (NSString *)getTomorrowDay;
- (NSString *)getTomorrowMonthday;
//获取numDay天时间
- (NSString *)getOtherDay:(NSInteger)numDay;

//判断是否为今天
-(BOOL)isToday:(NSDate*)date;
//判断是否为明天
-(BOOL)isTomorrowday:(NSDate*)date;
//判断是否为昨天
-(BOOL)isYesterday:(NSDate*)date;
//判断是否为今年
-(BOOL)isThisYear;
- (NSString *)weekdayStringWithDate:(NSDate *)date;
- (float )getTimeStrWithString:(NSString *)str;

-(NSString*)dateStrWithStr:(NSString*)dateStr;

-(NSString *)timestampSwitchTime:(NSInteger)timestamp andFormatter:(NSString *)format;
@end

NS_ASSUME_NONNULL_END
