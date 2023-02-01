//
//  HHOpenLocationView.h
//  HashdeepHotel
//
//  Created by Cindy on 2022/11/18.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HHOpenLocationView : UIView
@property (strong, nonatomic) void(^clickCloseButton)(void);
@property (strong, nonatomic) void(^clickSelectedAction)(void);
@property (strong, nonatomic) void(^clickOpenAction)(void);

@end

NS_ASSUME_NONNULL_END
