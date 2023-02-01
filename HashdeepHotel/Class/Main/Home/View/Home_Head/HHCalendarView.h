//
//  HHCalendarView.h
//  HashdeepHotel
//
//  Created by Cindy on 2022/7/14.
//

#import <UIKit/UIKit.h>
#import "MonthModel.h"
NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger, DateType) {
    KDateTypeContry = 0,
    KDateTypeHour = 1,
    KDateTypeDormitory = 2,
};

@interface HHCalendarView : UIView
@property(nonatomic, assign)DateType dateType;
@property(nonatomic, assign)BOOL isHotelDetail;
/**
 关闭日期UI
 */
@property (strong, nonatomic) void(^clickCloseButton)(void);

/**
 日期选择完毕
 */
@property (strong, nonatomic) void(^calendarViewBlock)(NSDictionary *dic,DateType dateType, DayModel *startModel,DayModel *endModel);
@property (nonatomic, strong) DayModel *startModel;//默认的显示的开始时间
@property (nonatomic, strong) DayModel *endModel;//默认的显示的结束时间
-(void)reloadMyTable;
@end

NS_ASSUME_NONNULL_END
