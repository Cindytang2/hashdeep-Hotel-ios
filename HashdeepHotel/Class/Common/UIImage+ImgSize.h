//
//  UIImage+ImgSize.h
//  BenefitLive
//
//  Created by cindy on 2020/4/7.
//  Copyright © 2020 XinShu Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (ImgSize)
+ (CGSize)getImageSizeWithURL:(id)URL;

// 高斯模糊
+ (UIImage *)blurryImageGaussian:(UIImage *)image   blurLevel:(CGFloat)blur ;
// 添加通用模糊效果
// image是图片，blur是模糊度
+ (UIImage *)blurryImage:(UIImage *)image withBlurLevel:(CGFloat)blur ;

#pragma mark - Blur Image

/**
 *  Get blured image.
 *
 *  @return Blured image.
 */
- (UIImage *)blurImage;

/**
 *  Get the blured image masked by another image.
 *
 *  @param maskImage Image used for mask.
 *
 *  @return the Blured image.
 */
- (UIImage *)blurImageWithMask:(UIImage *)maskImage;

/**
 *  Get blured image and you can set the blur radius.
 *
 *  @param radius Blur radius.
 *
 *  @return Blured image.
 */
- (UIImage *)blurImageWithRadius:(CGFloat)radius;

/**
 *  Get blured image at specified frame.
 *
 *  @param frame The specified frame that you use to blur.
 *
 *  @return Blured image.
 */
- (UIImage *)blurImageAtFrame:(CGRect)frame;

#pragma mark - Grayscale Image

/**
 *  Get grayScale image.
 *
 *  @return GrayScaled image.
 */
- (UIImage *)grayScale;

#pragma mark - Some Useful Method

/**
 *  Scale image with fixed width.
 *
 *  @param width The fixed width you give.
 *
 *  @return Scaled image.
 */
- (UIImage *)scaleWithFixedWidth:(CGFloat)width;

/**
 *  Scale image with fixed height.
 *
 *  @param height The fixed height you give.
 *
 *  @return Scaled image.
 */
- (UIImage *)scaleWithFixedHeight:(CGFloat)height;

/**
 *  Get the image average color.
 *
 *  @return Average color from the image.
 */
- (UIColor *)averageColor;

/**
 *  Get cropped image at specified frame.
 *
 *  @param frame The specified frame that you use to crop.
 *
 *  @return Cropped image
 */
- (UIImage *)croppedImageAtFrame:(CGRect)frame;

@end

NS_ASSUME_NONNULL_END
