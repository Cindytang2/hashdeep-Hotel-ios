//
//  HHUnbindingView.h
//  HashdeepHotel
//
//  Created by Cindy on 2022/12/8.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HHUnbindingView : UIView
@property (strong, nonatomic) NSString *subTitle;
@property (strong, nonatomic) void(^clickCancelAction)(void);
@property (strong, nonatomic) void(^clickDoneAction)(void);

@end

NS_ASSUME_NONNULL_END
