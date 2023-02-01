//
//  HHDormitoryDetailViewController.h
//  HashdeepHotel
//
//  Created by Cindy on 2022/12/13.
//

#import "HHBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface HHDormitoryDetailViewController : HHBaseViewController
@property (nonatomic, copy) NSString *homestay_id;
@property (nonatomic, copy) NSString *homestay_room_id;
@property (nonatomic, copy) NSString *backType; 
@property (nonatomic, strong) DayModel *startModel;//默认的显示的开始时间
@property (nonatomic, strong) DayModel *endModel;//默认的显示的结束时间
@property (strong, nonatomic) void(^updateDateAction)(DayModel *startModel,DayModel *endModel);

@end

NS_ASSUME_NONNULL_END
