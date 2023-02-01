//
//  HHOrderPayViewController.h
//  HashdeepHotel
//
//  Created by Cindy on 2022/7/21.
//

#import "HHBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface HHOrderPayViewController : HHBaseViewController
@property (nonatomic, copy) NSString *order_id;
@property (nonatomic, copy) NSString *backType;
@property (nonatomic, assign) NSInteger dateType;
@end

NS_ASSUME_NONNULL_END
