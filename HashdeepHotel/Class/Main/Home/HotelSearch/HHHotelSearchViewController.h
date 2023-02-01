//
//  HHHotelSearchViewController.h
//  HashdeepHotel
//
//  Created by Cindy on 2022/7/18.
//

#import "HHBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger, HotelSearchType) {
    KHotelSearchTypeContry = 0,//国内国际
    KHotelSearchTypeHourly = 1,//时租房
    KHotelSearchTypeDormintory = 2//民宿
};

@interface HHHotelSearchViewController : HHBaseViewController
@property(nonatomic, assign)HotelSearchType hotelSearchType;
@property (nonatomic, copy) NSString *searchKeyString;
@property (nonatomic, copy) NSString *type_click;
@property (nonatomic, copy) NSString *type_Str;
@property (nonatomic, strong) NSArray *type_has_tag;
@property (nonatomic, strong) NSDictionary *type_section;
@property (nonatomic, strong) DayModel *startModel;//默认的显示的开始时间
@property (nonatomic, strong) DayModel *endModel;//默认的显示的结束时间
@property (strong, nonatomic) void(^updateDateAction)(DayModel *startModel,DayModel *endModel,NSString *searchStr,NSString *str);
@end

NS_ASSUME_NONNULL_END
