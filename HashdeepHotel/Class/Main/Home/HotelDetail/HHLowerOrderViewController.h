//
//  HHLowerOrderViewController.h
//  HashdeepHotel
//
//  Created by Cindy on 2022/7/28.
//

#import "HHBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface HHLowerOrderViewController : HHBaseViewController
@property (nonatomic, copy) NSString *hotel_id;
@property (nonatomic, copy) NSString *quote_id;
@property (nonatomic, assign) NSInteger start_date;
@property (nonatomic, assign) NSInteger end_date;
@property (nonatomic, copy) NSString *old_order_id;
@property (nonatomic, copy) NSString *backType;
@property (nonatomic, strong) NSDictionary *dic;
@property (nonatomic, assign) BOOL is_modify;
@property (nonatomic, assign) NSInteger dateType;//0国内  1时租 2民宿
@property (nonatomic, assign) BOOL isBackstage;//后台返回的
@property (nonatomic, assign) NSInteger doneType;
@property (nonatomic, copy) NSString *homestay_id;
@property (nonatomic, copy) NSString *homestay_room_id;
@end

NS_ASSUME_NONNULL_END
