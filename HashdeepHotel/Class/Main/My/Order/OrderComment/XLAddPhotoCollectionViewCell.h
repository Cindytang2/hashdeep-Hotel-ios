//
//  XLAddPhotoCollectionViewCell.h
//  linlinlin
//
//  Created by cindy on 2020/6/23.
//  Copyright © 2020 yqm. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XLAddPhotoModel;
NS_ASSUME_NONNULL_BEGIN

@interface XLAddPhotoCollectionViewCell : UICollectionViewCell
@property(nonatomic,strong) XLAddPhotoModel *model;
@property(nonatomic,strong) UIImageView *imgView;
@property(nonatomic,strong) UIButton *deleteBtn;
@property (copy, nonatomic) void(^deleteBtnClickBlock)(XLAddPhotoModel *model);
@end

NS_ASSUME_NONNULL_END
