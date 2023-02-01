//
//  HHHotelDetailHeadView.h
//  HashdeepHotel
//
//  Created by Cindy on 2022/7/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HHHotelDetailHeadView : UIView
- (void)updatePhotoUI:(NSDictionary *)dic;
- (void)updateUI:(NSDictionary *)dic;
@property (strong, nonatomic) void(^clickTopImageAction)(NSDictionary *dic);
@property (strong, nonatomic) void(^clickPhoneAction)(NSString *phoneNumber);
@property (strong, nonatomic) void(^clickFullAction)(NSString *path);
@property (strong, nonatomic) void(^clickDetailButtonAction)(NSDictionary *dic);
@property (strong, nonatomic) void(^clickCommentButtonAction)(NSDictionary *dic);
@property (strong, nonatomic) void(^clickMapButtonAction)(NSDictionary *dic);
- (void)playVideoWithUrl:(NSURL *)videoUrl;
- (void)stopPlayWithUrl:(NSURL *)videoUrl;
@end

NS_ASSUME_NONNULL_END
