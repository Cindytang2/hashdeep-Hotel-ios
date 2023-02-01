//
//  XLBannerCollectionViewCell.h
//  linlinlin
//
//  Created by cindy on 2021/3/19.
//  Copyright © 2021 yqm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WMZBannerParam.h"
NS_ASSUME_NONNULL_BEGIN

@interface XLBannerCollectionViewCell : UICollectionViewCell
@property(nonatomic,strong)UIImageView *icon;
@property(nonatomic,strong)UIImageView *playImageView;
@property(strong,nonatomic) NSDictionary *dic;
@property(nonatomic,strong)WMZBannerParam *param;

@end

NS_ASSUME_NONNULL_END
