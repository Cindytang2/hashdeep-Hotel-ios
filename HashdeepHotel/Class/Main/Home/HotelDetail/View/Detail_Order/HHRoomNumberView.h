//
//  HHRoomNumberView.h
//  HashdeepHotel
//
//  Created by Cindy on 2022/7/28.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HHRoomNumberView : UIView
@property (nonatomic, copy) NSString *remaining_room_num;
@property (nonatomic, copy) NSString *titleStr;
@property (nonatomic, assign) NSInteger index;
@property (strong, nonatomic) void(^clickCloseButton)(void);
@property (strong, nonatomic) void(^clickButtonAction)(NSString *str);
@end

NS_ASSUME_NONNULL_END
