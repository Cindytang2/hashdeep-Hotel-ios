//
//  HHHotelDetailViewController.h
//  HashdeepHotel
//
//  Created by Cindy on 2022/7/25.
//

#import "HHBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface HHHotelDetailViewController : HHBaseViewController
@property (nonatomic, copy) NSString *hotel_id;
@property (nonatomic, assign) NSInteger dateType;
@property (nonatomic, copy) NSString *backType;
@property (nonatomic, strong) DayModel *startModel;//默认的显示的开始时间
@property (nonatomic, strong) DayModel *endModel;//默认的显示的结束时间
@property (strong, nonatomic) void(^updateCollectionSuccess)(NSString *hotel_id);
@property (strong, nonatomic) void(^updateDateAction)(NSInteger dateType,DayModel *startModel,DayModel *endModel);
@end

NS_ASSUME_NONNULL_END
