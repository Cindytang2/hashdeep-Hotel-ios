//
//  HHSelectedRegionHeadView.h
//  HashdeepHotel
//
//  Created by Cindy on 2022/7/14.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HHSelectedRegionHeadView : UIView
@property (nonatomic, strong) UILabel *addressLabel;
@property (nonatomic, strong) UILabel *refreshLocationLabel;
- (CGFloat)updateHotUI:(NSArray *)array;
@property (strong, nonatomic) void(^clickUpdateLocation)(void);
@property (strong, nonatomic) void(^clickHotAddress)(NSString *str,NSString *longitude, NSString *latitude);
@end

NS_ASSUME_NONNULL_END
