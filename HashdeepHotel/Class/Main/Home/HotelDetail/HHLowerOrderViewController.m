//
//  HHLowerOrderViewController.m
//  HashdeepHotel
//
//  Created by Cindy on 2022/7/28.
//

#import "HHLowerOrderViewController.h"
#import "HHLowerOrderView.h"
#import "HHRoomInfoView.h"
#import "HHRoomNumberView.h"

#import "HHBookRoomReadView.h"
#import "HHTimeView.h"
#import "HHOrderPayViewController.h"
#import "HHOrderNameView.h"
#import "HHOrderNameModel.h"
#import "HHOrderViewController.h"
#import "HHPriceInfoView.h"
@interface HHLowerOrderViewController ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) HHLowerOrderView *lowerOrderView;  ///整体View
@property (nonatomic, strong) HHRoomInfoView *roomInfoView;  ///房型详情View
@property (nonatomic, strong) HHRoomNumberView *roomNumberView;  ///房间数量View
@property (nonatomic, strong) HHBookRoomReadView *bookRoomReadView;  ///订房必读View
@property (nonatomic, strong) HHOrderNameView *orderNameView;
@property (nonatomic, strong) HHTimeView *timeView;  ///入住时间View
@property (nonatomic, strong) HHPriceInfoView *priceInfoView;
@property (nonatomic, assign) NSInteger room_num;
@property (nonatomic, assign) NSInteger pre_checkin_time;
@property (nonatomic, copy) NSString *linkman_name;
@property (nonatomic, copy) NSString *temp_order_id;
@end

@implementation HHLowerOrderViewController

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = XLColor_mainColor;
    
    //默认房间数量为1
    self.room_num = 1;
    
    //自定义导航栏
    [self _createdNavigationBar];
    
    //创建UI
    [self _createdViews];
    
    //网络请求
    [self _loadData:self.room_num];
    
    [self _loadNameData];
}

- (void)_loadNameData {
    NSString *url = [NSString stringWithFormat:@"%@/hotel/order/link/list",BASE_URL];
    
    [PPHTTPRequest requestGetWithURL:url parameters:@{} success:^(id  _Nonnull response) {
        NSLog(@"姓名=======%@", response);
        NSString *code = [NSString stringWithFormat:@"%@", response[@"code"]];
        if ([code isEqualToString:@"0"]) {//请求成功
            NSMutableArray *array = [NSMutableArray array];
            NSArray *data = response[@"data"];
            if (data.count !=0) {
                [array addObjectsFromArray:[HHOrderNameModel mj_objectArrayWithKeyValuesArray:data]];
            }
            for (int i= 0; i<array.count; i++) {
                HHOrderNameModel *model = array[i];
                if(i == 0){
                    model.isSelected = YES;
                }
            }
            self.orderNameView.dataArray = array;
            [self.orderNameView.tableView reloadData];
            
        }else {
            [self.view makeToast:response[@"msg"] duration:2 position:CSToastPositionCenter];
        }
    } failure:^(NSError * _Nonnull error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view makeToast:@"网络异常，请检查网络后重试" duration:2 position:CSToastPositionCenter];
        });
    }];
}

#pragma mark -----------------------自定义导航栏-----------------------
- (void)_createdNavigationBar {
    
    UIView *navView = [[UIView alloc] init];
    navView.backgroundColor = UIColorHex(49494B);
    [self.view addSubview:navView];
    [navView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.offset(0);
        make.height.offset(UINavigateHeight);
    }];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton addTarget:self action:@selector(backButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [backButton setImage:HHGetImage(@"icon_my_order_back") forState:UIControlStateNormal];
    [self.view addSubview:backButton];
    [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.top.offset(UINavigateTop);
        make.width.offset(55);
        make.height.offset(44);
    }];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.textColor = kWhiteColor;
    self.titleLabel.font = KBoldFont(18);
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.offset(UINavigateTop+10);
        make.height.offset(20);
    }];
}

- (void)backButtonAction {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark --------------创建Views---------------
- (void)_createdViews {
    WeakSelf(weakSelf)
    
    ///整体View
    self.lowerOrderView = [[HHLowerOrderView alloc] init];
    self.lowerOrderView.dateType = self.dateType;
    if(self.isBackstage){
        self.lowerOrderView.dic = self.dic;
    }
    [self.view addSubview:self.lowerOrderView];
    [self.lowerOrderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.offset(0);
        make.top.offset(UINavigateHeight);
    }];
    
    ///房型详情View
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    self.roomInfoView = [[HHRoomInfoView alloc] init];
    self.roomInfoView.hidden = YES;
    self.roomInfoView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    self.roomInfoView.clickCloseButton = ^{
        weakSelf.roomInfoView.hidden = YES;
    };
    [keyWindow addSubview:self.roomInfoView];
    [self.roomInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.top.offset(0);
    }];
    
    ///房间数量View
    self.roomNumberView = [[HHRoomNumberView alloc] init];
    self.roomNumberView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    self.roomNumberView.hidden = YES;
    self.roomNumberView.clickCloseButton = ^{
        weakSelf.roomNumberView.hidden = YES;
    };
    self.roomNumberView.clickButtonAction = ^(NSString * _Nonnull str) {
        weakSelf.room_num = str.integerValue;
        weakSelf.roomNumberView.hidden = YES;
        [weakSelf.lowerOrderView updataUIWithRoomNumber:str withArray:@[]];
        if(weakSelf.dateType != 2){
            [weakSelf _loadDataForRoomNumber:str];
        }
    };
    [keyWindow addSubview:self.roomNumberView];
    [self.roomNumberView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.top.offset(0);
    }];
    
    ///订房必读View
    self.bookRoomReadView = [[HHBookRoomReadView alloc] init];
    self.bookRoomReadView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    self.bookRoomReadView.hidden = YES;
    self.bookRoomReadView.clickCloseButton = ^{
        weakSelf.bookRoomReadView.hidden = YES;
    };
    [keyWindow addSubview:self.bookRoomReadView];
    [self.bookRoomReadView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.top.offset(0);
    }];
    
    ///入住时间View
    self.timeView = [[HHTimeView alloc] init];
    self.timeView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    self.timeView.dateType = self.dateType;
    self.timeView.hidden = YES;
    self.timeView.clickCloseButton = ^{
        weakSelf.timeView.hidden = YES;
    };
    self.timeView.clickButtonAction = ^(NSDictionary * _Nonnull dic) {
        weakSelf.timeView.hidden = YES;
        weakSelf.lowerOrderView.timeResultLabel.text = dic[@"time_desc"];
    };
    [keyWindow addSubview:self.timeView];
    [self.timeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.top.offset(0);
    }];
    
    self.orderNameView = [[HHOrderNameView alloc] init];
    self.orderNameView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    self.orderNameView.hidden = YES;
    self.orderNameView.clickCloseButton = ^{
        weakSelf.orderNameView.hidden = YES;
    };
    self.orderNameView.selectedSuccess = ^(NSString * _Nonnull name) {
        weakSelf.orderNameView.hidden = YES;
        weakSelf.lowerOrderView.nameTextField.text = name;
        weakSelf.linkman_name = name;
    };
    [keyWindow addSubview:self.orderNameView];
    [self.orderNameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.top.offset(0);
    }];
    
    self.priceInfoView = [[HHPriceInfoView alloc] init];
    if(self.isBackstage){
        self.priceInfoView.isBackstage = YES;
    }
    
    self.priceInfoView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    self.priceInfoView.hidden = YES;
    self.priceInfoView.clickCloseButton = ^{
        weakSelf.priceInfoView.hidden = YES;
    };
    [keyWindow addSubview:self.priceInfoView];
    [self.priceInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.offset(0);
        if (UINavigateTop == 44) {
            make.bottom.offset(-80);
        }else {
            make.bottom.offset(-60);
        }
    }];
}

#pragma  mark ----------------网络请求----------------
- (void)_loadData:(NSInteger )room_num {
    NSString *url;
    NSMutableDictionary *dic = @{}.mutableCopy;
    if(self.dateType == 2){
        
        url = [NSString stringWithFormat:@"%@/homestay/order/request",BASE_URL];
        [dic setValue:self.homestay_id forKey:@"homestay_id"];
        [dic setValue:self.homestay_room_id forKey:@"homestay_room_id"];
        [dic setValue:@(self.start_date) forKey:@"start_date"];
        [dic setValue:@(self.end_date) forKey:@"end_date"];
    }else {
        url = [NSString stringWithFormat:@"%@/hotel/order/request",BASE_URL];
        [dic setValue:self.hotel_id forKey:@"hotel_id"];
        [dic setValue:self.quote_id forKey:@"quote_id"];
        [dic setValue:@(self.start_date) forKey:@"start_date"];
        [dic setValue:@(self.end_date) forKey:@"end_date"];
        [dic setValue:@(room_num) forKey:@"room_num"];
        [dic setValue:@(self.is_modify) forKey:@"is_modify"];
        if (self.is_modify) {
            [dic setValue:self.old_order_id forKey:@"old_order_id"];
        }
    }
    
    WeakSelf(weakSelf)
    [PPHTTPRequest requestPostWithJSONForUrl:url parameters:dic success:^(id  _Nonnull response) {
        
        NSString *code = [NSString stringWithFormat:@"%@", response[@"code"]];
        if ([code isEqualToString:@"0"]) {//请求成功
            
            NSDictionary *data = response[@"data"];
            if(self.dateType == 2){
                self.titleLabel.text = data[@"homestay_room_name"];
            }else {
                self.titleLabel.text = data[@"hotel_name"];
            }
            
            NSDictionary *policy = data[@"policy"];
            NSDictionary *time_info = data[@"time_info"];
            NSArray *time_list = time_info[@"time_list"];
            self.pre_checkin_time = [NSString stringWithFormat:@"%@", time_list.firstObject[@"timestamp"]].integerValue;
            self.temp_order_id = data[@"temp_order_id"];
            self.bookRoomReadView.policy_info = policy[@"info_list"];
            self.lowerOrderView.policy_info = policy[@"info_list"];
            self.timeView.time_list = time_list;
            if(self.dateType == 0){
                self.timeView.info_desc = time_info[@"info_desc"];
            }
            self.lowerOrderView.data = data;
            self.priceInfoView.data = data;
            NSDictionary *linkman_info = data[@"linkman_info"];
            
            if(self.dateType == 2){
                NSArray *check_in_list = linkman_info[@"check_in_list"];
                NSDictionary *nameDic = check_in_list[1];
                NSArray *nameA = nameDic[@"desc"];
                if(nameA.count != 0){
                    self.linkman_name = nameA.firstObject;
                }
                weakSelf.roomNumberView.index = 0;
                NSString *accommodate = [NSString stringWithFormat:@"%@", linkman_info[@"accommodate"]];
                    self.roomNumberView.remaining_room_num = accommodate;
            }else {
                self.linkman_name = linkman_info[@"linkman_name"];
                NSArray *linkmanArr = [self.linkman_name componentsSeparatedByString:@","];
                if(linkmanArr.count != 0){
                    self.linkman_name = linkmanArr.firstObject;
                    [weakSelf.lowerOrderView updataUIWithRoomNumber:[NSString stringWithFormat:@"%ld",linkmanArr.count] withArray:linkmanArr];
                    [weakSelf _loadDataForRoomNumber:[NSString stringWithFormat:@"%ld",linkmanArr.count]];
                    weakSelf.roomNumberView.index = linkmanArr.count-1;
                }else {
                    weakSelf.roomNumberView.index = 0;
                }
                
                NSString *remaining_room_num = [NSString stringWithFormat:@"%@", data[@"remaining_room_num"]];
                if(remaining_room_num.intValue >= 10){
                    self.roomNumberView.remaining_room_num = @"10";
                }else {
                    self.roomNumberView.remaining_room_num = remaining_room_num;
                }
            }
            
            //房间详情
            self.lowerOrderView.clickRoomDetailAction = ^(UIButton * _Nonnull button) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    button.enabled = YES;
                });
                if(weakSelf.dateType == 2){
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                }else {
                    [weakSelf _loadRoomInfoData:data[@"room_id"] quote_id:weakSelf.quote_id];
                }
            };
            //房间数量
            self.lowerOrderView.clickRoomNumberAction = ^{
                if(weakSelf.dateType == 2){
                    weakSelf.roomNumberView.titleStr = @"入住人数";
                }else {
                    weakSelf.roomNumberView.titleStr = @"房间数量";
                }
                weakSelf.roomNumberView.hidden = NO;
            };
            //订房必读
            self.lowerOrderView.clickBookRoomReadAction = ^(UIButton * _Nonnull button) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    button.enabled = YES;
                });
                weakSelf.bookRoomReadView.hidden = NO;
            };
            //入住时间
            self.lowerOrderView.clickTimeAction = ^{
                weakSelf.timeView.hidden = NO;
            };
            self.lowerOrderView.clickPriceInfoAction = ^(UIButton * _Nonnull button) {
                UIImageView *imgView = [button viewWithTag:100];
                if(button.selected){
                    imgView.image = HHGetImage(@"icon_order_priceInfo_down");
                    weakSelf.priceInfoView.hidden = NO;
                }else{
                    imgView.image = HHGetImage(@"icon_order_priceInfo_top");
                    weakSelf.priceInfoView.hidden = YES;
                }
                
            };
            self.lowerOrderView.clickNameAction = ^{
                weakSelf.orderNameView.hidden = NO;
                for (HHOrderNameModel *mm in weakSelf.orderNameView.dataArray) {
                    mm.isSelected = NO;
                }
                
                for (int i= 0; i<weakSelf.orderNameView.dataArray.count; i++) {
                    HHOrderNameModel *model = weakSelf.orderNameView.dataArray[i];
                    if([model.link_man isEqualToString:weakSelf.linkman_name]){
                        model.isSelected = YES;
                    }
                }
                [weakSelf.orderNameView.tableView reloadData];
            };
            
            //提交订单
            self.lowerOrderView.clickDoneAction = ^(NSArray * _Nonnull nameArr, NSString * _Nonnull phone, UITextField * _Nonnull nameTextFiled, UITextField * _Nonnull phoneTextFiled, UIButton * _Nonnull button) {
                
                weakSelf.priceInfoView.hidden = YES;
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    button.enabled = YES;
                });
                [weakSelf _createdOrder:nameArr telephone:phone];
            };
            
        }else {
            [self.view makeToast:response[@"msg"] duration:2 position:CSToastPositionCenter];
        }
    } failure:^(NSError * _Nonnull error) {
        
    }];
    
}

- (void)_createdOrder:(NSArray *)link_man telephone:(NSString *)telephone {
    NSString *url;
    NSMutableDictionary *dic = @{}.mutableCopy;
    if(self.dateType == 2){
        url = [NSString stringWithFormat:@"%@/homestay/order/create",BASE_URL];
        [dic setValue:self.temp_order_id forKey:@"order_id"];
        [dic setValue:@(self.room_num) forKey:@"human_num"];
        [dic setValue:self.homestay_id forKey:@"homestay_id"];
        [dic setValue:self.homestay_room_id forKey:@"homestay_room_id"];
    }else {
        url = [NSString stringWithFormat:@"%@/hotel/order",BASE_URL];
        
        if(self.doneType == 5){
            [dic setValue:@"03" forKey:@"order_status"];//修改订单
            [dic setValue:self.old_order_id forKey:@"order_id"];
        }else{
            [dic setValue:@"00" forKey:@"order_status"];//创建订单
            [dic setValue:self.hotel_id forKey:@"hotel_id"];
            [dic setValue:self.temp_order_id forKey:@"order_id"];
        }
        
        [dic setValue:self.quote_id forKey:@"quote_id"];
        [dic setValue:@(self.room_num) forKey:@"room_num"];
        [dic setValue:@(self.pre_checkin_time) forKey:@"pre_checkin_time"];
        
    }
    [dic setValue:@(self.start_date) forKey:@"start_time"];
    [dic setValue:@(self.end_date) forKey:@"end_time"];
    
    [dic setValue:link_man forKey:@"link_man"];
    [dic setValue:telephone forKey:@"telephone"];
    
    [PPHTTPRequest requestPostWithJSONForUrl:url parameters:dic success:^(id  _Nonnull response) {
        NSLog(@"下单提交==%@",response);
        NSString *code = [NSString stringWithFormat:@"%@", response[@"code"]];
        if ([code isEqualToString:@"0"]) {//请求成功
            NSDictionary *data = response[@"data"];
            NSString *is_pay = [NSString stringWithFormat:@"%@",data[@"is_pay"]];
            if(is_pay.integerValue == 1){
                HHOrderViewController *vc = [[HHOrderViewController alloc] init];
                vc.backType = self.backType;
                vc.index = 0;
                vc.order_status = @"";
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }else {
                HHOrderPayViewController *vc = [[HHOrderPayViewController alloc] init];
                vc.dateType = self.dateType;
                vc.backType = self.backType;
                vc.order_id = data[@"order_id"];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }
            
        }else {
            [self.view makeToast:response[@"msg"] duration:2 position:CSToastPositionCenter];
        }
        
    } failure:^(NSError * _Nonnull error) {
        
    }];
}

- (void)_loadRoomInfoData:(NSString *)room_id quote_id:(NSString *)quote_id {
    NSString *url = [NSString stringWithFormat:@"%@/hotel/details/room",BASE_URL];
    NSMutableDictionary *dic = @{}.mutableCopy;
    [dic setValue:room_id forKey:@"room_id"];
    [dic setValue:quote_id forKey:@"quote_id"];
    [PPHTTPRequest requestPostWithJSONForUrl:url parameters:dic success:^(id  _Nonnull response) {
        NSString *code = [NSString stringWithFormat:@"%@", response[@"code"]];
        if ([code isEqualToString:@"0"]) {//请求成功
            self.roomInfoView.data = response[@"data"];
            self.roomInfoView.type = @"2";
            self.roomInfoView.hidden = NO;
        }else {
            [self.view makeToast:response[@"msg"] duration:2 position:CSToastPositionCenter];
        }
        
    } failure:^(NSError * _Nonnull error) {
        
    }];
}

- (void)_loadDataForRoomNumber:(NSString *)room_num{
    NSString *url = [NSString stringWithFormat:@"%@/hotel/order/request",BASE_URL];
    NSMutableDictionary *dic = @{}.mutableCopy;
    [dic setValue:self.hotel_id forKey:@"hotel_id"];
    [dic setValue:self.quote_id forKey:@"quote_id"];
    [dic setValue:@(self.start_date) forKey:@"start_date"];
    [dic setValue:@(self.end_date) forKey:@"end_date"];
    [dic setValue:@(room_num.integerValue) forKey:@"room_num"];
    [dic setValue:@(self.is_modify) forKey:@"is_modify"];
    if (self.is_modify) {
        [dic setValue:self.old_order_id forKey:@"old_order_id"];
    }
    [PPHTTPRequest requestPostWithJSONForUrl:url parameters:dic success:^(id  _Nonnull response) {
        
        NSString *code = [NSString stringWithFormat:@"%@", response[@"code"]];
        if ([code isEqualToString:@"0"]) {//请求成功
            
            NSDictionary *data = response[@"data"];
            [self.lowerOrderView updataUI:data withRoomNumber:room_num.integerValue];
            [self.priceInfoView updataUI:data withRoomNumber:room_num.integerValue];
        }else {
            [self.view makeToast:response[@"msg"] duration:2 position:CSToastPositionCenter];
        }
    } failure:^(NSError * _Nonnull error) {
        
    }];
}

@end
