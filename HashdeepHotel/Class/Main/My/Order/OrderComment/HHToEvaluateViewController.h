//
//  HHToEvaluateViewController.h
//  HashdeepHotel
//
//  Created by Cindy on 2022/8/1.
//

#import "HHBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface HHToEvaluateViewController : HHBaseViewController
@property (nonatomic, copy) NSString *order_id;
@property (strong, nonatomic) void(^commentSuccess)(void);
@end

NS_ASSUME_NONNULL_END
