//
//  HHOrderDetailCancelRuleView.h
//  HashdeepHotel
//
//  Created by Cindy on 2022/11/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HHOrderDetailCancelRuleView : UIView
@property (strong, nonatomic) NSArray *array;
@property (strong, nonatomic) void(^clickCloseButton)(void);
@end

NS_ASSUME_NONNULL_END
