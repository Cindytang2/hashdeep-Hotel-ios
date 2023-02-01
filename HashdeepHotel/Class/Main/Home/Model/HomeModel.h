//
//  HomeModel.h
//  HashdeepHotel
//
//  Created by Cindy on 2022/7/11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HomeModel : NSObject
@property (nonatomic, copy) NSString *hotel_comment;
@property (nonatomic, copy) NSString *hotel_cover_img;
@property (nonatomic, copy) NSString *hotel_id;
@property (nonatomic, copy) NSString *hotel_name;
@property (nonatomic, copy) NSString *hotel_original_price;
@property (nonatomic, copy) NSString *hotel_price;
@property (nonatomic, copy) NSString *order_soldout;
@property (nonatomic, assign) CGFloat  totalHeight;
@property (nonatomic, copy) NSString *stay_hours;
@property (nonatomic, copy) NSString *hourly_room_time;
@property (nonatomic, copy) NSString *room_desc;
@property (nonatomic, copy) NSString *room_type;
@property (nonatomic, copy) NSString *room_img;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *room_id;
@property (nonatomic, copy) NSString *hotel_default_quote_id;
@property (nonatomic, copy) NSString *original_price;
@property (nonatomic, strong) NSDictionary *cancel_time_tag;
@property (nonatomic, strong) NSDictionary *confirm_tag;
@property (nonatomic, strong) NSDictionary *no_smoking_tag;
@property (nonatomic, strong) NSArray *room_tags;
@property (nonatomic, copy) NSString *room_state;

@property (nonatomic, copy) NSString *homestay_id;
@property (nonatomic, copy) NSString *distance;
@property (nonatomic, copy) NSString *room_type_name;
@property (nonatomic, copy) NSString *room_name;
@property (nonatomic, copy) NSString *photos;
@property (nonatomic, copy) NSString *price_str;
@property (nonatomic, assign) CGFloat dormitoryTotalHeight;
@property (nonatomic, copy) NSString *homestay_room_id;

@end

NS_ASSUME_NONNULL_END
