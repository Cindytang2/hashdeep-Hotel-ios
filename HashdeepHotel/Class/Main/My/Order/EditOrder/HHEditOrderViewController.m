//
//  HHEditOrderViewController.m
//  HashdeepHotel
//
//  Created by Cindy on 2022/8/4.
//

#import "HHEditOrderViewController.h"
#import "HHEditOrderCell.h"
#import "HHEditOrderView.h"
#import "HHHotelModel.h"
#import "HHCalendarView.h"
#import "HHLowerOrderViewController.h"
#import "HHRoomInfoView.h"
#import "HHEditOrderToastView.h"
@interface HHEditOrderViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) HHEditOrderView *editOrerView;
@property (nonatomic, strong) HHCalendarView *calendarView;
@property (nonatomic, strong) HHRoomInfoView *roomInfoView;
@property (nonatomic, strong) UIButton *doneButton;
@property (nonatomic, assign) BOOL isLoad;
@property (nonatomic, assign) bool isEdit;
@property (nonatomic, copy) NSString *startDateTimeStamp;
@property (nonatomic, copy) NSString *endDateTimeStamp;
@property (nonatomic, strong) DayModel *startModel;//默认的显示的开始时间
@property (nonatomic, strong) DayModel *endModel;//默认的显示的结束时间
@property (nonatomic, strong) HHEditOrderToastView *toastView;
@property (nonatomic, assign) BOOL is_clickCell;
@end

@implementation HHEditOrderViewController

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
    
    self.dataArray = [NSMutableArray array];
    self.isEdit = NO;
    self.view.backgroundColor = XLColor_mainColor;
    
    //自定义导航栏
    [self _createdNavigationBar];
    
    //创建Views
    [self _createdViews];
    
    [self _loadData:self.start_time.integerValue end_time:self.end_time.integerValue];
}

- (void)_loadData:(NSInteger )start_time end_time:(NSInteger )end_time {
    NSString *url = [NSString stringWithFormat:@"%@/hotel/order/page/modify",BASE_URL];
    NSMutableDictionary *dic = @{}.mutableCopy;
    [dic setValue:self.order_id forKey:@"order_id"];
    [dic setValue:@(start_time) forKey:@"start_time"];
    [dic setValue:@(end_time) forKey:@"end_time"];
    WeakSelf(weakSelf)
    [PPHTTPRequest requestPostWithJSONForUrl:url parameters:dic success:^(id  _Nonnull response) {
        weakSelf.isLoad = YES;
        [self.dataArray removeAllObjects];
        NSLog(@"修改=====%@",response);
        NSString *code = [NSString stringWithFormat:@"%@", response[@"code"]];
        if ([code isEqualToString:@"0"]) {//请求成功
            NSDictionary *data = response[@"data"];
            NSArray *room_list = data[@"room_list"];
            if (room_list.count !=0) {
                [self.dataArray addObjectsFromArray:[HHHotelModel mj_objectArrayWithKeyValuesArray:room_list]];
            }
         
            [weakSelf.tableView reloadData];
        }else {
            [self.view makeToast:response[@"msg"] duration:2 position:CSToastPositionCenter];
        }
    } failure:^(NSError * _Nonnull error) {
        weakSelf.isLoad = YES;
        
    }];
}

#pragma mark -----------------------自定义导航栏-----------------------
- (void)_createdNavigationBar {
    
    [self createdNavigationBackButton];
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"修改日期与房型";
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


- (void)setStart_Dic:(NSDictionary *)start_Dic {
    NSString *year = [NSString stringWithFormat:@"%@",start_Dic[@"year"]];
    NSString *month = [NSString stringWithFormat:@"%@",start_Dic[@"month"]];
    NSString *day = [NSString stringWithFormat:@"%@",start_Dic[@"day"]];
    NSString *week = [NSString stringWithFormat:@"%@",start_Dic[@"week"]];
    self.startModel = [[DayModel alloc] init];
    self.startModel.year = year.integerValue;
    self.startModel.month = month.integerValue;
    self.startModel.day = day.integerValue;
    self.startModel.dayDate = start_Dic[@"date"];
    self.startModel.dayOfTheWeek = week.integerValue;
    self.startModel.state = DayModelStateStart;
}

- (void)setEnd_Dic:(NSDictionary *)end_Dic{
    NSString *year = [NSString stringWithFormat:@"%@",end_Dic[@"year"]];
    NSString *month = [NSString stringWithFormat:@"%@",end_Dic[@"month"]];
    NSString *day = [NSString stringWithFormat:@"%@",end_Dic[@"day"]];
    NSString *week = [NSString stringWithFormat:@"%@",end_Dic[@"week"]];
    self.endModel = [[DayModel alloc] init];
    self.endModel.year = year.integerValue;
    self.endModel.month = month.integerValue;
    self.endModel.day = day.integerValue;
    
    self.endModel.dayDate = end_Dic[@"date"];
    self.endModel.dayOfTheWeek = week.integerValue;
    self.endModel.state = DayModelStateEnd;
}

- (void)setDic:(NSDictionary *)dic {
    _dic = dic;
    
    
    
    NSString *begindateString = [HHAppManage getDateWithString:_dic[@"startDateStr"]];
    self.startDateTimeStamp = [HHAppManage getTimeStrWithString:[NSString stringWithFormat:@"%@ 00:00:00",begindateString]];
    
    NSString *endDateString =  [HHAppManage getDateWithString:_dic[@"endDateStr"]];
    self.endDateTimeStamp = [HHAppManage getTimeStrWithString:[NSString stringWithFormat:@"%@ 00:00:00",endDateString]];
}

#pragma mark ---------------------创建Views---------------------
- (void)_createdViews {
    WeakSelf(weakSelf)
    self.editOrerView = [[HHEditOrderView alloc] init];
    self.editOrerView.backgroundColor = kWhiteColor;
    self.editOrerView.dic = self.dic;
    self.editOrerView.clickUpdateButton = ^{
        [weakSelf _createdDateUI];
    };
    [self.view addSubview:self.editOrerView];
    [self.editOrerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.height.offset(120);
        make.top.offset(UINavigateHeight);
    }];

    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.top.equalTo(self.editOrerView.mas_bottom).offset(15);
        make.right.offset(-15);
        make.bottom.offset(-40);
        if (UINavigateTop == 44) {
            make.bottom.offset(-(24+45+20+15));
        }else {
            make.bottom.offset(-(69+15));
        }
    }];
    
    UIView *bottomView = [[UIView alloc] init];
    bottomView.backgroundColor = kWhiteColor;
    [self.view addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.bottom.offset(0);
        if (UINavigateTop == 44) {
            make.height.offset(24+45+20);
        }else {
            make.height.offset(24+45);
        }
    }];
    
    
    self.doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.doneButton setTitle:@"确认修改" forState:UIControlStateNormal];
    [self.doneButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
    self.doneButton.titleLabel.font = XLFont_subTextFont;
    self.doneButton.layer.cornerRadius = 45/2.0;
    self.doneButton.layer.masksToBounds = YES;
    self.doneButton.backgroundColor = XLColor_mainColor;
    [self.doneButton addTarget:self action:@selector(doneButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:self.doneButton];
    [self.doneButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.top.offset(12);
        make.height.offset(45);
        make.right.offset(-15);
    }];
    
    
}

- (void)_createdDateUI {
    WeakSelf(weakSelf)
    
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    self.calendarView = [[HHCalendarView alloc] init];
    self.calendarView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    self.calendarView.clickCloseButton = ^{
        [weakSelf.calendarView removeFromSuperview];
    };
    self.calendarView.dateType = KDateTypeContry;
    //设置默认显示的开始时间与结束时间
    NSLog(@"year===%ld",self.startModel.year);
    NSLog(@"month===%ld",self.startModel.month);
    NSLog(@"day===%ld",self.startModel.day);
    NSLog(@"week===%ld",self.startModel.dayOfTheWeek);
    NSLog(@"dayDate===%@",self.startModel.dayDate);
    
    weakSelf.calendarView.startModel = self.startModel;
    weakSelf.calendarView.endModel = self.endModel;
    self.calendarView.calendarViewBlock = ^(NSDictionary * _Nonnull dic, DateType dateType, DayModel * _Nonnull startModel, DayModel * _Nonnull endModel) {
        weakSelf.startModel = startModel;
        weakSelf.endModel = endModel;
        
        [weakSelf.calendarView removeFromSuperview];
        weakSelf.isEdit = YES;
        NSString *begindateString = [HHAppManage getDateWithString:dic[@"startDate"]];
        weakSelf.startDateTimeStamp = [HHAppManage getTimeStrWithString:[NSString stringWithFormat:@"%@ 00:00:00",begindateString]];
        
        NSString *endDateString =  [HHAppManage getDateWithString:dic[@"endDate"]];
        weakSelf.endDateTimeStamp = [HHAppManage getTimeStrWithString:[NSString stringWithFormat:@"%@ 00:00:00",endDateString]];
        
        weakSelf.dic = @{
            @"startDateStr":dic[@"startDate"],
            @"checkInWeekStr":dic[@"checkInWeek"],
            @"endDateStr":dic[@"endDate"],
            @"checkOutWeekStr":dic[@"checkOutWeek"],
            @"days":[NSString stringWithFormat:@"%@晚",dic[@"days"]]
        };
        weakSelf.doneButton.backgroundColor = UIColorHex(b58e7f);
        [weakSelf.editOrerView updateUI:weakSelf.dic];
        [weakSelf _loadData:weakSelf.startDateTimeStamp.integerValue end_time:weakSelf.endDateTimeStamp.integerValue];
    };
    [keyWindow addSubview:self.calendarView];
    [self.calendarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.offset(0);
    }];
    
    [self.calendarView reloadMyTable];
    
}

- (void)doneButtonAction {
    if (!self.isEdit) {
        return;
    }
    
    WeakSelf(weakSelf)
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    self.toastView = [[HHEditOrderToastView alloc] init];
    self.toastView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    self.toastView.clickCancelAction = ^{
        weakSelf.toastView.hidden = YES;
    };
    self.toastView.clickDoneAction = ^{
        weakSelf.toastView.hidden = YES;
        HHLowerOrderViewController *vc = [[HHLowerOrderViewController alloc] init];
        vc.backType = weakSelf.backType;
        vc.isBackstage = YES;
        vc.doneType = 5;
        vc.dic = weakSelf.dic;
        vc.is_modify = YES;
        vc.hotel_id = weakSelf.hotel_id;
        vc.quote_id = weakSelf.quote_id;
        vc.old_order_id = weakSelf.order_id;
        vc.start_date = weakSelf.startDateTimeStamp.integerValue;
        vc.end_date = weakSelf.endDateTimeStamp.integerValue;
        vc.hidesBottomBarWhenPushed = YES;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    [keyWindow addSubview:self.toastView];
    [self.toastView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.offset(0);
    }];
}

#pragma mark ---------------UITableViewDelegate-----------
//每组单元格的数量
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

//创建单元格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WeakSelf(weakSelf)
    HHHotelModel *model = self.dataArray[indexPath.row];
    HHEditOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HHEditOrderCell" forIndexPath:indexPath];
    if(cell ==nil){
        cell =[[HHEditOrderCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"HHEditOrderCell"];
    }
    cell.model = model;
    cell.clickSelectedButton = ^(UIButton * _Nonnull button) {
        if (button.selected) {
            for (HHHotelModel *mm in self.dataArray) {
                if (mm == model) {
                    model.isSelected = YES;
                    self.quote_id = model.quote_id;
                }else {
                    mm.isSelected = NO;
                }
            }
            self.isEdit = YES;
            weakSelf.doneButton.backgroundColor = UIColorHex(b58e7f);
        }else {
            model.isSelected = NO;
            self.isEdit = NO;
            weakSelf.doneButton.backgroundColor = XLColor_mainColor;
        }
        [weakSelf.tableView reloadData];
    };
    cell.backgroundColor = kWhiteColor;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}

//设置单元格的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 124;
}

//单元格点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HHHotelModel *model = self.dataArray[indexPath.row];
    if(self.is_clickCell) {
        return;
    }
    self.is_clickCell = YES;
    self.isEdit = YES;
    [self _loadRoomInfoData:model.room_id quote_id:model.quote_id];
    
}

- (void)_loadRoomInfoData:(NSString *)room_id quote_id:(NSString *)quote_id {
    NSString *url = [NSString stringWithFormat:@"%@/hotel/details/room",BASE_URL];
    NSMutableDictionary *dic = @{}.mutableCopy;
    [dic setValue:room_id forKey:@"room_id"];
    [dic setValue:quote_id forKey:@"quote_id"];
    [PPHTTPRequest requestPostWithJSONForUrl:url parameters:dic success:^(id  _Nonnull response) {
        
        NSString *code = [NSString stringWithFormat:@"%@", response[@"code"]];
        if ([code isEqualToString:@"0"]) {//请求成功
            
            WeakSelf(weakSelf)
            UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
            self.roomInfoView = [[HHRoomInfoView alloc] init];
            self.roomInfoView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
            self.roomInfoView.data = response[@"data"];
            self.roomInfoView.type = @"1";
            self.roomInfoView.isHas = YES;
            self.roomInfoView.clickCloseButton = ^{
                weakSelf.is_clickCell = NO;
                [weakSelf.roomInfoView removeFromSuperview];
            };
            self.roomInfoView.clickReserveButton = ^{
                weakSelf.is_clickCell = NO;
                [weakSelf.roomInfoView removeFromSuperview];
                
                HHLowerOrderViewController *vc = [[HHLowerOrderViewController alloc] init];
                vc.backType = weakSelf.backType;
                vc.isBackstage = YES;
                vc.doneType = 5;
                vc.dic = weakSelf.dic;
                vc.is_modify = YES;
                vc.hotel_id = weakSelf.hotel_id;
                vc.quote_id = quote_id;
                vc.old_order_id = weakSelf.order_id;
                vc.start_date = weakSelf.startDateTimeStamp.integerValue;
                vc.end_date = weakSelf.endDateTimeStamp.integerValue;
                vc.hidesBottomBarWhenPushed = YES;
                [weakSelf.navigationController pushViewController:vc animated:YES];
            };
            [keyWindow addSubview:self.roomInfoView];
            [self.roomInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.bottom.top.offset(0);
            }];
            
        }else {
            [self.view makeToast:response[@"msg"] duration:2 position:CSToastPositionCenter];
        }
        
    } failure:^(NSError * _Nonnull error) {
        
    }];
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.bounces = NO;
        _tableView.layer.cornerRadius = 15;
        _tableView.layer.masksToBounds = YES;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.backgroundColor = kWhiteColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[HHEditOrderCell class] forCellReuseIdentifier:@"HHEditOrderCell"];
    }
    return _tableView;
}



@end
