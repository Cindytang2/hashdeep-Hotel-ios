//
//  HHHotelAnnotationView.h
//  HashdeepHotel
//
//  Created by Cindy on 2022/8/10.
//

#import <MAMapKit/MAMapKit.h>
@class HHHotelModel;
NS_ASSUME_NONNULL_BEGIN

@interface HHHotelAnnotationView : MAAnnotationView
@property (nonatomic, strong) HHHotelModel *model;
@property (strong, nonatomic) void(^clickPriceAction)(HHHotelAnnotationView *view,HHHotelModel *model);
@end

NS_ASSUME_NONNULL_END
