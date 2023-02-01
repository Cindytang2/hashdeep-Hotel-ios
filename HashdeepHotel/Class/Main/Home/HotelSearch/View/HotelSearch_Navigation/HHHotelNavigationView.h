//
//  HHHotelNavigationView.h
//  HashdeepHotel
//
//  Created by Cindy on 2022/7/18.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HHHotelNavigationView : UIView
@property (nonatomic, strong) UILabel *goInLabel;
@property (nonatomic, strong) UILabel *leaveLabel;
@property (nonatomic, strong) UIButton *deleteButton;
@property (nonatomic, strong) UILabel *checkInLabel;
@property (nonatomic, strong) UILabel *searchLabel;
@property (nonatomic, strong) UILabel *checkOutLabel;
@property (nonatomic, assign) NSInteger index;
@property (strong, nonatomic) void(^clickSearchAction)(void);
@property (strong, nonatomic) void(^clickDateAction)(void);
@property (strong, nonatomic) void(^clickDeleteAction)(void);
@property (strong, nonatomic) void(^clickMapAction)(UIButton *button);
@end

NS_ASSUME_NONNULL_END
