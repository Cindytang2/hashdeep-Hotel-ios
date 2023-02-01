//
//  HHLoginView.m
//  HashdeepHotel
//
//  Created by Cindy on 2022/8/11.
//

#import "HHLoginView.h"
#import <YYText/YYLabel.h>
#import <YYText/NSAttributedString+YYText.h>
#import "TUILogin.h"
#import "HHLoginToastView.h"
@interface HHLoginView()<UITextFieldDelegate>
@property (nonatomic,strong) UITextField *phoneTextField;
@property (nonatomic,strong) UITextField *verificationCodeTextField;//验证码
@property (nonatomic, strong) UIButton *verificationCodeButton;
@property (nonatomic, strong) NSTimer *smsTimer;///<短信下发的计时器
@property (nonatomic, assign) NSInteger countDownTime;///<倒计时时间

@property (nonatomic,assign) BOOL isClick;
@property (nonatomic, strong) UIButton *loginButton;
@property (nonatomic, strong) HHLoginToastView *toastView;

@end

@implementation HHLoginView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self _addSubViews];
    }
    return self;
}

- (void)_addSubViews{
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"手机动态密码登录";
    titleLabel.textColor = XLColor_mainTextColor;
    titleLabel.font = KBoldFont(20);
    [self addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(20);
        make.top.offset(50);
        make.height.offset(25);
    }];
    
    UILabel *subTitleLabel = [[UILabel alloc] init];
    subTitleLabel.text = @"未注册的手机号验证后将自动创建账号";
    subTitleLabel.textColor = XLColor_mainTextColor;
    subTitleLabel.font = XLFont_subTextFont;
    [self addSubview:subTitleLabel];
    [subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(20);
        make.top.equalTo(titleLabel.mas_bottom).offset(5);
        make.height.offset(25);
    }];
    
    UILabel *numberLabel = [[UILabel alloc] init];
    numberLabel.text = @"+86";
    numberLabel.textColor = XLColor_mainTextColor;
    numberLabel.font = KBoldFont(16);
    [self addSubview:numberLabel];
    [numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(20);
        make.top.equalTo(subTitleLabel.mas_bottom).offset(40);
        make.height.offset(25);
        make.width.offset(50);
    }];
    
    self.phoneTextField = [[UITextField alloc] init];
    self.phoneTextField.borderStyle = UITextBorderStyleNone;
    self.phoneTextField.font = XLFont_mainTextFont;
    self.phoneTextField.textColor = XLColor_mainTextColor;
    self.phoneTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入手机号码" attributes:@{
        NSForegroundColorAttributeName:XLColor_subSubTextColor
    }];
    self.phoneTextField.tag = 100;
    self.phoneTextField.textMaxLength = 11;
    self.phoneTextField.textAlignment = NSTextAlignmentLeft;
    self.phoneTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.phoneTextField.delegate = self;
    self.phoneTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.phoneTextField.keyboardType = UIKeyboardTypeNumberPad;
    [self addSubview:self.phoneTextField];
    [self.phoneTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(numberLabel.mas_right).offset(0);
        make.height.offset(25);
        make.right.offset(-20);
        make.top.equalTo(subTitleLabel.mas_bottom).offset(40);
    }];
    
    UIView *phonebottomLineView = [[UIView alloc ] init];
    phonebottomLineView.backgroundColor = RGBColor(243, 244, 247);
    [self addSubview: phonebottomLineView];
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
    self.verificationCodeTextField.tag = 200;
    self.verificationCodeTextField.textMaxLength = 6;
    self.verificationCodeTextField.textAlignment = NSTextAlignmentLeft;
    self.verificationCodeTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.verificationCodeTextField.autocorrectionType=UITextAutocorrectionTypeNo;
    self.verificationCodeTextField.delegate = self;
    self.verificationCodeTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self addSubview:self.verificationCodeTextField];
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
    [self addSubview:self.verificationCodeButton];
    [self.verificationCodeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-15);
        make.height.offset(25);
        make.width.offset(100);
        make.top.equalTo(phonebottomLineView.mas_bottom).offset(15);
    }];
    
    UIView *lineView = [[UIView alloc ] init];
    lineView.backgroundColor = RGBColor(243, 244, 247);
    [self addSubview: lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.verificationCodeButton.mas_left).offset(-15);
        make.top.equalTo(phonebottomLineView.mas_bottom).offset(15);
        make.height.offset(25);
        make.width.offset(1);
    }];
    
    UIView *verificationCodebottomLineView = [[UIView alloc ] init];
    verificationCodebottomLineView.backgroundColor = RGBColor(243, 244, 247);
    [self addSubview: verificationCodebottomLineView];
    [verificationCodebottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(20);
        make.top.equalTo(self.verificationCodeTextField.mas_bottom).offset(15);
        make.height.offset(1);
        make.right.offset(-20);
    }];
    
    self.selectedButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.selectedButton setImage:HHGetImage(@"icon_login_normal") forState:UIControlStateNormal];
    [self.selectedButton setImage:HHGetImage(@"icon_login_selected") forState:UIControlStateSelected];
    [self.selectedButton addTarget:self action:@selector(selectedButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.selectedButton];
    [self.selectedButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(20);
        make.top.equalTo(verificationCodebottomLineView.mas_bottom).offset(12.5);
        make.width.height.offset(20);
    }];
    
    NSString *textStr = @"已阅读并同意安住会的《服务协议》以及《隐私政策》";
    YYLabel *bottomLabel = [[YYLabel alloc] init];
    bottomLabel.textVerticalAlignment =  YYTextVerticalAlignmentTop;//垂直属性，上  下 或居中显示
    //富文本属性
    NSMutableAttributedString  *attriStr = [[NSMutableAttributedString alloc] initWithString:textStr];
    
    NSRange range1 = [textStr rangeOfString:@"已阅读并同意安住会的" options:NSCaseInsensitiveSearch];
    [attriStr yy_setLineSpacing:5 range:NSMakeRange(0, textStr.length)];
    attriStr.yy_font = [UIFont systemFontOfSize:13];
    YYTextHighlight *highlight1 = [YYTextHighlight new];
    [highlight1 setColor:XLColor_mainTextColor];
    [attriStr yy_setTextHighlight:highlight1 range:range1];
    [attriStr yy_setColor:XLColor_mainTextColor range:range1];
    
    //高亮显示文本 点击交互事件
    NSRange range2 = [textStr rangeOfString:@"《服务协议》" options:NSCaseInsensitiveSearch];
    [attriStr yy_setLineSpacing:5 range:NSMakeRange(0, textStr.length)];
    YYTextHighlight *highlight2 = [YYTextHighlight new];
    highlight2.tapAction = ^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect) {
        if (self.clickServiceAgreement) {
            self.clickServiceAgreement(@"");
        }
        
    };
    [attriStr yy_setTextHighlight:highlight2 range:range2];
    [attriStr yy_setColor:XLColor_mainHHTextColor range:range2];
    [attriStr yy_setFont:[UIFont systemFontOfSize:13] range:range2];
    
    NSRange range3 = [textStr rangeOfString:@"以及" options:NSCaseInsensitiveSearch];
    [attriStr yy_setLineSpacing:5 range:NSMakeRange(0, textStr.length)];
    attriStr.yy_font = [UIFont systemFontOfSize:13];
    YYTextHighlight *highlight3 = [YYTextHighlight new];
    [highlight3 setColor:XLColor_mainTextColor];
    [attriStr yy_setTextHighlight:highlight3 range:range3];
    [attriStr yy_setColor:XLColor_mainTextColor range:range3];
    
    //高亮显示文本 点击交互事件
    NSRange range4 = [textStr rangeOfString:@"《隐私政策》" options:NSCaseInsensitiveSearch];
    [attriStr yy_setLineSpacing:5 range:NSMakeRange(0, textStr.length)];
    YYTextHighlight *highlight4 = [YYTextHighlight new];
    highlight4.tapAction = ^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect) {
        if (self.clickPrivacyAgreement) {
            self.clickPrivacyAgreement(@"");
        }
    };
    [attriStr yy_setTextHighlight:highlight4 range:range4];
    [attriStr yy_setColor:XLColor_mainHHTextColor range:range4];
    [attriStr yy_setFont:[UIFont systemFontOfSize:13] range:range4];
    
    
    CGFloat bottomLabelWidth = [LabelSize widthOfString:textStr font:[UIFont systemFontOfSize:13] height:20];
    CGSize introSize = CGSizeMake(bottomLabelWidth, CGFLOAT_MAX);
    YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:introSize text:attriStr];
    bottomLabel.textLayout = layout;
    [self addSubview:bottomLabel];
    [bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.selectedButton.mas_right).offset(5);
        make.right.offset(-10);
        make.top.equalTo(verificationCodebottomLineView.mas_bottom).offset(15);
        make.height.offset(15);
    }];
    
    self.loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.loginButton.layer.cornerRadius = 5;
    self.loginButton.layer.masksToBounds = YES;
    self.loginButton.titleLabel.font = KBoldFont(16);
    self.loginButton.backgroundColor = UIColorHex(EBDDD8);
    [self.loginButton setTitle:@"登录" forState:UIControlStateNormal];
    [self.loginButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
    [self.loginButton addTarget:self action:@selector(loginButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.loginButton];
    [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-20);
        make.left.offset(20);
        make.height.offset(45);
        make.top.equalTo(self.selectedButton.mas_bottom).offset(25);
    }];
    
}

- (void)selectedButtonAction:(UIButton *)button {
    button.selected = !button.selected;
    if (button.selected) {
        self.isAgree = YES;
    }else {
        self.isAgree = NO;
    }
}

#pragma mark ----------------登录-----------
- (void)loginButtonAction:(UIButton *)button {
    [self endEditing:YES];
    button.enabled = NO;

    if (self.phoneTextField.text.length == 0) {
        [self makeToast:@"请输入手机号码" duration:1.5 position:CSToastPositionCenter];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            button.enabled = YES;
       });
        return;
    }
    
    if (self.phoneTextField.text.length != 11) {
        [self makeToast:@"请输入正确的手机号码" duration:1.5 position:CSToastPositionCenter];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            button.enabled = YES;
       });
        return;
    }
    
    if(![self isPureInt:self.phoneTextField.text]){
        [self makeToast:@"请输入正确的手机号码" duration:1.5 position:CSToastPositionCenter];
         dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
             button.enabled = YES;
        });
        return;
    }
    
    if (self.verificationCodeTextField.text.length == 0) {
        [self makeToast:@"请输入验证码" duration:1.5 position:CSToastPositionCenter];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            button.enabled = YES;
       });
        return;
    }
    
    if (self.verificationCodeTextField.text.length != 6) {
        [self makeToast:@"请输入正确的验证码" duration:1.5 position:CSToastPositionCenter];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            button.enabled = YES;
       });
        return;
    }
    
    if(![self isPureInt:self.verificationCodeTextField.text]){
        [self makeToast:@"请输入正确的验证码" duration:1.5 position:CSToastPositionCenter];
         dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
             button.enabled = YES;
        });
        return;
    }
    
    if (!self.isClick) {
        [self makeToast:@"请输入正确的验证码" duration:1.5 position:CSToastPositionCenter];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            button.enabled = YES;
        });
        return;
    }
    
    if (!self.isAgree) {
            
        WeakSelf(weakSelf)
        UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
        self.toastView = [[HHLoginToastView alloc] init];
        self.toastView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        self.toastView.clickCloseButton = ^{
            button.enabled = YES;
            [weakSelf.toastView removeFromSuperview];
        };
        self.toastView.clickAgainAction = ^{
            [weakSelf.toastView removeFromSuperview];
            weakSelf.isAgree = YES;
            weakSelf.selectedButton.selected = YES;
            [weakSelf login:button];
        };
        self.toastView.clickPrivacyAgreementAction = ^{
            [weakSelf.toastView removeFromSuperview];
            if(weakSelf.clickPrivacyAgreement){
                weakSelf.clickPrivacyAgreement(@"2");
            }
        };
        self.toastView.clickServiceAgreementAction = ^{
            [weakSelf.toastView removeFromSuperview];
            if(weakSelf.clickServiceAgreement){
                weakSelf.clickServiceAgreement(@"2");
            }
        };
        [keyWindow addSubview:self.toastView];
        [self.toastView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.bottom.offset(0);
        }];
        
    }else {
        [self login:button];
    }
}

- (void)login:(UIButton *)button {
    //处理逻辑
     dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        button.enabled = YES;
    });
    NSString *url = [NSString stringWithFormat:@"%@/user/login/phone",BASE_URL];
    NSMutableDictionary *dic = @{}.mutableCopy;
    [dic setValue:self.phoneTextField.text forKey:@"user_phone"];
    [dic setValue:self.verificationCodeTextField.text forKey:@"valid_code"];
    [PPHTTPRequest requestPostWithJSONForUrl:url parameters:dic success:^(id  _Nonnull response) {
        NSLog(@"登录======%@",response);
        NSString *code = [NSString stringWithFormat:@"%@", response[@"code"]];
        if ([code isEqualToString:@"0"]) {//请求成功
            button.enabled = YES;
            NSDictionary *data = response[@"data"];
            NSDictionary *tokenDic = data[@"token"];
            NSString *phone = tokenDic[@"phone"];
            NSString *user_head_img = tokenDic[@"user_head_img"];
            NSString *user_name = tokenDic[@"user_name"];
            NSString *token = tokenDic[@"token"];
            NSString *refresh_token = tokenDic[@"refresh_token"];
            [UserInfoManager sharedInstance].refresh_token = refresh_token;
            [UserInfoManager sharedInstance].jwtToken = token;
            [UserInfoManager sharedInstance].mobile = phone;
            [UserInfoManager sharedInstance].userNickName = user_name;
            [UserInfoManager sharedInstance].im_account = tokenDic[@"im_account"];
            [UserInfoManager sharedInstance].im_sign = tokenDic[@"im_sign"];
            [UserInfoManager sharedInstance].headImageStr = user_head_img;
            [UserInfoManager synchronize];
            
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isLogin"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            if (self.clickLoginButton) {
                self.clickLoginButton();
            }
            
            [self loginSDK:tokenDic[@"im_account"] userSig:tokenDic[@"im_sign"] succ:^{
            } fail:^(int code, NSString *msg) {
            }];
            
        }else {
            [self makeToast:response[@"msg"] duration:2 position:CSToastPositionCenter];
            
        }
    } failure:^(NSError * _Nonnull error) {
       
    }];
}

// 您可以在用户 UI 点击登录的时候登录 UI 组件
- (void)loginSDK:(NSString *)userID userSig:(NSString *)sig succ:(TSucc)succ fail:(TFail)fail {
    // SDKAppID 可以在 即时通信 IM 控制台中获取
    // userSig生成见 GenerateTestUserSig.h
        [TUILogin login:1400740345 userID:userID userSig:sig succ:^{
            NSLog(@"-----> 登录成功");
        } fail:^(int code, NSString *msg) {
            NSLog(@"-----> 登录失败");
        }];
}

#pragma mark --------获取验证码---------
- (void)verificationCodeButtonAction {
    [self.phoneTextField resignFirstResponder];
    self.verificationCodeButton.enabled = NO;
    if (self.phoneTextField.text.length == 0) {
        [self makeToast:@"请输入手机号码" duration:1.5 position:CSToastPositionCenter];
         dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
             self.verificationCodeButton.enabled = YES;
        });
        return;
    }
    
    if (self.phoneTextField.text.length != 11) {
        [self makeToast:@"请输入正确的手机号码" duration:1.5 position:CSToastPositionCenter];
         dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
             self.verificationCodeButton.enabled = YES;
        });
        return;
    }
    
    if(![self isPureInt:self.phoneTextField.text]){
        [self makeToast:@"请输入正确的手机号码" duration:1.5 position:CSToastPositionCenter];
         dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
             self.verificationCodeButton.enabled = YES;
        });
        return;
    }
    
    if (!self.isAgree) {
        
        WeakSelf(weakSelf)
        UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
        self.toastView = [[HHLoginToastView alloc] init];
        self.toastView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        self.toastView.clickCloseButton = ^{
            self.verificationCodeButton.enabled = YES;
            [weakSelf.toastView removeFromSuperview];
        };
        self.toastView.clickAgainAction = ^{
            [weakSelf.toastView removeFromSuperview];
            weakSelf.isAgree = YES;
            weakSelf.selectedButton.selected = YES;
            [weakSelf getVerificationCode];
        };
        self.toastView.clickPrivacyAgreementAction = ^{
            [weakSelf.toastView removeFromSuperview];
            self.verificationCodeButton.enabled = YES;
            if(weakSelf.clickPrivacyAgreement){
                weakSelf.clickPrivacyAgreement(@"1");
            }
        };
        self.toastView.clickServiceAgreementAction = ^{
            [weakSelf.toastView removeFromSuperview];
            self.verificationCodeButton.enabled = YES;
            if(weakSelf.clickServiceAgreement){
                weakSelf.clickServiceAgreement(@"1");
            }
        };
        [keyWindow addSubview:self.toastView];
        [self.toastView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.bottom.offset(0);
        }];
        
    }else {
       
        [self getVerificationCode];
    }
}

- (void)getVerificationCode {
    
    
    NSString *url = [NSString stringWithFormat:@"%@/user/validcode",BASE_URL];
    NSMutableDictionary *dic = @{}.mutableCopy;
    [dic setValue:self.phoneTextField.text forKey:@"user_phone"];
    [dic setValue:@(1) forKey:@"type"];
    [dic setValue:@(1) forKey:@"biz"];
    
    [PPHTTPRequest requestPostWithJSONForUrl:url parameters:dic success:^(id  _Nonnull response) {
      
        NSString *code = [NSString stringWithFormat:@"%@", response[@"code"]];
        if ([code isEqualToString:@"0"]) {//请求成功
           
            self.isClick = YES;
            self.loginButton.backgroundColor = XLColor_mainHHTextColor;
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
            [self makeToast:response[@"msg"] duration:2 position:CSToastPositionCenter];
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
        
        self.verificationCodeButton.enabled = YES;
        
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

- (void)textFieldDidChangeSelection:(UITextField *)textField {
    if (textField.text.length > 11) {
        self.phoneTextField.text = [textField.text substringToIndex:11];
        [textField resignFirstResponder];
        return;
    }
}


//判断输入的字符串是否全为数字
- (BOOL)isPureInt:(NSString *)string {
    NSScanner *scan = [NSScanner scannerWithString:string];
    int val;
    return [scan scanInt:&val] &&[scan isAtEnd];
}

- (void)_createdToastView:(NSString *)type {
    WeakSelf(weakSelf)
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    self.toastView = [[HHLoginToastView alloc] init];
    self.toastView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    self.toastView.clickCloseButton = ^{
        [weakSelf.toastView removeFromSuperview];
    };
    self.toastView.clickAgainAction = ^{
        [weakSelf.toastView removeFromSuperview];
        weakSelf.isAgree = YES;
        weakSelf.selectedButton.selected = YES;
        if([type isEqualToString:@"1"]){
            [weakSelf getVerificationCode];
        }else {
            [weakSelf login:weakSelf.loginButton];
        }
    };
    self.toastView.clickPrivacyAgreementAction = ^{
        [weakSelf.toastView removeFromSuperview];
        if(weakSelf.clickPrivacyAgreement){
            weakSelf.clickPrivacyAgreement(type);
        }
    };
    self.toastView.clickServiceAgreementAction = ^{
        [weakSelf.toastView removeFromSuperview];
        if(weakSelf.clickServiceAgreement){
            weakSelf.clickServiceAgreement(type);
        }
    };
    [keyWindow addSubview:self.toastView];
    [self.toastView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.offset(0);
    }];
}
@end
