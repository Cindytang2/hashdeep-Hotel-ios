//
//  HHOrderViewController.h
//  HashdeepHotel
//
//  Created by Cindy on 2022/7/21.
//

#import "HHBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface HHOrderViewController : HHBaseViewController
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, copy) NSString *order_status;
@property (nonatomic, copy) NSString *backType;
@end

NS_ASSUME_NONNULL_END
