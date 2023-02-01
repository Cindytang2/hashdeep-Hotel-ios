//
//  HHDormitoryTableViewCell.h
//  HashdeepHotel
//
//  Created by Cindy on 2022/11/8.
//

#import <UIKit/UIKit.h>
@class HHHotelModel;
NS_ASSUME_NONNULL_BEGIN

@interface HHDormitoryTableViewCell : UITableViewCell
@property (nonatomic, strong) HHHotelModel *model;
@property (strong, nonatomic) void(^clickImageAction)(void);

@end

NS_ASSUME_NONNULL_END
