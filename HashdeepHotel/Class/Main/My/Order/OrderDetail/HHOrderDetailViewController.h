//
//  HHOrderDetailViewController.h
//  HashdeepHotel
//
//  Created by Cindy on 2022/7/22.
//

#import "HHBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface HHOrderDetailViewController : HHBaseViewController
@property (nonatomic, copy) NSString *order_id;
@property (nonatomic, copy) NSString *backType;
@property (nonatomic, assign) NSInteger dateType;
@property (strong, nonatomic) void(^deleteSuccess)(void);
@property (strong, nonatomic) void(^cancelSuccess)(void);
@end

NS_ASSUME_NONNULL_END
