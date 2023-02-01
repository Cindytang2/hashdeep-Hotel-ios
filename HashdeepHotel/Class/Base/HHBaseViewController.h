//
//  HHBaseViewController.h
//  HashdeepHotel
//
//  Created by Cindy on 2022/7/11.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HHBaseViewController : UIViewController
@property (strong, nonatomic) UIView *noNetWorkView;
@property (strong, nonatomic) void(^clickUpdateButton)(void);
@property (copy, nonatomic) void(^videoCompressCompleted)(NSURL * url);
- (void)noNetworkUI;

- (void)createdNavigationBackButton;

- (void)convertVideoQuailtyWithInputURL:(NSURL*)inputURL;

@end

NS_ASSUME_NONNULL_END
