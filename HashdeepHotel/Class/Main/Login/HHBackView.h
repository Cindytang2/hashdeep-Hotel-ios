//
//  HHBackView.h
//  HashdeepHotel
//
//  Created by Cindy on 2022/11/29.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HHBackView : UIView
@property (copy, nonatomic) NSString *type;
@property (strong, nonatomic) void(^clickBackAction)(void);
@end

NS_ASSUME_NONNULL_END
