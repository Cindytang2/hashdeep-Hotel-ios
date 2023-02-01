//
//  HHLandladyHomeViewController.h
//  HashdeepHotel
//
//  Created by Cindy on 2022/12/21.
//

#import "HHBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface HHLandladyHomeViewController : HHBaseViewController
@property (nonatomic, copy) NSString *homestay_id;
@property (nonatomic, strong) DayModel *startModel;//默认的显示的开始时间
@property (nonatomic, strong) DayModel *endModel;//默认的显示的结束时间

@end

NS_ASSUME_NONNULL_END
