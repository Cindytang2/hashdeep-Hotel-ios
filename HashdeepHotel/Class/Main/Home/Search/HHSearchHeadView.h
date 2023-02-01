//
//  HHSearchHeadView.h
//  HashdeepHotel
//
//  Created by Cindy on 2022/7/14.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HHSearchHeadView : UIView
- (void)updateHistoryUI:(NSArray *)array;
@property (strong, nonatomic) void(^clickButtonAction)(NSString *str);
@property (strong, nonatomic) void(^clickClearAction)(void);
@end

NS_ASSUME_NONNULL_END
