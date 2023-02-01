//
//  XLSetupBirthdayView.h
//  linlinlin
//
//  Created by cindy on 2020/12/12.
//  Copyright © 2020 yqm. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface XLSetupBirthdayView : UIView
@property (strong, nonatomic) void(^clickCancelAction)(void);
@property (strong, nonatomic) void(^clickDoneAction)(NSString *birthday);



@end

NS_ASSUME_NONNULL_END
