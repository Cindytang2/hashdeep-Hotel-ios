//
//  HHCancelOrderView.h
//  HashdeepHotel
//
//  Created by Cindy on 2022/7/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HHCancelOrderView : UIView
@property (nonatomic, strong) NSDictionary *data;
@property (nonatomic, copy) NSString *order_id;
@property (strong, nonatomic) void(^clickDoneAction)(void);
@end

NS_ASSUME_NONNULL_END
