//
//  HHEditOrderViewController.h
//  HashdeepHotel
//
//  Created by Cindy on 2022/8/4.
//

#import "HHBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface HHEditOrderViewController : HHBaseViewController
@property (nonatomic, strong) NSDictionary *start_Dic;
@property (nonatomic, strong) NSDictionary *end_Dic;
@property (nonatomic, copy) NSString *order_id;
@property (nonatomic, copy) NSString *hotel_id;
@property (nonatomic, copy) NSString *quote_id;
@property (nonatomic, strong) NSDictionary *dic;
@property (nonatomic, copy) NSString *start_time;
@property (nonatomic, copy) NSString *end_time;
@property (nonatomic, copy) NSString *backType;
@end

NS_ASSUME_NONNULL_END
