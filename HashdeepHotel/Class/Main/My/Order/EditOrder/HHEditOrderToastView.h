//
//  HHEditOrderToastView.h
//  HashdeepHotel
//
//  Created by Cindy on 2022/10/18.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HHEditOrderToastView : UIView
@property (strong, nonatomic) void(^clickCancelAction)(void);
@property (strong, nonatomic) void(^clickDoneAction)(void);

@end

NS_ASSUME_NONNULL_END
