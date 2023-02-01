//
//  HGAppLoginTool.m
//  HappyGame
//
//  Created by 彭小虎 on 2022/6/8.
//

#import "HGAppLoginTool.h"
#import "HGAppInitManager.h"
#import <AuthenticationServices/AuthenticationServices.h>///苹果登录按钮
//#import <TencentOpenAPI/TencentOAuth.h>
#import "HHBindMobilephoneViewController.h"///绑定手机号码
#import "HHMainTabBarViewController.h"
#import "HHNavigationBarViewController.h"
#import "WXApi.h"
#define URL_WXAPPID @"wxb9034c5eb2a0559c"
#define URL_WXSECRET @"03b28ce0e4f485d35a73f57e3f957aee"

#define URL_QQAPPID @"101960351"
#define URL_QQKey @"6278fb8e5bcb45b5cbf7173f7723c00b"
#import "TUILogin.h"
#import <AlipaySDK/AlipaySDK.h>
@interface HGAppLoginTool ()<ASAuthorizationControllerDelegate,ASAuthorizationControllerPresentationContextProviding>
//TencentSessionDelegate
//@property (nonatomic, strong) TencentOAuth *tencentOAuth;
@end

@implementation HGAppLoginTool
+ (instancetype)sharedInstance {
    static HGAppLoginTool *tool;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tool = [[HGAppLoginTool alloc] init];
    });
    return  tool;
}

#pragma mark --------------一键登录----------
- (void)oneClickLoginAction {
    UIViewController *vc = [HHAppManage getCurrentVC];
    [HGAppInitManager umQuickPhoneLoginVC:vc complete:^(NSString * quickLoginStutas) {
        
    }];
}

#pragma mark --------------注册----------
/**
 注册:password    密码 code    验证码   mobile    手机号码
 */
- (void)registerAction:(NSDictionary *)params{
    UIViewController *currentVC = [HHAppManage getCurrentVC];
    //    NSString *url = [NSString stringWithFormat:@"%@api_users/user_accounts/register",BASE_URL];
    //    [HGDataService requestURLWithPOST:url params:params completion:^(id  _Nonnull result) {
    //
    //        NSLog(@"结果====%@",result);
    //        NSString *code = [NSString stringWithFormat:@"%@", result[@"code"]];
    //        if ([code isEqualToString:@"1"]) {//请求成功
    ////            [self passWordLoginAction:password mobile:mobile];
    //        } else {
    //            [currentVC.view makeToast:result[@"msg"] duration:2 position:CSToastPositionCenter];
    //        }
    //
    //    } failure:^(NSError * _Nonnull error) {
    //        dispatch_async(dispatch_get_main_queue(), ^{
    //            [currentVC.view makeToast:@"网络异常，请检查网络后重试" duration:2 position:CSToastPositionCenter];
    //        });
    //    }];
}


#pragma mark --------------验证码登录----------
/**
 验证码登录: code    验证码   mobile    手机号码
 */
- (void)verificationCodeLoginAction:(NSDictionary *)params{
    NSString *url = [NSString stringWithFormat:@"%@api/login",BASE_URL];
    //    [HGDataService requestURLWithPOST:url params:params completion:^(id  _Nonnull result) {
    //        NSLog(@"验证码登录结果====%@",result);
    //        NSString *code = [NSString stringWithFormat:@"%@", result[@"code"]];
    //        if ([code isEqualToString:@"1"]) {//请求成功
    //            NSDictionary *data = result[@"data"];
    //
    //            [self saveUserInfoWithToken:[NSString stringWithFormat:@"%@",data[@"token"]] userID:[NSString stringWithFormat:@"%@",data[@"id"]] nick_name:[NSString stringWithFormat:@"%@",data[@"user_name"]] mobile:[NSString stringWithFormat:@"%@",data[@"mobile"]] headImageStr:[NSString stringWithFormat:@"%@",data[@"wechat_avatar"]]];
    //
    //        } else {
    ////            [self.view makeToast:result[@"msg"] duration:2 position:CSToastPositionCenter];
    //        }
    //
    //    } failure:^(NSError * _Nonnull error) {
    //        dispatch_async(dispatch_get_main_queue(), ^{
    //            UIViewController *currentVC = [HGAppManager appCurrentViewController];
    //            [currentVC.view makeToast:@"网络异常，请检查网络后重试" duration:2 position:CSToastPositionCenter];
    //        });
    //    }];
}

#pragma mark -------------密码登录----------
/**
 密码登录: password    密码  mobile    手机号码
 */
- (void)passWordLoginAction:(NSDictionary *)params{
    NSString *url = [NSString stringWithFormat:@"%@api/login",BASE_URL];
    
}

#pragma mark --------- qq登录 ------
- (void)qqLogin{
    //    NSArray* permissions = @[kOPEN_PERMISSION_GET_USER_INFO, kOPEN_PERMISSION_GET_SIMPLE_USER_INFO];
    //    //授权类型
    //    [self.tencentOAuth setAuthShareType:AuthShareType_QQ];
    //
    //    //调用SDK登录
    //    [self.tencentOAuth authorize:permissions];
}

/*
 #pragma mark --------- qq登录状态回调 ------
 //登录完成后，会调用TencentSessionDelegate中关于登录的协议方法。
 - (void)tencentDidLogin{
 if (self.tencentOAuth.accessToken && 0 != [_tencentOAuth.accessToken length]){
 [self.tencentOAuth getUserInfo];
 }else {
 // NSLog(@"登录不成功 没有获取accessToken");
 }
 }
 
 - (void)getUserInfoResponse:(APIResponse *)response {
 if (response && response.retCode == URLREQUEST_SUCCEED) {
 NSDictionary *dic = [response jsonResponse];
 NSLog(@"QQ信息=====%@",dic);
 [self _loadIs_bind:dic type:@"2" openId:self.tencentOAuth.openId token: self.tencentOAuth.accessToken];
 }
 }
 //非网络错误导致登录失败：
 -(void)tencentDidNotLogin:(BOOL)cancelled{
 
 //    NSLog(@"非网络错误导致登录失败");
 if (cancelled){
 //       NSLog(@"用户取消登录操作");
 }else{
 
 }
 }
 
 //网络错误导致登录失败：
 -(void)tencentDidNotNetWork{
 
 //    NSLog(@"网络错误导致登录失败：");
 }
 */
#pragma mark -------------苹果登录----------
- (void)appleLogin {
    if (@available(iOS 13.0, *)) {
        
        ASAuthorizationAppleIDProvider *appleIDProvider = [[ASAuthorizationAppleIDProvider alloc] init];
        ASAuthorizationAppleIDRequest *appleIDRequest = [appleIDProvider createRequest];
        // 用户授权请求的联系信息
        appleIDRequest.requestedScopes = @[ASAuthorizationScopeFullName, ASAuthorizationScopeEmail];
        ASAuthorizationController *authorizationController = [[ASAuthorizationController alloc] initWithAuthorizationRequests:@[appleIDRequest]];
        // 设置授权控制器通知授权请求的成功与失败的代理
        authorizationController.delegate = self;
        // 设置提供 展示上下文的代理，在这个上下文中 系统可以展示授权界面给用户
        authorizationController.presentationContextProvider = self;
        // 在控制器初始化期间启动授权流
        [authorizationController performRequests];
        
    } else {
        NSLog(@"该系统版本不可用Apple登录");
    }
}


#pragma mark- ASAuthorizationControllerDelegate
- (void)authorizationController:(ASAuthorizationController *)controller didCompleteWithAuthorization:(ASAuthorization *)authorization  API_AVAILABLE(ios(13.0)){
    
    if ([authorization.credential isKindOfClass:[ASAuthorizationAppleIDCredential class]]) {
        // 用户登录使用ASAuthorizationAppleIDCredential
        ASAuthorizationAppleIDCredential *appleIDCredential = (ASAuthorizationAppleIDCredential *)authorization.credential;
        NSDictionary *params = @{
            @"openId": appleIDCredential.user ?: @"",
            @"phoneNo": @"",
            @"nickName": appleIDCredential.fullName.nickname ?:@"",
            @"familyName": appleIDCredential.fullName.familyName ?:@"",
            @"givenName": appleIDCredential.fullName.givenName ?:@"",
            @"email": appleIDCredential.email ?:@"",
            @"avatar": @"",
            @"gender": @(0),
            @"accountType": @(0),
        };
        
        [self loginWithParams:params and:HGLoginTypeAppleLogin];
        
        //NSString *user = appleIDCredential.user;
        // 使用过授权的，可能获取不到以下三个参数
        //NSString *familyName = appleIDCredential.fullName.familyName;
        //NSString *givenName = appleIDCredential.fullName.givenName;
        //NSString *email = appleIDCredential.email;
        
    } else if ([authorization.credential isKindOfClass:[ASPasswordCredential class]]) {
        // 用户登录使用现有的密码凭证（iCloud记录的）
        ASPasswordCredential *passwordCredential = (ASPasswordCredential *)authorization.credential;
        // 密码凭证对象的用户标识 用户的唯一标识
        //NSString *user = passwordCredential.user;
        // 密码凭证对象的密码
        //NSString *password = passwordCredential.password;
        NSDictionary *params = @{
            @"user": passwordCredential.user ?: @"",
            @"password": passwordCredential.password ?:@""
        };
        [self loginWithParams:params and:HGLoginTypeAppleLogin];
    } else {
        NSLog(@"授权信息均不符");
    }
}

#pragma mark -------------苹果授权回调后发起登录请求----------
- (void)loginWithParams:(NSDictionary *)params and:(HGLoginType)thirdLoinType{
    NSLog(@"授权信息%@",params);
    
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    NSString *url = [NSString stringWithFormat:@"%@/user/third/party/login",BASE_URL];
    NSMutableDictionary *dic = @{}.mutableCopy;
    [dic setValue:@(3) forKey:@"login_type"];
    [dic setValue:params[@"openId"] forKey:@"open_id"];
    
    [PPHTTPRequest requestPostWithJSONForUrl:url parameters:dic success:^(id  _Nonnull response) {
        NSLog(@"苹果登录成功之后检测是否绑定手机号======%@",response);
        NSString *code = [NSString stringWithFormat:@"%@", response[@"code"]];
        if ([code isEqualToString:@"0"]) {//请求成功
            
            NSDictionary *data = response[@"data"];
            BOOL is_bind = [data[@"is_bind"] boolValue];
            NSString *bind_token = data[@"bind_token"];
            NSDictionary *token = data[@"token"];
            if(!is_bind){//没有绑定
                [self goBind:bind_token];
            }else {//绑定了手机号
                [self saveUserInfoWithToken:token];
            }
        }else {
            [keyWindow makeToast:response[@"msg"] duration:2 position:CSToastPositionCenter];
        }
    } failure:^(NSError * _Nonnull error) {
        
    }];
}

- (void)goBind:(NSString *)bind_token {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIViewController *currentVC = [HHAppManage getCurrentVC];
        [currentVC dismissViewControllerAnimated:YES completion:^{
            WeakSelf(weakSelf)
            [UMCommonHandler checkEnvAvailableWithAuthType:UMPNSAuthTypeLoginToken complete:^(NSDictionary*_Nullable resultDic){
                BOOL isSupport =[PNSCodeSuccess isEqualToString:[resultDic objectForKey:@"resultCode"]];
                if(isSupport) {
                    [HGAppInitManager bindMobileNumberWithOneClickLogin:[HHAppManage getCurrentVC] bind_token:bind_token complete:^(NSString * _Nonnull quickLoginStutas) {
                        
                    }];
                    
                }else {
                    HHBindMobilephoneViewController *bindMoblieVC = [[HHBindMobilephoneViewController alloc] init];
                    bindMoblieVC.hidesBottomBarWhenPushed = YES;
                    bindMoblieVC.bind_token = bind_token;
                    HHNavigationBarViewController *nav = [[HHNavigationBarViewController alloc] initWithRootViewController:bindMoblieVC];
                    nav.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
                    nav.modalPresentationStyle = UIModalPresentationFullScreen;
                    [[HHAppManage getCurrentVC] presentViewController:nav animated:YES completion:nil];
                }
            }];
        }];
        
    });
}

- (void)authorizationController:(ASAuthorizationController *)controller didCompleteWithError:(NSError *)error API_AVAILABLE(ios(13.0)) {
    
    NSString *errorMsg = nil;
    switch (error.code) {
        case ASAuthorizationErrorCanceled:
            errorMsg = @"用户取消了授权请求";
            break;
        case ASAuthorizationErrorFailed:
            errorMsg = @"授权请求失败";
            break;
        case ASAuthorizationErrorInvalidResponse:
            errorMsg = @"授权请求响应无效";
            break;
        case ASAuthorizationErrorNotHandled:
            errorMsg = @"未能处理授权请求";
            break;
        case ASAuthorizationErrorUnknown:
            errorMsg = @"授权请求失败未知原因";
            break;
            
        default:
            break;
    }
    if(errorMsg){
        [MBProgressHUD showError:errorMsg];
    }
}

#pragma mark- ASAuthorizationControllerPresentationContextProviding
- (ASPresentationAnchor)presentationAnchorForAuthorizationController:(ASAuthorizationController *)controller  API_AVAILABLE(ios(13.0)){
    UIViewController *vc = [HHAppManage getCurrentVC];
    return vc.view.window;
}
#pragma mark- apple授权状态 更改通知
- (void)handleSignInWithAppleStateChanged:(NSNotification *)notification{
    NSLog(@"%@", notification.userInfo);
}

#pragma mark --------- 微信登录 ------
- (void)wechatLogin{
    
    SendAuthReq *req = [[SendAuthReq alloc]init];
    req.scope = @"snsapi_userinfo";
    req.openID = URL_WXAPPID;
    req.state = @"1245";
    [WXApi sendReq:req completion:^(BOOL success) {
    }];
}

#pragma mark --------- 微信通知方法 ------
- (void)wxChatLoginNotification:(NSNotification *)aNotification{
    NSDictionary *diction = aNotification.userInfo;
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    
    NSString *code = diction[@"code"];
    
    NSString *url = [NSString stringWithFormat:@"%@/user/third/party/login",BASE_URL];
    NSMutableDictionary *dic = @{}.mutableCopy;
    [dic setValue:@(1) forKey:@"login_type"];
    [dic setValue:code forKey:@"open_id"];
    
    [PPHTTPRequest requestPostWithJSONForUrl:url parameters:dic success:^(id  _Nonnull response) {
        NSLog(@"微信登录成功之后检测是否绑定手机号======%@",response);
        NSString *code = [NSString stringWithFormat:@"%@", response[@"code"]];
        if ([code isEqualToString:@"0"]) {//请求成功
            NSDictionary *data = response[@"data"];
            BOOL is_bind = [data[@"is_bind"] boolValue];
            NSString *bind_token = data[@"bind_token"];
            NSDictionary *token = data[@"token"];
            if(!is_bind){//没有绑定
                [self goBind:bind_token];
            }else {//绑定了手机号
                [self saveUserInfoWithToken:token];
            }
        }else {
            [keyWindow makeToast:response[@"msg"] duration:2 position:CSToastPositionCenter];
        }
    } failure:^(NSError * _Nonnull error) {
        
    }];
    
}



//- (BOOL)isInstallQQ{
//    return [TencentOAuth iphoneQQInstalled];
//}

- (BOOL)isWXAppInstalled{
    return [WXApi isWXAppInstalled];
}

- (BOOL)isAlipayInstalled{
    return YES;
}


#pragma mark -----------------支付宝登录--------------------
- (void)alipayLogin {
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    
    NSURL * url = [NSURL URLWithString:@"alipay://"];//注意设置白名单
    if (![[UIApplication sharedApplication]canOpenURL:url]) {//未安装
        [keyWindow makeToast:@"支付宝未安装，请安装后重试" duration:2 position:CSToastPositionCenter];
        return;
    }else {
        
        NSString *url = [NSString stringWithFormat:@"%@/aly/auth",BASE_URL];
        [PPHTTPRequest requestGetWithURL:url parameters:@{} success:^(id  _Nonnull response) {
            
            NSString *code = [NSString stringWithFormat:@"%@", response[@"code"]];
            if ([code isEqualToString:@"0"]) {//请求成功
                NSString *data = response[@"data"];
                
                NSString *appScheme = @"HashdeepHotels";
                [[AlipaySDK defaultService] auth_V2WithInfo:data fromScheme:appScheme callback:^(NSDictionary *resultDic) {
                    NSLog(@"支付宝登录结果=====%@",resultDic);
                    NSString *result = resultDic[@"result"];
                    NSArray *arr = [result componentsSeparatedByString:@"alipay_open_id="];
                    NSArray *arr2 = [arr.lastObject componentsSeparatedByString:@"&user_id"];
                    
                    [self alipayBind:arr2.firstObject];
                }];
            }else {
                [keyWindow makeToast:response[@"msg"] duration:2 position:CSToastPositionCenter];
            }
            
        } failure:^(NSError * _Nonnull error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [keyWindow makeToast:@"网络异常，请检查网络后重试" duration:2 position:CSToastPositionCenter];
            });
        }];
    }
}

- (void)alipayBind:(NSString *)open_id {
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    NSString *url = [NSString stringWithFormat:@"%@/user/third/party/login",BASE_URL];
    NSMutableDictionary *dic = @{}.mutableCopy;
    [dic setValue:@(2) forKey:@"login_type"];
    [dic setValue:open_id forKey:@"open_id"];
    
    [PPHTTPRequest requestPostWithJSONForUrl:url parameters:dic success:^(id  _Nonnull response) {
        NSLog(@"支付宝登录成功之后检测是否绑定手机号======%@",response);
        NSString *code = [NSString stringWithFormat:@"%@", response[@"code"]];
        if ([code isEqualToString:@"0"]) {//请求成功
            
            NSDictionary *data = response[@"data"];
            BOOL is_bind = [data[@"is_bind"] boolValue];
            NSString *bind_token = data[@"bind_token"];
            NSDictionary *token = data[@"token"];
            if(!is_bind){//没有绑定
                [self goBind:bind_token];
            }else {//绑定了手机号
                [self saveUserInfoWithToken:token];
            }
        }else {
            [keyWindow makeToast:response[@"msg"] duration:2 position:CSToastPositionCenter];
        }
    } failure:^(NSError * _Nonnull error) {
        
    }];
}


//保存登录信息
- (void)saveUserInfoWithToken:(NSDictionary *)token{
    [UserInfoManager sharedInstance].jwtToken = token[@"token"];
    [UserInfoManager sharedInstance].mobile = token[@"phone"];
    [UserInfoManager sharedInstance].userNickName = token[@"user_name"];
    [UserInfoManager sharedInstance].im_account = token[@"im_account"];
    [UserInfoManager sharedInstance].im_sign = token[@"im_sign"];
    [UserInfoManager sharedInstance].headImageStr = token[@"user_head_img"];
    [UserInfoManager sharedInstance].refresh_token = token[@"refresh_token"];
    [UserInfoManager synchronize];
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isLogin"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [TUILogin login:1400740345 userID:token[@"im_account"] userSig:token[@"im_sign"] succ:^{
        NSLog(@"-----> 登录成功");
    } fail:^(int code, NSString *msg) {
        NSLog(@"-----> 登录失败");
    }];
    
    UIViewController *currentVC = [HHAppManage getCurrentVC];
    [currentVC dismissViewControllerAnimated:YES completion:nil];
    
}
@end
