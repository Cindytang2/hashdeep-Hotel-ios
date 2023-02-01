//
//  HHEditOrderView.h
//  HashdeepHotel
//
//  Created by Cindy on 2022/8/4.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HHEditOrderView : UIView
@property (strong, nonatomic) void(^clickUpdateButton)(void);
@property (nonatomic, strong) NSDictionary *dic;
- (void)updateUI:(NSDictionary *)dict;
@end

NS_ASSUME_NONNULL_END
