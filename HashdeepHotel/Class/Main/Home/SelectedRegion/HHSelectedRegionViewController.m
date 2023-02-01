//
//  HHSelectedRegionViewController.m
//  HashdeepHotel
//
//  Created by Cindy on 2022/7/14.
//

#import "HHSelectedRegionViewController.h"
#import "HHSelectedRegionHeadView.h"
#import "SelectedRegionModel.h"
#import "HHSelectedRegionTableViewCell.h"
#import <AMapLocationKit/AMapLocationKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>

@interface HHSelectedRegionViewController ()<UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, AMapLocationManagerDelegate>
@property (nonatomic, strong) HHSelectedRegionHeadView *headView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UITableView *searchTableView;
@property (nonatomic, strong) NSMutableArray *searchDataArray;
@property (nonatomic,strong) UITextField *textField;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *cellDataArray;
@property (nonatomic, strong) NSMutableDictionary *dataDic;
@property (nonatomic, strong) NSMutableArray *sectionArray;
@property (nonatomic, strong) AMapLocationManager *locationManager;///定位管理器
@end

@implementation HHSelectedRegionViewController
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
    self.sectionArray = [NSMutableArray array];
    self.cellDataArray = [NSMutableArray array];
    self.dataArray = [NSMutableArray array];
    self.searchDataArray = [NSMutableArray array];
    self.dataDic = [NSMutableDictionary dictionary];
    self.view.backgroundColor = kWhiteColor;
    
    [self startLocation];
    
    //自定义导航栏
    [self _createdNavigationBar];
    
    //创建Views
    [self _createdViews];
    
    [self _loadData];
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
    
    WeakSelf(weakSelf)
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        if (error != nil && error.code == AMapLocationErrorLocateFailed){
            //定位错误：此时location和regeocode没有返回值，不进行annotation的添加
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
            NSLog(@"逆地理错误:{%ld - %@};", (long)error.code, error.localizedDescription);
        }
        else if (error != nil && error.code == AMapLocationErrorRiskOfFakeLocation){
            //存在虚拟定位的风险：此时location和regeocode没有返回值，不进行annotation的添加
            NSLog(@"存在虚拟定位的风险:{%ld - %@};", (long)error.code, error.localizedDescription);
            return;
        }
        else{
            //没有错误：location有返回值，regeocode是否有返回值取决于是否进行逆地理操作，进行annotation的添加
        }
        weakSelf.headView.refreshLocationLabel.text = @"刷新位置";
        
        NSString *aoiName = regeocode.AOIName;
        if(aoiName.length == 0){
            NSString *poiName = regeocode.POIName;
            if(poiName.length == 0){
                self.headView.addressLabel.text = [NSString stringWithFormat:@"%@,%@",regeocode.city, regeocode.POIName];
            }else {
                self.headView.addressLabel.text = [NSString stringWithFormat:@"%@,%@",regeocode.city, regeocode.POIName];
            }
            
        }else {
            
            self.headView.addressLabel.text = [NSString stringWithFormat:@"%@,%@",regeocode.city, regeocode.AOIName];
            
        }
    }];
}

- (void)amapLocationManager:(AMapLocationManager *)manager doRequireLocationAuth:(CLLocationManager *)locationManager{
    [locationManager requestAlwaysAuthorization];
}

- (void)_loadData {
    
    NSString *url = [NSString stringWithFormat:@"%@/hotel/city",BASE_URL];
    [PPHTTPRequest requestGetWithURL:url parameters:@{} success:^(id  _Nonnull response) {
        NSLog(@"response====%@",response);
        NSString *code = [NSString stringWithFormat:@"%@", response[@"code"]];
        if ([code isEqualToString:@"0"]) {//请求成功
            NSMutableArray *cityArray = [NSMutableArray array];
            for (NSDictionary *dict in response[@"data"][@"city_list"]) {
                SelectedRegionModel *model = [SelectedRegionModel mj_objectWithKeyValues:dict];
                [cityArray addObject:model];
                [self.dataArray addObject:model];
            }
            
            NSDictionary *data = response[@"data"];
            NSArray *city_list = data[@"city_list"];
            
            for (int b=0; b<city_list.count; b++) {
                NSDictionary *dic = city_list[b];
                NSString *character = dic[@"character"];
                
                NSMutableArray *tempArray = [[self.dataDic objectForKey:character] mutableCopy];
                if (tempArray.count == 0) {
                    [self.sectionArray addObject:dic[@"character"]];
                    NSMutableArray *array = [[NSMutableArray alloc] initWithObjects:dic, nil];
                    [self.dataDic setObject:array forKey:character];
                } else {
                    [tempArray addObject:dic];
                    [self.dataDic setObject:tempArray forKey:character];
                }
            }
            
            NSMutableArray *hotArray = [NSMutableArray array];
            for (NSDictionary *dict in response[@"data"][@"city_popular"]) {
                SelectedRegionModel *model = [SelectedRegionModel mj_objectWithKeyValues:dict];
                [hotArray addObject:model];
            }
            
            CGFloat height = [self.headView updateHotUI:hotArray];
            self.headView.frame = CGRectMake(0, 0, kScreenWidth, height);
            self.headView.hidden = NO;
            [self.tableView reloadData];
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
    [self createdNavigationBackButton];
    
    UIView *searchView = [[UIView alloc] init];
    searchView.layer.cornerRadius = 5;
    searchView.layer.masksToBounds = YES;
    searchView.backgroundColor = XLColor_mainColor;
    [self.view addSubview:searchView];
    [searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(70);
        make.right.offset(-15);
        make.top.offset(UINavigateTop+5);
        make.height.offset(36);
    }];
    
    UIImageView *searchImgView = [[UIImageView alloc] init];
    searchImgView.image = HHGetImage(@"icon_home_search");
    [searchView addSubview:searchImgView];
    [searchImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.centerY.equalTo(searchView);
        make.width.offset(17);
        make.height.offset(16);
    }];
    
    self.textField = [[UITextField alloc] init];
    self.textField.borderStyle = UITextBorderStyleNone;
    self.textField.font = XLFont_mainTextFont;
    self.textField.textColor = XLColor_mainTextColor;
    self.textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"搜索城市" attributes:@{
        NSForegroundColorAttributeName:XLColor_subSubTextColor
    }];
    self.textField.textAlignment = NSTextAlignmentLeft;
    self.textField.keyboardType = UIKeyboardTypeTwitter;
    self.textField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.textField.delegate = self;
    self.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [searchView addSubview:self.textField];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(searchImgView.mas_right).offset(10);
        make.top.bottom.offset(0);
        make.right.offset(-15);
    }];
    
}

#pragma mark ---------------------创建Views---------------------
- (void)_createdViews {
    WeakSelf(weakSelf)
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.offset(0);
        make.top.offset(UINavigateHeight);
    }];
    
    self.headView = [[HHSelectedRegionHeadView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 140)];
    self.headView.hidden = YES;
    self.headView.backgroundColor = kWhiteColor;
    self.tableView.tableHeaderView = self.headView;
    self.headView.clickUpdateLocation = ^{
        weakSelf.headView.refreshLocationLabel.text = @"刷新中";
        [weakSelf startLocation];
    };
    
    self.headView.clickHotAddress = ^(NSString * _Nonnull str, NSString * _Nonnull longitude, NSString * _Nonnull latitude) {
        if (weakSelf.clickCellAction) {
            weakSelf.clickCellAction(str,longitude,latitude);
        }
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    
    [self.view addSubview:self.searchTableView];
    [self.searchTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.offset(0);
        make.top.offset(UINavigateHeight);
    }];
}

#pragma mark -----------UITableViewDelegate------------
//显示每组标题索引
-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    if (tableView.tag == 100) {
        return self.sectionArray;
    }
    return 0;
}
//返回每个索引的内容
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (tableView.tag == 100) {
        return self.sectionArray[section];
    }
    return nil;
}

//响应点击索引时的委托方法
-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString*)title atIndex:(NSInteger)index {
    if (tableView.tag == 100) {
        return index;
    }
    return 0;
}

//组的数量
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView.tag == 100) {
        return self.sectionArray.count;
    }
    return 1;
}

//每组单元格的数量
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView.tag == 100) {
        
        NSString *str = self.sectionArray[section];
        NSArray *array = self.dataDic[str];
        return array.count;
        
    }else {
        return self.searchDataArray.count;
    }
}

//创建单元格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag == 100) {
        HHSelectedRegionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HHSelectedRegionTableViewCell" forIndexPath:indexPath];
        if(cell ==nil){
            cell =[[HHSelectedRegionTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"HHSelectedRegionTableViewCell"];
        }
        NSString *str = self.sectionArray[indexPath.section];
        NSArray *array = self.dataDic[str];
        [self.cellDataArray removeAllObjects];
        [self.cellDataArray addObjectsFromArray:[SelectedRegionModel mj_objectArrayWithKeyValuesArray:array]];
        cell.model = self.cellDataArray[indexPath.row];
        cell.backgroundColor = kWhiteColor;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    }else {
        SelectedRegionModel *model = self.searchDataArray[indexPath.row];
        HHSelectedRegionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HHSelectedRegionTableViewCell" forIndexPath:indexPath];
        if(cell ==nil){
            cell =[[HHSelectedRegionTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"HHSelectedRegionTableViewCell"];
        }
        cell.model = model;
        cell.backgroundColor = kWhiteColor;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}
//组的头视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (tableView.tag == 100) {
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
        headerView.backgroundColor = kWhiteColor;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 20, 30)];
        label.text = self.sectionArray[section];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = KBoldFont(16);
        label.textColor = XLColor_mainTextColor;
        [headerView addSubview:label];
        
        return headerView;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

//组头的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (tableView.tag == 100) {
        return 30;
    }
    return 0;
}

//设置单元格的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

//单元格点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag == 100) {
        NSString *str = self.sectionArray[indexPath.section];
        NSArray *array = self.dataDic[str];
        NSDictionary *dic = array[indexPath.row];
        if (self.clickCellAction) {
            self.clickCellAction(dic[@"city_name"],dic[@"city_longitude"],dic[@"city_latitude"]);
        }
        
    }else {
        SelectedRegionModel *model = self.searchDataArray[indexPath.row];
        if (self.clickCellAction) {
            self.clickCellAction(model.city_name,model.city_longitude,model.city_latitude);
        }
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.bounces = NO;
        _tableView.tag = 100;
        _tableView.sectionIndexColor = XLColor_mainTextColor;
        _tableView.backgroundColor = kWhiteColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        [_tableView registerClass:[HHSelectedRegionTableViewCell class] forCellReuseIdentifier:@"HHSelectedRegionTableViewCell"];
        
    }
    return _tableView;
}

- (UITableView *)searchTableView {
    if (!_searchTableView) {
        _searchTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _searchTableView.dataSource = self;
        _searchTableView.delegate = self;
        _searchTableView.bounces = NO;
        _searchTableView.sectionIndexColor = XLColor_mainTextColor;
        _searchTableView.backgroundColor = kWhiteColor;
        _searchTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _searchTableView.showsVerticalScrollIndicator = NO;
        _searchTableView.showsHorizontalScrollIndicator = NO;
        _searchTableView.rowHeight = UITableViewAutomaticDimension;
        _searchTableView.hidden = YES;
        [_searchTableView registerClass:[HHSelectedRegionTableViewCell class] forCellReuseIdentifier:@"HHSelectedRegionTableViewCell"];
        
    }
    return _searchTableView;
}

- (void)textFieldDidChangeSelection:(UITextField *)textField {
    if (textField.text.length == 0) {
        [textField resignFirstResponder];
        [self.searchDataArray removeAllObjects];
        self.searchTableView.hidden = YES;
        self.tableView.hidden = NO;
        [self.tableView reloadData];
        [self.searchTableView reloadData];
        
    }else {
        [self.searchDataArray removeAllObjects];
        for (SelectedRegionModel *model in self.dataArray) {
            if ([model.city_name containsString:textField.text]) {
                [self.searchDataArray addObject:model];
            }
        }
        self.searchTableView.hidden = NO;
        self.tableView.hidden = YES;
        [self.searchTableView reloadData];
    }
    
}

@end
