//
//  HHDormitoryDetailHeadCollectionReusableView.h
//  HashdeepHotel
//
//  Created by Cindy on 2022/12/13.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HHDormitoryDetailHeadCollectionReusableView : UICollectionReusableView
- (void)updatePhotoUI:(NSDictionary *)dic;
- (CGFloat)updateUI:(NSDictionary *)dic;
- (void)updatePriceUI:(NSString *)price;//修改日期后，只更新价格
@property (strong, nonatomic) void(^clickTopImageAction)(NSDictionary *dic);
@property (strong, nonatomic) void(^clickMapButtonAction)(NSDictionary *dic);
@property (strong, nonatomic) void(^clickCommentButtonAction)(NSDictionary *dic);
@property (strong, nonatomic) void(^clickLandladyButtonAction)(NSDictionary *dic);


- (void)playVideoWithUrl:(NSURL *)videoUrl;
- (void)stopPlayWithUrl:(NSURL *)videoUrl;
@end

NS_ASSUME_NONNULL_END
