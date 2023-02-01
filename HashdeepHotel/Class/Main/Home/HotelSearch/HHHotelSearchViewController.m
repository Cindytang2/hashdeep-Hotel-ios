//
//  HHHotelSearchViewController.m
//  HashdeepHotel
//
//  Created by Cindy on 2022/7/18.
//

#import "HHHotelSearchViewController.h"
#import "HHHotelNavigationView.h"
#import "HHHotelListCell.h"
#import "HHHotelModel.h"
#import "HHHotelMenuView.h"
#import "HHSearchViewController.h"
#import "HHCalendarView.h"
#import "HHHoteNoDataCell.h"
#import "HHHotelDetailViewController.h"
#import "HHHotelMapView.h"
#import "HHHotelMenuModel.h"
#import "HHDormitoryTableViewCell.h"
#import "TABAnimated.h"
#import "HHDormitoryDetailViewController.h"
@interface HHHotelSearchViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) HHHotelNavigationView *navView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) HHHotelMenuView *menuView;
@property (nonatomic, assign) BOOL isMap;
@property (nonatomic, assign) BOOL isLoad;
@property (nonatomic, strong) HHCalendarView *calendarView;
@property (nonatomic, strong) HHHotelMapView *mapView;
@property (nonatomic, copy) NSString *distance_condition;
@property (nonatomic, copy) NSString *location;
@property (nonatomic, assign) BOOL is_location;
@end

@implementation HHHotelSearchViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if(self.updateDateAction){
        self.updateDateAction(self.startModel, self.endModel,self.searchKeyString,self.type_Str);
    }
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"homeSearchScreenArray"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"homeSearchScreenTitleArray"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    WeakSelf(weakSelf)
    self.view.backgroundColor = kWhiteColor;
    self.isMap = NO;
    self.is_location = NO;
    self.page = 1;
    self.dataArray = [NSMutableArray array];
    
    //自定义导航栏
    [self _createdNavigationBar];
    
    [self _createdViews];
    
    // 启动动画
    [self.tableView tab_startAnimationWithCompletion:^{
        [self _loadMenuData];
    }];
    
    self.clickUpdateButton = ^{
        [weakSelf _loadMenuData];
    };
}

- (void)_createdViews {
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.offset(0);
        make.top.offset(UINavigateHeight+5+40);
    }];
    
    WeakSelf(weakSelf)
    self.mapView = [[HHHotelMapView alloc] init];
    self.mapView.type = self.hotelSearchType;
    self.mapView.hidden = YES;
    self.mapView.goDetailVC = ^(HHHotelModel * _Nonnull model) {
        HHHotelDetailViewController *vc = [[HHHotelDetailViewController alloc] init];
        vc.backType = @"searchGo";
        vc.hotel_id = model.pid;
        if(weakSelf.hotelSearchType == 1){
            vc.dateType = 1;
            vc.startModel = weakSelf.startModel;
        }else {
            vc.dateType = 0;
            vc.startModel = weakSelf.startModel;
            vc.endModel = weakSelf.endModel;
        }
        vc.hidesBottomBarWhenPushed = YES;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    
    [self.view addSubview:self.mapView];
    [self.mapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.offset(0);
        make.top.offset(UINavigateHeight+5+40);
    }];
    
    NSMutableArray *arr = [NSMutableArray array];
    HHHotelMenuModel *sortingModel = [[HHHotelMenuModel alloc] init];
    sortingModel.name = @"智能排序";
    sortingModel.isSelected = NO;
    [arr addObject:sortingModel];
    
    HHHotelMenuModel *locationModel = [[HHHotelMenuModel alloc] init];
    locationModel.name = @"位置区域";
    locationModel.isSelected = NO;
    [arr addObject:locationModel];
    
    HHHotelMenuModel *starModel = [[HHHotelMenuModel alloc] init];
    starModel.name = self.type_Str;
    starModel.isSelected = NO;
    [arr addObject:starModel];
    
    HHHotelMenuModel *screeningModel = [[HHHotelMenuModel alloc] init];
    screeningModel.name = @"筛选";
    screeningModel.isSelected = NO;
    [arr addObject:screeningModel];
    
    self.menuView = [[HHHotelMenuView alloc] init];
    self.menuView.backgroundColor = kWhiteColor;
    self.menuView.dataArray = arr;
    if(self.hotelSearchType == 0){
        self.menuView.type = @"0";
    }else if(self.hotelSearchType == 1){
        self.menuView.type = @"1";
    }else {
        self.menuView.type = @"2";
    }
    self.menuView.selectedIntelligenceSuccess = ^(NSString * _Nonnull str) {
        weakSelf.page = 1;
        weakSelf.type_click = str;
        weakSelf.tableView.contentOffset = CGPointMake(0, 0);
        [weakSelf _loadData];
    };
    self.menuView.selectedPriceSuccess = ^(NSDictionary * _Nonnull dic, NSString * _Nonnull dormitoryStr, NSString * _Nonnull str) {
        if(dormitoryStr.length == 0 && str.length == 0){
            weakSelf.type_Str = @"价格星级";
        }else {
            if(dormitoryStr.length == 0){
                weakSelf.type_Str = str;
            }else {
                if(str.length == 0) {
                    weakSelf.type_Str = dormitoryStr;
                }else {
                    weakSelf.type_Str = [NSString stringWithFormat:@"%@,%@",dormitoryStr,str];
                }
            }
        }
        
        weakSelf.page = 1;
        weakSelf.type_section = dic;
        weakSelf.tableView.contentOffset = CGPointMake(0, 0);
        [weakSelf _loadData];
    };
    self.menuView.selectedScreenSuccess = ^(NSArray * _Nonnull arr) {
        weakSelf.page = 1;
        weakSelf.type_has_tag = arr;
        weakSelf.tableView.contentOffset = CGPointMake(0, 0);
        [weakSelf _loadData];
    };
    self.menuView.selectedLocationSuccess = ^(NSString * _Nonnull distance_condition, NSString * _Nonnull location, BOOL is_location) {
        weakSelf.page = 1;
        weakSelf.distance_condition = distance_condition;
        weakSelf.location = location;
        weakSelf.is_location = is_location;
        weakSelf.tableView.contentOffset = CGPointMake(0, 0);
        [weakSelf _loadData];
    };
    [self.view addSubview:self.menuView];
    [self.menuView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.height.offset(40);
        make.top.offset(UINavigateHeight);
    }];
}

- (void)_loadMenuData {
    
    NSString *url = [NSString stringWithFormat:@"%@/hotel/selecttype",BASE_URL];
    NSMutableDictionary *dic = @{}.mutableCopy;
    [dic setValue:@"1" forKey:@"longitude"];
    [dic setValue:@"2" forKey:@"latitude"];
    [PPHTTPRequest requestPostWithJSONForUrl:url parameters:dic success:^(id  _Nonnull response) {
        NSLog(@"菜单=====%@",response);
        NSString *code = [NSString stringWithFormat:@"%@", response[@"code"]];
        if ([code isEqualToString:@"0"]) {//请求成功
            [self.noNetWorkView removeFromSuperview];
            self.menuView.data = response[@"data"];
            [self _loadData];
        }
    } failure:^(id  _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self noNetworkUI];
        });
    }];
}

- (void)_loadData {
    
    NSString *url;
    if(self.hotelSearchType == 2 ){
        url = [NSString stringWithFormat:@"%@/homestay/list",BASE_URL];
    }else {
        url = [NSString stringWithFormat:@"%@/hotel/list",BASE_URL];
    }
    NSMutableDictionary *dic = @{}.mutableCopy;
    [dic setValue:@(self.page) forKey:@"page"];
    [dic setValue:@(10) forKey:@"size"];
    [dic setValue:[UserInfoManager sharedInstance].longitude forKey:@"longitude"];
    [dic setValue:[UserInfoManager sharedInstance].latitude forKey:@"latitude"];
    [dic setValue:self.searchKeyString forKey:@"content"];
    [dic setValue:self.type_click forKey:@"type_click"];
    [dic setValue:self.type_has_tag forKey:@"type_has_tag"];
    [dic setValue:self.type_section forKey:@"type_section"];
    [dic setValue:@([HashMainData shareInstance].currentEndDateTimeStamp.integerValue*1000) forKey:@"end_time"];
    [dic setValue:@([HashMainData shareInstance].currentStartDateTimeStamp.integerValue*1000) forKey:@"start_time"];
    [dic setValue:@(self.is_location) forKey:@"is_location"];
    [dic setValue:self.location forKey:@"location"];
    [dic setValue:self.distance_condition forKey:@"distance_condition"];
    if(self.hotelSearchType == 0){
        [dic setValue:@(NO) forKey:@"is_hourly"];
    }else if(self.hotelSearchType == 1){
        [dic setValue:@(YES) forKey:@"is_hourly"];
    }else {
        [dic setValue:@{
            @"number":@([HashMainData shareInstance].dormitoryPeopleNumber),
            @"bed_num":@([HashMainData shareInstance].dormitoryBedNumber)
        } forKey:@"bed_request"];
    }
    WeakSelf(weakSelf)
    [PPHTTPRequest requestPostWithJSONForUrl:url parameters:dic success:^(id  _Nonnull response) {
        weakSelf.isLoad = YES;
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        NSLog(@"response====%@",response);
        NSString *code = [NSString stringWithFormat:@"%@", response[@"code"]];
        if ([code isEqualToString:@"0"]) {//请求成功
            
            if (self.page == 1) {
                [self.dataArray removeAllObjects];
            }
            NSDictionary *data = response[@"data"];
            NSArray *list = data[@"list"];
            if (list.count !=0) {
                [self.dataArray addObjectsFromArray:[HHHotelModel mj_objectArrayWithKeyValuesArray:list]];
            }
            if (list.count < 10) {
                if (self.page == 1) {
                    self.tableView.mj_footer.hidden = YES;
                }else {
                    self.tableView.mj_footer.hidden = NO;
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }
            }else {
                weakSelf.tableView.mj_footer.hidden = NO;
                [weakSelf.tableView.mj_footer resetNoMoreData];
            }
            self.mapView.dataArray = self.dataArray;
            // 停止动画,并刷新数据
            [self.tableView tab_endAnimationEaseOut];
            [self.tableView reloadData];
        }else {
            [self.view makeToast:response[@"msg"] duration:2 position:CSToastPositionCenter];
        }
    } failure:^(NSError * _Nonnull error) {
        weakSelf.isLoad = YES;
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        
    }];
    
}
- (void)backButtonAction {
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    for (UIView *view in keyWindow.subviews) {
        if (view.tag == 100 || view.tag == 200 || view.tag == 300 || view.tag == 400) {
            [view removeFromSuperview];
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -----------------------自定义导航栏-----------------------
- (void)_createdNavigationBar {
    WeakSelf(weakSelf)
    [self createdNavigationBackButton];
    
    self.navView = [[HHHotelNavigationView alloc] init];
    
    if(self.hotelSearchType == 1) {
        self.navView.index = 1;
    }else if(self.hotelSearchType == 0){
        self.navView.index = 0;
    }else {
        self.navView.index = 2;
    }
    
    if (self.searchKeyString.length != 0) {
        self.navView.searchLabel.text = self.searchKeyString;
        self.navView.searchLabel.textColor = XLColor_mainTextColor;
        self.navView.deleteButton.hidden = NO;
        [self.navView.searchLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.offset(-50);
        }];
        [self.navView.deleteButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.height.offset(17);
            make.right.offset(-15);
        }];
        
    }else {
        self.navView.searchLabel.text = @"关键字/位置/品牌";
        self.navView.searchLabel.textColor = XLColor_subSubTextColor;
        self.navView.deleteButton.hidden = YES;
        [self.navView.searchLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.offset(-15);
        }];
        [self.navView.deleteButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.height.offset(0);
            make.right.offset(0);
        }];
    }
    [self.view addSubview:self.navView];
    [self.navView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(0);
        make.left.offset(60);
        make.top.offset(UINavigateTop);
        make.height.offset(44);
    }];
    
    self.navView.clickSearchAction = ^{
        [weakSelf updataMenuUI];
        HHSearchViewController *vc = [[HHSearchViewController alloc] init];
        vc.searchStr = weakSelf.searchKeyString;
        vc.selectedAction = ^(NSString * _Nonnull str) {
            weakSelf.searchKeyString = str;
            if (weakSelf.searchKeyString.length != 0) {
                weakSelf.navView.searchLabel.text = weakSelf.searchKeyString;
                weakSelf.navView.searchLabel.textColor = XLColor_mainTextColor;
                weakSelf.navView.deleteButton.hidden = NO;
                [weakSelf.navView.searchLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.right.offset(-50);
                }];
                [weakSelf.navView.deleteButton mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.width.height.offset(17);
                    make.right.offset(-15);
                }];
                
            }else {
                weakSelf.navView.searchLabel.text = @"关键字/位置/品牌";
                weakSelf.navView.searchLabel.textColor = XLColor_subSubTextColor;
                weakSelf.navView.deleteButton.hidden = YES;
                [weakSelf.navView.searchLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.right.offset(-15);
                }];
                [weakSelf.navView.deleteButton mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.width.height.offset(0);
                    make.right.offset(0);
                }];
            }
            [weakSelf _loadData];
        };
        vc.hidesBottomBarWhenPushed = YES;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    self.navView.clickDeleteAction = ^{
        weakSelf.searchKeyString = @"";
        weakSelf.page = 1;
        [weakSelf _loadData];
        
    };
    self.navView.clickDateAction = ^{
        [weakSelf updataMenuUI];
        UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
        
        weakSelf.calendarView = [[HHCalendarView alloc] init];
        weakSelf.calendarView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        if(self.hotelSearchType == 1) {
            weakSelf.calendarView.dateType = KDateTypeHour;
            weakSelf.calendarView.startModel = weakSelf.startModel;
        }else {
            weakSelf.calendarView.dateType = KDateTypeContry;
            //设置默认显示的开始时间与结束时间
            weakSelf.calendarView.startModel = weakSelf.startModel;
            weakSelf.calendarView.endModel = weakSelf.endModel;
        }
        weakSelf.calendarView.clickCloseButton = ^{
            [weakSelf.calendarView removeFromSuperview];
        };
        
        weakSelf.calendarView.calendarViewBlock = ^(NSDictionary * _Nonnull dic, DateType dateType, DayModel * _Nonnull startModel, DayModel * _Nonnull endModel) {
            weakSelf.startModel = startModel;
            weakSelf.endModel = endModel;
            
            //修改时租房、国内国际、民宿的显示的日期
            if(dateType == KDateTypeHour) {
                [HashMainData updateHourlyDateWithDic:dic];
                [HashMainData shareInstance].hourlyStartModel = startModel;
            }else{
                [HashMainData updateDateWithDic:dic];
                [HashMainData shareInstance].startModel = startModel;
                [HashMainData shareInstance].endModel = endModel;
            }
            NSString *str3 = [dic[@"startDate"] stringByReplacingOccurrencesOfString:@"月" withString:@"."];
            NSArray *array = [str3 componentsSeparatedByString:@"日"];
            NSString *str4 = [dic[@"endDate"] stringByReplacingOccurrencesOfString:@"月" withString:@"."];
            NSArray *array2 = [str4 componentsSeparatedByString:@"日"];
            weakSelf.navView.checkInLabel.text = array.firstObject;
            weakSelf.navView.checkOutLabel.text = array2.firstObject;
            
            [weakSelf _loadData];
        };
        [keyWindow addSubview:weakSelf.calendarView];
        [weakSelf.calendarView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.offset(0);
        }];
        [weakSelf.calendarView reloadMyTable];
    };
    
    self.navView.clickMapAction = ^(UIButton * _Nonnull button) {
        [weakSelf.menuView hiddenSubViews];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            button.enabled = YES;
       });
        weakSelf.mapView.dataArray = weakSelf.dataArray;
        if (button.selected) {
            weakSelf.mapView.hidden = NO;
            weakSelf.tableView.hidden = YES;
        }else {
            weakSelf.mapView.hidden = YES;
            weakSelf.tableView.hidden = NO;
        }
    };
}

- (void)updataMenuUI {
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    for (UIView *view in keyWindow.subviews) {
        if (view.tag == 100 || view.tag == 200 || view.tag == 300 || view.tag == 400) {
            view.hidden = YES;
        }
    }
    
    UIButton *button1 = [self.menuView viewWithTag:10];
    UIButton *button2 = [self.menuView viewWithTag:11];
    UIButton *button3 = [self.menuView viewWithTag:12];
    UIButton *button4 = [self.menuView viewWithTag:13];
    button1.selected = NO;
    button2.selected = NO;
    button3.selected = NO;
    button4.selected = NO;
    UIImageView *imgView1 = [button1 viewWithTag:200];
    imgView1.image = HHGetImage(@"icon_home_hotel_down");
    
    UIImageView *imgView2 = [button2 viewWithTag:200];
    imgView2.image = HHGetImage(@"icon_home_hotel_down");
    
    UIImageView *imgView3 = [button3 viewWithTag:200];
    imgView3.image = HHGetImage(@"icon_home_hotel_down");
    
    UIImageView *imgView4 = [button4 viewWithTag:200];
    imgView4.image = HHGetImage(@"icon_home_hotel_down");
    
}
#pragma mark ---------------UITableViewDelegate-----------
//每组单元格的数量
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.dataArray.count == 0 && self.isLoad) {
        return 1;
    }else {
        return self.dataArray.count;
    }
}

//创建单元格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.dataArray.count > 0) {
        WeakSelf(weakSelf)
        if(self.hotelSearchType == 2){
            HHHotelModel *model = self.dataArray[indexPath.row];
            HHDormitoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HHDormitoryTableViewCell" forIndexPath:indexPath];
            if(cell ==nil){
                cell =[[HHDormitoryTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"HHDormitoryTableViewCell"];
            }
            cell.clickImageAction = ^{
                HHDormitoryDetailViewController *vc = [[HHDormitoryDetailViewController alloc] init];
                vc.backType = @"searchGo";
                vc.homestay_id = model.homestay_id;
                vc.homestay_room_id = model.homestay_room_id;
                vc.startModel = self.startModel;
                vc.endModel = self.endModel;
                vc.updateDateAction = ^(DayModel * _Nonnull startModel, DayModel * _Nonnull endModel) {
                    weakSelf.endModel = endModel;
                    weakSelf.startModel = startModel;
                    NSString *str3 = [[HashMainData shareInstance].currentStartDateStr stringByReplacingOccurrencesOfString:@"月" withString:@"."];
                    NSArray *array = [str3 componentsSeparatedByString:@"日"];
                    NSString *str4 = [[HashMainData shareInstance].currentEndDateStr stringByReplacingOccurrencesOfString:@"月" withString:@"."];
                    NSArray *array2 = [str4 componentsSeparatedByString:@"日"];
                    weakSelf.navView.checkInLabel.text = array.firstObject;
                    weakSelf.navView.checkOutLabel.text = array2.firstObject;
                    
                    [self _loadData];
                };
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            };
            cell.model = self.dataArray[indexPath.row];
            cell.backgroundColor = kWhiteColor;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else {
            HHHotelListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HHHotelListCell" forIndexPath:indexPath];
            if(cell ==nil){
                cell =[[HHHotelListCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"HHHotelListCell"];
            }
            if(self.hotelSearchType == 0){
                cell.type = @"0";
            }else if(self.hotelSearchType == 1){
                cell.type = @"1";
            }
            cell.model = self.dataArray[indexPath.row];
            cell.backgroundColor = kWhiteColor;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        
    }else {
        HHHoteNoDataCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HHHoteNoDataCell" forIndexPath:indexPath];
        if(cell ==nil){
            cell =[[HHHoteNoDataCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"HHHoteNoDataCell"];
        }
        [cell updateUI:@"icon_home_hotelSearch_nodata" title:@"暂无数据" width:150 height:200 topHeight:(kScreenHeight-UINavigateHeight-40-200)/2-(UINavigateHeight+40)/2];
        cell.backgroundColor = kWhiteColor;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

//设置单元格的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.dataArray.count != 0) {
        HHHotelModel *model = self.dataArray[indexPath.row];
        if(self.hotelSearchType == 0){
            model.type = @"0";
        }else if(self.hotelSearchType == 1){
            model.type = @"1";
        }else {
            model.type = @"2";
        }
        return model.totalHeight;
    }else {
        return kScreenHeight-UINavigateHeight-40;
    }
}

//单元格点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    WeakSelf(weakSelf)
    if (self.dataArray.count != 0) {
        HHHotelModel *model = self.dataArray[indexPath.row];
        if(self.hotelSearchType == 2){
            HHDormitoryDetailViewController *vc = [[HHDormitoryDetailViewController alloc] init];
            vc.backType = @"searchGo";
            vc.homestay_id = model.homestay_id;
            vc.homestay_room_id = model.homestay_room_id;
            vc.startModel = self.startModel;
            vc.endModel = self.endModel;
            vc.updateDateAction = ^(DayModel * _Nonnull startModel, DayModel * _Nonnull endModel) {
                weakSelf.endModel = endModel;
                weakSelf.startModel = startModel;
                NSString *str3 = [[HashMainData shareInstance].currentStartDateStr stringByReplacingOccurrencesOfString:@"月" withString:@"."];
                NSArray *array = [str3 componentsSeparatedByString:@"日"];
                NSString *str4 = [[HashMainData shareInstance].currentEndDateStr stringByReplacingOccurrencesOfString:@"月" withString:@"."];
                NSArray *array2 = [str4 componentsSeparatedByString:@"日"];
                weakSelf.navView.checkInLabel.text = array.firstObject;
                weakSelf.navView.checkOutLabel.text = array2.firstObject;
                
                [self _loadData];
            };
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }else {
            
            HHHotelDetailViewController *vc = [[HHHotelDetailViewController alloc] init];
            vc.backType = @"searchGo";
            vc.hotel_id = model.pid;
            if(self.hotelSearchType == 0){
                vc.dateType = 0;
                vc.startModel = self.startModel;
                vc.endModel = self.endModel;
            }else {
                vc.dateType = 1;
                vc.startModel = self.startModel;
            }
            vc.updateDateAction = ^(NSInteger dateType, DayModel * _Nonnull startModel, DayModel * _Nonnull endModel) {
                if(dateType == 1) {
                    weakSelf.startModel = startModel;
                    
                }else {
                    weakSelf.endModel = endModel;
                    weakSelf.startModel = startModel;
                }
                   
                NSString *str3 = [[HashMainData shareInstance].currentStartDateStr stringByReplacingOccurrencesOfString:@"月" withString:@"."];
                NSArray *array = [str3 componentsSeparatedByString:@"日"];
                NSString *str4 = [[HashMainData shareInstance].currentEndDateStr stringByReplacingOccurrencesOfString:@"月" withString:@"."];
                NSArray *array2 = [str4 componentsSeparatedByString:@"日"];
                weakSelf.navView.checkInLabel.text = array.firstObject;
                weakSelf.navView.checkOutLabel.text = array2.firstObject;
                
                [self _loadData];
            };
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.backgroundColor = RGBColor(243, 244, 247);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[HHHotelListCell class] forCellReuseIdentifier:@"HHHotelListCell"];
        [_tableView registerClass:[HHHoteNoDataCell class] forCellReuseIdentifier:@"HHHoteNoDataCell"];
        [_tableView registerClass:[HHDormitoryTableViewCell class] forCellReuseIdentifier:@"HHDormitoryTableViewCell"];
        
        // 设置tabAnimated相关属性
        _tableView.tabAnimated = [TABTableAnimated animatedWithCellClass:[HHHotelListCell class] cellHeight:200];
        _tableView.tabAnimated.canLoadAgain = YES;
        _tableView.tabAnimated.superAnimationType = TABViewSuperAnimationTypeShimmer;
        _tableView.tabAnimated.adjustBlock = ^(TABComponentManager * _Nonnull manager) {
            manager.animationN(@"timeImageView").height(13);
            manager.animationN(@"scoreImageView").down(-15).height(12);
        };
        
        WeakSelf(weakSelf)
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            //下拉刷新
            weakSelf.page = 1 ;
            [weakSelf _loadData];
        }];
        
        _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            weakSelf.page ++;
            [weakSelf _loadData];
        }];
        _tableView.mj_footer.hidden = YES;
    }
    return _tableView;
}

@end
