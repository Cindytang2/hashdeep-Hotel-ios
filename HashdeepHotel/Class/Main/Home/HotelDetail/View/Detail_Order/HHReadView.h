//
//  HHReadView.h
//  HashdeepHotel
//
//  Created by Cindy on 2022/12/20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HHReadView : UIView
- (CGFloat)updateDetailSubViews:(NSArray *)policy_info;
@property (strong, nonatomic) void(^clickBookRoomReadAction)(UIButton *button);
@end

NS_ASSUME_NONNULL_END
