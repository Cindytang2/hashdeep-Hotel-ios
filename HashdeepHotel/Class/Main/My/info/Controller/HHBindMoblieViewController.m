//
//  HHBindMoblieViewController.m
//  HashdeepHotel
//
//  Created by Cindy on 2022/7/13.
//

#import "HHBindMoblieViewController.h"
#import "HHPersonalInformationViewController.h"
#import "HHVerificationCodeLoginViewController.h"
#import "HHNavigationBarViewController.h"
#import "HHMainTabBarViewController.h"

@interface HHBindMoblieViewController ()
@property (nonatomic,strong) UITextField *phoneTextField;
@property (nonatomic,strong) UITextField *verificationCodeTextField;//验证码
@property (nonatomic, strong) UIButton *verificationCodeButton;
@property (nonatomic, strong) NSTimer *smsTimer;///<短信下发的计时器
@property (nonatomic, assign) NSInteger countDownTime;///<倒计时时间

@end

@implementation HHBindMoblieViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = RGBColor(243, 244, 247);
    
    //自定义导航栏
    [self _createdNavigationBar];
    
    //创建Views
    [self _createdViews];
    
}

#pragma mark -----------------------自定义导航栏-----------------------
- (void)_createdNavigationBar {
    [self createdNavigationBackButton];
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"绑定新手机号";
    titleLabel.textColor = XLColor_mainTextColor;
    titleLabel.font = KBoldFont(18);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.offset(UINavigateTop+10);
        make.height.offset(20);
    }];
}

#pragma mark ---------------------创建Views---------------------
- (void)_createdViews {
    
    UIView *whiteView = [[UIView alloc] init];
    whiteView.backgroundColor = kWhiteColor;
    [self.view addSubview:whiteView];
    [whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.offset(UINavigateHeight+10);
        make.height.offset(101);
    }];
    
    
    UILabel *phoneLabel = [[UILabel alloc] init];
    phoneLabel.text = @"新手机号";
    phoneLabel.textColor = XLColor_mainTextColor;
    phoneLabel.font = XLFont_subTextFont;
    [whiteView addSubview:phoneLabel];
    [phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.top.offset(0);
        make.height.offset(50);
        make.width.offset(80);
    }];
    
    self.phoneTextField = [[UITextField alloc] init];
    self.phoneTextField.borderStyle = UITextBorderStyleNone;
    self.phoneTextField.font = XLFont_mainTextFont;
    self.phoneTextField.textColor = XLColor_mainTextColor;
    self.phoneTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入新手机号码" attributes:@{
        NSForegroundColorAttributeName:XLColor_subSubTextColor
    }];
    self.phoneTextField.tag = 100;
    self.phoneTextField.textMaxLength = 11;
    self.phoneTextField.textAlignment = NSTextAlignmentLeft;
    self.phoneTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.phoneTextField.delegate = self;
    self.phoneTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.phoneTextField.keyboardType = UIKeyboardTypeNumberPad;
    [self.phoneTextField becomeFirstResponder];
    [whiteView addSubview:self.phoneTextField];
    [self.phoneTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(phoneLabel.mas_right).offset(0);
        make.height.offset(50);
        make.right.offset(-15);
        make.top.offset(0);
    }];
    
    UIView *lineView = [[UIView alloc ] init];
    lineView.backgroundColor = RGBColor(243, 244, 247);
    [whiteView addSubview: lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.offset(51);
        make.height.offset(1);
    }];
    
    UILabel *verificationCodeLabel = [[UILabel alloc] init];
    verificationCodeLabel.text = @"验证码";
    verificationCodeLabel.textColor = XLColor_mainTextColor;
    verificationCodeLabel.font = XLFont_subTextFont;
    [whiteView addSubview:verificationCodeLabel];
    [verificationCodeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.top.equalTo(lineView.mas_bottom).offset(0);
        make.height.offset(50);
        make.width.offset(80);
    }];
    
    self.verificationCodeTextField = [[UITextField alloc] init];
    self.verificationCodeTextField.borderStyle = UITextBorderStyleNone;
    self.verificationCodeTextField.font = XLFont_subTextFont;
    self.verificationCodeTextField.textColor = XLColor_mainTextColor;
    self.verificationCodeTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入验证码" attributes:@{
        NSForegroundColorAttributeName:XLColor_subSubTextColor
    }];
    self.verificationCodeTextField.tag = 200;
    self.verificationCodeTextField.textAlignment = NSTextAlignmentLeft;
    self.verificationCodeTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.verificationCodeTextField.autocorrectionType=UITextAutocorrectionTypeNo;
    self.verificationCodeTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:self.verificationCodeTextField];
    [self.verificationCodeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(verificationCodeLabel.mas_right).offset(0);
        make.top.equalTo(lineView.mas_bottom).offset(0);
        make.height.offset(50);
        make.right.offset(-150);
    }];
    
    self.verificationCodeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.verificationCodeButton setTitle:@"发送验证码" forState:UIControlStateNormal];
    [self.verificationCodeButton setTitleColor:XLColor_mainTextColor forState:UIControlStateNormal];
    self.verificationCodeButton.backgroundColor = RGBColor(243, 244, 247);
    self.verificationCodeButton.layer.cornerRadius = 5;
    self.verificationCodeButton.layer.masksToBounds = YES;
    self.verificationCodeButton.titleLabel.font = XLFont_subTextFont;
    [self.verificationCodeButton addTarget:self action:@selector(verificationCodeButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.verificationCodeButton];
    [self.verificationCodeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-15);
        make.height.offset(30);
        make.width.offset(95);
        make.top.equalTo(lineView.mas_bottom).offset(10);
    }];
    
    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [doneButton setTitle:@"完成" forState:UIControlStateNormal];
    [doneButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
    doneButton.titleLabel.font = XLFont_mainTextFont;
    doneButton.layer.cornerRadius = 5;
    doneButton.layer.masksToBounds = YES;
    doneButton.backgroundColor = UIColorHex(b58e7f);
    [doneButton addTarget:self action:@selector(doneButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:doneButton];
    [doneButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.offset(-15);
        make.top.equalTo(whiteView.mas_bottom).offset(20);
        make.height.offset(45);
    }];
    
}

- (void)doneButtonAction:(UIButton *)button {
    [self.view endEditing:YES];
    button.enabled = NO;
    if (self.phoneTextField.text.length == 0) {
        [self.view makeToast:@"请输入手机号码" duration:1.5 position:CSToastPositionCenter];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            button.enabled = YES;
        });
        return;
    }
    
    if (self.phoneTextField.text.length != 11) {
        [self.view makeToast:@"请输入正确的手机号码" duration:1.5 position:CSToastPositionCenter];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            button.enabled = YES;
        });
        return;
    }
    
   
    if (self.verificationCodeTextField.text.length == 0) {
        [self.view makeToast:@"请输入验证码" duration:1.5 position:CSToastPositionCenter];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            button.enabled = YES;
        });
        return;
    }
    
    if (self.verificationCodeTextField.text.length != 6) {
        [self.view makeToast:@"请输入正确的验证码" duration:1.5 position:CSToastPositionCenter];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            button.enabled = YES;
        });
        return;
    }
  
    
    NSString *url = [NSString stringWithFormat:@"%@/user/modify/phone",BASE_URL];
    NSMutableDictionary *dic = @{}.mutableCopy;
    [dic setValue:self.phoneTextField.text forKey:@"user_phone"];
    [dic setValue:self.verificationCodeTextField.text forKey:@"valid_code"];
    [PPHTTPRequest requestPostWithJSONForUrl:url parameters:dic success:^(id  _Nonnull response) {
        NSLog(@"修改手机号码====%@",response);
        NSString *code = [NSString stringWithFormat:@"%@", response[@"code"]];
        if ([code isEqualToString:@"0"]) {//请求成功
            
            //更换手机号码成功之后，弹框提示用户，延迟3秒后弹出登录页面，登录成功之后，回到我的模块首页
            //更改UserInfoManager的手机号码，发送通知修改用户信息页的手机号
            //按钮设置为可点击
            [UserInfoManager sharedInstance].mobile = self.phoneTextField.text;
            [UserInfoManager synchronize];
            
            NSDictionary *dii = @{
                @"moblie":self.phoneTextField.text
            };
            //创建通知
            NSNotification *notification =[NSNotification notificationWithName:@"editMoblieSuccessNotification" object:dii];
            
            //通过通知中心发送通知
            [[NSNotificationCenter defaultCenter] postNotification:notification];
            
            [self.view makeToast:@"手机号码更换成功，请重新登录" duration:1 position:CSToastPositionCenter];
            
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isLogin"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            
            [self performSelector:@selector(perform) withObject:nil afterDelay:1];
            
            button.enabled = YES;
            
        } else {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                button.enabled = YES;
            });
            [self.view makeToast:response[@"msg"] duration:2 position:CSToastPositionCenter];
        }
    } failure:^(NSError * _Nonnull error) {
        
    }];
}

- (void)perform {
    
    NSNotification *notification =[NSNotification notificationWithName:@"againLogin" object:nil userInfo:nil];
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)loginAction {
    
    WeakSelf(weakSelf)
    [UMCommonHandler checkEnvAvailableWithAuthType:UMPNSAuthTypeLoginToken complete:^(NSDictionary*_Nullable resultDic){
        BOOL isSupport =[PNSCodeSuccess isEqualToString:[resultDic objectForKey:@"resultCode"]];
        if(isSupport) {
            [HGAppInitManager umQuickPhoneLoginVC:weakSelf complete:^(NSString * quickLoginStutas) {
                
            }];
            
        }else {
            HHVerificationCodeLoginViewController *loginVC = [[HHVerificationCodeLoginViewController alloc] init];
            loginVC.loginSuccessAction = ^{
                [weakSelf.navigationController popToRootViewControllerAnimated:YES];
            };
            loginVC.hidesBottomBarWhenPushed = YES;
            UINavigationController *loginNav = [[UINavigationController alloc] initWithRootViewController:loginVC];
            loginNav.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
            loginNav.modalPresentationStyle = UIModalPresentationFullScreen;
            [weakSelf presentViewController:loginNav animated:YES completion:nil];
        }
    }];
}

#pragma mark --------获取验证码---------
- (void)verificationCodeButtonAction {
    self.verificationCodeButton.enabled = NO;
    if (self.phoneTextField.text.length == 0) {
        [self.view makeToast:@"请输入手机号码" duration:1.5 position:CSToastPositionCenter];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.verificationCodeButton.enabled = YES;
        });
        return;
    }
    
    if (self.phoneTextField.text.length != 11) {
        [self.view makeToast:@"请输入正确的手机号码" duration:1.5 position:CSToastPositionCenter];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.verificationCodeButton.enabled = YES;
        });
        return;
    }
    
    NSString *url = [NSString stringWithFormat:@"%@/user/validcode",BASE_URL];
    NSMutableDictionary *dic = @{}.mutableCopy;
    [dic setValue:self.phoneTextField.text forKey:@"user_phone"];
    [dic setValue:@(1) forKey:@"type"];
    [dic setValue:@(4) forKey:@"biz"];
    [PPHTTPRequest requestPostWithJSONForUrl:url parameters:dic success:^(id  _Nonnull response) {
        NSString *code = [NSString stringWithFormat:@"%@", response[@"code"]];
        if ([code isEqualToString:@"0"]) {//请求成功
            self.verificationCodeButton.enabled = YES;
            [self.view makeToast:@"验证码发送成功" duration:2 position:CSToastPositionCenter];
            self.countDownTime = 60;
            [self.verificationCodeTextField becomeFirstResponder];
            [self.verificationCodeButton setTitle:[NSString stringWithFormat:@"%ld秒",self.countDownTime] forState:UIControlStateNormal];
            self.smsTimer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(onTimer:) userInfo:nil repeats:YES];
            [[NSRunLoop mainRunLoop] addTimer:self.smsTimer forMode:NSRunLoopCommonModes];
            
        } else {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.verificationCodeButton.enabled = YES;
            });
            [self.verificationCodeButton setTitle:@"发送验证码" forState:UIControlStateNormal];
            [self.view makeToast:response[@"msg"] duration:2 position:CSToastPositionCenter];
        }
    } failure:^(NSError * _Nonnull error) {
        
    }];
}

- (void)onTimer:(NSTimer *)timer{
    
    self.countDownTime --;
    //如果时间到了 0 秒, 把定时器取消掉
    if (self.countDownTime == 0){
        //释放定时器
        [timer invalidate];
        
        //把定时器设置成空.不然不起作用.
        timer = nil;
        
        //把修改的验证码按钮调整为初始状态
        self.verificationCodeButton.enabled = YES;
        [self.verificationCodeButton setTitle:@"发送验证码" forState:UIControlStateNormal];
    }else {
        [self.verificationCodeButton setTitle:[NSString stringWithFormat:@"%ld秒",self.countDownTime] forState:UIControlStateNormal];
    }
}

@end
