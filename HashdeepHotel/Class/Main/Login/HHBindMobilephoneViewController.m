//
//  HHBindMobilephoneViewController.m
//  HashdeepHotel
//
//  Created by Cindy on 2022/11/29.
//

#import "HHBindMobilephoneViewController.h"
#import "TUILogin.h"
@interface HHBindMobilephoneViewController ()
@property (nonatomic,strong) UITextField *phoneTextField;
@property (nonatomic,strong) UITextField *verificationCodeTextField;//验证码
@property (nonatomic, strong) UIButton *verificationCodeButton;
@property (nonatomic, strong) NSTimer *smsTimer;///<短信下发的计时器
@property (nonatomic, assign) NSInteger countDownTime;///<倒计时时间
@property (nonatomic,assign) BOOL isClick;
@end

@implementation HHBindMobilephoneViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kWhiteColor;
    [self _createdViews];
}

- (void)_createdViews {
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton addTarget:self action:@selector(backButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [leftButton setImage:HHGetImage(@"icon_my_setup_back") forState:UIControlStateNormal];
    [self.view addSubview:leftButton];
    [leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.top.offset(UINavigateTop);
        make.width.offset(55);
        make.height.offset(44);
    }];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"绑定手机号";
    titleLabel.textColor = XLColor_mainTextColor;
    titleLabel.font = KFont(22);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.offset(UINavigateHeight+30);
        make.height.offset(30);
    }];
    
    UILabel *detailLabel = [[UILabel alloc] init];
    detailLabel.text = @"根据法律规定，同时为保护您的账户安全，请您绑定手机号码";
    detailLabel.textColor = XLColor_mainTextColor;
    detailLabel.font = XLFont_subTextFont;
    detailLabel.numberOfLines = 0;
    detailLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:detailLabel];
    [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(25);
        make.right.offset(-25);
        make.top.equalTo(titleLabel.mas_bottom).offset(20);
        make.height.offset(40);
    }];
    
    self.phoneTextField = [[UITextField alloc] init];
    self.phoneTextField.borderStyle = UITextBorderStyleNone;
    self.phoneTextField.font = XLFont_mainTextFont;
    self.phoneTextField.textColor = XLColor_mainTextColor;
    self.phoneTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入手机号码" attributes:@{
        NSForegroundColorAttributeName:XLColor_subSubTextColor
    }];
    self.phoneTextField.textMaxLength = 11;
    self.phoneTextField.textAlignment = NSTextAlignmentLeft;
    self.phoneTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.phoneTextField.delegate = self;
    self.phoneTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.phoneTextField.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:self.phoneTextField];
    [self.phoneTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(20);
        make.height.offset(25);
        make.right.offset(-20);
        make.top.equalTo(detailLabel.mas_bottom).offset(40);
    }];
    
    UIView *phonebottomLineView = [[UIView alloc ] init];
    phonebottomLineView.backgroundColor = RGBColor(243, 244, 247);
    [self.view addSubview: phonebottomLineView];
    [phonebottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(20);
        make.top.equalTo(self.phoneTextField.mas_bottom).offset(15);
        make.height.offset(1);
        make.right.offset(-20);
    }];
    
    self.verificationCodeTextField = [[UITextField alloc] init];
    self.verificationCodeTextField.borderStyle = UITextBorderStyleNone;
    self.verificationCodeTextField.font = XLFont_mainTextFont;
    self.verificationCodeTextField.textColor = XLColor_mainTextColor;
    self.verificationCodeTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入验证码" attributes:@{
        NSForegroundColorAttributeName:XLColor_subSubTextColor
    }];
    self.verificationCodeTextField.textMaxLength = 6;
    self.verificationCodeTextField.textAlignment = NSTextAlignmentLeft;
    self.verificationCodeTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.verificationCodeTextField.autocorrectionType=UITextAutocorrectionTypeNo;
    self.verificationCodeTextField.delegate = self;
    self.verificationCodeTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:self.verificationCodeTextField];
    [self.verificationCodeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(20);
        make.height.offset(25);
        make.right.offset(-150);
        make.top.equalTo(phonebottomLineView.mas_bottom).offset(15);
    }];
    
    self.verificationCodeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.verificationCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    [self.verificationCodeButton setTitleColor:XLColor_mainTextColor forState:UIControlStateNormal];
    self.verificationCodeButton.titleLabel.font = KBoldFont(14);
    [self.verificationCodeButton addTarget:self action:@selector(verificationCodeButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.verificationCodeButton];
    [self.verificationCodeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-20);
        make.height.offset(25);
        make.width.offset(100);
        make.top.equalTo(phonebottomLineView.mas_bottom).offset(15);
    }];
    
    UIView *lineView = [[UIView alloc ] init];
    lineView.backgroundColor = RGBColor(243, 244, 247);
    [self.view addSubview: lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.verificationCodeButton.mas_left).offset(-15);
        make.top.equalTo(phonebottomLineView.mas_bottom).offset(15);
        make.height.offset(25);
        make.width.offset(1);
    }];
    
    UIView *verificationCodebottomLineView = [[UIView alloc ] init];
    verificationCodebottomLineView.backgroundColor = RGBColor(243, 244, 247);
    [self.view addSubview: verificationCodebottomLineView];
    [verificationCodebottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(20);
        make.top.equalTo(self.verificationCodeTextField.mas_bottom).offset(15);
        make.height.offset(1);
        make.right.offset(-20);
    }];
    
    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    doneButton.layer.cornerRadius = 22;
    doneButton.layer.masksToBounds = YES;
    doneButton.titleLabel.font = KBoldFont(16);
    doneButton.backgroundColor = UIColorHex(b58e7f);
    [doneButton setTitle:@"完成" forState:UIControlStateNormal];
    [doneButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
    [doneButton addTarget:self action:@selector(doneButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:doneButton];
    [doneButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-20);
        make.left.offset(20);
        make.height.offset(44);
        make.top.equalTo(verificationCodebottomLineView.mas_bottom).offset(25);
    }];
    
}

- (void)backButtonAction {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark ----------------完成-----------
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
    
    if(![self isPureInt:self.phoneTextField.text]){
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
    
    if(![self isPureInt:self.verificationCodeTextField.text]){
        [self.view makeToast:@"请输入正确的验证码" duration:1.5 position:CSToastPositionCenter];
         dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
             button.enabled = YES;
        });
        return;
    }
    
    if (!self.isClick) {
        [self.view makeToast:@"请输入正确的验证码" duration:1.5 position:CSToastPositionCenter];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            button.enabled = YES;
        });
        return;
    }
    
    NSString *url = [NSString stringWithFormat:@"%@/user/third/party/bind",BASE_URL];
    NSMutableDictionary *dic = @{}.mutableCopy;
    [dic setValue:@(2) forKey:@"auth_type"];
    [dic setValue:self.phoneTextField.text forKey:@"phone"];
    [dic setValue:self.verificationCodeTextField.text forKey:@"verify_code"];
    [dic setValue:self.bind_token forKey:@"bind_token"];

    [PPHTTPRequest requestPostWithJSONForUrl:url parameters:dic success:^(id  _Nonnull response) {
        NSLog(@"登录======%@",response);
        NSString *code = [NSString stringWithFormat:@"%@", response[@"code"]];
        if ([code isEqualToString:@"0"]) {//请求成功
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                button.enabled = YES;
            });
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
            [self.view makeToast:response[@"msg"] duration:2 position:CSToastPositionCenter];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                button.enabled = YES;
            });
        }
    } failure:^(NSError * _Nonnull error) {
     
    }];
}

#pragma mark --------获取验证码---------
- (void)verificationCodeButtonAction {
    [self.phoneTextField resignFirstResponder];
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
    
    if(![self isPureInt:self.phoneTextField.text]){
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
    [dic setValue:@(6) forKey:@"biz"];
    
    [PPHTTPRequest requestPostWithJSONForUrl:url parameters:dic success:^(id  _Nonnull response) {
        
        NSString *code = [NSString stringWithFormat:@"%@", response[@"code"]];
        if ([code isEqualToString:@"0"]) {//请求成功
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.verificationCodeButton.enabled = YES;
           });
            self.isClick = YES;
            self.countDownTime = 60;
            [self.verificationCodeTextField becomeFirstResponder];
            [self.verificationCodeButton setTitle:[NSString stringWithFormat:@"%ld秒后重新发送",self.countDownTime] forState:UIControlStateNormal];
            [self.verificationCodeButton mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.offset(130);
            }];
            
            [self.verificationCodeTextField mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.offset(-170);
            }];
            self.smsTimer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(onTimer:) userInfo:nil repeats:YES];
            [[NSRunLoop mainRunLoop] addTimer:self.smsTimer forMode:NSRunLoopCommonModes];
            
        } else {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.verificationCodeButton.enabled = YES;
           });
            
            [self.verificationCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
            [self.verificationCodeButton mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.offset(100);
            }];
            [self.verificationCodeTextField mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.offset(-150);
            }];
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
        [self.verificationCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        [self.verificationCodeButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.offset(100);
        }];
        [self.verificationCodeTextField mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.offset(-150);
        }];
    }else {
        [self.verificationCodeButton setTitle:[NSString stringWithFormat:@"%ld秒后重新发送",self.countDownTime] forState:UIControlStateNormal];
        [self.verificationCodeButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.offset(130);
        }];
        [self.verificationCodeTextField mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.offset(-170);
        }];
        
    }
}

//判断输入的字符串是否全为数字
- (BOOL)isPureInt:(NSString *)string {
    NSScanner *scan = [NSScanner scannerWithString:string];
    int val;
    return [scan scanInt:&val] &&[scan isAtEnd];
}

@end
