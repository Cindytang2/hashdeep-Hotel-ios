//
//  HHOnlinePayView.h
//  HashdeepHotel
//
//  Created by Cindy on 2022/8/3.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HHOnlinePayView : UIView
@property (strong, nonatomic) void(^clickCloseButton)(void);
@property (strong, nonatomic) NSDictionary *payment_info;
@end

NS_ASSUME_NONNULL_END
