//
//  HHHotelMenuView.h
//  HashdeepHotel
//
//  Created by Cindy on 2022/7/18.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HHHotelMenuView : UIView


@property (nonatomic, copy) NSString *type;//0 国内国际  1.时租  2.民宿
@property (nonatomic, strong) NSDictionary *data;
@property (nonatomic, strong) NSArray *dataArray;
@property (strong, nonatomic) void(^selectedIntelligenceSuccess)(NSString *str);
@property (strong, nonatomic) void(^selectedPriceSuccess)(NSDictionary *dic,NSString *dormitoryStr,NSString *str);
@property (strong, nonatomic) void(^selectedScreenSuccess)(NSArray *arr);
@property (strong, nonatomic) void(^selectedLocationSuccess)(NSString *distance_condition,NSString *location,BOOL is_location);

- (void)hiddenSubViews;
@end

NS_ASSUME_NONNULL_END
