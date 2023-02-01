//
//  XLAddPhotoModel.h
//  linlinlin
//
//  Created by cindy on 2020/6/23.
//  Copyright © 2020 yqm. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XLAddPhotoModel : NSObject
@property (nonatomic, assign) BOOL isAdd;
@property (nonatomic, assign) BOOL isVideo;
@property (nonatomic, strong) UIImage *image;//图片
@property (nonatomic, strong) AVAsset *asset;//视频
@property (nonatomic, copy) NSString *thumbnail;
@property (nonatomic, assign) BOOL isCheck;
@property (nonatomic, strong) NSURL *videoUrl;
@end

NS_ASSUME_NONNULL_END
