//
//  HHBookRoomReadView.h
//  HashdeepHotel
//
//  Created by Cindy on 2022/7/28.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HHBookRoomReadView : UIView
@property (nonatomic, strong) NSArray *policy_info;
@property (strong, nonatomic) void(^clickCloseButton)(void);
@end

NS_ASSUME_NONNULL_END
