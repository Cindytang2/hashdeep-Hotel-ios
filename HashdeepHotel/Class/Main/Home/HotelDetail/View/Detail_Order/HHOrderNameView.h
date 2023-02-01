//
//  HHOrderNameView.h
//  HashdeepHotel
//
//  Created by Cindy on 2022/9/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HHOrderNameView : UIView
@property (strong, nonatomic) void(^clickCloseButton)(void);
@property (strong, nonatomic) void(^selectedSuccess)(NSString *name);
@property (strong, nonatomic) NSArray *dataArray;
@property (nonatomic, strong) UITableView *tableView;
@end

NS_ASSUME_NONNULL_END
