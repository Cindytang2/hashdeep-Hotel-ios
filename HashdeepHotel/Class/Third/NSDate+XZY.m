//
//  NSDate+XZY.m
//  HashdeepHotel
//
//  Created by hashdeep on 2022/3/25.
//

#import "NSDate+XZY.h"

@implementation NSDate (XZY)


- (NSString *)getCurrentday{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateTime = [formatter stringFromDate:[NSDate date]];
    return dateTime;
}
- (NSString *)getCurrentMonthday{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM月dd日"];
    NSString *dateTime = [formatter stringFromDate:[NSDate date]];
    return dateTime;
}
//获取明天时间
- (NSString *)getTomorrowMonthday{
    NSString *currentDayStr = [self getCurrentday];
    NSDate *aDate =  [self dateFromYMDStr:currentDayStr];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDateComponents *components = [gregorian components:NSCalendarUnitWeekday | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:aDate];
        [components setDay:([components day]+1)];
        
        NSDate *beginningOfWeek = [gregorian dateFromComponents:components];
        NSDateFormatter *dateday = [[NSDateFormatter alloc] init];
        [dateday setDateFormat:@"MM月dd日"];
        return [dateday stringFromDate:beginningOfWeek];
}


- (NSString *)nowTimeInterval {
    // 现在的时间戳
    
    // 获取当前时间0秒后的时间
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0];
    // *1000 是精确到毫秒，不乘就是精确到秒
    NSTimeInterval time = [date timeIntervalSince1970];
    NSString *timeStr = [NSString stringWithFormat:@"%.0f", time];
    return timeStr;
}
//获取明天时间
- (NSString *)getTomorrowDay{
    NSString *currentDayStr = [self getCurrentday];
    NSDate *aDate =  [self dateFromYMDStr:currentDayStr];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDateComponents *components = [gregorian components:NSCalendarUnitWeekday | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:aDate];
        [components setDay:([components day]+1)];
        
        NSDate *beginningOfWeek = [gregorian dateFromComponents:components];
        NSDateFormatter *dateday = [[NSDateFormatter alloc] init];
        [dateday setDateFormat:@"yyyy-MM-dd"];
        return [dateday stringFromDate:beginningOfWeek];
}

- (NSString *)getOtherDay:(NSInteger)numDay{
    NSString *currentDayStr = [self getCurrentday];
    NSDate *aDate =  [self dateFromYMDStr:currentDayStr];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDateComponents *components = [gregorian components:NSCalendarUnitWeekday | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:aDate];
        [components setDay:([components day]+numDay)];
        
        NSDate *beginningOfWeek = [gregorian dateFromComponents:components];
        NSDateFormatter *dateday = [[NSDateFormatter alloc] init];
        [dateday setDateFormat:@"MM月dd日"];
        return [dateday stringFromDate:beginningOfWeek];
}
-(BOOL)isToday:(NSDate*)date{
//    NSTimeInterval secondsPerDay = 24 * 60 * 60;
    NSDate *today = [[NSDate alloc] init];
//    NSDate *tomorrow = [today dateByAddingTimeInterval:secondsPerDay];
    NSString * todayString = [[today description] substringToIndex:10];
    
    NSString * dateString = [[date description] substringToIndex:10];
    if ([dateString isEqualToString:todayString]){
        return YES;
    }return NO;
}
-(BOOL)isYesterday:(NSDate*)date{
    NSTimeInterval secondsPerDay = 24 * 60 * 60;
    NSDate *today = [[NSDate alloc] init];
    NSDate *yesterday = [today dateByAddingTimeInterval: -secondsPerDay];
    NSString * yesterdayString = [[yesterday description] substringToIndex:10];
    
    NSString * dateString = [[date description] substringToIndex:10];
    if ([dateString isEqualToString:yesterdayString]){
        return YES;
    }return NO;
}
//判断是否为明天
-(BOOL)isTomorrowday:(NSDate*)date{
    NSTimeInterval secondsPerDay = 24 * 60 * 60;
    NSDate *today = [[NSDate alloc] init];
    NSDate *tomorrow = [today dateByAddingTimeInterval:secondsPerDay];
    NSString * tomorrowString = [[tomorrow description] substringToIndex:10];
    
    NSString * dateString = [[date description] substringToIndex:10];
    if ([dateString isEqualToString:tomorrowString]){
        return YES;
    }return NO;
}
-(BOOL)isThisYear
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int unit = NSCalendarUnitYear;
    // 1.获得当前时间的年月日
    NSDateComponents *nowCmps = [calendar components:unit fromDate:[NSDate date]];
    // 2.获得self的年月日
    NSDateComponents *selfCmps = [calendar components:unit fromDate:self];
    return nowCmps.year == selfCmps.year;
}

-(NSDateComponents *)deltaWithNow
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int unit = NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    return [calendar components:unit fromDate:self toDate:[NSDate date] options:0];
}
//返回日期yyyy-MM-dd的格式的日期
- (NSDate *)dateWithYMD
{
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    NSString *selfStr = [fmt stringFromDate:self];
    return [fmt dateFromString:selfStr];
}

- (NSDate *)dateFromYMDStr:(NSString *)YMDStr
{
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    return [fmt dateFromString:YMDStr];
}

- (NSString *)weekdayStringWithDate:(NSDate *)date{
    //获取星期几
    NSDateComponents *componets = [[NSCalendar autoupdatingCurrentCalendar] components:NSCalendarUnitWeekday fromDate:date];
    NSInteger weekday = [componets weekday];//1代表星期日，2代表星期一，后面依次
    NSArray *weekArray = @[@"周日",@"周一",@"周二",@"周三",@"周四",@"周五",@"周六"];
    NSString *weekStr = weekArray[weekday-1];
    return weekStr;
}

// 字符串转时间戳 如：2022-06-07  （精确到毫秒*1000）
- (float )getTimeStrWithString:(NSString *)str {
    str = [NSString stringWithFormat:@"2022年%@",str];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];// 创建一个时间格式化对象
    [dateFormatter setDateFormat:@"YYYY年MM月dd日"]; //设定时间的格式
    NSDate *tempDate = [dateFormatter dateFromString:str];//将字符串转换为时间对象
    NSString *timeStr = [NSString stringWithFormat:@"%ld", (long)[tempDate timeIntervalSince1970]];//字符串转成时间戳,精确到毫秒*1000
    float timeS = (long)[tempDate timeIntervalSince1970];
    return timeS;
}

-(NSString*)dateStrWithStr:(NSString*)dateStr{
    // dateStr格式为MM月dd日 要改成MM.DD
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];// 创建一个时间格式化对象
    [dateFormatter setDateFormat:@"MM月dd日"]; //设定时间的格式
    NSDate *tempDate = [dateFormatter dateFromString:dateStr];//将字符串转换为时间对象
    
    NSDateFormatter *formatter2 = [[NSDateFormatter alloc] init];
    [formatter2 setDateFormat:@"MM.dd"];
    NSString *currentDateString = [formatter2 stringFromDate:tempDate];
    return currentDateString;
}
-(NSString *)timestampSwitchTime:(NSInteger)timestamp andFormatter:(NSString *)format

{

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];

    [formatter setDateStyle:NSDateFormatterMediumStyle];

    [formatter setTimeStyle:NSDateFormatterShortStyle];

    //（@"YYYY-MM-dd hh:mm:ss"）设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制

    [formatter setDateFormat:@"MM月dd日"];

    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];

    [formatter setTimeZone:timeZone];

    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:timestamp];

    NSLog(@"1296035591  = %@",confromTimesp);

    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];

    //NSLog(@"&&&&&&&confromTimespStr = : %@",confromTimespStr);

    return confromTimespStr;

}
@end
