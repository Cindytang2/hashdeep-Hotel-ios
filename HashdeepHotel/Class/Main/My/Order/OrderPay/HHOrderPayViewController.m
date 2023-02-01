//
//  HHOrderPayViewController.m
//  HashdeepHotel
//
//  Created by Cindy on 2022/7/21.
//

#import "HHOrderPayViewController.h"
#import "WXApi.h"
#import <AlipaySDK/AlipaySDK.h>
#import "HHOrderDetailViewController.h"
#import "NSString+URL.h"
@interface HHOrderPayViewController ()
@property (nonatomic, strong) UILabel *subTitleLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *hotelLabel;
@property (nonatomic, weak) UIButton *selectedBt;
@property (nonatomic, strong) NSTimer *smsTimer;///<计时器
@property (nonatomic, assign) NSInteger countDownTime;///<倒计时时间
@property (nonatomic, assign) NSInteger payNumber;//1 支付宝  2.微信

@end
@implementation HHOrderPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = XLColor_mainColor;
    
    //自定义导航栏
    [self _createdNavigationBar];
    self.payNumber = 1;
    
    [self _loadData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goOrderVC) name:@"paySuccessNotification" object:nil];
}

-(void)goOrderVC{
    NSString *url = [NSString stringWithFormat:@"%@/hotel/order/status",BASE_URL];
    
    NSMutableDictionary *dic = @{}.mutableCopy;
    [dic setValue:self.order_id forKey:@"order_id"];
    
    [PPHTTPRequest requestPostWithJSONForUrl:url parameters:dic success:^(id  _Nonnull response) {
        NSString *code = [NSString stringWithFormat:@"%@", response[@"code"]];
        NSLog(@"支付结果=====%@",response);
        if ([code isEqualToString:@"0"]) {//请求成功
            HHOrderDetailViewController *vc = [[HHOrderDetailViewController alloc] init];
            vc.dateType = self.dateType;
            vc.backType = self.backType;
            vc.order_id = self.order_id;
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            [self.view makeToast:response[@"msg"] duration:2 position:CSToastPositionCenter];
        }
        
    } failure:^(NSError * _Nonnull error) {
        
    }];
}

- (void)_loadData {
    
    NSString *url = [NSString stringWithFormat:@"%@/hotel/order/page/pay",BASE_URL];
    NSMutableDictionary *dic = @{}.mutableCopy;
    [dic setValue:self.order_id forKey:@"order_id"];
    [PPHTTPRequest requestPostWithJSONForUrl:url parameters:dic success:^(id  _Nonnull response) {
        
        NSString *code = [NSString stringWithFormat:@"%@", response[@"code"]];
        if ([code isEqualToString:@"0"]) {//请求成功
            
            NSDictionary *data = response[@"data"];
            //创建Views
            [self _createdViews:data];
        }else {
            [self.view makeToast:response[@"msg"] duration:2 position:CSToastPositionCenter];
        }
    } failure:^(NSError * _Nonnull error) {
        
    }];
    
}
#pragma mark -----------------------自定义导航栏-----------------------
- (void)_createdNavigationBar {
    
    [self createdNavigationBackButton];
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"安全支付";
    titleLabel.textColor = XLColor_mainTextColor;
    titleLabel.font = KBoldFont(18);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.offset(UINavigateTop+10);
        make.height.offset(20);
    }];
    
    UIView *lineView = [[UIView alloc ] init];
    lineView.backgroundColor = RGBColor(243, 244, 247);
    lineView.layer.shadowColor = kBlackColor.CGColor;
    //shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用  (0,0)时是四周都有阴影
    lineView.layer.shadowOffset = CGSizeMake(0, 1);
    //阴影透明度，默认0
    lineView.layer.shadowOpacity = 0.3;
    //阴影半径，默认3
    lineView.layer.shadowRadius = 1;
    [self.view addSubview: lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.offset(UINavigateHeight);
        make.height.offset(1);
    }];
}

#pragma mark ---------------------创建Views---------------------
- (void)_createdViews:(NSDictionary *)dic {
    self.subTitleLabel = [[UILabel alloc] init];
    self.subTitleLabel.textColor = XLColor_subTextColor;
    self.subTitleLabel.font = XLFont_subTextFont;
    self.subTitleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.subTitleLabel];
    [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.offset(UINavigateHeight+70);
        make.height.offset(20);
    }];
    
    //后台返回的截止时间的时间戳
    NSString *remaining_time =[NSString stringWithFormat:@"%@", dic[@"remaining_time"]];
    NSString *now_time_stamp =[NSString stringWithFormat:@"%@", dic[@"now_time_stamp"]];
    
    self.countDownTime = remaining_time.integerValue - now_time_stamp.integerValue;
    if (_smsTimer) {
        [_smsTimer invalidate];
        _smsTimer = nil;
    }
    _smsTimer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(onTimer:) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_smsTimer forMode:NSRunLoopCommonModes];
    
    self.priceLabel = [[UILabel alloc] init];
    self.priceLabel.text = dic[@"total_price"];
    self.priceLabel.textColor = UIColorHex(FF7E67);
    self.priceLabel.font = KBoldFont(30);
    self.priceLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.priceLabel];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.equalTo(self.subTitleLabel.mas_bottom).offset(15);
        make.height.offset(30);
    }];
    
    self.hotelLabel = [[UILabel alloc] init];
    self.hotelLabel.text = dic[@"hotel_name"];
    self.hotelLabel.textColor = XLColor_subTextColor;
    self.hotelLabel.font = XLFont_subTextFont;
    self.hotelLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.hotelLabel];
    [self.hotelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.equalTo(self.priceLabel.mas_bottom).offset(15);
        make.height.offset(20);
    }];
    
    UIView *whiteView = [[UIView alloc] init];
    whiteView.backgroundColor = kWhiteColor;
    whiteView.layer.cornerRadius = 12;
    whiteView.layer.masksToBounds = YES;
    [self.view addSubview:whiteView];
    [whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.offset(-15);
        make.height.offset(121);
        make.top.equalTo(self.hotelLabel.mas_bottom).offset(50);
    }];
    
    UIView *lineView = [[UIView alloc ] init];
    lineView.backgroundColor = XLColor_mainColor;
    [whiteView addSubview: lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.offset(60);
        make.height.offset(1);
    }];
    
    NSArray *array = @[
        @{ @"icon":@"icon_my_order_alipay",
           @"title":@"支付宝支付"
        },
        @{ @"icon":@"icon_my_order_wechat",
           @"title":@"微信支付"
        }
    ];
    int ybottom = 0;
    for (int i=0 ; i<array.count; i++) {
        NSDictionary *dic = array[i];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = i;
        if (i == 0) {
            button.selected = YES;
            self.selectedBt = button;
        }
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [whiteView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.offset(0);
            make.height.offset(60);
            make.top.offset(ybottom);
        }];
        
        UIImageView *imgView = [[UIImageView alloc] init];
        imgView.image = HHGetImage(dic[@"icon"]);
        imgView.userInteractionEnabled = YES;
        imgView.contentMode = UIViewContentModeScaleAspectFit;
        [button addSubview:imgView];
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(15);
            make.height.offset(23);
            make.width.offset(20);
            make.centerY.equalTo(button);
        }];
        
        UILabel *label = [[UILabel alloc] init];
        label.text = dic[@"title"];
        label.textColor = XLColor_subTextColor;
        label.font = XLFont_subTextFont;
        [button addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(imgView.mas_right).offset(15);
            make.top.bottom.offset(0);
            make.right.offset(-40);
        }];
        
        UIImageView *selectedImageView = [[UIImageView alloc] init];
        selectedImageView.tag = 100;
        if (i == 0) {
            selectedImageView.image = HHGetImage(@"icon_my_history_selected");
        }else {
            selectedImageView.image = HHGetImage(@"icon_my_history_normal");
        }
        [button addSubview:selectedImageView];
        [selectedImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(button);
            make.width.height.offset(20);
            make.right.offset(-15);
        }];
        
        ybottom = ybottom+60;
    }
    
    UIButton *payButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [payButton setTitle:[NSString stringWithFormat:@"支付%@", dic[@"total_price"]] forState:UIControlStateNormal];
    [payButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
    payButton.backgroundColor = UIColorHex(b58e7f);
    payButton.layer.cornerRadius = 8;
    payButton.layer.masksToBounds = YES;
    payButton.titleLabel.font = XLFont_mainTextFont;
    payButton.layer.shadowColor = kBlackColor.CGColor;
    //shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用  (0,0)时是四周都有阴影
    payButton.layer.shadowOffset = CGSizeMake(0, 0);
    //阴影透明度，默认0
    payButton.layer.shadowOpacity = 0.3;
    //阴影半径，默认3
    payButton.clipsToBounds = NO;
    payButton.layer.shadowRadius = 3;
    [payButton addTarget:self action:@selector(payButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:payButton];
    [payButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.offset(-15);
        make.height.offset(45);
        if(UINavigateTop == 44) {
            make.bottom.offset(-40);
        }else {
            make.bottom.offset(-20);
        }
    }];
}

- (void)buttonAction:(UIButton *)button {
    UIImageView *imgView = [self.selectedBt viewWithTag:100];
    imgView.image = HHGetImage(@"icon_my_history_normal");
    self.selectedBt.selected = NO;
    button.selected = YES;
    self.selectedBt = button;
    if (self.selectedBt.selected) {
        UIImageView *imageView = [self.selectedBt viewWithTag:100];
        imageView.image = HHGetImage(@"icon_my_history_selected");
    }
    
    if (button.tag == 0) {
        self.payNumber = 1;
    }else {
        self.payNumber = 2;
    }
}

- (void)payButtonAction{
    
    if (self.payNumber == 1) {
        
        NSURL * url = [NSURL URLWithString:@"alipay://"];//注意设置白名单
        if (![[UIApplication sharedApplication]canOpenURL:url]) {//未安装
            [self.view makeToast:@"支付宝未安装，请安装后重试" duration:2 position:CSToastPositionCenter];
            return;
        }else {
            
            NSString *unencodedString = [NSString stringWithFormat:@"order_id=%@&token=%@",self.order_id,[UserInfoManager sharedInstance].jwtToken];
            NSString *encodedString = [unencodedString URLEncodedString];
            
            NSString *urlString = [NSString stringWithFormat:@"alipays://platformapi/startapp?appId=2021003145678448&page=pages/pay/pay&query=%@",encodedString];
            NSURL *url = [NSURL URLWithString:urlString];
            [[UIApplication sharedApplication] openURL:url options:nil completionHandler:^(BOOL success) {
                
            }];
            
            
            //            NSString *url = [NSString stringWithFormat:@"%@/hotel/order",BASE_URL];
            //            NSString *appScheme = @"HashdeepHotels";
            //            NSMutableDictionary *dic = @{}.mutableCopy;
            //            [dic setValue:self.order_id forKey:@"order_id"];
            //            [dic setValue:@"alipay" forKey:@"pay_type"];
            //            [dic setValue:@"01" forKey:@"order_status"];
            //            NSString *str = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:dic options:0 error:nil] encoding:NSUTF8StringEncoding];
            //            WeakSelf(weakSelf)
            //            [PPHTTPRequest requestPostWithJSONForUrl:url parameters:str success:^(id  _Nonnull response) {
            //                NSLog(@"支付宝支付====%@",response);
            //                NSString *code = [NSString stringWithFormat:@"%@", response[@"code"]];
            //
            //                if ([code isEqualToString:@"0"]) {//请求成功
            //                    NSDictionary *data = response[@"data"];
            //                    NSString *pay_msg = data[@"pay_msg"][@"pay_msg"];
            //                    [[AlipaySDK defaultService] payOrder:pay_msg fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            //
            //                    }];
            //                } else {
            //                    [self.view makeToast:response[@"msg"] duration:2 position:CSToastPositionCenter];
            //                }
            //
            //            } failure:^(NSError * _Nonnull error) {
            //                dispatch_async(dispatch_get_main_queue(), ^{
            //                    [self.view makeToast:@"网络异常，请检查网络后重试" duration:2 position:CSToastPositionCenter];
            //                });
            //            }];
        }
        
        
        
    }else {
        
        if([WXApi isWXAppInstalled] == YES){
            
            WXLaunchMiniProgramReq *launchMiniProgramReq = [WXLaunchMiniProgramReq object];
            launchMiniProgramReq.userName = @"gh_a229cd41f60f";  //拉起的小程序的username
            launchMiniProgramReq.path = [NSString stringWithFormat:@"pages/pay/pay?order_id=%@&token=%@",self.order_id,[UserInfoManager sharedInstance].jwtToken];    ////拉起小程序页面的可带参路径，不填默认拉起小程序首页，对于小游戏，可以只传入 query 部分，来实现传参效果，如：传入 "?foo=bar"。
            //            launchMiniProgramReq.miniProgramType = miniProgramType; //拉起小程序的类型
            return [WXApi sendReq:launchMiniProgramReq completion:^(BOOL success) {
                
            }];
            
            //            //调起微信支付
            //            PayReq* req= [[PayReq alloc] init];
            //
            //            NSString *url = [NSString stringWithFormat:@"%@/hotel/order",BASE_URL];
            //            NSMutableDictionary *dic = @{}.mutableCopy;
            //            [dic setValue:self.order_id forKey:@"order_id"];
            //            [dic setValue:@"wxpay" forKey:@"pay_type"];
            //            [dic setValue:@"01" forKey:@"order_status"];
            //            NSString *str = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:dic options:0 error:nil] encoding:NSUTF8StringEncoding];
            //
            //            [PPHTTPRequest requestPostWithJSONForUrl:url parameters:str success:^(id  _Nonnull response) {
            //                NSLog(@"微信支付====%@",response);
            //                NSString *code = [NSString stringWithFormat:@"%@", response[@"code"]];
            //
            //                if ([code isEqualToString:@"0"]) {//请求成功
            //
            //                    NSMutableString *stamp  = [response[@"data"][@"pay_msg"] objectForKey:@"time_stamp"];
            //                    req.partnerId = [response[@"data"][@"pay_msg"] objectForKey:@"paraten_id"];
            //                    req.prepayId  = [response[@"data"][@"pay_msg"] objectForKey:@"prepay_id"];
            //                    req.nonceStr = [response[@"data"][@"pay_msg"] objectForKey:@"nonce_str"];
            //                    req.timeStamp  = stamp.intValue;
            //                    req.package = [response[@"data"][@"pay_msg"] objectForKey:@"package"];
            //                    req.sign = [response[@"data"][@"pay_msg"] objectForKey:@"sign"];
            //                    [WXApi sendReq:req completion:^(BOOL success) {
            //                        NSLog(@"111");
            //                    }];
            //
            //                } else {
            //                    [self.view makeToast:response[@"msg"] duration:2 position:CSToastPositionCenter];
            //                }
            //
            //            } failure:^(NSError * _Nonnull error) {
            //                dispatch_async(dispatch_get_main_queue(), ^{
            //                    [self.view makeToast:@"网络异常，请检查网络后重试" duration:2 position:CSToastPositionCenter];
            //                });
            //            }];
        }else {
            [self.view makeToast:@"微信未安装，请安装后重试" duration:2 position:CSToastPositionCenter];
            return;
        }
    }
    
}

- (void)onTimer:(NSTimer *)timer{
    self.countDownTime = self.countDownTime - 1;
    if (self.countDownTime <= 0) {
        [_smsTimer invalidate];
        _smsTimer = nil;
    }else{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *endTime = [self time:self.countDownTime];
            self.subTitleLabel.text = [NSString stringWithFormat:@"支付剩余时间：%@",endTime];
        });
    }
}
- (NSString *)time:(NSInteger)time{
    //format of hour
    NSString *str_hour = [NSString stringWithFormat:@"%02ld",time/3600];
    //format of minute
    NSString *str_minute = [NSString stringWithFormat:@"%02ld",(time%3600)/60];
    //format of second
    NSString *str_second = [NSString stringWithFormat:@"%02ld",time%60];
    //format of time
    NSString *format_time = [NSString stringWithFormat:@"%@:%@",str_minute,str_second];
    return format_time;
}

@end
