//
//  HHHotelModel.h
//  HashdeepHotel
//
//  Created by Cindy on 2022/7/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HHHotelModel : NSObject
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *hour_room_inout_time;
@property (nonatomic, copy) NSString *hour_room_check_in_time;
@property (nonatomic, copy) NSString *pid;
@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, copy) NSString *photo;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *info;
@property (nonatomic, copy) NSString *detect_time;
@property (nonatomic, strong) NSArray *tag;
@property (nonatomic, copy) NSString *distance;
@property (nonatomic, copy) NSString *original_price;
@property (nonatomic, copy) NSString *prices;
@property (nonatomic, copy) NSString *latitude;
@property (nonatomic, copy) NSString *longitude;
@property (nonatomic, copy) NSString *rating;
@property (nonatomic, assign) CGFloat safe_star;
@property (nonatomic, assign) CGFloat totalHeight;
@property (nonatomic, assign) CGFloat titleHeight;
@property (nonatomic, strong) NSArray *photo_path;
@property (nonatomic, copy) NSString *detective_time;
@property (nonatomic, copy) NSString *room_type_name;
@property (nonatomic, copy) NSString *room_name;
@property (nonatomic, strong) NSArray *homestay_tag;
@property (nonatomic, copy) NSString *homestay_price;

@property (nonatomic, copy) NSString *room_type;
@property (nonatomic, copy) NSString *room_desc;
@property (nonatomic, copy) NSString *room_id;
@property (nonatomic, copy) NSString *quote_id;
@property (nonatomic, copy) NSString *balance_price;
@property (nonatomic, copy) NSString *totle_price;
@property (nonatomic, strong) NSDictionary *icon_with_desc;

@property (nonatomic, copy) NSString *homestay_room_id;
@property (nonatomic, copy) NSString *homestay_id;
@property (nonatomic, copy) NSString *homestay_type_str;
@property (nonatomic, copy) NSString *nearbystr;
@property (nonatomic, assign) NSInteger collect_type;
@end

NS_ASSUME_NONNULL_END
