//
//  SelectedRegionModel.h
//  HashdeepHotel
//
//  Created by Cindy on 2022/7/14.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SelectedRegionModel : NSObject
@property (nonatomic, copy) NSString *character;
@property (nonatomic, copy) NSString *city_name;
@property (nonatomic, copy) NSString *city_adcode;
@property (nonatomic, copy) NSString *city_pin_yin;
@property (nonatomic, copy) NSString *city_longitude;
@property (nonatomic, copy) NSString *city_latitude;


@end

NS_ASSUME_NONNULL_END
