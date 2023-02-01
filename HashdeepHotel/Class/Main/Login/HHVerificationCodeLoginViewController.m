//
//  HHVerificationCodeLoginViewController.m
//  HashdeepHotel
//
//  Created by Cindy on 2022/11/29.
//

#import "HHVerificationCodeLoginViewController.h"
#import "HHLoginToastView.h"
#import "HHLoginView.h"
#import "HGAppLoginTool.h"
#import <AuthenticationServices/AuthenticationServices.h>///苹果登录按钮
#import "HHLoginServiceViewController.h"
#import "HHLoginPrivacyViewController.h"
#import "WXApi.h"
#import "HGAppInitManager.h"

@interface HHVerificationCodeLoginViewController ()<UITextFieldDelegate,UITextFieldTextMaxCountDelegate>
@property (nonatomic,strong) HHLoginView *loginView;
@property (nonatomic,strong) UIButton *appleButton;
@property (nonatomic,copy) NSString *type;
@property (nonatomic, strong) HHLoginToastView *toastView;
@end

@implementation HHVerificationCodeLoginViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)dealloc {
    if (@available(iOS 13.0, *)) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:ASAuthorizationAppleIDProviderCredentialRevokedNotification object:nil];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = kWhiteColor;
    //创建子视图
    [self _createdViews];
    
    [self _createdThirdUI];
    
    // 手机系统版本 不支持 时 隐藏苹果登录按钮
    if (@available(iOS 13.0, *)) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleSignInWithAppleStateChanged:) name:ASAuthorizationAppleIDProviderCredentialRevokedNotification object:nil];
    } else {
        self.appleButton.hidden = YES;
    }
    
    //监听微信登录成功的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wxChatLoginNotification:) name:@"WXChatLoginSuccess" object:nil];
    
}
#pragma mark --------- 微信通知方法 ------
- (void)wxChatLoginNotification:(NSNotification *)aNotification{
    [[HGAppLoginTool sharedInstance] wxChatLoginNotification:aNotification];
}

#pragma mark- apple授权状态 更改通知
- (void)handleSignInWithAppleStateChanged:(NSNotification *)notification{
    NSLog(@"%@", notification.userInfo);
}

#pragma mark ---------------------创建Views---------------------
- (void)_createdViews {
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 25, 25);
    [backButton addTarget:self action:@selector(backButtonAction) forControlEvents:UIControlEventTouchUpInside] ;
    [backButton setImage: [UIImage imageNamed:@"icon_my_setup_back"] forState:UIControlStateNormal];
    UIBarButtonItem* barItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = barItem;
    
    WeakSelf(weakSelf)
    self.loginView = [[HHLoginView alloc] init];
    self.loginView.backgroundColor = kWhiteColor;
    [self.view addSubview:self.loginView];
    [self.loginView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.bottom.offset(0);
        make.top.offset(UINavigateHeight);
    }];
    
    self.loginView.clickServiceAgreement = ^(NSString * _Nonnull type) {
        weakSelf.type = type;
        HHLoginServiceViewController *vc = [[HHLoginServiceViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    
    self.loginView.clickPrivacyAgreement = ^(NSString * _Nonnull type) {
        weakSelf.type = type;
        HHLoginPrivacyViewController *vc = [[HHLoginPrivacyViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    
    self.loginView.clickLoginButton = ^{
        if (weakSelf.loginSuccessAction) {
            weakSelf.loginSuccessAction();
        }
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
    };
    
}


- (void)backButtonAction {
    if (self.loginCancelAction) {
        self.loginCancelAction();
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

/**
 创建第三方登录UI
 */
- (void)_createdThirdUI{
    UIButton *wechatButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [wechatButton setImage:HHGetImage(@"icon_login_wechat") forState:UIControlStateNormal];
    [wechatButton addTarget:self action:@selector(wechatButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:wechatButton];
    [wechatButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(60);
        make.left.offset((kScreenWidth-60*3-60)/3);
        if (UINavigateTop == 44) {
            make.bottom.offset(-120);
        }else {
            make.bottom.offset(-70);
        }
    }];
    
    UIButton *alipayButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [alipayButton setImage:HHGetImage(@"icon_login_alipay") forState:UIControlStateNormal];
    [alipayButton addTarget:self action:@selector(alipayButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:alipayButton];
    [alipayButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(60);
        make.left.equalTo(wechatButton.mas_right).offset(30);
        make.top.equalTo(wechatButton).offset(0);
    }];
    
    self.appleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.appleButton setImage:HHGetImage(@"icon_login_apple") forState:UIControlStateNormal];
    [self.appleButton addTarget:self action:@selector(appleButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.appleButton];
    [self.appleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(60);
        make.left.equalTo(alipayButton.mas_right).offset(30);
        make.top.equalTo(wechatButton).offset(0);
    }];
    
    
    if (@available(iOS 13.0, *)) {//显示苹果登录
        self.appleButton.hidden = NO;


        if([[HGAppLoginTool sharedInstance] isWXAppInstalled] == YES){//有微信
            wechatButton.hidden = NO;

            NSURL * url = [NSURL URLWithString:@"alipay://"];//注意设置白名单
            if ([[UIApplication sharedApplication]canOpenURL:url]) {//有支付宝
                alipayButton.hidden = NO;

                [wechatButton mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.left.offset((kScreenWidth-(60*3+60))/2);
                }];

                [alipayButton mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(wechatButton.mas_right).offset(30);
                }];

                [self.appleButton mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(alipayButton.mas_right).offset(30);
                }];

            }else {//没有支付宝
                alipayButton.hidden = YES;

                [wechatButton mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.left.offset((kScreenWidth-(60*2+30))/2);
                }];

                [alipayButton mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(wechatButton.mas_right).offset(30);
                    make.width.height.offset(0);
                }];

                [self.appleButton mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(alipayButton.mas_right).offset(0);
                }];

            }

        }else{//没有微信
            wechatButton.hidden = YES;
            NSURL * url = [NSURL URLWithString:@"alipay://"];//注意设置白名单
            if ([[UIApplication sharedApplication]canOpenURL:url]) {//有支付宝
                alipayButton.hidden = NO;

                [wechatButton mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.left.offset((kScreenWidth-(60*2+30))/2);
                    make.width.height.offset(0);
                }];

                [alipayButton mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(wechatButton.mas_right).offset(0);
                }];

                [self.appleButton mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(alipayButton.mas_right).offset(30);
                }];

            }else {//没有支付宝
                alipayButton.hidden = YES;

                [wechatButton mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.left.offset((kScreenWidth-60)/2);
                    make.width.height.offset(0);
                }];

                [alipayButton mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(wechatButton.mas_right).offset(0);
                    make.width.height.offset(0);
                }];
                [self.appleButton mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(alipayButton.mas_right).offset(0);
                }];
            }
        }

    }else {
        self.appleButton.hidden = YES;
        [self.appleButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.offset(0);
        }];
        if([[HGAppLoginTool sharedInstance] isWXAppInstalled] == YES){//有微信
            wechatButton.hidden = NO;
            
            NSURL * url = [NSURL URLWithString:@"alipay://"];//注意设置白名单
            if ([[UIApplication sharedApplication]canOpenURL:url]) {//有支付宝
                alipayButton.hidden = NO;
                [wechatButton mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.left.offset((kScreenWidth-(60*2+30))/2);
                    make.width.height.offset(60);
                }];
                
                [alipayButton mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(wechatButton.mas_right).offset(30);
                    make.width.height.offset(60);
                }];
            }else {//没有支付宝
                alipayButton.hidden = YES;
                [alipayButton mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.width.height.offset(0);
                }];
                [wechatButton mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.left.offset((kScreenWidth-60)/2);
                    make.width.height.offset(60);
                }];
            }
            
        }else{//没有微信
            wechatButton.hidden = YES;
            NSURL * url = [NSURL URLWithString:@"alipay://"];//注意设置白名单
            if ([[UIApplication sharedApplication]canOpenURL:url]) {//有支付宝
                alipayButton.hidden = NO;
                [wechatButton mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.left.offset((kScreenWidth-60)/2);
                    make.width.height.offset(0);
                }];
                
                [alipayButton mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(wechatButton.mas_right).offset(0);
                    make.width.height.offset(60);
                }];
                
            }else {//没有支付宝
                alipayButton.hidden = YES;
                [wechatButton mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.width.height.offset(0);
                }];
                
                [alipayButton mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.width.height.offset(0);
                }];
                
            }
        }
    }
}

#pragma mark --------------登录按钮点击----------
- (void)alipayButtonAction {
    [self.view endEditing:YES];
    if(!self.loginView.isAgree){
        [self _createdToastViewForAlipayButton];
    }else {
        [HGAppLoginTool sharedInstance].type = HGLoginTypeAlipayLogin;
        [[HGAppLoginTool sharedInstance] alipayLogin];
    }
}

- (void)appleButtonAction{
    [self.view endEditing:YES];
    
    if(!self.loginView.isAgree){
        [self _createdToastViewForAppleButton];
    }else {
        [HGAppLoginTool sharedInstance].type = HGLoginTypeAppleLogin;
        [[HGAppLoginTool sharedInstance] appleLogin];
    }
}

- (void)wechatButtonAction {
    [self.view endEditing:YES];
 
    if(!self.loginView.isAgree){
        [self _createdToastViewForWechatButton];
    }else {
        [HGAppLoginTool sharedInstance].type = HGLoginTypeWeChatLogin;
        [[HGAppLoginTool sharedInstance] wechatLogin];
    }
}

- (void)_createdToastViewForAppleButton{
    WeakSelf(weakSelf)
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    self.toastView = [[HHLoginToastView alloc] init];
    self.toastView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    self.toastView.clickCloseButton = ^{
        [weakSelf.toastView removeFromSuperview];
    };
    self.toastView.clickAgainAction = ^{
        [weakSelf.toastView removeFromSuperview];
        weakSelf.loginView.isAgree = YES;
        weakSelf.loginView.selectedButton.selected = YES;
        [HGAppLoginTool sharedInstance].type = HGLoginTypeAppleLogin;
        [[HGAppLoginTool sharedInstance] appleLogin];
    };
    self.toastView.clickPrivacyAgreementAction = ^{
        [weakSelf.toastView removeFromSuperview];
        HHLoginServiceViewController *vc = [[HHLoginServiceViewController alloc] init];
        vc.backAction = ^{
            [weakSelf _createdToastViewForAppleButton];
        };
        vc.hidesBottomBarWhenPushed = YES;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    self.toastView.clickServiceAgreementAction = ^{
        [weakSelf.toastView removeFromSuperview];
        HHLoginPrivacyViewController *vc = [[HHLoginPrivacyViewController alloc] init];
        vc.backAction = ^{
            [weakSelf _createdToastViewForAppleButton];
        };
        vc.hidesBottomBarWhenPushed = YES;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    [keyWindow addSubview:self.toastView];
    [self.toastView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.offset(0);
    }];
}

- (void)_createdToastViewForWechatButton{
    WeakSelf(weakSelf)
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    self.toastView = [[HHLoginToastView alloc] init];
    self.toastView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    self.toastView.clickCloseButton = ^{
        [weakSelf.toastView removeFromSuperview];
    };
    self.toastView.clickAgainAction = ^{
        [weakSelf.toastView removeFromSuperview];
        weakSelf.loginView.isAgree = YES;
        weakSelf.loginView.selectedButton.selected = YES;
        [HGAppLoginTool sharedInstance].type = HGLoginTypeWeChatLogin;
        [[HGAppLoginTool sharedInstance] wechatLogin];
    };
    self.toastView.clickPrivacyAgreementAction = ^{
        [weakSelf.toastView removeFromSuperview];
        HHLoginServiceViewController *vc = [[HHLoginServiceViewController alloc] init];
        vc.backAction = ^{
            [weakSelf _createdToastViewForWechatButton];
        };
        vc.hidesBottomBarWhenPushed = YES;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    self.toastView.clickServiceAgreementAction = ^{
        [weakSelf.toastView removeFromSuperview];
        HHLoginPrivacyViewController *vc = [[HHLoginPrivacyViewController alloc] init];
        vc.backAction = ^{
            [weakSelf _createdToastViewForWechatButton];
        };
        vc.hidesBottomBarWhenPushed = YES;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    [keyWindow addSubview:self.toastView];
    [self.toastView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.offset(0);
    }];
}

- (void)_createdToastViewForAlipayButton{
    WeakSelf(weakSelf)
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    self.toastView = [[HHLoginToastView alloc] init];
    self.toastView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    self.toastView.clickCloseButton = ^{
        [weakSelf.toastView removeFromSuperview];
    };
    self.toastView.clickAgainAction = ^{
        [weakSelf.toastView removeFromSuperview];
        weakSelf.loginView.isAgree = YES;
        weakSelf.loginView.selectedButton.selected = YES;
        [HGAppLoginTool sharedInstance].type = HGLoginTypeQQLogin;
        [[HGAppLoginTool sharedInstance] alipayLogin];
    };
    self.toastView.clickPrivacyAgreementAction = ^{
        [weakSelf.toastView removeFromSuperview];
        HHLoginServiceViewController *vc = [[HHLoginServiceViewController alloc] init];
        vc.backAction = ^{
            [weakSelf _createdToastViewForAlipayButton];
        };
        vc.hidesBottomBarWhenPushed = YES;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    self.toastView.clickServiceAgreementAction = ^{
        [weakSelf.toastView removeFromSuperview];
        HHLoginPrivacyViewController *vc = [[HHLoginPrivacyViewController alloc] init];
        vc.backAction = ^{
            [weakSelf _createdToastViewForAlipayButton];
        };
        vc.hidesBottomBarWhenPushed = YES;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    [keyWindow addSubview:self.toastView];
    [self.toastView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.offset(0);
    }];
}
@end
