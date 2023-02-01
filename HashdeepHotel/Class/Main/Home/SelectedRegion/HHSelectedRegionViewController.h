//
//  HHSelectedRegionViewController.h
//  HashdeepHotel
//
//  Created by Cindy on 2022/7/14.
//

#import "HHBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface HHSelectedRegionViewController : HHBaseViewController
@property (strong, nonatomic) void(^clickCellAction)(NSString *addressStr, NSString *longitude, NSString *latitude);

@end

NS_ASSUME_NONNULL_END
