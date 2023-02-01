//
//  HHAppManage.h
//  HashdeepHotel
//
//  Created by Cindy on 2022/7/14.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HHAppManage : NSObject
//获取当前VC
+ (UIViewController *)getCurrentVC;
//将view转成图片的方法
+ (UIImage *)makeImageWithView:(UIView *)view;

+ (UIImage *)thumbnailWithImage:(UIImage *)originalImage size:(CGSize)size;
//根据具体时间显示星期
+ (NSString *)weekdayStringWithTime:(NSString *)timeStr;
//view圆角
+(void)mq_setRect:(CGRect)bounds cornerRect:(UIRectCorner)corners radius:(CGFloat)cornerRadius view:(UIView *)view;

+ (BOOL)isBlankString:(NSString *)string;

+ (NSInteger) calcDaysFromBegin:(NSDate *)startDate end:(NSDate *)endDate;
// 图片缩放，scaleSize = font_size / image.size.height
+ (UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize ;
+ (UIImage *)scaleImage:(UIImage *)image size:( CGSize ) cSize ;
// 裁剪出的图片尺寸按照size的尺寸，但图片不拉伸，但多余部分会被裁减掉
+ (UIImage *)thumbnailWithImage:(UIImage *)originalImage size:(CGSize)size  ;
//图片压缩
+ (UIImage *)imageCompressForSize:(UIImage *)sourceImage targetSize:(CGSize)size ;
+ (UIImage *)zipImage:(UIImage *)sourceImage ;
+ (UIImage *)zipImage:(UIImage *)sourceImage width:( int )iWth ;

// 获取首字母
+ (NSString *)groupTitleWithString:(NSString *)strLetter ;

// 图文混排
+ (NSAttributedString *) creatAttrStringWithText:(NSString *) text fontSize:(int )fSize textColor:(UIColor *)clr image:(UIImage *) image isLeft:(BOOL ) iLeft ;
// 图片旋转角度
+ (UIImage *)imageRotatedByDegrees:(UIImage*)oldImage deg:(CGFloat)degrees ;
// 生成image
+ (UIImage *)makeImageWithView:(UIView *)view withSize:(CGSize)size ;

// 异步操作
+ (void)asyncSleepWithTimeScond:(float )second completion:(void (^)(void))completion ;
// Json 转 NSDictionary
+( NSDictionary * )dictionaryFromJsonString:( NSString * ) strJson ;
// 设置状态栏背景色
+ (void)setStatusBarBackgroundColor:(UIColor *)color ;
// 获取视频第一帧
+ (UIImage*) getVideoPreViewImage:(NSURL *)path ;

// 获取手机系统版本号
+ (NSString *)getCurrentDeviceSystemBersion;
+ (NSString *)getDateWithString:(NSString *)string;
+ (NSString *)getTimeStrWithString:(NSString *)str;
@end

NS_ASSUME_NONNULL_END
