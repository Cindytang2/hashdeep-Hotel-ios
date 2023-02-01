//
//  HHOrderDetailViewController.m
//  HashdeepHotel
//
//  Created by Cindy on 2022/7/22.
//

#import "HHOrderDetailViewController.h"
#import "HHOrderViewController.h"
#import "HHOrderDetailView.h"///订单详情View
#import "HHCancelOrderViewController.h"///取消订单VC
#import "HHHotelDetailViewController.h"///酒店详情VC
#import "HHOrderPayViewController.h"/// 支付VC
#import "HHRoomInfoView.h"///房型详情UI
#import "HHOnlinePayView.h"///
#import "HHToEvaluateViewController.h"///去评价VC
#import "HHOneCheckInView.h"
#import "HHLowerOrderViewController.h"///下单详情VC
#import "HHEditOrderViewController.h"///修改订单VC
#import "HHPlayVideoViewController.h" ///播放视屏
#import "HHTripMainViewController.h"
#import "HHMyViewController.h"
#import "HHDormitoryDetailViewController.h"
@interface HHOrderDetailViewController ()
@property (nonatomic, strong) HHOrderDetailView *detailView;
@property (nonatomic, strong) HHRoomInfoView *roomInfoView;  ///房型详情View
@property (nonatomic, strong) HHOnlinePayView *onlinePayView;
@property (nonatomic, strong) HHOneCheckInView *oneCheckInView;
@property (nonatomic, copy) NSString *hotel_id;///酒店id
@property (nonatomic, copy) NSString *homestay_room_id;
@property (nonatomic, copy) NSString *quote_id;

@end

@implementation HHOrderDetailViewController

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

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
    WeakSelf(weakSelf)
    self.view.backgroundColor = XLColor_mainColor;
    
    //自定义导航栏
    [self _createdNavigationBar];
    
    //创建UI
    [self _createdViews];
    
    //    //订单详情数据
    [self _loadData];
    
    //    侧滑处理
    [self _sideslip_handle];
    
    self.clickUpdateButton = ^{
        [weakSelf _loadData];
    };
}

#pragma mark --------------创建Views---------------
- (void)_createdViews {
    WeakSelf(weakSelf)
    
    self.detailView = [[HHOrderDetailView alloc] init];
    self.detailView.dateType = self.dateType;
    self.detailView.hidden = YES;
    [self.view addSubview:self.detailView];
    [self.detailView mas_makeConstraints:^(MASConstraintMaker *make) {
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
    
    self.onlinePayView = [[HHOnlinePayView alloc] init];
    self.onlinePayView.hidden = YES;
    self.onlinePayView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    self.onlinePayView.clickCloseButton = ^{
        weakSelf.onlinePayView.hidden = YES;
    };
    [keyWindow addSubview:self.onlinePayView];
    [self.onlinePayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.top.offset(0);
    }];
    
}

#pragma mark -------------订单详情数据--------------
- (void)_loadData {
    NSString *url;
    NSMutableDictionary *dic = @{}.mutableCopy;
    if(self.dateType == 2){
        url = [NSString stringWithFormat:@"%@/homestay/order/detail",BASE_URL];
    }else {
        url = [NSString stringWithFormat:@"%@/hotel/order/detail",BASE_URL];
    }
    
    [dic setValue:self.order_id forKey:@"order_id"];
    [PPHTTPRequest requestPostWithJSONForUrl:url parameters:dic success:^(id  _Nonnull response) {
        NSLog(@"订单详情数据==%@",response);
        NSString *code = [NSString stringWithFormat:@"%@", response[@"code"]];
        if ([code isEqualToString:@"0"]) {//请求成功
            [self.noNetWorkView removeFromSuperview];
            NSDictionary *data = response[@"data"];
            self.quote_id = data[@"hotel_quote_id"];
            self.hotel_id = data[@"hotel_Id"];
            self.homestay_room_id = data[@"room_id"];
            self.detailView.data = data;
            self.detailView.hidden = NO;
            
            [self _infoAndAction:data];
        }else {
            [self.view makeToast:response[@"msg"] duration:2 position:CSToastPositionCenter];
        }
    } failure:^(NSError * _Nonnull error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self noNetworkUI];
        });
    }];
    
}

- (void)_infoAndAction:(NSDictionary *)data {
    WeakSelf(weakSelf)
    
    NSDictionary *hotel_info = data[@"hotel_info"];
    
    NSDictionary *check_in_and_out = data[@"check_in_and_out"];
    NSString *checkin_date_desc = check_in_and_out[@"checkin_date_desc"];
    NSString *checkout_date_desc = check_in_and_out[@"checkout_date_desc"];
    NSString *duration_desc = check_in_and_out[@"duration_desc"];
    NSArray *checkInArray = [checkin_date_desc componentsSeparatedByString:@"("];
    NSArray *checkWeekArray = [checkInArray.lastObject componentsSeparatedByString:@")"];
    NSString *checkInStr = [HHAppManage getDateWithString:checkInArray.firstObject];
    NSString *checkTimeStp = [HHAppManage getTimeStrWithString:[NSString stringWithFormat:@"%@ 00:00:00",checkInStr]];
    NSDate *end_date;
    NSArray *checkOutArray;
    NSArray *checkOutWeekArray;
    NSString *checkOutStr;
    NSString *checkOutTimeStp;
    if(checkout_date_desc.length == 0){
        end_date = nil;
        checkOutArray = @[];
        checkOutWeekArray = @[];
        checkOutStr = @"";
        checkOutTimeStp = @"";
    }else {
        checkOutArray = [checkout_date_desc componentsSeparatedByString:@"("];
        checkOutWeekArray = [checkOutArray.lastObject componentsSeparatedByString:@")"];
        checkOutStr = [HHAppManage getDateWithString:checkOutArray.firstObject];
        checkOutTimeStp = [HHAppManage getTimeStrWithString:[NSString stringWithFormat:@"%@ 00:00:00",checkOutStr]];
        NSDateFormatter *end_dateFormatter = [[NSDateFormatter alloc] init];
        [end_dateFormatter setDateFormat:@"yyyy-MM-dd"];
        end_date = [end_dateFormatter dateFromString:checkOutStr];
    }
    
    NSString *start_time = [NSString stringWithFormat:@"%@", data[@"start_time"]];
    NSString *end_time = [NSString stringWithFormat:@"%@", data[@"end_time"]];
    NSDictionary *start_dic =  [self timeStr:start_time.integerValue];
    NSDictionary *end_dic =  [self timeStr:end_time.integerValue];
    NSString *checkInWeek = checkWeekArray.firstObject;
    NSInteger start_weekIndex;
    NSInteger end_weekIndex;
    if([checkInWeek isEqualToString:@"周日"]){
        start_weekIndex = 1;
        end_weekIndex = 1;
    }else if ([checkInWeek isEqualToString:@"周一"]){
        start_weekIndex = 2;
        end_weekIndex = 2;
    }else if ([checkInWeek isEqualToString:@"周二"]){
        start_weekIndex = 3;
        end_weekIndex = 3;
    }else if ([checkInWeek isEqualToString:@"周三"]){
        start_weekIndex = 4;
        end_weekIndex = 4;
    }else if ([checkInWeek isEqualToString:@"周四"]){
        start_weekIndex = 5;
        end_weekIndex = 5;
    }else if ([checkInWeek isEqualToString:@"周五"]){
        start_weekIndex = 6;
        end_weekIndex = 6;
    }else if ([checkInWeek isEqualToString:@"周六"]){
        start_weekIndex = 7;
        end_weekIndex = 7;
    }
    
    NSString *checkOutWeekStr;
    if(checkOutWeekArray.count == 0){
        checkOutWeekStr = @"";
    }else {
        checkOutWeekStr = checkOutWeekArray.firstObject;
    }
    NSString *startDateStr = checkInArray.firstObject;
    NSString *checkInWeekStr = checkWeekArray.firstObject;
    NSString *endDateStr;
    if(checkOutArray.count == 0){
        endDateStr = @"";
    }else {
        endDateStr = checkOutArray.firstObject;
    }
    
    NSMutableDictionary *dii = @{
        @"hotelName":hotel_info[@"hotel_name"],
        @"startDateStr":startDateStr,
        @"checkInWeekStr":checkInWeekStr,
        @"days":duration_desc
    }.mutableCopy;
    if (endDateStr != nil) {
        dii[@"endDateStr"] = endDateStr;
    }
    if (checkOutWeekStr != nil) {
        dii[@"checkOutWeekStr"] = checkOutWeekStr;
    }
    
    NSDateFormatter *start_dateFormatter = [[NSDateFormatter alloc] init];
    [start_dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *start_date = [start_dateFormatter dateFromString:checkInStr];
    
    NSDictionary *editStart_Dic = @{
        @"year":start_dic[@"year"],
        @"month":start_dic[@"month"],
        @"day":start_dic[@"day"],
        @"date":start_date,
        @"week":@(start_weekIndex)
    };
    
    NSMutableDictionary *editEnd_Dic = @{
        @"year":end_dic[@"year"],
        @"month":end_dic[@"month"],
        @"day":end_dic[@"day"],
        @"week":@(end_weekIndex)
    }.mutableCopy;
    if (end_date != nil) {//@"date":end_date,
        editEnd_Dic[@"date"] = end_date;
    }
    
    self.detailView.againLoadData = ^{
        [weakSelf _loadData];
    };
    //删除
    self.detailView.clickDeleteButtonAction = ^{
        [weakSelf deleteAction];
    };
    //取消
    self.detailView.clickCancelButtonAction = ^(NSDictionary * _Nonnull data) {
        [weakSelf cancelAction:data];
    };
    //再次预定
    self.detailView.clickAgainButtonAction = ^{
        if(weakSelf.dateType == 2){
            HHDormitoryDetailViewController *vc = [[HHDormitoryDetailViewController alloc] init];
            vc.backType = weakSelf.backType;
            vc.homestay_id = data[@"hotel_Id"];
            vc.homestay_room_id = data[@"room_id"];
            vc.hidesBottomBarWhenPushed = YES;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }else {
            HHHotelDetailViewController *vc = [[HHHotelDetailViewController alloc] init];
            vc.backType = weakSelf.backType;
            BOOL is_hour_room = [NSString stringWithFormat:@"%@", data[@"is_hourly"]].boolValue;
            if(is_hour_room){
                vc.dateType = 1;
            }else {
                vc.dateType = 0;
            }
            vc.hotel_id = data[@"hotel_Id"];
            vc.hidesBottomBarWhenPushed = YES;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }
        
    };
    //去付款
    self.detailView.clickGoPayButtonAction = ^{
        HHOrderPayViewController *vc = [[HHOrderPayViewController alloc] init];
        vc.dateType = weakSelf.dateType;
        vc.backType = weakSelf.backType;
        vc.order_id = weakSelf.order_id;
        vc.hidesBottomBarWhenPushed = YES;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    
    self.detailView.clickSeeRoomInfoAction = ^(UIButton * _Nonnull button) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            button.enabled = YES;
       });
        if(weakSelf.dateType == 2){
            [weakSelf _loadRoomInfoData:data[@"room_id"]];
        }else {
            [weakSelf _loadRoomInfoData:data[@"room_id"]];
        }
    };
    
    self.detailView.clickOnLineButtonAction = ^{
        weakSelf.onlinePayView.payment_info = data[@"payment_info"];
        weakSelf.onlinePayView.hidden = NO;
    };
    
    //去评价
    self.detailView.clickGoCommentButtonAction = ^{
        HHToEvaluateViewController *vc = [[HHToEvaluateViewController alloc] init];
        vc.order_id = weakSelf.order_id;
        vc.commentSuccess = ^{
            [weakSelf _loadData];
        };
        vc.hidesBottomBarWhenPushed = YES;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    self.detailView.clickOneAddButtonAction = ^{
        weakSelf.oneCheckInView = [[HHOneCheckInView alloc] init];
        weakSelf.oneCheckInView.check_in_and_out = data[@"check_in_and_out"];
        weakSelf.oneCheckInView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
        weakSelf.oneCheckInView.clickCloseButton = ^{
            [weakSelf.oneCheckInView removeFromSuperview];
        };
        weakSelf.oneCheckInView.clickDoneButton = ^(NSInteger beginTimeNumber, NSInteger endTimeNumber, NSDictionary * _Nonnull dic) {
            [weakSelf.oneCheckInView removeFromSuperview];
            HHLowerOrderViewController *vc = [[HHLowerOrderViewController alloc] init];
            vc.doneType = 1;
            vc.dateType = weakSelf.dateType;
            vc.isBackstage = YES;
            vc.backType = weakSelf.backType;
            vc.is_modify = NO;
            vc.homestay_id = weakSelf.hotel_id;
            vc.homestay_room_id = weakSelf.homestay_room_id;
            vc.hotel_id = weakSelf.hotel_id;
            vc.quote_id = weakSelf.quote_id;
            vc.start_date = beginTimeNumber;
            vc.end_date = endTimeNumber;
            vc.dic = dic;
            vc.hidesBottomBarWhenPushed = YES;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        };
        [keyWindow addSubview:weakSelf.oneCheckInView];
        [weakSelf.oneCheckInView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.top.offset(0);
        }];
    };
    
    self.detailView.clickEditButtonAction = ^{
        HHEditOrderViewController *vc = [[HHEditOrderViewController alloc] init];
        vc.backType = weakSelf.backType;
        vc.dic = dii;
        vc.start_Dic = editStart_Dic;
        vc.end_Dic = editEnd_Dic;
        vc.start_time = checkTimeStp;
        vc.end_time = checkOutTimeStp;
        vc.order_id = weakSelf.order_id;
        vc.quote_id = weakSelf.quote_id;
        vc.hotel_id = weakSelf.hotel_id;
        vc.hidesBottomBarWhenPushed = YES;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    
    self.detailView.clickSeeButtonAction = ^{
        [weakSelf seeAction];
    };
}

- (void)seeAction{
    NSString *url = [NSString stringWithFormat:@"%@/hotel/order/view/video",BASE_URL];
    NSMutableDictionary *dic = @{}.mutableCopy;
    [dic setValue:self.order_id forKey:@"order_id"];
    WeakSelf(weakSelf)
    [PPHTTPRequest requestPostWithJSONForUrl:url parameters:dic success:^(id  _Nonnull response) {
        
        NSString *code = [NSString stringWithFormat:@"%@", response[@"code"]];
        NSLog(@"酒店列表=====%@",response);
        if ([code isEqualToString:@"0"]) {//请求成功
            NSDictionary *data = response[@"data"];
            NSArray *video_list = data[@"video_list"];
            if(video_list.count != 0){
                NSDictionary *firstDic = video_list.firstObject;
                HHPlayVideoViewController *vc = [[HHPlayVideoViewController alloc] init];
                [vc createdVideo: firstDic[@"video_path"]];
                vc.hidesBottomBarWhenPushed = YES;
                [weakSelf.navigationController pushViewController:vc animated:YES];
            }else {
                [self.view makeToast:@"暂无视频" duration:2 position:CSToastPositionCenter];
            }
            
        } else {
            [self.view makeToast:response[@"msg"] duration:2 position:CSToastPositionCenter];
        }
        
    } failure:^(NSError * _Nonnull error) {
        
    }];
}

- (void)_loadRoomInfoData:(NSString *)room_id{
    NSString *url = [NSString stringWithFormat:@"%@/hotel/details/room",BASE_URL];
    NSMutableDictionary *dic = @{}.mutableCopy;
    [dic setValue:room_id forKey:@"room_id"];
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

#pragma mark ---------------取消订单------------------
- (void)cancelAction:(NSDictionary *)data {
    HHCancelOrderViewController *vc = [[HHCancelOrderViewController alloc] init];
    vc.backType = self.backType;
    vc.order_id = self.order_id;
    vc.hotel_id = self.hotel_id;
    vc.homestay_room_id = self.homestay_room_id;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark ---------------删除订单------------------
- (void)deleteAction{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否要删除订单？" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
        
    }];
    [cancelAction setValue:XLColor_subSubTextColor forKey:@"titleTextColor"];
    [alert addAction:cancelAction];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
        NSString *url = [NSString stringWithFormat:@"%@/hotel/order",BASE_URL];
        NSMutableDictionary *dic = @{}.mutableCopy;
        [dic setValue:@"07" forKey:@"order_status"];
        [dic setValue:self.order_id forKey:@"order_id"];
        [PPHTTPRequest requestPostWithJSONForUrl:url parameters:dic success:^(id  _Nonnull response) {
            NSLog(@"response==%@",response);
            NSString *code = [NSString stringWithFormat:@"%@", response[@"code"]];
            if ([code isEqualToString:@"0"]) {//请求成功
                if(self.deleteSuccess){
                    self.deleteSuccess();
                }
                [self.navigationController popViewControllerAnimated:YES];
            }else {
                [self.view makeToast:response[@"msg"] duration:2 position:CSToastPositionCenter];
            }
        } failure:^(NSError * _Nonnull error) {
            
        }];
    }];
    [okAction setValue:UIColorHex(b58e7f) forKey:@"titleTextColor"];
    [alert addAction:okAction];
    
    // 弹出对话框
    [self presentViewController:alert animated:true completion:nil];
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
    
    //返回按钮
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
    
    //标题
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = [NSString stringWithFormat:@"订单 %@",self.order_id];
    titleLabel.textColor = kWhiteColor;
    titleLabel.font = KBoldFont(14);
    [self.view addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backButton.mas_right).offset(10);
        make.top.offset(UINavigateTop+10);
        make.height.offset(20);
    }];
}

- (void)backButtonAction {
    if ([self.backType isEqualToString:@"1"]) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

#pragma mark -----------------侧滑处理------------------
- (void)_sideslip_handle {
    
    //下单成功之后需要直接返回到指定页（首页），所以需要进行侧滑处理
    //处理侧滑返回到指定页面
    if ([self.backType isEqualToString:@"orderGo"] || [self.backType isEqualToString:@"5"]) {
        
        //在需要侧滑到指定控制器的控制器的 view 加载完毕后偷偷将当前控制器与目标控制器之间的所有控制器出栈
        //      # 1. 获取当行控制器所有子控制器
        NSMutableArray <UIViewController *>* tmp = self.navigationController.viewControllers.mutableCopy;
        //      # 2. 获取目标控制器索引
        UIViewController * targetVC = nil;
        for (NSInteger i = 0 ; i < tmp.count; i++) {
            
            UIViewController * vc = tmp[i];
            if ([vc isKindOfClass:NSClassFromString(@"HHOrderViewController")])
            {
                targetVC = vc;
                // 也可在此直接获取 i 的数值
                break;
            }
        }
        NSInteger index = [tmp indexOfObject:targetVC];
        //      # 3. 移除目标控制器与当前控制器之间的所有控制器
        NSRange  range = NSMakeRange(index + 1, tmp.count - 1 - (index + 1));
        
        [tmp removeObjectsInRange:range];
        //      # 4. 重新赋值给导航控制器
        self.navigationController.viewControllers = [tmp copy];
    }else if([self.backType isEqualToString:@"TripGo"]){
        NSMutableArray <UIViewController *>* tmp = self.navigationController.viewControllers.mutableCopy;
        UIViewController * targetVC = nil;
        for (NSInteger i = 0 ; i < tmp.count; i++) {
            
            UIViewController * vc = tmp[i];
            if ([vc isKindOfClass:NSClassFromString(@"HHTripMainViewController")]){
                targetVC = vc;
                // 也可在此直接获取 i 的数值
                break;
            }
        }
        NSInteger index = [tmp indexOfObject:targetVC];
        NSRange  range = NSMakeRange(index + 1, tmp.count - 1 - (index + 1));
        [tmp removeObjectsInRange:range];
        self.navigationController.viewControllers = [tmp copy];
    }else if([self.backType isEqualToString:@"MyGo"]){
        NSMutableArray <UIViewController *>* tmp = self.navigationController.viewControllers.mutableCopy;
        UIViewController * targetVC = nil;
        for (NSInteger i = 0 ; i < tmp.count; i++) {
            
            UIViewController * vc = tmp[i];
            if ([vc isKindOfClass:NSClassFromString(@"HHMyViewController")]){
                targetVC = vc;
                // 也可在此直接获取 i 的数值
                break;
            }
        }
        NSInteger index = [tmp indexOfObject:targetVC];
        NSRange  range = NSMakeRange(index + 1, tmp.count - 1 - (index + 1));
        [tmp removeObjectsInRange:range];
        self.navigationController.viewControllers = [tmp copy];
    }else{
        NSMutableArray <UIViewController *>* tmp = self.navigationController.viewControllers.mutableCopy;
        UIViewController * targetVC = nil;
        for (NSInteger i = 0 ; i < tmp.count; i++) {
            
            UIViewController * vc = tmp[i];
            if ([vc isKindOfClass:NSClassFromString(@"HHHomeViewController")]){
                targetVC = vc;
                // 也可在此直接获取 i 的数值
                break;
            }
        }
        NSInteger index = [tmp indexOfObject:targetVC];
        NSRange  range = NSMakeRange(index + 1, tmp.count - 1 - (index + 1));
        [tmp removeObjectsInRange:range];
        self.navigationController.viewControllers = [tmp copy];
    }
}

- (NSDictionary *) timeStr:(NSInteger )timestamp{
    
    // 创建日历对象
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *msgDate = [NSDate dateWithTimeIntervalSince1970:timestamp];
    
    NSDateComponents *components = [calendar components:NSCalendarUnitYear| NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond fromDate:msgDate];
    
    CGFloat msgYear = components.year;
    CGFloat msgMonth = components.month;
    CGFloat msgDay = components.day;
    
    NSDictionary *dd = @{
        @"year":[NSString stringWithFormat:@"%.f",msgYear],
        @"month":[NSString stringWithFormat:@"%.f",msgMonth],
        @"day":[NSString stringWithFormat:@"%.f",msgDay]
    };
    return dd;
}
@end
