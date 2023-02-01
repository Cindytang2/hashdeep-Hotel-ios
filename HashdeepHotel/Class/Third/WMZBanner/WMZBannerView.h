//
//  WMZBannerView.h
//  WMZBanner
//
//  Created by wmz on 2019/9/6.
//  Copyright © 2019 wmz. All rights reserved.
//

#import "WMZBannerParam.h"
NS_ASSUME_NONNULL_BEGIN

@interface WMZBannerView : UIView
@property(strong,nonatomic) NSArray *resultArray;
@property(strong,nonatomic)UICollectionView *myCollectionV;
/**
 *  调用方法
 *
 */
- (instancetype)initConfigureWithModel:(WMZBannerParam *)param withView:(UIView*)parentView;

/**
 *  调用方法
 *
 */
- (instancetype)initConfigureWithModel:(WMZBannerParam *)param;
/**
 *  更新UI
 *
 */
- (void)updateUI;

@end


NS_ASSUME_NONNULL_END
