//
//  HHEditNameViewController.m
//  HashdeepHotel
//
//  Created by Cindy on 2022/7/13.
//

#import "HHEditNameViewController.h"
#define kMaxLength 16
@interface HHEditNameViewController ()<UITextFieldDelegate,UITextFieldTextMaxCountDelegate>
@property (nonatomic,strong) UITextField *textField;//昵称
@end

@implementation HHEditNameViewController

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
    titleLabel.text = @"修改昵称";
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
        make.height.offset(50);
    }];
    
    self.textField = [[UITextField alloc] init];
    self.textField.borderStyle = UITextBorderStyleNone;
    self.textField.font = XLFont_mainTextFont;
    self.textField.textColor = XLColor_mainTextColor;
    self.textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入昵称" attributes:@{
        NSForegroundColorAttributeName:XLColor_subSubTextColor
    }];
    if ([UserInfoManager sharedInstance].userNickName.length != 0) {
        self.textField.text = [UserInfoManager sharedInstance].userNickName;
    }
    self.textField.textAlignment = NSTextAlignmentLeft;
    self.textField.keyboardType = UIKeyboardTypeTwitter;
    self.textField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.textField.delegate = self;
    [self.textField addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    
    self.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [whiteView addSubview:self.textField];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.top.bottom.offset(0);
        make.right.offset(-15);
    }];
    
    UILabel *tipLabel = [[UILabel alloc] init];
    tipLabel.text = @"以英文字母或汉字开头，限4-16个字符，一个汉字为2个字符";
    tipLabel.textColor = XLColor_subTextColor;
    tipLabel.font = XLFont_subSubTextFont;
    [self.view addSubview:tipLabel];
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.offset(-15);
        make.top.equalTo(whiteView.mas_bottom).offset(7);
        make.height.offset(20);
    }];
    
    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [doneButton setTitle:@"确定" forState:UIControlStateNormal];
    [doneButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
    doneButton.titleLabel.font = XLFont_mainTextFont;
    doneButton.layer.cornerRadius = 5;
    doneButton.layer.masksToBounds = YES;
    doneButton.backgroundColor = UIColorHex(b58e7f);
    [doneButton addTarget:self action:@selector(doneButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:doneButton];
    [doneButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.offset(-15);
        make.top.equalTo(tipLabel.mas_bottom).offset(20);
        make.height.offset(45);
    }];
    
}

//判断字符串为6～12位“字符”
- (BOOL)isValidateName:(NSString *)name{
    NSUInteger  character = 0;
    for(int i=0; i< [name length];i++){
        int a = [name characterAtIndex:i];
        if( a >= 0x4e00 && a <= 0x9fa5){ //判断是否为中文
            character +=2;
        }else{
            character +=1;
        }
    }
    
    if (character >=4 && character <=16) {
        return YES;
    }else{
        return NO;
    }
    
}

- (void)doneButtonAction {
    [self.view endEditing:YES];
    
    if (self.textField.text.length == 0) {
        [self.view makeToast:@"请输入昵称" duration:1.5 position:CSToastPositionCenter];
        return;
    }
    
    if(![self isValidateName:self.textField.text]) {
        
        [self.view makeToast:@"长度4-16个字符，请检查重试" duration:1.5 position:CSToastPositionCenter];
        return;
    }
    
    BOOL b = [HHAppManage isBlankString:self.textField.text];
    if (b) {
        [self.view makeToast:@"请输入昵称" duration:1 position:CSToastPositionCenter];
    }else {
        NSString *url = [NSString stringWithFormat:@"%@/user/modify",BASE_URL];
        NSMutableDictionary *dic = @{}.mutableCopy;
        [dic setValue:self.textField.text forKey:@"user_name"];
        [PPHTTPRequest requestPostWithJSONForUrl:url parameters:dic success:^(id  _Nonnull response) {
            
            NSString *code = [NSString stringWithFormat:@"%@", response[@"code"]];
            if ([code isEqualToString:@"0"]) {//请求成功
                NSDictionary *data = response[@"data"];
                NSString *user_name = data[@"user_name"];
                [UserInfoManager sharedInstance].userNickName = user_name;
                [UserInfoManager synchronize];
                if (self.updateNickNameSuccess) {
                    self.updateNickNameSuccess(self.textField.text);
                }
                [self.navigationController popViewControllerAnimated:YES];
            } else {
                [self.view makeToast:response[@"msg"] duration:2 position:CSToastPositionCenter];
            }
        } failure:^(NSError * _Nonnull error) {
            
        }];
    }
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSLog(@"------------shouldChangeCharactersInRange:%@-----------",string);
    
    if ([self isInputRuleNotBlank:string] || [string isEqualToString:@""]) {//当输入符合规则和退格键时允许改变输入框
        return YES;
    } else {
        return NO;
    }
}



- (void)textFieldChanged:(UITextField *)textField {
    
    NSLog(@"----------textFieldChanged:%@-------------",textField.text);
    
    NSString *toBeString = textField.text;
    
    if (![self isInputRuleAndBlank:toBeString]) {
        
        textField.text = [self disable_emoji:toBeString];
        return;
    }
    
    NSString *lang = [[textField textInputMode] primaryLanguage]; // 获取当前键盘输入模式
    
    
    NSLog(@"%@",lang);
    
    
    
    if([lang isEqualToString:@"zh-Hans"])
    { //简体中文输入,第三方输入法（搜狗）所有模式下都会显示“zh-Hans”
        UITextRange *selectedRange = [textField markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        //没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if(!position) {
            NSString *getStr = [self getSubString:toBeString];
            if(getStr && getStr.length > 0) {
                textField.text = getStr;
            }
        }
    }
    else
    {
        NSString *getStr = [self getSubString:toBeString];
        if(getStr && getStr.length > 0) {
            textField.text= getStr;
        }
    }
    
}

/**
 * 字母、数字、中文正则判断（不包括空格）
 */
- (BOOL)isInputRuleNotBlank:(NSString *)str {
    
    //    NSString *pattern = @"^[a-zA-Z\u4E00-\u9FA5\\d]*$";
    NSString *pattern = @"^[➋➌➍➎➏➐➑➒a-zA-Z\u4E00-\u9FA5]*$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:str];
    return isMatch;
}

/**
 * 字母、数字、中文正则判断（包括空格）（在系统输入法中文输入时会出现拼音之间有空格，需要忽略，当按return键时会自动用字母替换，按空格输入响应汉字）
 */
- (BOOL)isInputRuleAndBlank:(NSString *)str {
    
    //    NSString *pattern = @"^[a-zA-Z\u4E00-\u9FA5\\d\\s]*$";
    NSString *pattern = @"^[➋➌➍➎➏➐➑➒a-zA-Z\u4E00-\u9FA5\\s]*$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:str];
    return isMatch;
}


/**
 *  获得 kMaxLength长度的字符
 */
-(NSString *)getSubString:(NSString*)string
{
    NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSData* data = [string dataUsingEncoding:encoding];
    NSInteger length = [data length];
    if (length > kMaxLength) {
        NSData *data1 = [data subdataWithRange:NSMakeRange(0, kMaxLength)];
        NSString *content = [[NSString alloc] initWithData:data1 encoding:encoding];//注意：当截取kMaxLength长度字符时把中文字符截断返回的content会是nil
        if (!content || content.length == 0) {
            data1 = [data subdataWithRange:NSMakeRange(0, kMaxLength - 1)];
            content =  [[NSString alloc] initWithData:data1 encoding:encoding];
        }
        return content;
    }
    return nil;
}


- (NSString *)disable_emoji:(NSString *)text{
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]"options:NSRegularExpressionCaseInsensitive error:nil];
    NSString *modifiedString = [regex stringByReplacingMatchesInString:text
                                                               options:0
                                                                 range:NSMakeRange(0, [text length])
                                                          withTemplate:@""];
    return modifiedString;
}

@end
