//
//  HHEditOrderCell.h
//  HashdeepHotel
//
//  Created by Cindy on 2022/8/4.
//

#import <UIKit/UIKit.h>
@class HHHotelModel;
NS_ASSUME_NONNULL_BEGIN

@interface HHEditOrderCell : UITableViewCell
@property (nonatomic, strong) HHHotelModel *model;
@property (strong, nonatomic) void(^clickSelectedButton)(UIButton *button);
@end

NS_ASSUME_NONNULL_END
