//
//  AppDelegate.m
//  HashdeepHotel
//
//  Created by Cindy on 2022/7/11.
//

#import "AppDelegate.h"
#import "HHMainTabBarViewController.h"
#import "HHGuideViewController.h"
#import <AMapLocationKit/AMapLocationKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"
#import <AdSupport/AdSupport.h>
#import <AppTrackingTransparency/AppTrackingTransparency.h>
#import "TUILogin.h"
#import "TABAnimated.h"
#import "HGAppInitManager.h"


@interface AppDelegate ()<WXApiDelegate>
@property (nonatomic, assign) BOOL isFirst;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = UIColor.whiteColor;
    [self.window makeKeyAndVisible];
    WeakSelf(weakSelf)
    self.isFirst =  [[NSUserDefaults standardUserDefaults ]boolForKey:@"isFirstRun"];
    if (!self.isFirst) {
        HHGuideViewController *guideVC = [[HHGuideViewController alloc]init];
        self.window.rootViewController = guideVC;
        
        guideVC.clickCancelButtonAction = ^{
            weakSelf.isFirst = NO;
        };
        guideVC.clickAgreeButtonAction = ^{
            weakSelf.isFirst = YES;
            [[NSUserDefaults standardUserDefaults]setBool:self.isFirst forKey:@"isFirstRun"];
            [[NSUserDefaults standardUserDefaults]synchronize];
        };
        
    }else {
        HHMainTabBarViewController *mainVC = [[HHMainTabBarViewController alloc] init];
        self.window.rootViewController = mainVC;
    }
    
    /**过渡**/
    // 初始化TABAnimated，并设置TABAnimated相关属性
    // 初始化方法仅仅设置的是全局的动画效果
    // 你可以设置`TABViewAnimated`中局部动画属性`superAnimationType`覆盖全局属性，在工程中兼容多种动画
    [[TABAnimated sharedAnimated] initWithOnlySkeleton];
    // 开启日志
    [TABAnimated sharedAnimated].openLog = NO;
    //    [TABAnimated sharedAnimated].openAnimationTag = YES;
    
    //高德地图的key
    [AMapLocationManager updatePrivacyShow:AMapPrivacyShowStatusDidShow privacyInfo:AMapPrivacyInfoStatusDidContain];
    [AMapLocationManager updatePrivacyAgree:AMapPrivacyAgreeStatusDidAgree];
    [AMapServices sharedServices].apiKey = @"6ad099aa4e499c8773618ad37029392f";
    
    //腾讯IM登录
    [self loginSDK:[UserInfoManager sharedInstance].im_account userSig:[UserInfoManager sharedInstance].im_sign succ:^{
        
    } fail:^(int code, NSString *msg) {
        
    }];
    
    //友盟
    [HGAppInitManager HGAppInitThirdSDK];
        
    //向微信注册应用。
    [WXApi registerApp:@"wxb9034c5eb2a0559c" universalLink:@"https://www.anzhuhui.com/iosuniversal/"];
    
    return YES;
}


// 您可以在用户 UI 点击登录的时候登录 UI 组件
- (void)loginSDK:(NSString *)userID userSig:(NSString *)sig succ:(TSucc)succ fail:(TFail)fail {
    [TUILogin login:1400740345 userID:userID userSig:sig succ:^{
        NSLog(@"-----> 登录成功");
    } fail:^(int code, NSString *msg) {
        NSLog(@"-----> 登录失败");
    }];
}

//9之后的
-(BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options{
    if ([url.host containsString:@"safepay"]) {
        
        [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"支付宝result = %@",resultDic);
            // 解析 auth code
            NSString *result = resultDic[@"result"];
            NSString *authCode = nil;
            if (result.length>0) {
                NSArray *resultArr = [result componentsSeparatedByString:@"&"];
                for (NSString *subResult in resultArr) {
                    if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
                        authCode = [subResult substringFromIndex:10];
                        break;
                    }
                }
            }
            NSLog(@"支付宝授权结果 authCode = %@", authCode?:@"");
        }];
        
    }else{
        return [WXApi handleOpenURL:url delegate:self];
    }
    
    return YES;
}

-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    return [WXApi handleOpenURL:url delegate:self];

}
-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    return [WXApi handleOpenURL:url delegate:self];
}

- (void)onReq:(BaseReq*)req{
    NSLog(@"---");
}


/*! 微信回调，不管是登录还是分享成功与否，都是走这个方法 @brief 发送一个sendReq后，收到微信的回应
 *
 * 收到一个来自微信的处理结果。调用一次sendReq后会收到onResp。
 * 可能收到的处理结果有SendMessageToWXResp、SendAuthResp等。
 * @param resp具体的回应内容，是自动释放的
 */

/*
 enum  WXErrCode {
 WXSuccess           = 0,    成功
 WXErrCodeCommon     = -1,  普通错误类型
 WXErrCodeUserCancel = -2,    用户点击取消并返回
 WXErrCodeSentFail   = -3,   发送失败
 WXErrCodeAuthDeny   = -4,    授权失败
 WXErrCodeUnsupport  = -5,   微信不支持
 };
 */

//微信代理方法
- (void)onResp:(BaseResp *)resp {
    
    if ([resp isKindOfClass:[SendAuthResp class]]) {   //授权登录的类。
        
        SendAuthResp *aresp = (SendAuthResp *)resp;
        if(aresp.errCode== 0 && [aresp.state isEqualToString:@"1245"]){//成功。
            //这里处理回调的方法 。 通过代理吧对应的登录消息传送过去。
            NSString *code = aresp.code;
            NSDictionary *dic = @{
                @"code":code
            };
            NSLog(@"code---------------%@",code);
            NSNotification *notification =[NSNotification notificationWithName:@"WXChatLoginSuccess" object:nil userInfo:dic];
            //通过通知中心发送通知
            [[NSNotificationCenter defaultCenter] postNotification:notification];
        }else {
//            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"登录失败" message:[NSString stringWithFormat:@"reason : %@",resp.errStr] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//            [alert show];
        }
        
    }else if([resp isKindOfClass:[SendMessageToWXResp class]]) {
        
       
    }else{ //失败
        NSLog(@"error %@",resp.errStr);
        
    }
}
- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray<id<UIUserActivityRestoring>> * _Nullable))restorationHandler{
    return [WXApi handleOpenUniversalLink:userActivity delegate:self];
}

//微信支付、支付宝支付
/*
 - (BOOL)application:(UIApplication *)application continueUserActivity:(nonnull NSUserActivity *)userActivity restorationHandler:(nonnull void (^)(NSArray * _Nullable))restorationHandler {
 return [WXApi handleOpenUniversalLink:userActivity delegate:self];
 }
 
 //被废弃的方法. 但是在低版本中会用到.建议写上
 - (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
 return [WXApi handleOpenURL:url delegate:self];
 }
 //被废弃的方法. 但是在低版本中会用到.建议写上
 
 - (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
 return [WXApi handleOpenURL:url delegate:self];
 }
 
 
 #pragma mark 微信回调方法
 - (void)onResp:(BaseResp *)resp{
 NSString * strMsg = [NSString stringWithFormat:@"errorCode: %d",resp.errCode];
 NSLog(@"strMsg: %@",strMsg);
 
 NSString * errStr = [NSString stringWithFormat:@"errStr: %@",resp.errStr];
 NSLog(@"errStr: %@",errStr);
 
 
 NSString * strTitle;
 //判断是微信消息的回调 --> 是支付回调回来的还是消息回调回来的.
 if ([resp isKindOfClass:[SendMessageToWXResp class]]){
 strTitle = [NSString stringWithFormat:@"发送媒体消息的结果"];
 }
 
 NSString * wxPayResult;
 //判断是否是微信支付回调 (注意是PayResp 而不是PayReq)
 
 if ([resp isKindOfClass:[PayResp class]]){
 //支付返回的结果, 实际支付结果需要去微信服务器端查询
 strTitle = [NSString stringWithFormat:@"支付结果"];
 switch (resp.errCode){
 case WXSuccess:{
 strMsg = @"支付结果:";
 NSLog(@"支付成功: %d",resp.errCode);
 wxPayResult = @"success";
 break;
 }
 case WXErrCodeUserCancel:{
 strMsg = @"用户取消了支付";
 NSLog(@"用户取消支付: %d",resp.errCode);
 wxPayResult = @"cancel";
 break;
 }
 default:{
 strMsg = [NSString stringWithFormat:@"支付失败! code: %d  errorStr: %@",resp.errCode,resp.errStr];
 NSLog(@":支付失败: code: %d str: %@",resp.errCode,resp.errStr);
 wxPayResult = @"faile";
 break;
 }
 }
 //发出通知 从微信回调回来之后,发一个通知,让请求支付的页面接收消息,并且展示出来,或者进行一些自定义的展示或者跳转
 [[NSNotificationCenter defaultCenter] postNotificationName:@"paySyr" object:nil userInfo:nil];
 }
 }
 */
//进入主界面调用的方法
- (void)goMain {
    HHMainTabBarViewController *mainVC = [[HHMainTabBarViewController alloc] init];
    self.window.rootViewController = mainVC;
    [self.window makeKeyAndVisible];
}

- (void)applicationWillEnterForeground:(UIApplication *)application{
    NSLog(@"即将从后台进入前台");
    //创建通知
    NSNotification *notification =[NSNotification notificationWithName:@"paySuccessNotification" object:nil];
    
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}
@end
