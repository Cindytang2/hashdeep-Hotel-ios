//
//  HHHomeViewController.m
//  HashdeepHotel
//
//  Created by Cindy on 2022/7/11.
//

#import "HHHomeViewController.h"
#import "HHHomeCollectionViewCell.h"
#import "HHHomeNavigationView.h"
#import "HHHomeCollectionViewFlowLayout.h"
#import "HomeModel.h"
#import "HHHomeHeadCollectionReusableView.h"
#import <AMapLocationKit/AMapLocationKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import "HHSelectedRegionViewController.h"
#import "HHSearchViewController.h"
#import "HHHotelSearchViewController.h"
#import "HHHotelDetailViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "HHCalendarView.h"
#import "HHConversationController.h"
#import "HHHomePriceView.h"
#import "HHOpenLocationView.h"
#import "HHDormitoryDetailCollectionViewCell.h"
#import "HHDormitoryDetailViewController.h"
@interface HHHomeViewController ()<CLLocationManagerDelegate,HHHomeCollectionViewFlowLayoutDelegate, UICollectionViewDelegate,UICollectionViewDataSource, AMapLocationManagerDelegate>
@property (nonatomic, strong) HHHomeNavigationView *navView;
@property (nonatomic, strong) UICollectionView *customcollectionView;
@property (nonatomic, strong) NSMutableArray *dataArray;//列表数组
@property (nonatomic, assign) BOOL isLoad;//是否加载了数据
@property (nonatomic, strong) HHHomeCollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong) AMapLocationManager *locationManager;///定位管理器
@property (nonatomic, strong) HHHomeHeadCollectionReusableView *headView;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, copy) NSString *type_country_Str;
@property (nonatomic, copy) NSString *all_str;
@property (nonatomic, strong) NSDictionary *type_section;
@property (nonatomic, strong) CLLocationManager *cllLocationManager;
@property (nonatomic, strong) CLLocation *cllLocation;
@property (nonatomic, strong) HHHomePriceView *priceView;
@property (nonatomic, strong) HHOpenLocationView *toastView;
@property (nonatomic, strong) DayModel *startModel;//默认的显示的开始时间
@property (nonatomic, strong) DayModel *endModel;//默认的显示的结束时间
@end

@implementation HHHomeViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    [self.headView updateTime:self.index];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    WeakSelf(weakSelf)
    
    self.view.backgroundColor = kWhiteColor;
    self.dataArray = [NSMutableArray array];
    self.index = 0;
    self.page = 1;
    self.type_country_Str = @"价格星级";
    self.all_str = @"价格星级";
    //加载默认的地址数据
    [self _loadingDefaultLocationData];
    
    //创建UI
    [self _createdViews];
    
    //获取app版本信息
    [self _loadingVersionData];
    
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    self.toastView = [[HHOpenLocationView alloc] init];
    self.toastView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
    self.toastView.hidden = YES;
    self.toastView.clickCloseButton = ^{
        weakSelf.toastView.hidden = YES;
    };
    self.toastView.clickSelectedAction = ^{
        weakSelf.toastView.hidden = YES;
        HHSelectedRegionViewController *vc = [[HHSelectedRegionViewController alloc] init];
        vc.clickCellAction = ^(NSString * _Nonnull addressStr, NSString * _Nonnull longitude, NSString * _Nonnull latitude) {
            [UserInfoManager sharedInstance].longitude = [NSString stringWithFormat:@"%@",longitude];
            [UserInfoManager sharedInstance].latitude = [NSString stringWithFormat:@"%@",latitude];
            [UserInfoManager synchronize];
            [weakSelf.headView updateCountryAddress:addressStr];
        };
        vc.hidesBottomBarWhenPushed = YES;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    self.toastView.clickOpenAction = ^{
        weakSelf.toastView.hidden = YES;
        NSURL * appSettingURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if ([[UIApplication sharedApplication] canOpenURL:appSettingURL]){
            [[UIApplication sharedApplication] openURL:appSettingURL options:@{UIApplicationOpenURLOptionsSourceApplicationKey : @YES} completionHandler:^(BOOL success) {
                
            }];
        }
    };
    [keyWindow addSubview:self.toastView];
    [self.toastView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.offset(0);
    }];
    
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    if (status == kCLAuthorizationStatusNotDetermined){
        //用户尚未做出决定是否启用定位服务
        NSLog(@"用户尚未做出决定是否启用定位服务");
    }else if (status == kCLAuthorizationStatusRestricted){
        //没有获得用户授权使用定位服务, 可能用户没有自己禁止访问授权
        NSLog(@"没有获得用户授权使用定位服务, 可能用户没有自己禁止访问授权");
    }else if (status == kCLAuthorizationStatusAuthorizedAlways || status == kCLAuthorizationStatusAuthorizedWhenInUse){
        //kCLAuthorizationStatusAuthorizedAlways //应用获得授权可以一直使用定位服务，即使应用不在使用状态
        //kCLAuthorizationStatusAuthorizedWhenInUse
        //使用此应用过程中允许访问定位服务
        NSLog(@"使用此应用过程中允许访问定位服务");
    }else {
        NSLog(@"用户已经明确禁止应用使用定位服务或者当前系统定位服务处于关闭状态");
        BOOL openLocation =  [[NSUserDefaults standardUserDefaults ]boolForKey:@"openLocation"];
        if (!openLocation) {
            self.toastView.hidden = NO;
        }
        
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateLocation) name:@"paySuccessNotification" object:nil];
}

#pragma mark ---------获取banner图片-------------
- (void)_loadingImageData{
    
    NSString *url = [NSString stringWithFormat:@"%@/index/carousel",BASE_URL];
    NSMutableDictionary *dic = @{}.mutableCopy;
    [dic setValue:[UserInfoManager sharedInstance].longitude forKey:@"longitude"];
    [dic setValue:[UserInfoManager sharedInstance].latitude forKey:@"latitude"];
    if(self.index == 0){
        [dic setValue:@(2) forKey:@"belongs_to"];
    }else if(self.index == 1){
        [dic setValue:@(3) forKey:@"belongs_to"];
    }else {
        [dic setValue:@(4) forKey:@"belongs_to"];
    }
    
    [PPHTTPRequest requestPostWithJSONForUrl:url parameters:dic success:^(id  _Nonnull response) {
        
        //        NSLog(@"图片====%@",response);
        NSString *code = [NSString stringWithFormat:@"%@", response[@"code"]];
        if ([code isEqualToString:@"0"]) {//请求成功
            NSDictionary *data = response[@"data"];
            NSArray *list = data[@"list"];
            NSMutableArray *bannerData = [NSMutableArray array];
            NSMutableArray *resultData = [NSMutableArray array];
            if (list.count != 0) {
                for (int i=0; i<list.count; i++) {
                    NSDictionary *dictionary = list[i];
                    [bannerData addObject:dictionary[@"path"]];
                    [resultData addObject:dictionary];
                }
                [self.headView updateUIForBanner:bannerData withResultData:resultData];
            }
            
        } else {
            [self.view makeToast:response[@"msg"] duration:2 position:CSToastPositionCenter];
        }
    } failure:^(NSError * _Nonnull error) {
    }];
    
}

//   iOS的版本号，一个叫做Version，一个叫做Build，这两个值都可以在Xcode中选中target，点击"General"后看到。 Version在plist文件中的key是“CFBundleShortVersionString”，和AppStore上的版本号保持一致。
//    Build在plist中的key是“CFBundleVersion”，代表build的版本号，该值每次build之后都应该增加1。

#pragma mark ---------获取app版本信息-------------
- (void)_loadingVersionData{
    
    NSString *url = [NSString stringWithFormat:@"%@/data/version/check",BASE_URL];
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString *build = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    
    NSMutableDictionary *dic = @{}.mutableCopy;
    [dic setValue:[NSString stringWithFormat:@"%@",version] forKey:@"version_name"];
    [dic setValue:[NSString stringWithFormat:@"%@",build] forKey:@"version_code"];
    
    [PPHTTPRequest requestPostWithJSONForUrl:url parameters:dic success:^(id  _Nonnull response) {
        
        NSString *code = [NSString stringWithFormat:@"%@", response[@"code"]];
        if ([code isEqualToString:@"0"]) {//请求成功
            
            NSDictionary *data = response[@"data"];
            NSString *version = data[@"version"];
            BOOL is_need_update = [NSString stringWithFormat:@"%@", data[@"is_need_update"]].boolValue;
            BOOL is_forced = [NSString stringWithFormat:@"%@", data[@"is_forced"]].boolValue;
            
            if (is_need_update) {
                if (is_forced) {
                    [self _createdneedUpdateUI:data[@"version_info"]];
                }else {
                    NSString *history_Version = [[NSUserDefaults standardUserDefaults] objectForKey:@"version"];
                    if (version.integerValue > history_Version.integerValue) {
                        [[NSUserDefaults standardUserDefaults] setObject: version forKey: @"version"];
                        [[NSUserDefaults standardUserDefaults]synchronize];
                        [self _createdneedUpdateUI:data[@"version_info"]];
                    }
                }
            }
            
        } else {
            [self.view makeToast:response[@"msg"] duration:2 position:CSToastPositionCenter];
        }
    } failure:^(NSError * _Nonnull error) {
    }];
}

- (void)_createdneedUpdateUI:(NSString *)str {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"检测到更新" message:str preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
        exit(0);
    }];
    [cancelAction setValue:XLColor_subSubTextColor forKey:@"titleTextColor"];
    [alert addAction:cancelAction];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"立即更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://apps.apple.com/us/app/%E4%B8%AD%E5%8D%8E%E5%BF%97%E6%84%BF%E8%80%85/id1634393465"] options:nil completionHandler:^(BOOL success) {
        }];
    }];
    [okAction setValue:UIColorHex(b58e7f) forKey:@"titleTextColor"];
    [alert addAction:okAction];
    
    // 弹出对话框
    [self presentViewController:alert animated:true completion:nil];
}

#pragma mark -------------------创建UI--------------------
- (void)_createdViews {
    WeakSelf(weakSelf)
    self.flowLayout = [[HHHomeCollectionViewFlowLayout alloc]init];
    self.flowLayout.itemSize = CGSizeMake(220, 180);
    self.flowLayout.height = 570;
    self.flowLayout.delegate = self;
    self.customcollectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:self.flowLayout];
    self.customcollectionView.backgroundColor = XLColor_mainColor;
    self.customcollectionView.delegate = self;
    self.customcollectionView.dataSource = self;
    self.customcollectionView.showsVerticalScrollIndicator = NO;
    self.customcollectionView.showsHorizontalScrollIndicator = NO;
    [self.customcollectionView registerClass:[HHDormitoryDetailCollectionViewCell class] forCellWithReuseIdentifier:@"HHDormitoryDetailCollectionViewCell"];
    [self.customcollectionView registerClass:[HHHomeCollectionViewCell class] forCellWithReuseIdentifier:@"HHHomeCollectionViewCell"];
    //注册头视图
    [self.customcollectionView registerClass:[HHHomeHeadCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UICollectionViewHeader"];
    self.customcollectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    [self.view addSubview:self.customcollectionView];
    [self.customcollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.offset(0);
        make.height.offset(kScreenHeight-UITabbarHeight);
    }];
    
    self.customcollectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weakSelf.page ++;
        [weakSelf _loadingData];
    }];
    self.customcollectionView.mj_footer.hidden = YES;
    
    
    self.navView = [[HHHomeNavigationView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth ,UINavigateHeight)];
    self.navView.clickNoticeAction = ^{
        HHConversationController *vc = [[HHConversationController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    [self.view addSubview:self.navView];
    
}

//创建头视图
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    WeakSelf(weakSelf)
    self.headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UICollectionViewHeader" forIndexPath:indexPath];
    self.headView.index = self.index;
    self.headView.backgroundColor = XLColor_mainColor;
    self.headView.clickColumnAction = ^(UIButton * _Nonnull button) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            button.enabled = YES;
        });
        weakSelf.page = 1;
        weakSelf.index = button.tag-100;
        
        if ([weakSelf.all_str containsString:@"人"] || [weakSelf.all_str containsString:@"床"]) {
            if(weakSelf.index == 2){
                weakSelf.type_country_Str = weakSelf.all_str;
            }else {
                NSArray *array = [weakSelf.all_str componentsSeparatedByString:@","];
                NSMutableArray *arr = [NSMutableArray arrayWithArray:array];
                [arr removeObjectAtIndex:0];
                weakSelf.type_country_Str = [arr componentsJoinedByString:@","];
            }
        }else {
            weakSelf.type_country_Str = weakSelf.all_str;
        }
      
        [weakSelf.headView updateSetup:weakSelf.type_country_Str];
        [weakSelf _loadingImageData];
        [weakSelf _loadingData];
    };
    self.headView.dateAction = ^(DayModel * _Nonnull startModel, DayModel * _Nonnull endModel) {
        
        UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
        
        HHCalendarView *calendarView = [[HHCalendarView alloc] init];
        calendarView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        if(weakSelf.index == 1){//时租房
            calendarView.dateType = KDateTypeHour;
            calendarView.startModel = startModel;
            weakSelf.startModel = startModel;
        }else {//  国内、国际 / 民宿
            calendarView.dateType = KDateTypeContry;
            //设置默认显示的开始时间与结束时间
            calendarView.startModel = startModel;
            calendarView.endModel = endModel;
            weakSelf.startModel = startModel;
            weakSelf.endModel = endModel;
        }
        calendarView.clickCloseButton = ^{
            [calendarView removeFromSuperview];
        };
        calendarView.calendarViewBlock = ^(NSDictionary * _Nonnull dic, DateType dateType, DayModel * _Nonnull startModel, DayModel * _Nonnull endModel) {
            
            weakSelf.startModel = startModel;
            if(weakSelf.index != 1){
                weakSelf.endModel = endModel;
            }
            [weakSelf.headView updateDateUI:weakSelf.index dic:dic startModel:startModel endModel:endModel];
        };
        [keyWindow addSubview:calendarView];
        [calendarView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.offset(0);
        }];
        [calendarView reloadMyTable];
    };
    self.headView.selectedAddress = ^{
        HHSelectedRegionViewController *vc = [[HHSelectedRegionViewController alloc] init];
        vc.clickCellAction = ^(NSString * _Nonnull addressStr, NSString * _Nonnull longitude, NSString * _Nonnull latitude) {
            //更改用户的经纬度
            [UserInfoManager sharedInstance].longitude = [NSString stringWithFormat:@"%@",longitude];
            [UserInfoManager sharedInstance].latitude = [NSString stringWithFormat:@"%@",latitude];
            [UserInfoManager synchronize];
            [weakSelf.headView updateCountryAddress:addressStr];
            [weakSelf _loadingData];
        };
        vc.hidesBottomBarWhenPushed = YES;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    
    self.headView.deleteSearchKey = ^{
        [weakSelf.headView updateDeleteSearch];
    };
    self.headView.currentLocationAction = ^(UILabel * _Nonnull label) {
        CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
        if (status == kCLAuthorizationStatusNotDetermined){
            //用户尚未做出决定是否启用定位服务
            NSLog(@"用户尚未做出决定是否启用定位服务");
        }else if (status == kCLAuthorizationStatusRestricted){
            //没有获得用户授权使用定位服务, 可能用户没有自己禁止访问授权
            NSLog(@"没有获得用户授权使用定位服务, 可能用户没有自己禁止访问授权");
        }else if (status == kCLAuthorizationStatusAuthorizedAlways || status == kCLAuthorizationStatusAuthorizedWhenInUse){
            //kCLAuthorizationStatusAuthorizedAlways //应用获得授权可以一直使用定位服务，即使应用不在使用状态
            //kCLAuthorizationStatusAuthorizedWhenInUse
            //使用此应用过程中允许访问定位服务
            NSLog(@"使用此应用过程中允许访问定位服务");
            label.text = @"刷新中";
            [weakSelf startLocation];
            
        }else {
            
            NSLog(@"用户已经明确禁止应用使用定位服务或者当前系统定位服务处于关闭状态");
            BOOL openLocation =  [[NSUserDefaults standardUserDefaults ]boolForKey:@"openLocation"];
            if (!openLocation) {
                
            }
        }
    };
    self.headView.searchAction = ^(NSString * _Nonnull str) {
        
        HHSearchViewController *vc = [[HHSearchViewController alloc] init];
        vc.searchStr = str;
        vc.selectedAction = ^(NSString * _Nonnull str) {
            
            [weakSelf.headView updateSearch:str];
        };
        vc.hidesBottomBarWhenPushed = YES;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    self.headView.lookupAction = ^(NSString * _Nonnull searchText) {
        HHHotelSearchViewController *vc = [[HHHotelSearchViewController alloc] init];
        if(self.index == 1){
            vc.hotelSearchType = KHotelSearchTypeHourly;
        }else if(self.index == 0){
            vc.hotelSearchType = KHotelSearchTypeContry;
        }else {
            vc.hotelSearchType = KHotelSearchTypeDormintory;
        }
        
        vc.type_Str = weakSelf.type_country_Str;
        vc.startModel = weakSelf.startModel;
        vc.endModel = weakSelf.endModel;
        vc.type_section = weakSelf.type_section;
        vc.searchKeyString = searchText;
        vc.updateDateAction = ^(DayModel * _Nonnull startModel, DayModel * _Nonnull endModel, NSString * _Nonnull searchStr, NSString * _Nonnull str) {
            weakSelf.startModel = startModel;
            weakSelf.endModel = endModel;
            weakSelf.all_str = str;
            if ([str containsString:@"人"] || [str containsString:@"床"]) {
                if(weakSelf.index == 2){
                    weakSelf.type_country_Str = weakSelf.all_str;
                }else {
                    NSArray *array = [weakSelf.all_str componentsSeparatedByString:@","];
                    NSMutableArray *arr = [NSMutableArray arrayWithArray:array];
                    [arr removeObjectAtIndex:0];
                    weakSelf.type_country_Str = [arr componentsJoinedByString:@","];
                }
            }else {
                weakSelf.type_country_Str = weakSelf.all_str;
            }
            [weakSelf.headView updateSetup:weakSelf.type_country_Str];
            [weakSelf.headView updateSearch:searchStr];
        };
        vc.hidesBottomBarWhenPushed = YES;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    
    self.headView.selectedSetupAction = ^{
        UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
        weakSelf.priceView = [[HHHomePriceView alloc] init];
        if(weakSelf.index == 0){
            weakSelf.priceView.isHour = NO;
            weakSelf.priceView.isDormitory = NO;
        }else if(weakSelf.index == 1){
            weakSelf.priceView.isHour = YES;
            weakSelf.priceView.isDormitory = NO;
        }else {
            weakSelf.priceView.isHour = NO;
            weakSelf.priceView.isDormitory = YES;
        }
        weakSelf.priceView.type = @"bottom";
        weakSelf.priceView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        weakSelf.priceView.clickCloseButton = ^{
            [weakSelf.priceView removeFromSuperview];
        };
        weakSelf.priceView.selectedWithDormitorySuccess = ^(NSString * _Nonnull dormitory, NSString * _Nonnull str, NSDictionary * _Nonnull dic) {
            [weakSelf.priceView removeFromSuperview];
            weakSelf.type_section = dic;
            if(dormitory.length == 0){
                if(str.length == 0){
                    weakSelf.type_country_Str = @"价格星级";
                    weakSelf.all_str = @"价格星级";
                }else {
                    weakSelf.type_country_Str = str;
                    weakSelf.all_str = str;
                }
            }else {
                if(str.length == 0){
                    weakSelf.type_country_Str = dormitory;
                    weakSelf.all_str = dormitory;
                }else {
                    weakSelf.type_country_Str = [NSString stringWithFormat:@"%@,%@",dormitory,str];
                    weakSelf.all_str = [NSString stringWithFormat:@"%@,%@",dormitory,str];
                }
            }
            
            [weakSelf.headView updateSetup:weakSelf.type_country_Str];
        };
        weakSelf.priceView.selectedSuccess = ^(NSString * _Nonnull str, NSDictionary * _Nonnull dic) {
            weakSelf.type_section = dic;
            weakSelf.type_country_Str = str;
            weakSelf.all_str = str;
            if(str.length == 0){
                weakSelf.type_country_Str = @"价格星级";
                weakSelf.all_str = @"价格星级";
            }
            
            [weakSelf.priceView removeFromSuperview];
            [weakSelf.headView updateSetup:str];
        };
        [keyWindow addSubview:weakSelf.priceView];
        [weakSelf.priceView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.offset(0);
        }];
    };
    return self.headView;
}

// 设置section头视图的参考大小，与tableheaderview类似
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(kScreenWidth, 570);
}

#pragma mark ---------列表网络请求-------------
- (void)_loadingData{
    NSString *url;
    NSMutableDictionary *dic = @{}.mutableCopy;
    if(self.index == 2){
        url = [NSString stringWithFormat:@"%@/homestay/details/recommend",BASE_URL];
        [dic setValue:@([HashMainData shareInstance].currentEndDateTimeStamp.integerValue*1000) forKey:@"end_time"];
        [dic setValue:@([HashMainData shareInstance].currentStartDateTimeStamp.integerValue*1000) forKey:@"start_time"];
    }else {
        url = [NSString stringWithFormat:@"%@/hotel/get/recommendlist",BASE_URL];
    }
    [dic setValue:[UserInfoManager sharedInstance].longitude forKey:@"longitude"];
    [dic setValue:[UserInfoManager sharedInstance].latitude forKey:@"latitude"];
    [dic setValue:@(self.page) forKey:@"page"];
    [dic setValue:@(10) forKey:@"size"];
    WeakSelf(weakSelf)
    [PPHTTPRequest requestPostWithJSONForUrl:url parameters:dic success:^(id  _Nonnull response) {
        [weakSelf.customcollectionView.mj_header endRefreshing];
        [weakSelf.customcollectionView.mj_footer endRefreshing];
        
        NSString *code = [NSString stringWithFormat:@"%@", response[@"code"]];
        
        if ([code isEqualToString:@"0"]) {//请求成功
            if (self.page == 1) {
                [self.dataArray removeAllObjects];
            }
            NSDictionary *data = response[@"data"];
            
            NSArray *list = data[@"list"];
            NSLog(@"list====%ld",list.count);
            if (list.count !=0) {
                [self.dataArray addObjectsFromArray:[HomeModel mj_objectArrayWithKeyValuesArray:list]];
            }
            if (list.count < 10) {
                if (weakSelf.page == 1) {
                    weakSelf.customcollectionView.mj_footer.hidden = YES;
                }else {
                    weakSelf.customcollectionView.mj_footer.hidden = NO;
                    [weakSelf.customcollectionView.mj_footer endRefreshingWithNoMoreData];
                }
            }else {
                weakSelf.customcollectionView.mj_footer.hidden = NO;
                [weakSelf.customcollectionView.mj_footer resetNoMoreData];
            }
            [weakSelf.customcollectionView reloadData];
        }else {
            [self.view makeToast:response[@"msg"] duration:2 position:CSToastPositionCenter];
        }
        
    } failure:^(NSError * _Nonnull error) {
        [weakSelf.customcollectionView.mj_header endRefreshing];
        [weakSelf.customcollectionView.mj_footer endRefreshing];
        
    }];
}

#pragma mark - UICollectionViewDatasource
//返回单元格的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

//返回单元格
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if(self.index == 2){
        HHDormitoryDetailCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HHDormitoryDetailCollectionViewCell" forIndexPath:indexPath];
        //        cell.backgroundColor = kWhiteColor;
        cell.layer.cornerRadius = 12;
        cell.layer.masksToBounds = YES;
        cell.model = self.dataArray[indexPath.row];
        return cell;
    }else {
        HHHomeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HHHomeCollectionViewCell" forIndexPath:indexPath];
        cell.backgroundColor = kWhiteColor;
        cell.layer.cornerRadius = 12;
        cell.layer.masksToBounds = YES;
        cell.model = self.dataArray[indexPath.row];
        return cell;
    }
}

-(CGSize)itemSizeForHomeCollectionView:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath{
    HomeModel *model = self.dataArray[indexPath.row];
    if(self.index == 2){
        if (model.dormitoryTotalHeight != 0) {
            return CGSizeMake((kScreenWidth - 52)/2, model.dormitoryTotalHeight);
        }else {
            return CGSizeMake(0, 0);
        }
    }else {
        if (model.totalHeight != 0) {
            return CGSizeMake((kScreenWidth - 52)/2, model.totalHeight);
        }else {
            return CGSizeMake(0, 0);
        }
    }
}

#pragma mark - 单元格的选中方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    WeakSelf(weakSelf)
    HomeModel *model = self.dataArray[indexPath.row];
    if(self.index == 2){
        HHDormitoryDetailViewController *vc = [[HHDormitoryDetailViewController alloc] init];
        vc.backType = @"HomeGo";
        vc.homestay_id = model.homestay_id;
        vc.homestay_room_id = model.homestay_room_id;
        vc.updateDateAction = ^(DayModel * _Nonnull startModel, DayModel * _Nonnull endModel) {
            weakSelf.endModel = endModel;
            weakSelf.startModel = startModel;
        };
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        
    }else {
        HHHotelDetailViewController *vc = [[HHHotelDetailViewController alloc] init];
        vc.backType = @"HomeGo";
        vc.dateType = self.index;
        vc.hotel_id = model.hotel_id;
        if(self.index == 1){
            vc.startModel = self.startModel;
        }else {
            vc.startModel = self.startModel;
            vc.endModel = self.endModel;
        }
        vc.updateDateAction = ^(NSInteger dateType, DayModel * _Nonnull startModel, DayModel * _Nonnull endModel) {
            weakSelf.endModel = endModel;
            weakSelf.startModel = startModel;
        };
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat minAlphaOffset = -UINavigateHeight;
    CGFloat maxAlphaOffset = 200;
    CGFloat offset = scrollView.contentOffset.y;
    CGFloat alpha = (offset - minAlphaOffset) / (maxAlphaOffset - minAlphaOffset);
    
    if (offset <= 0) {
        self.navView.bgView.alpha = 0;
        [self.navView.scanButton setImage:HHGetImage(@"icon_home_scan") forState:UIControlStateNormal];
        [self.navView.noticeButton setImage:HHGetImage(@"icon_home_notice") forState:UIControlStateNormal];
    }else {
        self.navView.bgView.alpha = alpha;
        [self.navView.scanButton setImage:HHGetImage(@"icon_home_scan_black") forState:UIControlStateNormal];
        [self.navView.noticeButton setImage:HHGetImage(@"icon_home_notice_black") forState:UIControlStateNormal];
    }
}

- (AMapLocationManager *)locationManager {
    if (!_locationManager) {
        _locationManager = [[AMapLocationManager alloc] init];
        _locationManager.delegate = self;
        //设置定位最小更新距离方法如下，单位米
        _locationManager.distanceFilter = 20;
        // 设置精准度为百米
        _locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    }
    return _locationManager;
}

-(void)startLocation{
    
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        
        if (error != nil && error.code == AMapLocationErrorLocateFailed){
            //定位错误：此时location和regeocode没有返回值，不进行annotation的添加
            [self _loadingData];
            [self _loadingImageData];
            return;
        }
        else if (error != nil
                 && (error.code == AMapLocationErrorReGeocodeFailed
                     || error.code == AMapLocationErrorTimeOut
                     || error.code == AMapLocationErrorCannotFindHost
                     || error.code == AMapLocationErrorBadURL
                     || error.code == AMapLocationErrorNotConnectedToInternet
                     || error.code == AMapLocationErrorCannotConnectToHost))
        {
            //逆地理错误：在带逆地理的单次定位中，逆地理过程可能发生错误，此时location有返回值，regeocode无返回值，进行annotation的添加
        }else if (error != nil && error.code == AMapLocationErrorRiskOfFakeLocation){
            //存在虚拟定位的风险：此时location和regeocode没有返回值，不进行annotation的添加
            return;
        }else{
            //没有错误：location有返回值，regeocode是否有返回值取决于是否进行逆地理操作，进行annotation的添加
        }
        
        [UserInfoManager sharedInstance].longitude = [NSString stringWithFormat:@"%f",location.coordinate.longitude];
        [UserInfoManager sharedInstance].latitude = [NSString stringWithFormat:@"%f",location.coordinate.latitude];
        
        NSString *aoiName = regeocode.AOIName;
        if(aoiName.length == 0){
            NSString *poiName = regeocode.POIName;
            if(poiName.length == 0){
                
                [self.headView updateCountryAddress:[NSString stringWithFormat:@"%@,%@",regeocode.city, regeocode.POIName]];
                [UserInfoManager sharedInstance].address = [NSString stringWithFormat:@"%@,%@",regeocode.city, regeocode.POIName];
            }else {
                [self.headView updateCountryAddress:[NSString stringWithFormat:@"%@,%@",regeocode.city, regeocode.POIName]];
                [UserInfoManager sharedInstance].address = [NSString stringWithFormat:@"%@,%@",regeocode.city, regeocode.POIName];
                
            }
            
        }else {
            [self.headView updateCountryAddress:[NSString stringWithFormat:@"%@,%@",regeocode.city, regeocode.AOIName]];
            [UserInfoManager sharedInstance].address = [NSString stringWithFormat:@"%@,%@",regeocode.city, regeocode.AOIName];
            
        }
        
        [UserInfoManager synchronize];
        
        [self _loadingData];
        [self _loadingImageData];
    }];
}

- (void)amapLocationManager:(AMapLocationManager *)manager doRequireLocationAuth:(CLLocationManager *)locationManager{
    [locationManager requestAlwaysAuthorization];
}

- (void)_loadingDefaultLocationData{
    
    NSString *url = [NSString stringWithFormat:@"%@/data/default",BASE_URL];
    
    [PPHTTPRequest requestGetWithURL:url parameters:@{} success:^(id  _Nonnull response) {
        
        NSString *code = [NSString stringWithFormat:@"%@", response[@"code"]];
        if ([code isEqualToString:@"0"]) {//请求成功
            NSDictionary *data = response[@"data"];
            NSDictionary *location_data = data[@"location_data"];
            NSDictionary *service_data = data[@"service_data"];
            NSDictionary *user_data = data[@"user_data"];
            
            [UserInfoManager sharedInstance].address = [NSString stringWithFormat:@"%@",location_data[@"desc"]];
            [UserInfoManager sharedInstance].longitude = [NSString stringWithFormat:@"%@",location_data[@"longitude"]];
            [UserInfoManager sharedInstance].latitude = [NSString stringWithFormat:@"%@",location_data[@"latitude"]];
            
            [self.headView updateCountryAddress:[NSString stringWithFormat:@"%@",location_data[@"desc"]]];
            [UserInfoManager synchronize];
            [HashMainData shareInstance].user_head_img = user_data[@"user_head_img"];
            [HashMainData shareInstance].tel = service_data[@"tel"];
            
            [self _startPositioning];
        } else {
            [self.view makeToast:response[@"msg"] duration:2 position:CSToastPositionCenter];
        }
        
    } failure:^(NSError * _Nonnull error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view makeToast:@"网络异常，请检查网络后重试" duration:2 position:CSToastPositionCenter];
        });
    }];
}

#pragma mark --------------------------- 定位---------------------
- (void)_startPositioning{
    
    if (_cllLocationManager == nil) {
        _cllLocationManager = [[CLLocationManager alloc] init];
        //设置定位的精准度
        [_cllLocationManager setDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
        _cllLocationManager.delegate = self;
        
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
            //请求用户授权
            [_cllLocationManager requestWhenInUseAuthorization];
        }
    }
    
    //开始定位
    [_cllLocationManager startUpdatingLocation];
}

/*
 *定位失败
 */
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    //停止更新定位
    [manager stopUpdatingLocation];
    
    //列表数据
    [self _loadingData];
    [self _loadingImageData];
    
}

#pragma mark ---------------- CLLocationManagerDelegate--------------------
//定位不断调用的协议方法
- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations {
    
    //停止更新定位
    [manager stopUpdatingLocation];
    
    //取得当前定位出来的位置
    self.cllLocation = [locations lastObject];
    
    CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
    [geoCoder reverseGeocodeLocation:self.cllLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        
        if (error || placemarks.count == 0) {
            //列表数据
            [self _loadingData];
            [self _loadingImageData];
        } else {
            
            CLPlacemark *placeMark = [placemarks lastObject];
            
            if ([placeMark.ISOcountryCode isEqualToString:@"CN"]) {
                
                if (placeMark.locality.length == 0) {
                    
                }else{
                    
                    if ([self isChineseWithStr:placeMark.administrativeArea]) {
                        [self startLocation];
                    }else {
                        [self _loadingData];
                        [self _loadingImageData];
                    }
                }
            } else {
                [self _loadingData];
                [self _loadingImageData];
            }
        }
    }];
}

- (BOOL)isChineseWithStr:(NSString *)str{
    for(int i = 0; i< [str length]; i++){
        int a = [str characterAtIndex:i];
        if( a > 0x4e00 && a < 0x9fff){
            return YES;
        }else{
            return NO;
        }
    }
    return NO;
}

- (void)updateLocation {
    [self _startPositioning];
}
@end
