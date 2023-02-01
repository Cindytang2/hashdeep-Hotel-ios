
//
//  HHLowerOrderView.m
//  HashdeepHotel
//
//  Created by Cindy on 2022/7/28.
//

#import "HHLowerOrderView.h"
#import "HHReadView.h"
#import "HHInfoView.h"
#import "HHPriceInfoView.h"
#import "HHInvoiceView.h"
#define kMaxLength 20
@interface HHLowerOrderView ()<UITextFieldDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *topWhiteView;
@property (nonatomic, assign) CGFloat readHeight;
@property (nonatomic, strong) HHReadView *readView;
@property (nonatomic, strong) HHInfoView *infoView;

@property (nonatomic, strong) HHPriceInfoView *priceInfoView;

@property (nonatomic, strong) UIView *bottomView;

@property (nonatomic, strong) UIView *centerWhiteView;
@property (nonatomic, strong) UIView *nameView;
@property (nonatomic, strong) UIButton *nameRightButton;
@property (nonatomic, strong) UILabel *tLabel;
@property (nonatomic, strong) UILabel *readLabel;
@property (nonatomic, strong) UIButton *timeButton;
@property (nonatomic, assign) NSInteger roomNumber;
@property (nonatomic, strong) UILabel *roomNumberLabel;

@property (nonatomic, strong) UITextField *phoneTextField;

@property (nonatomic, strong) HHInvoiceView *invoiceView;



@end

@implementation HHLowerOrderView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.roomNumber = 1;
        [self _addSubViews];
    }
    return self;
}

- (void)_addSubViews{
    WeakSelf(weakSelf)
    [self addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.offset(0);
        if (UINavigateTop == 44) {
            make.height.offset(80);
        }else {
            make.height.offset(60);
        }
    }];
    
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.bounces = NO;
    self.scrollView.backgroundColor = XLColor_mainColor;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.offset(0);
        if (UINavigateTop == 44) {
            make.bottom.offset(-80);
        }else {
            make.bottom.offset(-60);
        }
    }];
    
    UIView *blackView = [[UIView alloc] init];
    blackView.backgroundColor = UIColorHex(49494B);
    [HHAppManage mq_setRect:CGRectMake(0, 0, kScreenWidth, 150) cornerRect:UIRectCornerBottomLeft|UIRectCornerBottomRight radius:15 view:blackView];
    [self.scrollView addSubview:blackView];
    [blackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.offset(0);
        make.height.offset(150);
        make.centerX.offset(0);
    }];
    
    self.topWhiteView = [[UIView alloc] init];
    self.topWhiteView.backgroundColor = kWhiteColor;
    self.topWhiteView.layer.cornerRadius = 15;
    self.topWhiteView.layer.masksToBounds = YES;
    [self.scrollView addSubview:self.topWhiteView];
    [self.topWhiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.offset(-15);
        make.top.offset(40);
        make.height.offset(250);
    }];
    
    self.infoView = [[HHInfoView alloc] init];
    self.infoView.clickRoomDetailAction = ^(UIButton * _Nonnull button) {
        if(weakSelf.clickRoomDetailAction){
            weakSelf.clickRoomDetailAction(button);
        }
    };
    [self.topWhiteView addSubview:self.infoView];
    [self.infoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.offset(0);
        make.height.offset(100);
    }];
    
    UIView *detailBottomLineView = [[UIView alloc] init];
    detailBottomLineView.backgroundColor = XLColor_mainColor;
    [self.topWhiteView addSubview:detailBottomLineView];
    [detailBottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.offset(-15);
        make.height.offset(1);
        make.top.equalTo(self.infoView.mas_bottom).offset(0);
    }];
    
    self.readView = [[HHReadView alloc] init];
    self.readView.clickBookRoomReadAction = ^(UIButton * _Nonnull button) {
        if(weakSelf.clickBookRoomReadAction){
            weakSelf.clickBookRoomReadAction(button);
        }
    };
    [self.topWhiteView addSubview:self.readView];
    [self.readView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.equalTo(detailBottomLineView.mas_bottom).offset(0);
        make.height.offset(100);
    }];
    
    self.centerWhiteView = [[UIView alloc] init];
    self.centerWhiteView.backgroundColor = kWhiteColor;
    self.centerWhiteView.layer.cornerRadius = 15;
    self.centerWhiteView.layer.masksToBounds = YES;
    [self.scrollView addSubview:self.centerWhiteView];
    [self.centerWhiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.offset(-15);
        make.height.offset(250);
        make.top.equalTo(self.topWhiteView.mas_bottom).offset(15);
    }];
    
    UILabel *checkInfoLabel = [[UILabel alloc] init];
    checkInfoLabel.textColor = XLColor_mainTextColor;
    checkInfoLabel.font = KBoldFont(16);
    checkInfoLabel.text = @"入住信息";
    [self.centerWhiteView addSubview:checkInfoLabel];
    [checkInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.top.offset(15);
        make.height.offset(20);
        make.right.offset(-15);
    }];
    
    UIView *checkInfoBottomLineView = [[UIView alloc] init];
    checkInfoBottomLineView.backgroundColor = XLColor_mainColor;
    [self.centerWhiteView addSubview:checkInfoBottomLineView];
    [checkInfoBottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.offset(-15);
        make.height.offset(1);
        make.top.equalTo(checkInfoLabel.mas_bottom).offset(10);
    }];
    
    UIButton *roomNuberButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [roomNuberButton addTarget:self action:@selector(roomNuberButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.centerWhiteView addSubview:roomNuberButton];
    [roomNuberButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.equalTo(checkInfoBottomLineView.mas_bottom).offset(0);
        make.height.offset(50);
    }];
    
    self.roomNumberLabel = [[UILabel alloc] init];
    self.roomNumberLabel.textColor = XLColor_subTextColor;
    self.roomNumberLabel.font = XLFont_subTextFont;
    [roomNuberButton addSubview:self.roomNumberLabel];
    [self.roomNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.centerY.equalTo(roomNuberButton);
        make.height.offset(20);
        make.width.offset(80);
    }];
    
    UIImageView *roomNumberGetIntoImageView = [[UIImageView alloc] init];
    roomNumberGetIntoImageView.image = HHGetImage(@"icon_home_down");
    [roomNuberButton addSubview:roomNumberGetIntoImageView];
    [roomNumberGetIntoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-15);
        make.centerY.equalTo(roomNuberButton);
        make.width.offset(12);
        make.height.offset(6);
    }];
    
    self.roomNumberResultLabel = [[UILabel alloc] init];
    self.roomNumberResultLabel.textColor = XLColor_mainTextColor;
    self.roomNumberResultLabel.font = KBoldFont(14);
    [roomNuberButton addSubview:self.roomNumberResultLabel];
    [self.roomNumberResultLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.roomNumberLabel.mas_right).offset(0);
        make.centerY.equalTo(roomNuberButton);
        make.height.offset(20);
        make.right.offset(-30);
    }];
    
    UIView *roomNumberBottomLineView = [[UIView alloc] init];
    roomNumberBottomLineView.backgroundColor = XLColor_mainColor;
    [self.centerWhiteView addSubview:roomNumberBottomLineView];
    [roomNumberBottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.offset(-15);
        make.height.offset(1);
        make.top.equalTo(roomNuberButton.mas_bottom).offset(0);
    }];
    
    self.nameView = [[UIView alloc] init];
    [self.centerWhiteView addSubview:self.nameView];
    [self.nameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.equalTo(roomNumberBottomLineView.mas_bottom).offset(0);
        make.height.offset(50);
    }];
    
    UIButton *nameButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.nameView addSubview:nameButton];
    [nameButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.offset(0);
        make.height.offset(50);
    }];
    
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.textColor = XLColor_subTextColor;
    nameLabel.font = XLFont_subTextFont;
    nameLabel.text = @"住客姓名";
    [nameButton addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.centerY.equalTo(nameButton);
        make.height.offset(20);
        make.width.offset(80);
    }];
    
    self.nameTextField = [[UITextField alloc] init];
    self.nameTextField.borderStyle = UITextBorderStyleNone;
    self.nameTextField.font = KBoldFont(14);
    self.nameTextField.textColor = XLColor_mainTextColor;
    self.nameTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入姓名" attributes:@{
        NSForegroundColorAttributeName:XLColor_subSubTextColor
    }];
    self.nameTextField.textAlignment = NSTextAlignmentLeft;
    self.nameTextField.keyboardType = UIKeyboardTypeTwitter;
    self.nameTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.nameTextField.tag = 100;
    [self.nameTextField addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    self.nameTextField.delegate = self;
    self.nameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [nameButton addSubview:self.nameTextField];
    [self.nameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(nameButton);
        make.height.offset(20);
        make.right.offset(-50);
        make.left.equalTo(nameLabel.mas_right).offset(0);
    }];
    
    self.nameRightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.nameRightButton setImage:HHGetImage(@"icon_home_order_name") forState:UIControlStateNormal];
    [self.nameRightButton addTarget:self action:@selector(nameRightButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [nameButton addSubview:self.nameRightButton];
    [self.nameRightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(nameButton);
        make.height.offset(25);
        make.width.offset(25);
        make.right.offset(-15);
    }];
    
    UIView *nameBottomLineView = [[UIView alloc] init];
    nameBottomLineView.backgroundColor = XLColor_mainColor;
    [self.centerWhiteView addSubview:nameBottomLineView];
    [nameBottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.offset(-15);
        make.height.offset(1);
        make.top.equalTo(self.nameView.mas_bottom).offset(0);
    }];
    
    UIButton *phoneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.centerWhiteView addSubview:phoneButton];
    [phoneButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.equalTo(nameBottomLineView.mas_bottom).offset(0);
        make.height.offset(50);
    }];
    
    UILabel *phoneLabel = [[UILabel alloc] init];
    phoneLabel.textColor = XLColor_subTextColor;
    phoneLabel.font = XLFont_subTextFont;
    phoneLabel.text = @"联系手机";
    [phoneButton addSubview:phoneLabel];
    [phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.centerY.equalTo(phoneButton);
        make.height.offset(20);
        make.width.offset(80);
    }];
    
    UILabel *nLabel = [[UILabel alloc] init];
    nLabel.textColor = XLColor_subTextColor;
    nLabel.font = XLFont_subTextFont;
    nLabel.text = @"+86";
    [phoneButton addSubview:nLabel];
    [nLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(phoneButton);
        make.height.offset(20);
        make.width.offset(35);
        make.left.equalTo(phoneLabel.mas_right).offset(0);
    }];
    
    UIView *phoneSmallLineView = [[UIView alloc] init];
    phoneSmallLineView.backgroundColor = XLColor_mainColor;
    [phoneButton addSubview:phoneSmallLineView];
    [phoneSmallLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nLabel.mas_right).offset(0);
        make.width.offset(1);
        make.centerY.equalTo(phoneButton);
        make.height.offset(20);
    }];
    
    self.phoneTextField = [[UITextField alloc] init];
    self.phoneTextField.borderStyle = UITextBorderStyleNone;
    self.phoneTextField.font = KBoldFont(14);
    self.phoneTextField.textColor = XLColor_mainTextColor;
    self.phoneTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入手机号码" attributes:@{
        NSForegroundColorAttributeName:XLColor_subSubTextColor
    }];
    self.phoneTextField.text = [UserInfoManager sharedInstance].mobile;
    self.phoneTextField.tag = 200;
    self.phoneTextField.textAlignment = NSTextAlignmentLeft;
    self.phoneTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.phoneTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.phoneTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [phoneButton addSubview:self.phoneTextField];
    [self.phoneTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(phoneSmallLineView.mas_right).offset(10);
        make.right.offset(-15);
        make.centerY.equalTo(phoneButton);
        make.height.offset(20);
    }];
    
    UIView *phoneBottomLineView = [[UIView alloc] init];
    phoneBottomLineView.backgroundColor = XLColor_mainColor;
    [self.centerWhiteView addSubview:phoneBottomLineView];
    [phoneBottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.offset(-15);
        make.height.offset(1);
        make.top.equalTo(phoneButton.mas_bottom).offset(0);
    }];
    
    self.timeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.timeButton addTarget:self action:@selector(timeButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.centerWhiteView addSubview:self.timeButton];
    [self.timeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.equalTo(phoneBottomLineView.mas_bottom).offset(0);
        make.height.offset(50);
    }];
    
    UILabel *timeLabel = [[UILabel alloc] init];
    timeLabel.textColor = XLColor_subTextColor;
    timeLabel.font = XLFont_subTextFont;
    timeLabel.text = @"入住时间";
    [self.timeButton addSubview:timeLabel];
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.centerY.equalTo(self.timeButton);
        make.height.offset(20);
        make.width.offset(80);
    }];
    
    self.timeResultLabel = [[UILabel alloc] init];
    self.timeResultLabel.textColor = XLColor_mainTextColor;
    self.timeResultLabel.font = KBoldFont(14);
    [self.timeButton addSubview:self.timeResultLabel];
    [self.timeResultLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(timeLabel.mas_right).offset(0);
        make.centerY.equalTo(self.timeButton);
        make.height.offset(20);
    }];
    
    self.tLabel = [[UILabel alloc] init];
    self.tLabel.textColor = XLColor_subTextColor;
    self.tLabel.font = XLFont_subSubTextFont;
    self.tLabel.text = @"房间将整晚保留";
    [self.timeButton addSubview:self.tLabel];
    [self.tLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.timeResultLabel.mas_right).offset(10);
        make.centerY.equalTo(self.timeButton);
        make.height.offset(20);
        make.right.offset(-40);
    }];
    
    UIImageView *timeGetIntoImageView = [[UIImageView alloc] init];
    timeGetIntoImageView.image = HHGetImage(@"icon_home_gray_right");
    [self.timeButton addSubview:timeGetIntoImageView];
    [timeGetIntoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-15);
        make.centerY.equalTo(self.timeButton);
        make.height.offset(15);
        make.width.offset(12);
    }];
    
    self.invoiceView = [[HHInvoiceView alloc] init];
    self.invoiceView.backgroundColor = kWhiteColor;
    self.invoiceView.layer.cornerRadius = 15;
    self.invoiceView.layer.masksToBounds = YES;
    [self.scrollView addSubview:self.invoiceView];
    [self.invoiceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.offset(-15);
        make.height.offset(80);
        make.top.equalTo(self.centerWhiteView.mas_bottom).offset(15);
    }];
    
    self.priceInfoView = [[HHPriceInfoView alloc] init];
    self.priceInfoView.backgroundColor = kWhiteColor;
    self.priceInfoView.layer.cornerRadius = 15;
    self.priceInfoView.layer.masksToBounds = YES;
    [self.scrollView addSubview:self.priceInfoView];
    [self.priceInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.offset(-15);
        make.height.offset(150);
        make.top.equalTo(self.invoiceView.mas_bottom).offset(15);
        make.bottom.offset(-15);
    }];
    
}

- (void)setData:(NSDictionary *)data {
    _data = data;
    
    CGFloat infoHeight = [self.infoView updateUIForData:_data];
    [self.infoView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.offset(infoHeight);
    }];
    
    [self.topWhiteView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.offset(infoHeight+1+self.readHeight);
    }];
    
    NSDictionary *invoice_info = _data[@"invoice_info"];
    self.invoiceView.invoice_info = invoice_info;
    
    [self.priceInfoView updataUI:_data withRoomNumber:1];
    CGFloat priceInfoHeight = [self.priceInfoView priceInfoHeight];
    [self.priceInfoView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.offset(priceInfoHeight);
    }];
    
    NSDictionary *payment_info = data[@"payment_info"];
    self.priceLabel.text = payment_info[@"payment_price"];
    
    NSDictionary *time_info = data[@"time_info"];
    NSArray *time_list = time_info[@"time_list"];
    self.timeResultLabel.text = time_list.firstObject[@"time_desc"];
    
    NSDictionary *linkman_info = _data[@"linkman_info"];
    
    if(self.dateType == 2){//民宿
        NSArray *check_in_list = linkman_info[@"check_in_list"];
        NSDictionary *nameDic = check_in_list[1];
        NSDictionary *phoneDic = check_in_list[2];
        NSArray *nameA = nameDic[@"desc"];
        if(nameA.count != 0){
            self.nameTextField.text = nameA.firstObject;
        }
        NSArray *phoneA = phoneDic[@"desc"];
        self.phoneTextField.text = phoneA.lastObject;
        
        [self.centerWhiteView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset(198);
        }];
        
        self.roomNumberLabel.text = @"入住人数";
        self.roomNumberResultLabel.text = @"1人";
        
        self.timeButton.hidden = YES;
        [self.timeButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset(0);
        }];
        self.invoiceView.hidden = YES;
        [self.invoiceView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset(0);
            make.top.equalTo(self.centerWhiteView.mas_bottom).offset(0);
        }];
        
       
    }else {
        self.nameTextField.text = linkman_info[@"linkman_name"];
        self.phoneTextField.text = linkman_info[@"linkman_phone"];
        
        [self.centerWhiteView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset(250);
        }];
        
        self.roomNumberLabel.text = @"房间数量";
        self.roomNumberResultLabel.text = @"1间（每间最多住两人）";
        
        self.timeButton.hidden = NO;
        [self.timeButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset(50);
        }];
        
        self.invoiceView.hidden = NO;
        [self.invoiceView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset(80);
            make.top.equalTo(self.centerWhiteView.mas_bottom).offset(15);
        }];
    }
}

- (void)roomNuberButtonAction {
    if (self.clickRoomNumberAction) {
        self.clickRoomNumberAction();
    }
}

- (void)timeButtonAction {
    
    if (self.clickTimeAction) {
        self.clickTimeAction();
    }
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
    
    if (character >=2 && character <=20) {
        return YES;
    }else{
        return NO;
    }
    
}

- (void)doneButtonAction:(UIButton *)button {
    button.enabled = NO;
    
    NSMutableArray *nameArray = [NSMutableArray array];
    if(self.roomNumber == 1){
        
        if (self.nameTextField.text.length == 0) {
            [self makeToast:@"请输入姓名" duration:2 position:CSToastPositionCenter];
            [self.nameTextField becomeFirstResponder];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                button.enabled = YES;
           });
            return;
        }else {
            
            if(![self isValidateName:self.nameTextField.text]) {
                [self makeToast:@"长度2-20个字符，请检查重试" duration:1.5 position:CSToastPositionCenter];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    button.enabled = YES;
               });
                return;
            }
            
            [nameArray addObject:self.nameTextField.text];
        }
        
    }else {
        
        for (int i= 0; i<self.roomNumber; i++) {
            UIButton *button = (UIButton *)[self.nameView viewWithTag:10+i];
            UITextField *textField = (UITextField *)[button viewWithTag:100+i];
            if (textField.text.length == 0) {
                [self makeToast:@"请输入姓名" duration:2 position:CSToastPositionCenter];
                [textField becomeFirstResponder];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    button.enabled = YES;
               });
                return;
            }else {
                
                if(![self isValidateName:self.nameTextField.text]) {
                    
                    [self makeToast:@"长度2-20个字符，请检查重试" duration:1.5 position:CSToastPositionCenter];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        button.enabled = YES;
                   });
                    return;
                }
                [nameArray addObject:textField.text];
            }
        }
    }
   
    if (self.phoneTextField.text.length == 0) {
        [self makeToast:@"请输入手机号码" duration:2 position:CSToastPositionCenter];
        [self.phoneTextField becomeFirstResponder];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            button.enabled = YES;
       });
        return;
    }
    
    if (self.phoneTextField.text.length != 11) {
        [self makeToast:@"请输入正确的手机号码" duration:2 position:CSToastPositionCenter];
        [self.phoneTextField becomeFirstResponder];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            button.enabled = YES;
       });
        return;
    }
    
    NSSet *set = [NSSet setWithArray:nameArray];
    if (set.count != nameArray.count) {
        [self makeToast:@"输入的姓名，不能重复" duration:2 position:CSToastPositionCenter];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            button.enabled = YES;
       });
        return;
    }
    
    if (self.clickDoneAction) {
        self.clickDoneAction(nameArray,self.phoneTextField.text, self.nameTextField, self.phoneTextField,button);
    }
    
    
}


- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
        _bottomView.backgroundColor = kWhiteColor;
        
        self.priceLabel = [[UILabel alloc] init];
        self.priceLabel.font = KBoldFont(16);
        self.priceLabel.textColor = UIColorHex(FF7E67);
        [_bottomView addSubview:self.priceLabel];
        [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(15);
            make.top.offset(15);
            make.right.offset(-150);
            make.height.offset(30);
        }];
        
        UIButton *priceInfoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [priceInfoButton addTarget:self action:@selector(priceInfoButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:priceInfoButton];
        [priceInfoButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.offset(-130);
            make.top.offset(12);
            make.width.offset(70);
            make.height.offset(36);
        }];
        
        UILabel *priceInfoLabel = [[UILabel alloc] init];
        priceInfoLabel.text = @"费用明细";
        priceInfoLabel.textColor = XLColor_subTextColor;
        priceInfoLabel.font = XLFont_subSubTextFont;
        [priceInfoButton addSubview:priceInfoLabel];
        [priceInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(0);
            make.top.bottom.offset(0);
            make.width.offset(55);
        }];
        
        UIImageView *priceInfoImageView = [[UIImageView alloc] init];
        priceInfoImageView.tag = 100;
        priceInfoImageView.image = HHGetImage(@"icon_order_priceInfo_top");
        [priceInfoButton addSubview:priceInfoImageView];
        [priceInfoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(priceInfoLabel.mas_right).offset(0);
            make.centerY.equalTo(priceInfoButton);
            make.width.offset(10);
            make.height.offset(6);
        }];
        
        UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [doneButton setTitle:@"提交订单" forState:UIControlStateNormal];
        [doneButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
        doneButton.titleLabel.font = KBoldFont(16);
        doneButton.layer.cornerRadius = 36/2.0;
        doneButton.layer.masksToBounds = YES;
        doneButton.backgroundColor = UIColorHex(b58e7f);
        [doneButton addTarget:self action:@selector(doneButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:doneButton];
        [doneButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.offset(-15);
            make.top.offset(12);
            make.width.offset(100);
            make.height.offset(36);
        }];
    }
    return _bottomView;
}

- (void)updataUIWithRoomNumber:(NSString *)str withArray:(NSArray *)arr{
    NSDictionary *linkman_info = self.data[@"linkman_info"];
    self.roomNumber = str.integerValue;
    if(self.dateType == 2){
        self.roomNumberResultLabel.text = [NSString stringWithFormat:@"%@人",str];
    }else {
        self.roomNumberResultLabel.text = [NSString stringWithFormat:@"%@间（每间最多住两人）",str];
    }
    for (UIView *view in self.nameView.subviews) {
        [view removeFromSuperview];
    }
    
    if(str.intValue == 1){
        self.nameRightButton.hidden = NO;
        UIButton *nameButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.nameView addSubview:nameButton];
        [nameButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.offset(0);
            make.height.offset(50);
        }];
        
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.textColor = XLColor_subTextColor;
        nameLabel.font = XLFont_subTextFont;
        nameLabel.text = @"住客姓名";
        [nameButton addSubview:nameLabel];
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(15);
            make.centerY.equalTo(nameButton);
            make.height.offset(20);
            make.width.offset(80);
        }];
        
        self.nameTextField = [[UITextField alloc] init];
        self.nameTextField.borderStyle = UITextBorderStyleNone;
        self.nameTextField.font = KBoldFont(14);
        self.nameTextField.textColor = XLColor_mainTextColor;
        self.nameTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入姓名" attributes:@{
            NSForegroundColorAttributeName:XLColor_subSubTextColor
        }];
        if(self.dateType == 2){//民宿
            NSArray *check_in_list = linkman_info[@"check_in_list"];
            NSDictionary *nameDic = check_in_list[1];
            NSArray *nameA = nameDic[@"desc"];
            if(nameA.count != 0){
                self.nameTextField.text = nameA.firstObject;
            }
        }else {
            NSString *linkman_name =  linkman_info[@"linkman_name"];
            if ([linkman_name containsString:@","]) {
                NSArray *linkmanArr = [linkman_name componentsSeparatedByString:@","];
                self.nameTextField.text = linkmanArr.firstObject;
            }else {
                self.nameTextField.text = linkman_name;
            }
        }
        self.nameTextField.textAlignment = NSTextAlignmentLeft;
        self.nameTextField.keyboardType = UIKeyboardTypeTwitter;
        self.nameTextField.autocorrectionType = UITextAutocorrectionTypeNo;
        self.nameTextField.tag = 100;
        self.nameTextField.delegate = self;
        [self.nameTextField addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
        
        self.nameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        [nameButton addSubview:self.nameTextField];
        [self.nameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(nameButton);
            make.height.offset(20);
            make.right.offset(-50);
            make.left.equalTo(nameLabel.mas_right).offset(0);
        }];
        
        self.nameRightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.nameRightButton setImage:HHGetImage(@"icon_home_order_name") forState:UIControlStateNormal];
        [self.nameRightButton addTarget:self action:@selector(nameRightButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [nameButton addSubview:self.nameRightButton];
        [self.nameRightButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(nameButton);
            make.height.offset(25);
            make.width.offset(25);
            make.right.offset(-15);
        }];
        
        [self.nameView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset(50);
        }];
        
        if(self.dateType == 2){//民宿
            [self.centerWhiteView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.offset(198);
            }];
        }else {
            [self.centerWhiteView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.offset(250);
            }];
        }
        
    }else {
        self.nameRightButton.hidden = YES;
        int ybottom = 0;
        for (int i=0; i<str.intValue; i++) {
            UIButton *nameButton = [UIButton buttonWithType:UIButtonTypeCustom];
            nameButton.tag = 10+i;
            [self.nameView addSubview:nameButton];
            [nameButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.offset(0);
                make.top.offset(ybottom);
                make.height.offset(50);
            }];
            
            UILabel *nameLabel = [[UILabel alloc] init];
            nameLabel.textColor = XLColor_subTextColor;
            nameLabel.font = XLFont_subTextFont;
            if(self.dateType == 2){
                nameLabel.text = [NSString stringWithFormat:@"住客姓名%d",i+1];
            }else {
                nameLabel.text = [NSString stringWithFormat:@"房间%d",i+1];
            }
            [nameButton addSubview:nameLabel];
            [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.offset(15);
                make.centerY.equalTo(nameButton);
                make.height.offset(20);
                make.width.offset(80);
            }];
            
            UITextField *nameTextField = [[UITextField alloc] init];
            nameTextField.borderStyle = UITextBorderStyleNone;
            nameTextField.font = KBoldFont(14);
            nameTextField.textColor = XLColor_mainTextColor;
            if(self.dateType == 2){
                nameTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"姓名不能重复" attributes:@{
                    NSForegroundColorAttributeName:XLColor_subSubTextColor
                }];
            }else {
                nameTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"每间填1位住客姓名，不能重复" attributes:@{
                    NSForegroundColorAttributeName:XLColor_subSubTextColor
                }];
            }
            
            nameTextField.textAlignment = NSTextAlignmentLeft;
            nameTextField.keyboardType = UIKeyboardTypeTwitter;
            nameTextField.autocorrectionType = UITextAutocorrectionTypeNo;
            nameTextField.tag = 100+i;
            if(arr.count != 0){
                nameTextField.text = arr[i];
            }else {
                if(i == 0) {
                    if(self.dateType == 2){//民宿
                        NSArray *check_in_list = linkman_info[@"check_in_list"];
                        NSDictionary *nameDic = check_in_list[1];
                        NSDictionary *phoneDic = check_in_list[2];
                        NSArray *nameA = nameDic[@"desc"];
                        if(nameA.count != 0){
                            nameTextField.text = nameA.firstObject;
                        }
                    }else {
                        nameTextField.text = linkman_info[@"linkman_name"];
                    }
                }
            }
            nameTextField.delegate = self;
            [nameTextField addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
            
            nameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
            [nameButton addSubview:nameTextField];
            [nameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(nameButton);
                make.height.offset(20);
                make.right.offset(-15);
                make.left.equalTo(nameLabel.mas_right).offset(0);
            }];
            
            if(i != str.intValue-1){
                UIView *nameBottomLineView = [[UIView alloc] init];
                nameBottomLineView.backgroundColor = XLColor_mainColor;
                [nameButton addSubview:nameBottomLineView];
                [nameBottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.offset(15);
                    make.right.offset(-15);
                    make.height.offset(1);
                    make.bottom.offset(0);
                }];
            }
            ybottom = ybottom+50;
        }
        
        [self.nameView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset(str.intValue*50);
        }];
        
        if(self.dateType == 2){//民宿
            [self.centerWhiteView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.offset(198-50+(str.intValue*50));
            }];
        }else {
            [self.centerWhiteView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.offset(250-50+(str.intValue*50));
            }];
        }
       
    }
}

- (void)nameRightButtonAction {
    if (self.clickNameAction) {
        self.clickNameAction();
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([self isInputRuleNotBlank:string] || [string isEqualToString:@""]) {//当输入符合规则和退格键时允许改变输入框
        return YES;
    }else {
        return NO;
    }
}

- (void)textFieldChanged:(UITextField *)textField {
    
    NSString *toBeString = textField.text;
    
    if (![self isInputRuleAndBlank:toBeString]) {
        
        textField.text = [self disable_emoji:toBeString];
        return;
    }
   
    NSString *lang = [[textField textInputMode] primaryLanguage]; // 获取当前键盘输入模式
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
    }else{
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
-(NSString *)getSubString:(NSString*)string{
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

- (void)priceInfoButtonAction:(UIButton *)button {
    button.selected = !button.selected;
    if (self.clickPriceInfoAction) {
        self.clickPriceInfoAction(button);
    }
   
}

- (void)setPolicy_info:(NSArray *)policy_info {
    _policy_info = policy_info;
    self.readHeight = [self.readView updateDetailSubViews:_policy_info];
    [self.readView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.offset(self.readHeight);
    }];
   
}

- (void)setDateType:(NSInteger)dateType {
    _dateType = dateType;
    self.infoView.dateType = _dateType;
}

- (void)setDic:(NSDictionary *)dic{
    _dic = dic;
    self.infoView.dic = _dic;
    self.priceInfoView.isBackstage = YES;
}

- (void)updataUI:(NSDictionary *)data withRoomNumber:(NSInteger)roomNumber{
    NSDictionary *payment_info = data[@"payment_info"];
    self.priceLabel.text = payment_info[@"payment_price"];
    
    [self.priceInfoView updataUI:data withRoomNumber:roomNumber];
    CGFloat priceInfoHeight = [self.priceInfoView priceInfoHeight];
    [self.priceInfoView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.offset(priceInfoHeight);
    }];
}

@end
