//
//  HHOneCheckInView.h
//  HashdeepHotel
//
//  Created by Cindy on 2022/8/3.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HHOneCheckInView : UIView
@property (strong, nonatomic) NSDictionary *check_in_and_out;
@property (strong, nonatomic) void(^clickCloseButton)(void);
@property (strong, nonatomic) void(^clickDoneButton)(NSInteger beginTimeNumber, NSInteger endTimeNumber, NSDictionary *dic);


@end

NS_ASSUME_NONNULL_END
