//
//  HHHotelDetailFooterView.h
//  HashdeepHotel
//
//  Created by Cindy on 2022/7/26.
//

#import <UIKit/UIKit.h>
@class HomeModel;
NS_ASSUME_NONNULL_BEGIN

@interface HHHotelDetailFooterView : UIView
- (CGFloat)updateUI:(NSArray *)array;
@property (nonatomic, assign) NSInteger dateType;
@property (nonatomic, strong) UITableView *hourTableView;
@property (nonatomic, strong) NSArray *hourArray;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArray;
@property (strong, nonatomic) void(^clickCellAction)(NSString *pid);
@property (strong, nonatomic) void(^clickRoomInfoAction)(HomeModel *model);
@property (strong, nonatomic) void(^clickPayAction)(HomeModel *model);
@end

NS_ASSUME_NONNULL_END
