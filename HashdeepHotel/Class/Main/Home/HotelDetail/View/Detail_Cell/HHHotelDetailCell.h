//
//  HHHotelDetailCell.h
//  HashdeepHotel
//
//  Created by Cindy on 2022/7/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class HomeModel;
@interface HHHotelDetailCell : UITableViewCell
@property (nonatomic, copy) NSString *type;//0国内国际  1.时租
@property (nonatomic, strong) HomeModel *model;
@property (strong, nonatomic) void(^clickLowerOrderAction)(HomeModel *model, UIButton *button);
@end

NS_ASSUME_NONNULL_END
