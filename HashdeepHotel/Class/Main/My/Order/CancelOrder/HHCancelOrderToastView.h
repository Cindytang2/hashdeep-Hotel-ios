//
//  HHCancelOrderToastView.h
//  HashdeepHotel
//
//  Created by Cindy on 2022/7/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HHCancelOrderToastView : UIView
@property (strong, nonatomic) void(^clickBackAction)(void);
@property (strong, nonatomic) void(^clickAgainAction)(void);
@end

NS_ASSUME_NONNULL_END
