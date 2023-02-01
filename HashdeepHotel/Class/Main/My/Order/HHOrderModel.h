//
//  HHOrderModel.h
//  HashdeepHotel
//
//  Created by Cindy on 2022/7/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HHOrderModel : NSObject
@property (nonatomic, copy) NSString *hotel_name;
@property (nonatomic, copy) NSString *hotel_id;
@property (nonatomic, copy) NSString *order_hotel_img;
@property (nonatomic, copy) NSString *order_status_str;
@property (nonatomic, copy) NSString *order_id;
@property (nonatomic, copy) NSString *order_prices;

@property (nonatomic, strong) NSArray *order_info;
@property (nonatomic, strong) NSMutableArray *button_list;
@property (nonatomic, assign) BOOL is_hourly;
@property (nonatomic, assign) BOOL is_hotel;
@property (nonatomic, copy) NSString *room_id;
@property (nonatomic, assign) CGFloat  totalHeight;
@end

NS_ASSUME_NONNULL_END
