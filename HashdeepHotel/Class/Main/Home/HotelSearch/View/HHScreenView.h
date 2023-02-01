//
//  HHScreenView.h
//  HashdeepHotel
//
//  Created by Cindy on 2022/7/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HHScreenView : UIView
@property (nonatomic, strong) NSArray *array;
@property (strong, nonatomic) void(^clickCloseButton)(void);
@property (strong, nonatomic) void(^clickDoneButton)(NSArray *arr, NSString *str);

@end

NS_ASSUME_NONNULL_END
