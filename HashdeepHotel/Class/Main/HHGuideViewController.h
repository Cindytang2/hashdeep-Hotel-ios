//
//  HHGuideViewController.h
//  HashdeepHotel
//
//  Created by Cindy on 2022/7/11.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HHGuideViewController : UIViewController
@property (strong, nonatomic) void(^clickCancelButtonAction)(void);
@property (strong, nonatomic) void(^clickAgreeButtonAction)(void);
@end

NS_ASSUME_NONNULL_END
