//
//  HHCountryView.h
//  HashdeepHotel
//
//  Created by Cindy on 2022/7/13.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HHCountryView : UIView
/**
 选择地点
 */
@property (strong, nonatomic) void(^clickAddressAction)(void);

/**
 获取当前位置
 */
@property (strong, nonatomic) void(^clickCurrentLocationAction)(UILabel *label);
/**
 删除搜索条件
 */
@property (strong, nonatomic) void(^clickDeleteSearchKey)(void);

/**
 搜索关键字
 */
@property (strong, nonatomic) void(^clickSearchAction)(NSString *str);

/**
 查找按钮
 */
@property (strong, nonatomic) void(^clickLookupAction)(void);

/**
 设置价格
 */
@property (strong, nonatomic) void(^selectedSetupSuccess)(void);
/**
 日期
 */
@property (strong, nonatomic) void(^clickDateAction)(void);

@property (nonatomic, strong) UILabel *addressLabel;//具体地址
@property (nonatomic, strong) UILabel *currentLocationLabel;//当前位置
@property (nonatomic, strong) UILabel *searchResultLabel;//关键字
@property (nonatomic, strong) UILabel *checkInDateLabel;//入住日期
@property (nonatomic, strong) UILabel *checkInWeekLabel;//入住星期
@property (nonatomic, strong) UILabel *leaveLabel;
@property (nonatomic, strong) UILabel *leaveDateLabel;//离店日期
@property (nonatomic, strong) UILabel *leaveWeekLabel;//离店星期
@property (nonatomic, strong) UILabel *numberDayLabel;//入住几晚
@property (nonatomic, strong) UILabel *searchLabel;
@property (nonatomic, strong) UIImageView *searchImgView;
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UILabel *setupLabel;
- (void)updateCountrySearch:(NSString *)str;
@end

NS_ASSUME_NONNULL_END







/**
 //- (void)getNowTime {
 //    NSDate *date = [NSDate date];
 //    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
 //    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
 //
 //    NSString *str = [formatter stringFromDate:date];
 //
 //    //下面是单独获取每项的值
 //    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
 //    NSDateComponents *comps = [[NSDateComponents alloc] init];
 //    NSInteger unitFlags = NSYearCalendarUnit |NSMonthCalendarUnit |NSDayCalendarUnit |NSWeekdayCalendarUnit |NSHourCalendarUnit |NSMinuteCalendarUnit |NSSecondCalendarUnit;
 //    comps = [calendar components:unitFlags fromDate:date];
 //    //星期 注意星期是从周日开始计算
 //    int week = [comps weekday];
 //    //年
 //    int year=[comps year];
 //    //月
 //    int month = [comps month];
 //    //日
 //    int day = [comps day];
 //
 //    DayModel *startModel = [[DayModel alloc] init];
 //    startModel.year = year;
 //    startModel.month = month;
 //    startModel.day = day;
 //    startModel.dayDate = date;
 //    startModel.dayOfTheWeek = week;
 //    startModel.state = DayModelStateStart;
 //    [HashMainData shareInstance].startModel = startModel;
 //}
 */
