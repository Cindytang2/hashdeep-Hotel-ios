//
//  HHCancelOrderView.m
//  HashdeepHotel
//
//  Created by Cindy on 2022/7/22.
//

#import "HHCancelOrderView.h"
@interface HHCancelOrderView ()
@property (nonatomic, strong) UIView *bottomWhiteView;
@property (nonatomic, strong) UILabel *refundAmountResultLabel;
@property (nonatomic, strong) UILabel *orderPriceResultLabel;
@property (nonatomic, strong) UIView *tagSuperView;
@property (nonatomic, weak) UIButton *selectedBt;
@property (nonatomic, strong) UIButton *doneButton;
@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, copy) NSString *cancel_id;
@property (nonatomic, copy) NSString *cancel_desc;

@end
@implementation HHCancelOrderView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self _addSubViews];
    }
    return self;
}

- (void)_addSubViews{
    
    UIView *topWhiteView = [[UIView alloc] init];
    topWhiteView.backgroundColor = kWhiteColor;
    topWhiteView.layer.cornerRadius = 12;
    topWhiteView.layer.masksToBounds = YES;
    [self addSubview:topWhiteView];
    [topWhiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.offset(-15);
        make.top.offset(15);
        make.height.offset(130);
    }];
    
    UILabel *refundAmountLabel = [[UILabel alloc] init];
    refundAmountLabel.textColor = XLColor_mainTextColor;
    refundAmountLabel.font = KBoldFont(14);
    refundAmountLabel.text = @"退款金额";
    [topWhiteView addSubview:refundAmountLabel];
    [refundAmountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.top.offset(15);
        make.height.offset(20);
    }];
    
    self.refundAmountResultLabel = [[UILabel alloc] init];
    self.refundAmountResultLabel.textColor = UIColorHex(FF7E67);
    self.refundAmountResultLabel.font = KBoldFont(14);
    self.refundAmountResultLabel.textAlignment = NSTextAlignmentRight;
    [topWhiteView addSubview:self.refundAmountResultLabel];
    [self.refundAmountResultLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-15);
        make.top.offset(15);
        make.height.offset(20);
    }];
    
    UILabel *refundLabel = [[UILabel alloc] init];
    refundLabel.textColor = XLColor_subTextColor;
    refundLabel.font = XLFont_subSubTextFont;
    refundLabel.text = @"退回原支付方";
    [topWhiteView addSubview:refundLabel];
    [refundLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.top.equalTo(refundAmountLabel.mas_bottom).offset(15);
        make.height.offset(15);
    }];
    
    UIView *refundBottomLineView = [[UIView alloc] init];
    refundBottomLineView.backgroundColor = XLColor_mainColor;
    [topWhiteView addSubview:refundBottomLineView];
    [refundBottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.top.equalTo(refundLabel.mas_bottom).offset(15);
        make.height.offset(1);
        make.right.offset(-15);
    }];
    
    UILabel *orderPriceLabel = [[UILabel alloc] init];
    orderPriceLabel.textColor = XLColor_subTextColor;
    orderPriceLabel.font = XLFont_subSubTextFont;
    orderPriceLabel.text = @"订单支付金额";
    [topWhiteView addSubview:orderPriceLabel];
    [orderPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.top.equalTo(refundBottomLineView.mas_bottom).offset(15);
        make.height.offset(15);
    }];
    
    self.orderPriceResultLabel = [[UILabel alloc] init];
    self.orderPriceResultLabel.textColor = XLColor_mainTextColor;
    self.orderPriceResultLabel.font = KFont(12);
    [topWhiteView addSubview:self.orderPriceResultLabel];
    [self.orderPriceResultLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-15);
        make.top.equalTo(refundBottomLineView.mas_bottom).offset(15);
        make.height.offset(15);
    }];
    
    self.bottomWhiteView = [[UIView alloc] init];
    self.bottomWhiteView.backgroundColor = kWhiteColor;
    self.bottomWhiteView.layer.cornerRadius = 12;
    self.bottomWhiteView.layer.masksToBounds = YES;
    [self addSubview:self.bottomWhiteView];
    [self.bottomWhiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.offset(-15);
        make.top.equalTo(topWhiteView.mas_bottom).offset(15);
        make.height.offset(120);
    }];
    
    UILabel *cancelDetailLabel = [[UILabel alloc] init];
    cancelDetailLabel.textColor = XLColor_mainTextColor;
    cancelDetailLabel.font = KBoldFont(14);
    cancelDetailLabel.text = @"取消订单原因";
    [self.bottomWhiteView addSubview:cancelDetailLabel];
    [cancelDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.top.offset(15);
        make.height.offset(20);
    }];
    
    UIView *cancelDetailBottomLineView = [[UIView alloc] init];
    cancelDetailBottomLineView.backgroundColor = XLColor_mainColor;
    [self.bottomWhiteView addSubview:cancelDetailBottomLineView];
    [cancelDetailBottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.top.equalTo(cancelDetailLabel.mas_bottom).offset(15);
        make.height.offset(1);
        make.right.offset(-15);
    }];
    
    self.tagSuperView = [[UIView alloc] init];
    [self.bottomWhiteView addSubview:self.tagSuperView];
    [self.tagSuperView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.top.equalTo(cancelDetailBottomLineView.mas_bottom).offset(15);
        make.height.offset(100);
        make.right.offset(0);
    }];
    
    self.doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.doneButton setTitle:@"请选择取消原因" forState:UIControlStateNormal];
    self.doneButton.backgroundColor = kLightGrayColor;
    [self.doneButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
    self.doneButton.titleLabel.font = XLFont_subTextFont;
    self.doneButton.layer.cornerRadius = 45/2.0;
    self.doneButton.layer.masksToBounds = YES;
    [self.doneButton addTarget:self action:@selector(doneButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.doneButton];
    [self.doneButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        if (UINavigateTop == 44) {
            make.bottom.offset(-40);
        }else {
            make.bottom.offset(-20);
        }
        make.height.offset(45);
        make.right.offset(-15);
    }];
}

- (void)setData:(NSDictionary *)data {
    _data = data;
    
    NSDictionary *refund_payment = _data[@"refund_payment"];
    self.refundAmountResultLabel.text = refund_payment[@"totle_price"];
    self.orderPriceResultLabel.text = refund_payment[@"order_price"];
    
    NSArray *refund_pay_result = _data[@"refund_pay_result"];
    int xLeft = 15;
    int ybottom = 0;
    int lineNumber = 1;
    for (int i=0; i<refund_pay_result.count; i++) {
        NSDictionary *dic = refund_pay_result[i];
        if (xLeft+(kScreenWidth-60-14)/3 > kScreenWidth-15) {
            xLeft = 15;
            lineNumber++;
            ybottom = lineNumber+45+10;
        }
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:dic[@"desc"] forState:UIControlStateNormal];
        [button setTitleColor:XLColor_mainTextColor forState:UIControlStateNormal];
        button.titleLabel.font = XLFont_subSubTextFont;
        button.backgroundColor = XLColor_mainColor;
        button.tag = i;
        button.layer.borderWidth = 1;
        button.layer.borderColor = RGBColor(243, 243, 243).CGColor;
        button.layer.cornerRadius = 5;
        button.layer.masksToBounds = YES;
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.tagSuperView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(xLeft);
            make.width.offset((kScreenWidth-60-14)/3);
            make.top.offset(ybottom);
            make.height.offset(45);
        }];
        xLeft = xLeft+(kScreenWidth-60-14)/3+7;
        
        UIImageView *imgView = [[UIImageView alloc] init];
        imgView.image = HHGetImage(@"icon_home_screen_selected");
        imgView.tag = 400;
        imgView.hidden = YES;
        [button addSubview:imgView];
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.offset(0);
            make.width.offset(15);
            make.height.offset(13);
            make.bottom.offset(0);
        }];
    }
    
    [self.tagSuperView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.offset(45+lineNumber*45+lineNumber*10-10);
    }];
    
    [self.bottomWhiteView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.offset(45+lineNumber*45+lineNumber*10-10+51);
    }];
}

- (void)buttonAction:(UIButton *)button {
    
    self.isSelected = YES;
    UIImageView *buttom_ImgView = [self.selectedBt viewWithTag:400];
    buttom_ImgView.hidden = YES;
    self.selectedBt.layer.borderColor = RGBColor(243, 243, 243).CGColor;
    self.selectedBt.selected = NO;
    button.selected = YES;
    self.selectedBt = button;
    if (self.selectedBt.selected) {
        self.selectedBt.layer.borderColor = UIColorHex(b58e7f).CGColor;
        UIImageView *imgView = [self.selectedBt viewWithTag:400];
        imgView.hidden = NO;
    }
    
    NSArray *refund_pay_result = self.data[@"refund_pay_result"];
    NSDictionary *dic = refund_pay_result[button.tag];
    self.cancel_desc = dic[@"desc"];
    self.cancel_id = dic[@"cancel_id"];
    self.doneButton.backgroundColor = UIColorHex(b58e7f);
    [self.doneButton setTitle:@"确定" forState:UIControlStateNormal];
}

- (void)doneButtonAction:(UIButton *)button {
    button.enabled = NO;
    if (!self.isSelected) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            button.enabled = YES;
        });
        return;
    }
    
    NSString *url = [NSString stringWithFormat:@"%@/hotel/order",BASE_URL];
    NSMutableDictionary *dic = @{}.mutableCopy;
    [dic setValue:@"05" forKey:@"order_status"];
    [dic setValue:self.order_id forKey:@"order_id"];
    [dic setValue:self.cancel_id forKey:@"cancel_id"];
    [dic setValue:self.cancel_desc forKey:@"cancel_desc"];
    WeakSelf(weakSelf)
    [PPHTTPRequest requestPostWithJSONForUrl:url parameters:dic success:^(id  _Nonnull response) {
        NSLog(@"response====%@",response);
        NSString *code = [NSString stringWithFormat:@"%@", response[@"code"]];
        if ([code isEqualToString:@"0"]) {//请求成功
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                button.enabled = YES;
            });
            if(self.clickDoneAction){
                self.clickDoneAction();
            }
        }else {
            [self makeToast:response[@"msg"] duration:2 position:CSToastPositionCenter];
        }
    } failure:^(NSError * _Nonnull error) {
        
    }];
    
    
}
@end
