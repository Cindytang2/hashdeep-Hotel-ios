//
//  HHCancellationViewController.m
//  HashdeepHotel
//
//  Created by Cindy on 2022/7/29.
//

#import "HHCancellationViewController.h"
#import "HHCancellationToastView.h"
@interface HHCancellationViewController ()
@property (nonatomic, strong) UIView *normalView;
@property (nonatomic, strong) UIView *clickView;
@property (nonatomic, strong) UITextField *verificationCodeTextField;
@property (nonatomic, strong) UIButton *verificationCodeButton;
@property (nonatomic, strong) NSTimer *smsTimer;///<短信下发的计时器
@property (nonatomic, assign) NSInteger countDownTime;///<倒计时时间
@property (nonatomic,assign) BOOL isClick;
@property (nonatomic,assign) BOOL isNormal;
@property (nonatomic, strong) HHCancellationToastView *toastView;
@end

@implementation HHCancellationViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isNormal = YES;
    self.view.backgroundColor = kWhiteColor;
    
    //自定义导航栏
    [self _createdNavigationBar];
    
    //创建Views
    [self _createdViews];
    
}

#pragma mark -----------------------自定义导航栏-----------------------
- (void)_createdNavigationBar {
    
    [self createdNavigationBackButton];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"注销账号";
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
    
    self.normalView = [[UIView alloc] init];
    [self.view addSubview:self.normalView];
    [self.normalView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.offset(UINavigateHeight);
        if (UINavigateTop == 44) {
            make.bottom.offset(-80);
        }else {
            make.bottom.offset(-60);
        }
    }];
    
    UIImageView *imgView = [[UIImageView alloc] init];
    imgView.image = HHGetImage(@"icon_my_cancellation");
    [self.normalView addSubview:imgView];
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(150);
        make.width.height.offset(90);
        make.centerX.equalTo(self.normalView);
    }];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"注销账户之后，您将放弃安住会所有权益！";
    titleLabel.textColor = XLColor_mainTextColor;
    titleLabel.font = KBoldFont(16);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.normalView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.equalTo(imgView.mas_bottom).offset(12);
        make.height.offset(20);
    }];
    
    
    self.clickView = [[UIView alloc] init];
    self.clickView.hidden = YES;
    [self.view addSubview:self.clickView];
    [self.clickView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.offset(UINavigateHeight);
        if (UINavigateTop == 44) {
            make.bottom.offset(-80);
        }else {
            make.bottom.offset(-60);
        }
    }];
    
    
    
    
    
    UILabel *detailLabel = [[UILabel alloc] init];
    detailLabel.font = XLFont_mainTextFont;
    detailLabel.textColor = XLColor_mainTextColor;
    detailLabel.numberOfLines = 0;
    detailLabel.text = [NSString stringWithFormat:@"短信验证码将发送到您绑定的手机号码%@，请输入验证码验证您的身份",[UserInfoManager sharedInstance].mobile];
    [self.clickView addSubview:detailLabel];
    [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.offset(-15);
        make.top.offset(15);
        make.height.offset(50);
    }];
    
    self.verificationCodeTextField = [[UITextField alloc] init];
    self.verificationCodeTextField.borderStyle = UITextBorderStyleNone;
    self.verificationCodeTextField.font = XLFont_subTextFont;
    self.verificationCodeTextField.textColor = XLColor_mainTextColor;
    self.verificationCodeTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入验证码" attributes:@{
        NSForegroundColorAttributeName:XLColor_subSubTextColor
    }];
    self.verificationCodeTextField.tag = 200;
    self.verificationCodeTextField.textMaxLength = 6;
    self.verificationCodeTextField.textAlignment = NSTextAlignmentLeft;
    self.verificationCodeTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.verificationCodeTextField.autocorrectionType=UITextAutocorrectionTypeNo;
    self.verificationCodeTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.clickView addSubview:self.verificationCodeTextField];
    [self.verificationCodeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.top.equalTo(detailLabel.mas_bottom).offset(15);
        make.height.offset(30);
        make.right.offset(-150);
    }];
    
    self.verificationCodeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.verificationCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    [self.verificationCodeButton setTitleColor:XLColor_mainTextColor forState:UIControlStateNormal];
    self.verificationCodeButton.backgroundColor = RGBColor(243, 244, 247);
    self.verificationCodeButton.layer.cornerRadius = 5;
    self.verificationCodeButton.layer.masksToBounds = YES;
    self.verificationCodeButton.titleLabel.font = XLFont_subTextFont;
    [self.verificationCodeButton addTarget:self action:@selector(verificationCodeButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.clickView addSubview:self.verificationCodeButton];
    [self.verificationCodeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-15);
        make.height.offset(30);
        make.width.offset(95);
        make.top.equalTo(detailLabel.mas_bottom).offset(15);
    }];
    
    UIView *lineView = [[UIView alloc ] init];
    lineView.backgroundColor = RGBColor(243, 244, 247);
    [self.clickView addSubview: lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.verificationCodeButton.mas_left).offset(-15);
        make.top.equalTo(detailLabel.mas_bottom).offset(17.5);
        make.height.offset(25);
        make.width.offset(1);
    }];
    
    UIView *verificationCodebottomLineView = [[UIView alloc ] init];
    verificationCodebottomLineView.backgroundColor = RGBColor(243, 244, 247);
    [self.clickView addSubview: verificationCodebottomLineView];
    [verificationCodebottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(20);
        make.top.equalTo(self.verificationCodeTextField.mas_bottom).offset(15);
        make.height.offset(1);
        make.right.offset(-20);
    }];
    
    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [doneButton setTitle:@"确认注销" forState:UIControlStateNormal];
    [doneButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
    doneButton.backgroundColor = UIColorHex(b58e7f);
    doneButton.layer.cornerRadius = 8;
    doneButton.layer.masksToBounds = YES;
    doneButton.titleLabel.font = XLFont_mainTextFont;
    doneButton.layer.shadowColor = kBlackColor.CGColor;
    //shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用  (0,0)时是四周都有阴影
    doneButton.layer.shadowOffset = CGSizeMake(0, 0);
    //阴影透明度，默认0
    doneButton.layer.shadowOpacity = 0.3;
    //阴影半径，默认3
    doneButton.clipsToBounds = NO;
    doneButton.layer.shadowRadius = 3;
    [doneButton addTarget:self action:@selector(doneButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:doneButton];
    [doneButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.offset(-15);
        make.height.offset(45);
        if (UINavigateTop == 44) {
            make.bottom.offset(-35);
        }else {
            make.bottom.offset(-15);
        }
        
    }];
    
    
    WeakSelf(weakSelf)
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    self.toastView = [[HHCancellationToastView alloc] init];
    self.toastView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    self.toastView.hidden = YES;
    self.toastView.clickCancelAction = ^{
        weakSelf.toastView.hidden = YES;
    };
    self.toastView.clickDoneAction = ^{
        weakSelf.toastView.hidden = YES;
        [weakSelf cancellationAction];
    };
    [keyWindow addSubview:self.toastView];
    [self.toastView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.offset(0);
    }];
    
}

- (void)cancellationAction {
    NSString *url = [NSString stringWithFormat:@"%@/user/logout",BASE_URL];
    NSMutableDictionary *dic = @{}.mutableCopy;
    [dic setValue:self.verificationCodeTextField.text forKey:@"valid_code"];
    [PPHTTPRequest requestPostWithJSONForUrl:url parameters:dic success:^(id  _Nonnull response) {
        NSLog(@"注销======%@",response);
        NSString *code = [NSString stringWithFormat:@"%@", response[@"code"]];
        if ([code isEqualToString:@"0"]) {//请求成功
            [UserInfoManager logout];
            [UserInfoManager removeInfo];
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isLogin"];
            [[NSUserDefaults standardUserDefaults]setValue:@"0" forKey:@"countryCalendarOffsetY"];
            [[NSUserDefaults standardUserDefaults]setValue:@"0" forKey:@"hourlyCalendarOffsetY"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            
            [self performSelector:@selector(perform) withObject:nil afterDelay:1];
        }else {
            [self.view makeToast:response[@"msg"] duration:2 position:CSToastPositionCenter];
        }
    } failure:^(NSError * _Nonnull error) {
       
    }];
    
}

- (void)doneButtonAction:(UIButton *)button {
    
    if(self.isNormal){
        [self.normalView removeFromSuperview];
        self.clickView.hidden = NO;
        self.isNormal = NO;
    }else {
        button.enabled = NO;
        if (self.verificationCodeTextField.text.length == 0) {
            [self.view
             makeToast:@"请输入验证码" duration:1.5 position:CSToastPositionCenter];
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
        
        self.toastView.hidden = NO;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            button.enabled = YES;
        });
    }
}

- (void)perform {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark --------获取验证码---------
- (void)verificationCodeButtonAction {
    
    self.verificationCodeButton.enabled = NO;
    
    NSString *url = [NSString stringWithFormat:@"%@/user/validcode/token",BASE_URL];
    [PPHTTPRequest requestGetWithURL:url parameters:@{} success:^(id  _Nonnull response) {
        NSString *code = [NSString stringWithFormat:@"%@", response[@"code"]];
        if ([code isEqualToString:@"0"]) {//请求成功
          
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
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
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
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.verificationCodeButton.enabled = YES;
        });
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view makeToast:@"网络异常，请检查网络后重试" duration:2 position:CSToastPositionCenter];
        });
        
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
