//
//  HGAppInitManager.m
//  HappyGame
//
//  Created by 彭小虎 on 2022/6/6.
//

#import "HGAppInitManager.h"
#import "HGAppLoginTool.h"
#import "HHMainTabBarViewController.h"
//友盟
#import <UMCommon/UMCommon.h>
#import <UMVerify/UMVerify.h>
#import "HHBackView.h"
#import "HHLoginToastView.h"
#import "TUILogin.h"
#import "HHVerificationCodeLoginViewController.h"
#import "HHNavigationBarViewController.h"
#import "HHBindMobilephoneViewController.h"///绑定手机号码
@implementation HGAppInitManager
+ (void)HGAppInitThirdSDK{
    //友盟初始化
    [self appInitUM];
}

+ (void)appInitUM{
    
    // 初始化友盟相关配置
    [UMConfigure initWithAppkey:@"638489f7ba6a5259c49d749d" channel:@"App Store"];
    // 设置密钥
    NSString *verifyInfo = @"mMajs7Ef08R9uU8olVOTENKrNytnenLp3BRMKpN/iL1YSUJSVKtFspMTLoglvrlu4BVgXNXWH1OaokcHolASCfbenxiyZLlVXSfT1vuHe7/eGHNne93XxyR4TuCm5HZojI3f478bDdfSWio8BbqgTEvPd9Q6iB//1kO+S00KkL/qGFyxMmwmhx3oQetNjUC2PFJcri7raTklLmS4pEBlsPrhE8f+zF6WGV0q8Uum/7auJyqjdxk10nU6LoyqxUjGnRqjnI4WQuI=";
    [UMCommonHandler setVerifySDKInfo:verifyInfo complete:^(NSDictionary*_Nonnull
                                                            resultDic){
        NSLog(@"++++++++%@",resultDic);
        /*
         msg = "AppID\U3001Appkey\U89e3\U6790\U6210\U529f";
         requestId = eb8e5ede7d60491d;
         resultCode = 600000;
         */
    }];
}

+ (void)umQuickPhoneLoginVC:(UIViewController *)controller complete:(void (^)(NSString * quickLoginStutas))complete{
    //检查环境
    WeakSelf(weakSelf)
    [UMCommonHandler checkEnvAvailableWithAuthType:UMPNSAuthTypeLoginToken complete:^
     (NSDictionary*_Nullable resultDic){
        
        //判断检查环境是否成功
        /*
         msg = "";
         requestId = 5372bd322c264ea8;
         resultCode = 600000;
         */
        if([resultDic[@"resultCode"] integerValue] == 600000){
            complete(@"YES");
            //1. 调用取号接⼝，加速授权⻚的弹起
            [UMCommonHandler accelerateLoginPageWithTimeout:3.0 complete:^(NSDictionary *_Nonnull resultDic){
                //设置样式
                UMCustomModel*model = [[UMCustomModel alloc]init];
                model.navIsHidden = YES;
                model.navColor = kWhiteColor;
                model.sloganIsHidden = YES;
                model.privacyOne = @[@"《服务协议》",@"https://www.anzhuhui.com/agreement/protocol.html"];
                model.privacyTwo = @[@"《隐私政策》",@"https://www.anzhuhui.com/protocol4.html"];
                model.logoImage = [UIImage imageNamed:@"icon_login_onekey"];
                model.logoFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
                    return CGRectMake((kScreenWidth-200)/2, UINavigateHeight+54, 200, 65);
                };
                model.numberFont = [UIFont boldSystemFontOfSize:16];
                model.numberColor = XLColor_mainTextColor;
                model.numberFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
                    return CGRectMake((kScreenWidth-100)/2, 215, 100, 45);
                };
                
                model.loginBtnBgImgs = @[HHGetImage(@"icon_login_loginButton_bg"),HHGetImage(@"icon_login_loginButton_bg"),HHGetImage(@"icon_login_loginButton_bg")];
                model.loginBtnFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
                    return CGRectMake(20, 290, kScreenWidth-40, 45);
                };
                model.loginBtnText = [[NSAttributedString alloc]initWithString:@"本机号一键登录" attributes:@{NSForegroundColorAttributeName:kWhiteColor, NSFontAttributeName:[UIFont boldSystemFontOfSize:18]}];
                model.customViewBlock =^(UIView*_Nonnull superCustomView){
                    HHBackView *backView = [[HHBackView alloc] init];
                    backView.type = @"login";
                    backView.clickBackAction = ^{
                        UIViewController *currentVC = [HHAppManage getCurrentVC];
                        [currentVC dismissViewControllerAnimated:YES completion:nil];
                    };
                    [superCustomView addSubview:backView];
                    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.offset(0);
                        make.top.offset(UINavigateTop);
                        make.width.offset(55);
                        make.height.offset(44);
                    }];
                };
                
                model.changeBtnFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
                    return CGRectMake((kScreenWidth-150)/2, 340, 150, 30);
                };
                model.changeBtnTitle = [[NSAttributedString alloc] initWithString:@"其他方式登录" attributes:@{NSForegroundColorAttributeName:XLColor_mainTextColor,NSFontAttributeName :[UIFont systemFontOfSize:16.0]}];
                
                model.checkBoxImages = @[HHGetImage(@"icon_login_normal"),HHGetImage(@"icon_login_selected")];
                model.privacyAlignment = NSTextAlignmentLeft;
                model.privacyColors = @[XLColor_mainTextColor,UIColorHex(b58e7f)];
                model.privacyPreText = @"已阅读并同意接受安住会的";
                model.privacyConectTexts = @[@"、",@"、",@"、"];
                model.privacyOperatorIndex = 2;
                model.privacyOperatorSufText = @"》";
                model.privacyOperatorPreText = @"《";
                model.checkBoxIsChecked = NO;
                //2.调⽤唤起授权⻚面
                [UMCommonHandler getLoginTokenWithTimeout:3.0 controller:controller model:model complete:^(NSDictionary*_Nonnull resultDic){
                    NSString *code = [resultDic objectForKey:@"resultCode"];
                    if([PNSCodeLoginControllerPresentSuccess isEqualToString:code]){
                        //弹起授权⻚成功
                        NSLog(@"唤起授权页成功");
                    }else if([PNSCodeLoginControllerClickCancel isEqualToString:code]){
                        //点击了授权页的返回
                        NSLog(@"取消一键登录");
                    }else if([PNSCodeLoginControllerClickChangeBtn isEqualToString:code]){
                        //点击切换其他登录⽅式按钮
                        complete(@"Other");
                        UIViewController *currentVC = [HHAppManage getCurrentVC];
                        [currentVC dismissViewControllerAnimated:YES completion:nil];
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            UIViewController *currentVC = [HHAppManage getCurrentVC];
                            HHVerificationCodeLoginViewController *loginVC = [[HHVerificationCodeLoginViewController alloc] init];
                            loginVC.loginSuccessAction = ^{
                                
                            };
                            loginVC.hidesBottomBarWhenPushed = YES;
                            HHNavigationBarViewController *loginNav = [[HHNavigationBarViewController alloc] initWithRootViewController:loginVC];
                            loginNav.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
                            loginNav.modalPresentationStyle = UIModalPresentationFullScreen;
                            [currentVC presentViewController:loginNav animated:YES completion:nil];
                        });
                    }else if([PNSCodeLoginControllerClickLoginBtn isEqualToString:code]){
                        if([[resultDic objectForKey:@"isChecked"] boolValue]== YES){
                            //点击了登录按钮
                            NSLog(@"要去登录了啊");
                        }else{
                            //点击了登录按钮，check box未选中，SDK内部不会去获取登陆Token
                            dispatch_async(dispatch_get_main_queue(), ^{
                                
                                UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
                                [keyWindow makeToast:@"请先同意一键登录认证服务条款" duration:1.5 position:CSToastPositionCenter];
                                
                            });
                        }
                    }else if([PNSCodeLoginControllerClickCheckBoxBtn isEqualToString:code]){
                        //点击check box
                        if([[resultDic objectForKey:@"isChecked"] boolValue]== YES){
                            [HGAppLoginTool sharedInstance].isAgree = YES;
                        }else{
                            [HGAppLoginTool sharedInstance].isAgree = NO;
                        }
                        
                    }else if([PNSCodeLoginControllerClickProtocol isEqualToString:code]){
                        //点击了协议富⽂本
                        NSLog(@"点击了协议富文本");
                    }else if([PNSCodeSuccess isEqualToString:code]){
                        NSString*token =[resultDic objectForKey:@"token"];
                        if([HGAppLoginTool sharedInstance].isAgree == YES){
                            [weakSelf postLoginWithParm:token];
                        }else{
                            UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
                            [keyWindow makeToast:@"请先同意一键登录认证服务条款" duration:1.5 position:CSToastPositionCenter];
                        }
                    }else{
                        //获取登录Token失败
                        UIViewController *currentVC = [HHAppManage getCurrentVC];
                        [currentVC dismissViewControllerAnimated:YES completion:nil];
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            UIViewController *currentVC = [HHAppManage getCurrentVC];
                            HHVerificationCodeLoginViewController *loginVC = [[HHVerificationCodeLoginViewController alloc] init];
                            loginVC.loginSuccessAction = ^{
                                
                            };
                            loginVC.hidesBottomBarWhenPushed = YES;
                            HHNavigationBarViewController *loginNav = [[HHNavigationBarViewController alloc] initWithRootViewController:loginVC];
                            loginNav.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
                            loginNav.modalPresentationStyle = UIModalPresentationFullScreen;
                            [currentVC presentViewController:loginNav animated:YES completion:nil];
                        });
                    }
                }];
            }];
        }else{
            complete(resultDic[@"msg"]);
        }
    }];
}

+ (void)bindMobileNumberWithOneClickLogin:(UIViewController *)controller bind_token:(NSString *)bind_token complete:(void (^)(NSString * quickLoginStutas))complete{
    
    
    //检查环境
    WeakSelf(weakSelf)
    [UMCommonHandler checkEnvAvailableWithAuthType:UMPNSAuthTypeLoginToken complete:^
     (NSDictionary*_Nullable resultDic){
        //判断检查环境是否成功
        /*
         msg = "";
         requestId = 5372bd322c264ea8;
         resultCode = 600000;
         */
        if([resultDic[@"resultCode"] integerValue] == 600000){
            complete(@"YES");
            //1. 调用取号接⼝，加速授权⻚的弹起
            [UMCommonHandler accelerateLoginPageWithTimeout:3.0 complete:^(NSDictionary *_Nonnull resultDic){
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSLog(@"哈哈哈，进了没哦");
                    //设置样式
                    UMCustomModel*model = [[UMCustomModel alloc]init];
                    model.navIsHidden = YES;
                    model.navColor = kWhiteColor;
                    model.sloganIsHidden = YES;
                    model.logoIsHidden = YES;
                    model.numberFont = [UIFont boldSystemFontOfSize:16];
                    model.numberColor = XLColor_mainTextColor;
                    model.numberFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
                        return CGRectMake((kScreenWidth-100)/2, 215, 100, 45);
                    };
                    
                    model.loginBtnBgImgs = @[HHGetImage(@"icon_login_loginButton_bg"),HHGetImage(@"icon_login_loginButton_bg"),HHGetImage(@"icon_login_loginButton_bg")];
                    model.loginBtnFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
                        return CGRectMake(20, 290, kScreenWidth-40, 45);
                    };
                    model.loginBtnText = [[NSAttributedString alloc]initWithString:@"本机号一键绑定" attributes:@{NSForegroundColorAttributeName:kWhiteColor, NSFontAttributeName:[UIFont boldSystemFontOfSize:18]}];
                    model.customViewBlock =^(UIView*_Nonnull superCustomView){
                        HHBackView *backView = [[HHBackView alloc] init];
                        backView.type = @"bindMobileNumber";
                        backView.clickBackAction = ^{
                            UIViewController *currentVC = [HHAppManage getCurrentVC];
                            [currentVC dismissViewControllerAnimated:YES completion:nil];
                        };
                        [superCustomView addSubview:backView];
                        [backView mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.left.offset(0);
                            make.top.offset(UINavigateTop);
                            make.width.offset(kScreenWidth);
                            make.height.offset(200);
                        }];
                    };
                    
                    model.changeBtnFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
                        return CGRectMake((kScreenWidth-150)/2, 340, 150, 30);
                    };
                    model.changeBtnTitle = [[NSAttributedString alloc] initWithString:@"更换手机号" attributes:@{NSForegroundColorAttributeName:XLColor_mainTextColor,NSFontAttributeName :[UIFont systemFontOfSize:16.0]}];
                    
                    model.checkBoxImages = @[HHGetImage(@"icon_login_normal"),HHGetImage(@"icon_login_selected")];
                    model.privacyAlignment = NSTextAlignmentLeft;
                    model.privacyColors = @[XLColor_mainTextColor,UIColorHex(b58e7f)];
                    model.privacyPreText = @"本机号码认证服务由";
                    model.privacySufText = @"提供";
                    model.privacyOperatorSufText = @"》";
                    model.privacyOperatorPreText = @"《";
                    model.checkBoxIsChecked = NO;
                    //2.调⽤唤起授权⻚面
                    [UMCommonHandler getLoginTokenWithTimeout:3.0 controller:controller model:model complete:^(NSDictionary*_Nonnull resultDic){
                        NSString *code = [resultDic objectForKey:@"resultCode"];
                        NSLog(@"友盟一键登录code =======%@",code);
                        NSLog(@"友盟一键登录resultDic =======%@",resultDic);
                        if([PNSCodeLoginControllerPresentSuccess isEqualToString:code]){
                            //弹起授权⻚成功
                            NSLog(@"唤起授权页成功");
                        }else if([PNSCodeLoginControllerClickCancel isEqualToString:code]){
                            //点击了授权页的返回
                            NSLog(@"取消一键登录");
                        }else if([PNSCodeLoginControllerClickChangeBtn isEqualToString:code]){
                            
                            NSLog(@"点击切换其他登录⽅式按钮");
                            complete(@"Other");
                            UIViewController *currentVC = [HHAppManage getCurrentVC];
                            [currentVC dismissViewControllerAnimated:YES completion:nil];
                            
                            dispatch_async(dispatch_get_main_queue(), ^{
                                HHBindMobilephoneViewController *bindMobileVC = [[HHBindMobilephoneViewController alloc] init];
                                bindMobileVC.bind_token = bind_token;
                                bindMobileVC.hidesBottomBarWhenPushed = YES;
                                HHNavigationBarViewController *nav = [[HHNavigationBarViewController alloc] initWithRootViewController:bindMobileVC];
                                nav.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
                                nav.modalPresentationStyle = UIModalPresentationFullScreen;
                                [[HHAppManage getCurrentVC] presentViewController:nav animated:YES completion:nil];
                            });
                        }else if([PNSCodeLoginControllerClickLoginBtn isEqualToString:code]){
                            if([[resultDic objectForKey:@"isChecked"] boolValue]== YES){
                                //点击了登录按钮
                                NSLog(@"要去登录了啊");
                            }else{
                                //点击了登录按钮，check box未选中，SDK内部不会去获取登陆Token
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    
                                    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
                                    [keyWindow makeToast:@"请先同意一键绑定认证服务条款" duration:1.5 position:CSToastPositionCenter];
                                    
                                });
                            }
                        }else if([PNSCodeLoginControllerClickCheckBoxBtn isEqualToString:code]){
                            //点击check box
                            NSLog(@"点击了同意协议");
                            if([[resultDic objectForKey:@"isChecked"] boolValue]== YES){
                                [HGAppLoginTool sharedInstance].isAgree = YES;
                            }else{
                                [HGAppLoginTool sharedInstance].isAgree = NO;
                            }
                            
                        }else if([PNSCodeLoginControllerClickProtocol isEqualToString:code]){
                            //点击了协议富⽂本
                            NSLog(@"点击了协议富文本");
                        }else if([PNSCodeSuccess isEqualToString:code]){
                            NSString *token =[resultDic objectForKey:@"token"];
                            if([HGAppLoginTool sharedInstance].isAgree == YES){
                                [weakSelf bindPostLoginWithParm:token bind_token:bind_token];
                            }else{
                                UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
                                [keyWindow makeToast:@"请先同意一键绑定认证服务条款" duration:1.5 position:CSToastPositionCenter];
                            }
                        }else{
                            UIViewController *currentVC = [HHAppManage getCurrentVC];
                            [currentVC dismissViewControllerAnimated:YES completion:nil];
                            
                            dispatch_async(dispatch_get_main_queue(), ^{
                                HHBindMobilephoneViewController *bindMobileVC = [[HHBindMobilephoneViewController alloc] init];
                                bindMobileVC.bind_token = bind_token;
                                bindMobileVC.hidesBottomBarWhenPushed = YES;
                                HHNavigationBarViewController *nav = [[HHNavigationBarViewController alloc] initWithRootViewController:bindMobileVC];
                                nav.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
                                nav.modalPresentationStyle = UIModalPresentationFullScreen;
                                [[HHAppManage getCurrentVC] presentViewController:nav animated:YES completion:nil];
                            });
                        }
                    }];
                });
            }];
        }else{
            complete(resultDic[@"msg"]);
        }
    }];
}

+ (void)bindPostLoginWithParm:(NSString *)convenient_token bind_token:(NSString *)bind_token {
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    
    NSString *url = [NSString stringWithFormat:@"%@/user/third/party/bind",BASE_URL];
    NSMutableDictionary *dic = @{}.mutableCopy;
    [dic setValue:@(1) forKey:@"auth_type"];
    [dic setValue:convenient_token forKey:@"convenient_token"];
    [dic setValue:@(2) forKey:@"mode"];
    [dic setValue:bind_token forKey:@"bind_token"];
    [PPHTTPRequest requestPostWithJSONForUrl:url parameters:dic success:^(id  _Nonnull response) {
        NSLog(@"登录======%@",response);
        NSString *code = [NSString stringWithFormat:@"%@", response[@"code"]];
        if ([code isEqualToString:@"0"]) {//请求成功
            
            NSDictionary *data = response[@"data"];
            NSDictionary *token = data[@"token"];
            
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
            UIViewController *currentVC = [HHAppManage getCurrentVC];
            [currentVC dismissViewControllerAnimated:YES completion:nil];
            
            [TUILogin login:1400740345 userID:token[@"im_account"] userSig:token[@"im_sign"] succ:^{
                NSLog(@"-----> 登录成功");
            } fail:^(int code, NSString *msg) {
                NSLog(@"-----> 登录失败");
            }];
        }else {
            [keyWindow makeToast:response[@"msg"] duration:2 position:CSToastPositionCenter];
        }
    } failure:^(NSError * _Nonnull error) {
    }];
}

+ (void)postLoginWithParm:(NSString *)token {
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    //点击登录按钮获取登录Token成功回调
    NSLog(@"点击登录按钮获取登录Token成功回调:%@",token);
    //拿Token去服务器器换⼿机号
    [HGAppLoginTool sharedInstance].type = HGLoginTypePhoneQuickLogin;
    
    NSString *url = [NSString stringWithFormat:@"%@/user/login/convenient",BASE_URL];
    NSMutableDictionary *dic = @{}.mutableCopy;
    [dic setValue:token forKey:@"token"];
    [dic setValue:@(2) forKey:@"mode"];
    [PPHTTPRequest requestPostWithJSONForUrl:url parameters:dic success:^(id  _Nonnull response) {
        NSLog(@"登录======%@",response);
        NSString *code = [NSString stringWithFormat:@"%@", response[@"code"]];
        if ([code isEqualToString:@"0"]) {//请求成功
            
            NSDictionary *data = response[@"data"];
            NSDictionary *tokenDic = data[@"token"];
            NSString *phone = tokenDic[@"phone"];
            NSString *user_head_img = tokenDic[@"user_head_img"];
            NSString *user_name = tokenDic[@"user_name"];
            NSString *token = tokenDic[@"token"];
            
            [UserInfoManager sharedInstance].refresh_token = tokenDic[@"refresh_token"];;
            [UserInfoManager sharedInstance].jwtToken = token;
            [UserInfoManager sharedInstance].mobile = phone;
            [UserInfoManager sharedInstance].userNickName = user_name;
            [UserInfoManager sharedInstance].im_account = tokenDic[@"im_account"];
            [UserInfoManager sharedInstance].im_sign = tokenDic[@"im_sign"];
            [UserInfoManager sharedInstance].headImageStr = user_head_img;
            [UserInfoManager synchronize];
            
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isLogin"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            UIViewController *currentVC = [HHAppManage getCurrentVC];
            [currentVC dismissViewControllerAnimated:YES completion:nil];
            
            [TUILogin login:1400740345 userID:tokenDic[@"im_account"] userSig:tokenDic[@"im_sign"] succ:^{
                NSLog(@"-----> 登录成功");
            } fail:^(int code, NSString *msg) {
                NSLog(@"-----> 登录失败");
            }];
            
        }else {
            [keyWindow makeToast:response[@"msg"] duration:2 position:CSToastPositionCenter];
        }
    } failure:^(NSError * _Nonnull error) {
        
    }];
}


@end
