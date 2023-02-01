//
//  HHCancelOrderViewController.h
//  HashdeepHotel
//
//  Created by Cindy on 2022/7/22.
//

#import "HHBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface HHCancelOrderViewController : HHBaseViewController
@property (nonatomic, copy) NSString *order_id;
@property (nonatomic, copy) NSString *hotel_id;
@property (nonatomic, copy) NSString *backType;
@property (nonatomic, copy) NSString *homestay_room_id;
@end

NS_ASSUME_NONNULL_END
