//
//  HHLandladyCommentViewController.h
//  HashdeepHotel
//
//  Created by Cindy on 2022/12/21.
//

#import "HHBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface HHLandladyCommentViewController : HHBaseViewController
@property(nonatomic,assign)CGFloat offerY;
@property(nonatomic,assign)CGFloat headHeight;
@property (nonatomic, copy) NSString *homestay_id;
@property(nonatomic,strong)UITableView *tableView;
@property (copy, nonatomic) void(^moveAction)(CGFloat y);
@end

NS_ASSUME_NONNULL_END
