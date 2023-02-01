//
//  HHOrderTableViewCell.h
//  HashdeepHotel
//
//  Created by Cindy on 2022/7/21.
//

#import <UIKit/UIKit.h>
@class HHOrderModel;
NS_ASSUME_NONNULL_BEGIN

@interface HHOrderTableViewCell : UITableViewCell
@property (nonatomic, assign) BOOL isTrip;
@property (nonatomic, strong) HHOrderModel *model;
@property (strong, nonatomic) void(^clickCancelButton)(HHOrderModel *model);
@property (strong, nonatomic) void(^clickGoPayButton)(HHOrderModel *model);
@property (strong, nonatomic) void(^clickAgainButton)(HHOrderModel *model);
@property (strong, nonatomic) void(^clickDeleteButton)(HHOrderModel *model);
@property (strong, nonatomic) void(^clickGoCommentButton)(HHOrderModel *model);
@property (strong, nonatomic) void(^clickSeeButton)(HHOrderModel *model);
@end

NS_ASSUME_NONNULL_END
