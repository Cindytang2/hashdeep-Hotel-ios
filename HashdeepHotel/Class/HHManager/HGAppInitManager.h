//
//  HGAppInitManager.h
//  HappyGame
//
//  Created by 彭小虎 on 2022/6/6.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface HGAppInitManager : NSObject
+ (void)HGAppInitThirdSDK;
+ (void)umQuickPhoneLoginVC:(UIViewController *)controller complete:(void (^)(NSString * quickLoginStutas))complete;

+ (void)bindMobileNumberWithOneClickLogin:(UIViewController *)controller bind_token:(NSString *)bind_token complete:(void (^)(NSString * quickLoginStutas))complete;
@end

NS_ASSUME_NONNULL_END
