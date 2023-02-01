//
//  HHAppManage.m
//  HashdeepHotel
//
//  Created by Cindy on 2022/7/14.
//

#import "HHAppManage.h"
#import "NSDate+XZY.h"
@implementation HHAppManage
+ (UIViewController *)getCurrentVC {
    UIViewController *result = nil;
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal) {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows) {
            if (tmpWin.windowLevel == UIWindowLevelNormal) {
                window = tmpWin;
                break;
            }
        }
    }
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    if ([nextResponder isKindOfClass:[UIViewController class]]) {
        result = nextResponder;
    } else {
        result = window.rootViewController;
    }
    return result;
}

#pragma mark - 将view转成图片的方法
+ (UIImage *)makeImageWithView:(UIView *)view{
    CGSize s = view.bounds.size;
    UIGraphicsBeginImageContextWithOptions(s, NO, [UIScreen mainScreen].scale);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage*image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}



/**
 * 根据具体时间显示星期
 *
 * @param timeStr 目标时间
 * @return 返回星期
 */
+ (NSString *)weekdayStringWithTime:(NSString *)timeStr{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
    
    NSDate *date = [formatter dateFromString:timeStr];
    NSString *str = [[NSDate date] weekdayStringWithDate:date];
    BOOL istoday = [[NSCalendar currentCalendar]isDateInToday:date];
    BOOL isYesterday = [[NSCalendar currentCalendar] isDateInTomorrow:date];
    if (istoday) {
        str= @"今天";
    } else if (isYesterday){
        str = @"明天";
    }
    
    return str;
}

+ (NSString *)weekdayStringFromDate:(NSDate *)inputDate {
    //知道为什么加一个null类型吗？
    //因为数组的下标是以0开始的
    //而星期的对应数字范围是1-7
    //所以加一个null类型(不会取到这个null值)
    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"周日", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六", nil];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    [calendar setTimeZone: timeZone];
    
    NSDateComponents *theComponents = [calendar components:NSCalendarUnitWeekday fromDate:inputDate];
    
    return [weekdays objectAtIndex:theComponents.weekday];
}
// 获取视频第一帧
+(UIImage*) getVideoPreViewImage:(NSURL *)path {
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:path options:nil];
    AVAssetImageGenerator *assetGen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    assetGen.appliesPreferredTrackTransform = YES;
    CMTime time = CMTimeMakeWithSeconds(0.0, 600);
    NSError *error = nil;
    CMTime actualTime;
    CGImageRef image = [assetGen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    UIImage *videoImage = [[UIImage alloc] initWithCGImage:image];
    CGImageRelease(image);
    return videoImage;
}


//https://www.jianshu.com/p/32cfcd85cd99
/**
 对view切部分圆角
 
 @param bounds view的bounds（针对用masonry布局的）
 @param corners 切圆角部位
 @param cornerRadius 圆角大小
 */
+ (void)mq_setRect:(CGRect)bounds cornerRect:(UIRectCorner)corners radius:(CGFloat)cornerRadius view:(UIView *)view {
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:bounds
                                                   byRoundingCorners:corners
                                                         cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = bounds;
    maskLayer.path = maskPath.CGPath;
    view.layer.mask = maskLayer;
}

//判断字符串为空和只为空格解决办法
+ (BOOL)isBlankString:(NSString *)string{
    
    if (string == nil) {
        return YES;
    }
    
    if (string == NULL) {
        return YES;
    }
    
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}
#pragma mark -  计算两个日期之间的天数
+ (NSInteger) calcDaysFromBegin:(NSDate *)startDate end:(NSDate *)endDate{
    //利用NSCalendar比较日期的差异
    NSCalendar *calendar = [NSCalendar currentCalendar];
    /**
     * 要比较的时间单位,常用如下,可以同时传：
     *    NSCalendarUnitDay : 天
     *    NSCalendarUnitYear : 年
     *    NSCalendarUnitMonth : 月
     *    NSCalendarUnitHour : 时
     *    NSCalendarUnitMinute : 分
     *    NSCalendarUnitSecond : 秒
     */
    NSCalendarUnit unit = NSCalendarUnitDay;//只比较天数差异
    //比较的结果是NSDateComponents类对象
    NSDateComponents *delta = [calendar components:unit fromDate:startDate toDate:endDate options:0];
    //打印
    NSLog(@"%@",delta);
    //获取其中的"天"
    NSLog(@"%ld",delta.day);
    //创建日期格式化对象
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    //取两个日期对象的时间间隔：
    //这里的NSTimeInterval 并不是对象，是基本型，其实是double类型，是由c定义的:typedef double NSTimeInterval;
    NSTimeInterval time=[endDate timeIntervalSinceDate:startDate];
    
    int days=((int)time)/(3600*24);
    return days;
}
+ (UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize {
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width * scaleSize , image.size.height * scaleSize ) ) ;
    [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height * scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

+ (UIImage *)scaleImage:(UIImage *)image size:( CGSize ) cSize {
    UIGraphicsBeginImageContext(CGSizeMake(  cSize.width ,  cSize.height ) ) ;
    [image drawInRect:CGRectMake( 0 , 0 ,  cSize.width , cSize.height  ) ];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

// 裁剪出的图片尺寸按照size的尺寸，但图片不拉伸，但多余部分会被裁减掉
+ (UIImage *)thumbnailWithImage:(UIImage *)originalImage size:(CGSize)size  {
    CGSize originalsize = [originalImage size];
    // 原图长宽均小于标准长宽的，不作处理返回原图
    if (originalsize.width<size.width && originalsize.height<size.height) {
        return originalImage;
    } else if(originalsize.width>size.width && originalsize.height>size.height) {
        // 原图长宽均大于标准长宽的，按比例缩小至最大适应值
        CGFloat rate = 1.0;
        CGFloat widthRate = originalsize.width/size.width;
        CGFloat heightRate = originalsize.height/size.height;
        rate = widthRate>heightRate?heightRate:widthRate;
        CGImageRef imageRef = nil;
        if (heightRate>widthRate) {
            imageRef = CGImageCreateWithImageInRect([originalImage CGImage], CGRectMake(0, originalsize.height/2-size.height*rate/2, originalsize.width, size.height*rate));//获取图片整体部分
        } else {
            imageRef = CGImageCreateWithImageInRect([originalImage CGImage], CGRectMake(originalsize.width/2-size.width*rate/2, 0, size.width*rate, originalsize.height));//获取图片整体部分
        }
        UIGraphicsBeginImageContext(size);//指定要绘画图片的大小
        CGContextRef con = UIGraphicsGetCurrentContext();
        CGContextTranslateCTM(con, 0.0, size.height);
        CGContextScaleCTM(con, 1.0, -1.0);
        CGContextDrawImage(con, CGRectMake(0, 0, size.width, size.height), imageRef);
        UIImage *standardImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        CGImageRelease(imageRef);
        return standardImage;
    } else if(originalsize.height>size.height || originalsize.width>size.width) {
        //原图长宽有一项大于标准长宽的，对大于标准的那一项进行裁剪，另一项保持不变
        CGImageRef imageRef = nil;
        if(originalsize.height>size.height) {
            imageRef = CGImageCreateWithImageInRect([originalImage CGImage], CGRectMake(0, originalsize.height/2-size.height/2, originalsize.width, size.height));//获取图片整体部分
        } else if (originalsize.width>size.width) {
            imageRef = CGImageCreateWithImageInRect([originalImage CGImage], CGRectMake(originalsize.width/2-size.width/2, 0, size.width, originalsize.height));//获取图片整体部分
        }
        UIGraphicsBeginImageContext(size);//指定要绘画图片的大小
        　 　　      CGContextRef con = UIGraphicsGetCurrentContext();
        CGContextTranslateCTM(con, 0.0, size.height);
        CGContextScaleCTM(con, 1.0, -1.0);
        CGContextDrawImage(con, CGRectMake(0, 0, size.width, size.height), imageRef);
        UIImage *standardImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        CGImageRelease(imageRef);
        return standardImage;
    }  else  {
        //原图为标准长宽的，不做处理
        return originalImage;
    }
}


+ (UIImage *)imageCompressForSize:(UIImage *)sourceImage targetSize:(CGSize)size {
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = size.width;
    CGFloat targetHeight = size.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
    if(CGSizeEqualToSize(imageSize, size) == NO){
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        if(widthFactor > heightFactor){
            scaleFactor = widthFactor;
        } else {
            scaleFactor = heightFactor;
        }
        scaledWidth = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        if(widthFactor > heightFactor){
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }else if(widthFactor < heightFactor){
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    UIGraphicsBeginImageContextWithOptions(size, NO, 3.0);
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    [sourceImage drawInRect:thumbnailRect];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil){
        
    }
    UIGraphicsEndImageContext();
    return newImage;
}

//选择原图的，不压缩，否则压缩。压缩规则是：宽度大于1500的压缩成1080，宽度小于1500的不压缩，保持纵横比。大于1500的，还需要压缩质量
+ (UIImage *)zipImage:(UIImage *)sourceImage {
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = width * 1 ;
    if (width > 1500) {
        targetWidth = 1500 ;
    }
    CGFloat targetHeight = (targetWidth / width) * height;
    UIGraphicsBeginImageContext(CGSizeMake(targetWidth, targetHeight));
    [sourceImage drawInRect:CGRectMake(0,0,targetWidth,  targetHeight)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    //    NSData* imageData = UIImageJPEGRepresentation(newImage, 0.8 );
    //    newImage = [UIImage imageWithData: imageData];
    return newImage ;
}

+ (UIImage *)zipImage:(UIImage *)sourceImage width:( int )iWth  {
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = width * 1 ;
    if (width > iWth) {
        targetWidth = iWth ;
    }
    CGFloat targetHeight = (targetWidth / width) * height;
    UIGraphicsBeginImageContext(CGSizeMake(targetWidth, targetHeight));
    [sourceImage drawInRect:CGRectMake(0,0,targetWidth,  targetHeight)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage ;
}


+ (NSAttributedString *) creatAttrStringWithText:(NSString *) text fontSize:(int )fSize textColor:(UIColor *)clr image:(UIImage *) image isLeft:(BOOL ) iLeft {
    NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
    attachment.image = image;
    NSAttributedString *imageAttr = [NSAttributedString attributedStringWithAttachment:attachment];
    NSAttributedString *textAttr = [[NSMutableAttributedString alloc] initWithString:text attributes:@{ NSFontAttributeName:[UIFont systemFontOfSize:fSize ] , NSForegroundColorAttributeName: clr }];
    NSAttributedString *spaceAttr = [[NSMutableAttributedString alloc] initWithString: @" " attributes:@{ NSFontAttributeName:[UIFont systemFontOfSize:fSize ] , NSForegroundColorAttributeName: clr }];
    NSMutableAttributedString *mutableAttr = [[NSMutableAttributedString alloc] init];
    if ( iLeft ) {
        [mutableAttr appendAttributedString:imageAttr];
        [mutableAttr appendAttributedString: spaceAttr ] ;
        [mutableAttr appendAttributedString:textAttr];
    } else {
        [mutableAttr appendAttributedString:textAttr];
        [mutableAttr appendAttributedString: spaceAttr ] ;
        [mutableAttr appendAttributedString:imageAttr];
    }
    
    return [mutableAttr copy];
}

+ (void)setStatusBarBackgroundColor:(UIColor *)color {
    UIView *statusBar;
    if (@available(iOS 13.0,*)) {
        UIView *window = [ self getKeyWindow];
        statusBar = [[UIView alloc]initWithFrame:[UIApplication sharedApplication].keyWindow.windowScene.statusBarManager.statusBarFrame];
        [window addSubview:statusBar];
    } else {
        statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    }
    
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        statusBar.backgroundColor = color;
    }
}

+ (UIWindow *)getKeyWindow {
    // 获取keywindow
    NSArray *array = [UIApplication sharedApplication].windows;
    UIWindow *window = [array objectAtIndex:0];
    
    //  判断取到的window是不是keywidow
    if (!window.hidden || window.isKeyWindow) {
        return window;
    }
    
    //  如果上面的方式取到的window 不是keywidow时  通过遍历windows取keywindow
    for (UIWindow *window in array) {
        if (!window.hidden || window.isKeyWindow) {
            return window;
        }
    }
    return nil;
}
// 图片旋转角度
+ (UIImage *)imageRotatedByDegrees:(UIImage*)oldImage deg:(CGFloat)degrees {
    // calculate the size of the rotated view's containing box for our drawing space
    UIView *rotatedViewBox = [[UIView alloc] initWithFrame:CGRectMake(0,0,oldImage.size.width, oldImage.size.height)];
    CGAffineTransform t = CGAffineTransformMakeRotation(degrees * M_PI / 180);
    rotatedViewBox.transform = t;
    CGSize rotatedSize = rotatedViewBox.frame.size;
    // Create the bitmap context
    UIGraphicsBeginImageContext(rotatedSize);
    CGContextRef bitmap = UIGraphicsGetCurrentContext();
    
    // Move the origin to the middle of the image so we will rotate and scale around the center.
    CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
    
    //   // Rotate the image context
    CGContextRotateCTM(bitmap, (degrees * M_PI / 180));
    
    // Now, draw the rotated/scaled image into the context
    CGContextScaleCTM(bitmap, 1.0, -1.0);
    CGContextDrawImage(bitmap, CGRectMake(-oldImage.size.width / 2, -oldImage.size.height / 2, oldImage.size.width, oldImage.size.height), [oldImage CGImage]);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

// 生成image
+ (UIImage *)makeImageWithView:(UIView *)view withSize:(CGSize)size {
    // 下面方法，第一个参数表示区域大小。第二个参数表示是否是非透明的。如果需要显示半透明效果，需要传NO，否则传YES。第三个参数就是屏幕密度了，关键就是第三个参数 [UIScreen mainScreen].scale。
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
    
}

// 异步操作
+ (void)asyncSleepWithTimeScond:(float )second completion:(void (^)(void))completion {
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(second * NSEC_PER_SEC));
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    queue = dispatch_get_main_queue();
    dispatch_after(popTime, queue , completion);
}

// Json 转 NSDictionary
+( NSDictionary * )dictionaryFromJsonString:( NSString * ) strJson {
    NSData *dataJson = [ strJson dataUsingEncoding: NSUTF8StringEncoding ] ;
    NSDictionary *dictJson =  [NSJSONSerialization JSONObjectWithData: dataJson options:kNilOptions error:nil] ;
    return dictJson;
}

// 获取手机系统版本号
+ (NSString *)getCurrentDeviceSystemBersion {
    return [[UIDevice currentDevice] systemVersion]  ;
}

+ (NSString *)getDateWithString:(NSString *)string {
    
    NSDate *senddate = [NSDate date];
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"yyyy"];
    NSString *yearString = [dateformatter stringFromDate:senddate];
    
    NSArray *array = [string componentsSeparatedByString:@"月"];
    
    NSString *lastStr = array.lastObject;
    NSArray *riArray = [lastStr componentsSeparatedByString:@"日"];
    
    NSString *ssss = [NSString stringWithFormat:@"%@-%@-%@",yearString,array.firstObject,riArray.firstObject];
    return ssss;
}
+ (NSString *)getTimeStrWithString:(NSString *)str{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];// 创建一个时间格式化对象
    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"]; //设定时间的格式
    NSDate *tempDate = [dateFormatter dateFromString:str];//将字符串转换为时间对象
    NSString *timeStr = [NSString stringWithFormat:@"%ld", (long)[tempDate timeIntervalSince1970]];//字符串转成时间戳,精确到毫秒*1000
    return timeStr;
}
@end
