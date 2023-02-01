//
//  HHSearchViewController.h
//  HashdeepHotel
//
//  Created by Cindy on 2022/7/14.
//

#import "HHBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface HHSearchViewController : HHBaseViewController
@property (copy, nonatomic) NSString *searchStr;
@property (strong, nonatomic) void(^selectedAction)(NSString *str);
@end

NS_ASSUME_NONNULL_END
