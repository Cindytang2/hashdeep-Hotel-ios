//
//  HHHotelMapView.h
//  HashdeepHotel
//
//  Created by Cindy on 2022/8/10.
//

#import <UIKit/UIKit.h>
@class HHHotelModel;
NS_ASSUME_NONNULL_BEGIN

@interface HHHotelMapView : UIView
@property (nonatomic, assign) NSInteger type;//0.国内国际  1.时租 2.民宿
@property (nonatomic, strong) NSArray *dataArray;
@property (strong, nonatomic) void(^goDetailVC)(HHHotelModel *model);
@end

NS_ASSUME_NONNULL_END

