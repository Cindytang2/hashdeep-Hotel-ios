//
//  HGAppLoginTool.h
//  HappyGame
//
//  Created by 彭小虎 on 2022/6/8.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, HGLoginType) {
    HGLoginTypePhoneQuickLogin        = 0,    // 一键登录
    HGLoginTypeVerificationCodeLogin  = 1,    // 验证码登录
    HGLoginTypePassWordLogin          = 2,    // 密码登录
    HGLoginTypeWeChatLogin            = 3,    // 微信登录
    HGLoginTypeQQLogin                = 4,    // QQ登录
    HGLoginTypeAppleLogin             = 5,    // 苹果登录
    HGLoginTypeRegister               = 6,    // 注册
    HGLoginTypeAlipayLogin            =7 //支付宝登录
};

@interface HGAppLoginTool : NSObject
@property (nonatomic, assign) HGLoginType type;  //登录类型
@property (nonatomic, assign) BOOL isAgree;    //阅读并同意 YES NO

//- (BOOL)isInstallQQ;
- (BOOL)isWXAppInstalled;
- (BOOL)isAlipayInstalled;
+ (instancetype)sharedInstance;

/**
 一键登录
 */
- (void)oneClickLoginAction;

/**
 验证码登录 :code    验证码   mobile    手机号码
 */
- (void)verificationCodeLoginAction:(NSDictionary *)params;

/**
 密码登录: password    密码  mobile    手机号码
 */
- (void)passWordLoginAction:(NSDictionary *)params;

/**
 注册:  password    密码  code    验证码   mobile    手机号码
 */
- (void)registerAction:(NSDictionary *)params;

/**
 微信登录
 */
- (void)wechatLogin;

/**
 苹果登录
 */
- (void)appleLogin;

/**
 qq登录
 */
- (void)qqLogin;
/**
 支付宝登录
 */
- (void)alipayLogin;

- (void)wxChatLoginNotification:(NSNotification *)aNotification;

@end

NS_ASSUME_NONNULL_END
