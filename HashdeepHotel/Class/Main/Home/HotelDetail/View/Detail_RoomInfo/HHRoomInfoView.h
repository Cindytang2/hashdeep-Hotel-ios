//
//  HHRoomInfoView.h
//  HashdeepHotel
//
//  Created by Cindy on 2022/7/27.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HHRoomInfoView : UIView
@property (nonatomic, assign) BOOL isHas;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSDictionary *data;
@property (strong, nonatomic) void(^clickCloseButton)(void);
@property (strong, nonatomic) void(^clickReserveButton)(void);
@property (strong, nonatomic) void(^clickServiceButton)(void);
@end

NS_ASSUME_NONNULL_END
