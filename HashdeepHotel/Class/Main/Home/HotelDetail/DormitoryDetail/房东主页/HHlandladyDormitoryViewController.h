//
//  HHlandladyDormitoryViewController.h
//  HashdeepHotel
//
//  Created by Cindy on 2022/12/21.
//

#import "HHBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface HHlandladyDormitoryViewController : HHBaseViewController
@property(nonatomic,assign)CGFloat offerY;
@property(nonatomic,assign)CGFloat headHeight;
@property(nonatomic,strong)UITableView *tableView;
@property (nonatomic, strong) DayModel *startModel;//默认的显示的开始时间
@property (nonatomic, strong) DayModel *endModel;//默认的显示的结束时间
@property (nonatomic, copy) NSString *homestay_id;
@property (copy, nonatomic) void(^moveAction)(CGFloat y);
@end

NS_ASSUME_NONNULL_END
