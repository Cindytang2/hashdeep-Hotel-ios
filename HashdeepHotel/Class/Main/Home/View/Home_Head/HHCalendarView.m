//
//  HHCalendarView.m
//  HashdeepHotel
//
//  Created by Cindy on 2022/7/14.
//

#import "HHCalendarView.h"
#import "MonthTableViewCell.h"
#import "HashMainData.h"
#import "NSDate+XZY.h"
@interface HHCalendarView ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UIView *whiteView;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIView *bottomDateView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UILabel *checkInDateLabel;
@property (nonatomic, strong) UILabel *checkOutDateLabel;
@property (nonatomic, strong) UILabel *hourDateLabel;
@property (nonatomic, strong) UIButton *doneButton;
@property (nonatomic, copy) NSString *startDate;
@property (nonatomic, copy) NSString *endDate;
@property (nonatomic, copy) NSString *checkInWeekStr;
@property (nonatomic, copy) NSString *checkOutWeekStr;
@property (nonatomic, copy) NSString *days;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, copy) NSString *offsetY;
@end

@implementation HHCalendarView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = XLColor_mainColor;
        [self _addSubViews];
    }
    return self;
}

- (void)_addSubViews{
    
    self.whiteView = [[UIView alloc] init];
    self.whiteView.layer.cornerRadius = 20;
    self.whiteView.layer.masksToBounds = YES;
    self.whiteView.backgroundColor = kWhiteColor;
    [HHAppManage mq_setRect:CGRectMake(0, 0, kScreenWidth, kScreenHeight-110) cornerRect:UIRectCornerTopLeft|UIRectCornerTopRight radius:20 view:self.whiteView];
    [self addSubview:self.whiteView];
    [self.whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(kScreenHeight-110);
        make.left.right.bottom.offset(0);
    }];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"选择日期";
    titleLabel.font = KBoldFont(16);
    titleLabel.textColor = XLColor_mainTextColor;
    [self.whiteView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.top.offset(15);
        make.height.offset(25);
        make.right.offset(-100);
    }];
    
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeButton setImage:HHGetImage(@"icon_home_search_close") forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(closeButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.whiteView addSubview:closeButton];
    [closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-15);
        make.top.offset(15);
        make.height.width.offset(25);
    }];
    
    UIView *weekView = [[UIView alloc] init];
    NSArray *title = @[@"日",@"一",@"二",@"三",@"四",@"五",@"六"];
    int xLeft = 0;
    for (int i =0 ; i < 7; i++) {
        UILabel *label = [[UILabel alloc] init];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = title[i];
        if (i== 0|| i == 6) {
            label.textColor = kOrangeColor;
        }else {
            label.textColor = XLColor_subTextColor;
        }
        [weekView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(xLeft);
            make.top.bottom.offset(0);
            make.width.offset(kScreenWidth/7);
        }];
        xLeft = xLeft+kScreenWidth/7;
    }
    [self.whiteView addSubview:weekView];
    [weekView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.equalTo(titleLabel.mas_bottom).offset(0);
        make.height.offset(50);
    }];
    
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = XLColor_mainColor;
    [self.whiteView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.offset(0);
        make.top.equalTo(weekView.mas_bottom).offset(0);
        make.height.offset(1);
    }];
    
    [self.whiteView addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.offset(0);
        make.bottom.offset(-160);
        make.top.equalTo(lineView.mas_bottom).offset(0);
    }];
    
    self.bottomView = [[UIView alloc] init];
    self.bottomView.backgroundColor = kWhiteColor;
    [self.whiteView addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.offset(0);
        make.height.offset(160);
    }];
    
    self.bottomDateView = [[UIView alloc] init];
    self.bottomDateView.backgroundColor = kWhiteColor;
    [self.bottomView addSubview:self.bottomDateView];
    [self.bottomDateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.offset(0);
        make.height.offset(90);
    }];
    
    UILabel *checkInLabel = [[UILabel alloc]init];
    checkInLabel.font = XLFont_subSubTextFont;
    checkInLabel.textColor = XLColor_subSubTextColor;
    checkInLabel.text = @"入住";
    [self.bottomDateView addSubview:checkInLabel];
    [checkInLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(20);
        make.top.offset(20);
        make.height.offset(20);
        make.width.offset(50);
    }];
    
    UILabel *checkOutLabel = [[UILabel alloc]init];
    checkOutLabel.font = XLFont_subSubTextFont;
    checkOutLabel.textColor = XLColor_subSubTextColor;
    checkOutLabel.text = @"离店";
    [self.bottomDateView addSubview:checkOutLabel];
    [checkOutLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(kScreenWidth/2+60);
        make.top.offset(20);
        make.height.offset(20);
        make.width.offset(50);
    }];
    
    self.checkInDateLabel = [[UILabel alloc]init];
    self.checkInDateLabel.textColor = XLColor_mainTextColor;
    self.checkInDateLabel.font = KBoldFont(16);
    self.checkInDateLabel.text = [NSString stringWithFormat:@"%@ 今天",[HashMainData shareInstance].startDateStr];
    [self.bottomDateView addSubview:self.checkInDateLabel];
    [self.checkInDateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(20);
        make.top.equalTo(checkInLabel.mas_bottom).offset(5);
        make.height.offset(25);
        make.width.offset(140);
    }];
    
    UIView *dateLineView = [[UIView alloc]init];
    dateLineView.backgroundColor = XLColor_mainTextColor;
    [self.bottomDateView addSubview:dateLineView];
    [dateLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bottomView);
        make.top.equalTo(checkInLabel.mas_bottom).offset(20);
        make.height.offset(1);
        make.width.offset(25);
    }];
    
    self.checkOutDateLabel = [[UILabel alloc]init];
    self.checkOutDateLabel.textColor = XLColor_mainTextColor;
    self.checkOutDateLabel.font = KBoldFont(16);
    
    self.checkOutDateLabel.text =[NSString stringWithFormat:@"%@ 明天",[HashMainData shareInstance].endDateStr];
    [self.bottomDateView addSubview:self.checkOutDateLabel];
    [self.checkOutDateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(checkOutLabel).offset(0);;
        make.top.equalTo(checkOutLabel.mas_bottom).offset(5);
        make.height.offset(25);
        make.width.offset(140);
    }];
    
    self.doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.doneButton.backgroundColor = XLColor_mainHHTextColor;
    [self.doneButton setTitle:@"确认1晚" forState:UIControlStateNormal];
    [self.doneButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
    self.doneButton.layer.cornerRadius = 22.0f;
    self.doneButton.layer.masksToBounds = YES;
    [self.doneButton addTarget:self action:@selector(doneButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:self.doneButton];
    [self.doneButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(16);
        make.right.offset(-16);
        if(UINavigateTop == 44) {
            make.bottom.offset(-35);
        }else {
            make.bottom.offset(-15);
        }
        make.height.offset(44);
    }];
    
    self.hourDateLabel = [[UILabel alloc] init];
    self.hourDateLabel.textColor = XLColor_mainTextColor;
    self.hourDateLabel.font = KBoldFont(16);
    self.hourDateLabel.textAlignment = NSTextAlignmentCenter;
    [self.bottomView addSubview:self.hourDateLabel];
    [self.hourDateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.offset(0);
        make.height.offset(44);
    }];
    
}

- (void)setStartModel:(DayModel *)startModel {
    _startModel = startModel;
    
    
}

- (void)setDateType:(DateType)dateType{
    _dateType = dateType;
    if (_dateType == KDateTypeHour) {
        self.bottomDateView.hidden = YES;
        self.hourDateLabel.hidden = NO;
        self.hourDateLabel.text = [NSString stringWithFormat:@"%@ %@ 入住",[HashMainData shareInstance].hourStartDateStr,[HashMainData shareInstance].hourCheckInWeekStr];
        
        [self.doneButton setTitle:@"确认" forState:UIControlStateNormal];
        [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset(130);
        }];
    }else {
        self.bottomDateView.hidden = NO;
        self.hourDateLabel.hidden = YES;
        [self.doneButton setTitle:@"确认1晚" forState:UIControlStateNormal];
        [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset(160);
        }];
    }
}

-(void)doneButtonAction{
    if (self.dateType != KDateTypeHour) {
        if([self.checkOutDateLabel.text isEqualToString:@"请选择日期"]){
            return;
        }
    }
    self.offsetY = [NSString stringWithFormat:@"%.f",self.tableView.contentOffset.y];
    [self selectedCheckDate];
}

#pragma mark ---------------UITableViewDelegate----------------------
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MonthTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MonthTableViewCell" forIndexPath:indexPath];
    if(cell ==nil){
        cell =[[MonthTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"MonthTableViewCell"];
    }
    cell.model =  self.dataArray[indexPath.row];
    cell.backgroundColor = kWhiteColor;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.selectedDay = ^(DayModel *returnDaymodel){
        
        if (self.dateType == KDateTypeHour) {
            // 每次都是单个点击
            for (MonthModel *Mo in self.dataArray) {
                for (DayModel *mo in Mo.days) {
                    if (mo.state == DayModelStateUnSelected) {
                        mo.state = DayModelStateUnSelected;
                    }else{
                        mo.state = DayModelStateNormal;
                    }
                }
            }
            [self setCheckInDateText:returnDaymodel.dayDate];
            returnDaymodel.state = DayModelStateStart;
            [self.tableView reloadData];
            [self.tableView layoutIfNeeded];
            return;
        }
        BOOL isHaveStart = NO;
        BOOL isHaveEnd = NO;
        BOOL isHaveSelected = NO;
        NSDate *startDate;
        NSDate *endDate;
        DayModel *starModel;
        DayModel *endModel;
        for (MonthModel *Mo in self.dataArray) {
            for (DayModel *mo in Mo.days) {
                if (mo.state == DayModelStateStart) {
                    isHaveStart = YES;
                    startDate = mo.dayDate;
                    starModel = mo;
                    [self setCheckInDateText:startDate];
                }else if (mo.state == DayModelStateSelected) {
                    isHaveSelected = YES;
                }else if (mo.state == DayModelStateUnSelected) {
                    mo.state = DayModelStateUnSelected;
                }else if (mo.state == DayModelStateEnd) {
                    isHaveEnd = YES;
                    endDate = mo.dayDate;
                    [self setCheckOutDateText:endDate];
                    endModel = mo;
                    break;
                }
            }
        }
        
        if ((!isHaveStart && !isHaveEnd && !isHaveSelected )|| (!isHaveStart && !isHaveEnd) ) {
            //没有设置开始结束
            [self setCheckInDateText:returnDaymodel.dayDate];
            returnDaymodel.state = DayModelStateStart;
        }else if ((isHaveEnd && isHaveStart)){
            //有开始有结束
            for (MonthModel *Mo in self.dataArray) {
                for (DayModel *mo in Mo.days) {
                    if (mo.state == DayModelStateUnSelected) {
                        mo.state = DayModelStateUnSelected;
                    }else{
                        mo.state = DayModelStateNormal;
                    }
                }
            }
            [self setCheckInDateText:returnDaymodel.dayDate];
            returnDaymodel.state = DayModelStateStart;
            [self setBtnTitle];
        }else if(isHaveStart && !isHaveEnd){
            //有开始没有结束
            NSInteger ci = [self compareDate:returnDaymodel.dayDate withDate:startDate];
            switch (ci) {
                case 1://startDate > currentSelectDate
                    starModel.state = DayModelStateNormal;
                    [self setCheckInDateText:returnDaymodel.dayDate];
                    returnDaymodel.state = DayModelStateStart;
                    [self setBtnTitle];
                    break;
                case -1:
                    [self setCheckOutDateText:returnDaymodel.dayDate];
                    returnDaymodel.state = DayModelStateEnd;
                    [self setBtnTitle];
                    for (MonthModel *Mo in self.dataArray) {
                        for (DayModel *mo in Mo.days) {
                            NSInteger ci1 = [self compareDate:mo.dayDate withDate:startDate];
                            NSInteger ci2 = [self compareDate:mo.dayDate withDate:returnDaymodel.dayDate];
                            if (ci1 == -1 && ci2 == 1 ) {
                                mo.state = DayModelStateSelected;
                            }
                        }
                    }
                    break;
                case 0:
                    returnDaymodel.state = DayModelStateStart;
                    break;
                default:
                    break;
            }
        }
        [self.tableView reloadData];
        [self.tableView layoutIfNeeded];
        
    };
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    MonthModel *model = self.dataArray[indexPath.row];
    NSLog(@"cellHight=====%.f",model.cellHight);
    return model.cellHight;
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.bounces = NO;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.backgroundColor = kWhiteColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[MonthTableViewCell class] forCellReuseIdentifier:@"MonthTableViewCell"];
    }
    return _tableView;
}

#pragma mark - 确定事件返回
-(void)selectedCheckDate{
    NSDate *startDate;
    DayModel *startModel;
    DayModel *endModel;
    BOOL isHaveStartDate = NO;
    for (MonthModel *Mo in self.dataArray) {
        for (DayModel *mo in Mo.days) {
            if (mo.state == DayModelStateStart) {
                isHaveStartDate = YES;
                startDate = mo.dayDate;
                startModel = mo;
                break;
            }
        }
    }
    NSDate *endDate;
    BOOL isHaveEndDate = NO;
    for (MonthModel *Mo in self.dataArray) {
        for (DayModel *mo in Mo.days) {
            if (mo.state == DayModelStateEnd) {
                isHaveEndDate = YES;
                endDate = mo.dayDate;
                endModel = mo;
                break;
            }
        }
    }
    
    if (isHaveStartDate && isHaveEndDate) {
        NSInteger days = [self calcDaysFromBegin:startDate end:endDate];
        NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM月dd日"];
        NSString *startDateStr = [dateFormatter stringFromDate:startDate];
        NSString *endDateStr = [dateFormatter stringFromDate:endDate];
        NSString *daysStr = [NSString stringWithFormat:@"%ld",days];
        self.startDate = startDateStr;
        self.endDate = endDateStr;
        self.days = daysStr;
        
        self.checkInWeekStr = [self checkWeekStr:startDate];
        self.checkOutWeekStr = [self checkWeekStr:endDate];
        if ([self.checkInWeekStr containsString:@"星期"]) {
            [self.checkInWeekStr stringByReplacingOccurrencesOfString:@"星期" withString:@"周"];
        }
        if ([self.checkOutWeekStr containsString:@"星期"]) {
            [self.checkOutWeekStr stringByReplacingOccurrencesOfString:@"星期"withString:@"周"];
        }
        
        NSDictionary *dictionary = @{
            @"start_year":@(startModel.year),
            @"end_year":@(endModel.year),
            @"startDate":startDateStr,
            @"endDate":endDateStr,
            @"days":@(days),
            @"checkInWeek":self.checkInWeekStr,
            @"checkOutWeek":self.checkOutWeekStr
        };
        
        if (self.dateType == KDateTypeHour) {
            [[NSUserDefaults standardUserDefaults]setValue:self.offsetY forKey:@"hourlyCalendarOffsetY"];
            [[NSUserDefaults standardUserDefaults]synchronize];
        }else {
            if(self.isHotelDetail){
                if(days == 1){
                    [[NSUserDefaults standardUserDefaults]setValue:self.offsetY forKey:@"hourlyCalendarOffsetY"];
                    [[NSUserDefaults standardUserDefaults]synchronize];
                }
                
            }
          
                [[NSUserDefaults standardUserDefaults]setValue:self.offsetY forKey:@"countryCalendarOffsetY"];
                [[NSUserDefaults standardUserDefaults]synchronize];
            
        }
        
        if (self.calendarViewBlock) {
            self.calendarViewBlock(dictionary,self.dateType,startModel,endModel);
        }
        [self removeFromSuperview];
        
    }else{
        
        NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM月dd日"];
        NSString *startDateStr = [dateFormatter stringFromDate:startDate];
        
        self.checkInWeekStr = [self checkWeekStr:startDate];
        
        if ([self.checkInWeekStr containsString:@"星期"]) {
            [self.checkInWeekStr stringByReplacingOccurrencesOfString:@"星期" withString:@"周"];
        }
        NSDictionary *dictionary = @{
            @"start_year":@(startModel.year),
            @"end_year":@(endModel.year),
            @"startDate":startDateStr,
            @"endDate":@"",
            @"days":@(0),
            @"checkInWeek":self.checkInWeekStr,
            @"checkOutWeek":@""
        };
        if (self.calendarViewBlock) {
            self.calendarViewBlock(dictionary,self.dateType,startModel,endModel);
        }
        
        [self removeFromSuperview];
        
        if (self.dateType == KDateTypeHour) {
            [[NSUserDefaults standardUserDefaults]setValue:self.offsetY forKey:@"hourlyCalendarOffsetY"];
            [[NSUserDefaults standardUserDefaults]synchronize];
        }else {
           
                [[NSUserDefaults standardUserDefaults]setValue:self.offsetY forKey:@"countryCalendarOffsetY"];
                [[NSUserDefaults standardUserDefaults]synchronize];
        }
    }
    
}

-(void)reloadMyTable{
    
    if (self.dateType == KDateTypeHour) {
        for (MonthModel *Mo in self.dataArray) {
            for (DayModel *mo in Mo.days) {
                if (self.startModel.month == mo.month && self.startModel.day == mo.day) {
                    mo.state = DayModelStateStart;
                }else{
                    if (mo.state == DayModelStateUnSelected) {
                        mo.state = DayModelStateUnSelected;
                    }else{
                        mo.state = DayModelStateNormal;
                    }
                }
            }
        }
        [self.tableView reloadData];
        [self.tableView layoutIfNeeded];
        
    }else{
        for (MonthModel *Mo in self.dataArray) {
            for (DayModel *mo in Mo.days) {
                if (self.startModel.month == self.endModel.month) {
                    if (self.startModel.month == mo.month && self.startModel.day == mo.day){
                        mo.state = DayModelStateStart;
                        [self setCheckInDateText:mo.dayDate];
                    }
                    else if (self.startModel.month == mo.month && mo.day > self.startModel.day && mo.day <self.endModel.day){
                        mo.state = DayModelStateSelected;
                    }
                    else if (self.endModel.month == mo.month && self.endModel.day == mo.day){
                        mo.state = DayModelStateEnd;
                        [self setCheckOutDateText:mo.dayDate];
                    }else{
                        if (mo.state == DayModelStateUnSelected) {
                            mo.state = DayModelStateUnSelected;
                        }else{
                            mo.state = DayModelStateNormal;
                        }
                    }
                }else{
                    if (self.startModel.month == mo.month && self.startModel.day == mo.day) {
                        mo.state = DayModelStateStart;
                        [self setCheckInDateText:mo.dayDate];
                    }else if (self.startModel.month == mo.month && mo.day > self.startModel.day ){
                        mo.state = DayModelStateSelected;
                    }else if (self.startModel.month < mo.month && mo.month < self.endModel.month){
                        mo.state = DayModelStateSelected;
                    }else if (self.endModel.month == mo.month && self.endModel.day == mo.day){
                        mo.state = DayModelStateEnd;
                        [self setCheckOutDateText:mo.dayDate];
                    }else if (self.endModel.month == mo.month && mo.day < self.endModel.day){
                        mo.state = DayModelStateSelected;
                    }else{
                        if (mo.state == DayModelStateUnSelected) {
                            mo.state = DayModelStateUnSelected;
                        }else{
                            mo.state = DayModelStateNormal;
                        }
                    }
                }
            }
        }
        [self.tableView reloadData];
        [self.tableView layoutIfNeeded];
    }
    
    NSLog(@"height=====%.f",self.tableView.contentSize.height);
    NSString *offset_Y;
    if (self.dateType == KDateTypeHour) {
        offset_Y = [[NSUserDefaults standardUserDefaults ]valueForKey:@"hourlyCalendarOffsetY"];
    }else {
        offset_Y = [[NSUserDefaults standardUserDefaults ]valueForKey:@"countryCalendarOffsetY"];
    }
    
    if (offset_Y.floatValue > 0) {
        [self.tableView setContentOffset:CGPointMake(0, offset_Y.floatValue) animated:YES];
    }
}

#pragma mark --------------懒加载数据源-------------
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
        NSDate *nowdate = [NSDate date];
        NSInteger toYear = [self getDataFromDate:nowdate type:@"year"];
        NSInteger toMonth = [self getDataFromDate:nowdate type:@"month"];
        // 支持预订几个月 i = 几
        for (int i = 0; i<6; i++) {
            if (i == 0) {
                MonthModel  * monthModel = [[MonthModel alloc] init];
                monthModel.year = toYear;
                monthModel.month = toMonth;
                NSMutableArray *days = [NSMutableArray array];
                NSInteger starNum = [self getDataFromDate :nowdate type:@"day"];
                NSInteger startNum = 1;
                for (NSInteger i = startNum ; i <=[self totaldaysInMonth:nowdate]; i++) {
                    DayModel *dayModel = [[DayModel alloc]init];
                    dayModel.dayDate = [self dateWithYear:monthModel.year month:monthModel.month day:i];
                    dayModel.day = i;
                    dayModel.month = monthModel.month;
                    dayModel.year = monthModel.year;
                    
                    NSInteger dayOfTheWeek = [self getDataFromDate:dayModel.dayDate type:@"week"];
                    if (dayOfTheWeek == 7) {
                        dayModel.dayOfTheWeek = 1;
                    }else{
                        dayModel.dayOfTheWeek = dayOfTheWeek + 1;
                    }
                    dayModel.isToday = i == starNum;
                    if (i < starNum) {
                        dayModel.state = DayModelStateUnSelected;
                    }else{
                        NSLog(@"startModel=====%@",self.startModel);
                        NSLog(@"endModel====%@",self.endModel);
                        //处理默认值
                        if (self.startModel == nil && dayModel.isToday == YES) {
                            self.startModel = dayModel;
                        }
                        
                        if (starNum+1 == i && self.endModel == nil && self.dateType != KDateTypeHour) {
                            self.endModel = dayModel;
                        }
                        
                        if (self.startModel.day == dayModel.day) {
                            dayModel.state = DayModelStateStart;
                        }
                        if (self.endModel.day == dayModel.day && self.dateType != KDateTypeHour) {
                            dayModel.state = DayModelStateEnd;
                        }
                    }
                    
                    [days addObject:dayModel];
                }
                monthModel.days = days;
                DayModel *m = days.firstObject;
                NSInteger lineCount = 1;
                NSInteger oneLineCoune =( 7 - m.dayOfTheWeek + 2 ) % 7;
                if (oneLineCoune == 0) {
                    oneLineCoune = 7;
                }
                NSInteger count = days.count - oneLineCoune;
                if (count%7==0) {
                    lineCount = lineCount + count/7 ;
                }else{
                    lineCount = lineCount + count/7 + 1 ;
                    
                }
                monthModel.cellNum = lineCount * 7;
                monthModel.cellStartNum = 7 - oneLineCoune ;
                monthModel.cellHight = 60 + 70 * lineCount + 2 * (lineCount + 1);
                
                [_dataArray addObject:monthModel];
                toMonth++;
                
            }else{
                if (toMonth == 13) {
                    toMonth = 1;
                    toYear += 1;
                }
                NSDate *toDate = [self dateWithYear:toYear month:toMonth day:1];
                
                MonthModel  * monthModel = [[MonthModel alloc] init];
                monthModel.year = [self getDataFromDate:toDate type:@"year"];
                monthModel.month = [self getDataFromDate:toDate type:@"month"];
                NSMutableArray *days = [NSMutableArray array ];
                for (NSInteger i = 1 ; i <=[self totaldaysInMonth:toDate]; i++) {
                    DayModel *dayModel = [[DayModel alloc]init];
                    dayModel.dayDate = [self dateWithYear:monthModel.year month:monthModel.month day:i];
                    dayModel.day = i;
                    dayModel.month = monthModel.month;
                    dayModel.year = monthModel.year;
                    NSInteger dayOfTheWeek = [self getDataFromDate:dayModel.dayDate type:@"week"];
                    if (dayOfTheWeek == 7) {
                        dayModel.dayOfTheWeek = 1;
                    }else{
                        dayModel.dayOfTheWeek = dayOfTheWeek + 1;
                    }
                    dayModel.isToday = NO;
                    dayModel.state = DayModelStateNormal;
                    [days addObject:dayModel];
                }
                monthModel.days = days;
                DayModel *m = days.firstObject;
                NSInteger lineCount = 1;
                NSInteger oneLineCoune =( 7 - m.dayOfTheWeek + 2 ) % 7;
                if (oneLineCoune == 0) {
                    oneLineCoune = 7;
                }
                NSInteger count = days.count - oneLineCoune;
                if (count%7==0) {
                    lineCount = lineCount + count/7 ;
                }else{
                    lineCount = lineCount + count/7 + 1 ;
                    
                }
                monthModel.cellNum = lineCount * 7;
                monthModel.cellStartNum = 7 - oneLineCoune ;
                monthModel.cellHight = 60 + 70 * lineCount + 2 * (lineCount + 1);
                
                [_dataArray addObject:monthModel];
                toMonth++;
            }
        }
        
    }
    return _dataArray;
}

#pragma mark - 获取年，月，日，星期 注：日历获取在9.x之后的系统使用currentCalendar会出异常。在8.0之后使用系统新API。
-(NSInteger )getDataFromDate:(NSDate *)date type:(NSString * )type{
    NSCalendar *calendar = nil;
    if ([NSCalendar respondsToSelector:@selector(calendarWithIdentifier:)]) {
        calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    }else{
        calendar = [NSCalendar currentCalendar];
    }
    NSDateComponents *components = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay |NSCalendarUnitWeekday) fromDate:date];
    if ([type isEqualToString:@"year"]) {
        return components.year;
    }else if ([type isEqualToString:@"month"]) {
        return components.month;
    }else if ([type isEqualToString:@"day"]) {
        return components.day;
    }else if ([type isEqualToString:@"week"]) {
        return components.weekday;
    }else{
        return 0;
    }
}
-(NSString*)checkWeekStr:(NSDate*)startdate{
    NSString *str = [[NSDate date] weekdayStringWithDate:startdate];
    BOOL istoday = [[NSCalendar currentCalendar]isDateInToday:startdate];
    BOOL isYesterday = [[NSCalendar currentCalendar] isDateInTomorrow:startdate];
    if (istoday) {
        str= @"今天";
    } else if (isYesterday){
        str = @"明天";
    }
    return str;
}

-(void)setCheckInDateText:(NSDate*)startdate{
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM月dd日"];
    NSString *startDateStr = [dateFormatter stringFromDate:startdate];
    NSString *str = [[NSDate date] weekdayStringWithDate:startdate];
    
    BOOL istoday = [[NSCalendar currentCalendar]isDateInToday:startdate];
    BOOL isYesterday = [[NSCalendar currentCalendar] isDateInTomorrow:startdate];
    if (istoday) {
        str= @"今天";
    } else if (isYesterday){
        str = @"明天";
    }
    
    if(self.dateType == KDateTypeHour) {
        NSString *title = @"确认";
        [self.doneButton setTitle:title forState:UIControlStateNormal];
        self.doneButton.backgroundColor = XLColor_mainHHTextColor;
        self.hourDateLabel.text = [NSString stringWithFormat:@"%@ %@ 入住",startDateStr,str];
    }else {
        self.checkInDateLabel.text = [NSString stringWithFormat:@"%@ %@",startDateStr,str];
        self.checkOutDateLabel.text = @"请选择日期";
        self.checkOutDateLabel.textColor = XLColor_subSubTextColor;
        self.doneButton.backgroundColor = XLColor_subSubTextColor;
        [self.doneButton setTitle:@"确认0晚" forState:UIControlStateNormal];
    }
}

-(void)setCheckOutDateText:(NSDate*)enddate{
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM月dd日"];
    NSString *endDateStr = [dateFormatter stringFromDate:enddate];
    NSString *str = [[NSDate date] weekdayStringWithDate:enddate];
    BOOL istoday = [[NSCalendar currentCalendar]isDateInToday:enddate];
    BOOL isYesterday = [[NSCalendar currentCalendar] isDateInTomorrow:enddate];
    if (istoday) {
        str= @"今天";
    } else if (isYesterday){
        str = @"明天";
    }
    self.checkOutDateLabel.text = [NSString stringWithFormat:@"%@ %@",endDateStr,str];
    self.checkOutDateLabel.textColor = XLColor_mainTextColor;
    self.doneButton.backgroundColor = XLColor_mainHHTextColor;
    [self setBtnTitle];
}

-(void)setBtnTitle{
    NSDate *startDate;
    BOOL isHaveStartDate = NO;
    for (MonthModel *Mo in self.dataArray) {
        for (DayModel *mo in Mo.days) {
            if (mo.state == DayModelStateStart) {
                isHaveStartDate = YES;
                startDate = mo.dayDate;
                break;
            }
        }
    }
    NSDate *endDate;
    BOOL isHaveEndDate = NO;
    for (MonthModel *Mo in self.dataArray) {
        for (DayModel *mo in Mo.days) {
            if (mo.state == DayModelStateEnd) {
                isHaveEndDate = YES;
                endDate = mo.dayDate;
                break;
            }
        }
    }
    
    if(self.dateType == KDateTypeHour) {
        NSString *title = @"确认";
        [self.doneButton setTitle:title forState:UIControlStateNormal];
    }else {
        
        if (isHaveStartDate && isHaveEndDate) {
            NSInteger days = [self calcDaysFromBegin:startDate end:endDate];
            NSString *title = [NSString stringWithFormat:@"确认(共%ld晚)",days];
            [self.doneButton setTitle:title forState:UIControlStateNormal];
        }else{
            NSString *title = @"确认";
            [self.doneButton setTitle:title forState:UIControlStateNormal];
        }
    }
}

#pragma mark -- 获取当前月共有多少天
- (NSInteger)totaldaysInMonth:(NSDate *)date{
    NSRange daysInLastMonth = [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    return daysInLastMonth.length;
}

#pragma mark - 时间字符串转时间
-(NSDate *)dateWithYear:(NSInteger )year month:(NSInteger )month day:(NSInteger )day{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyyMMdd"];
    return [formatter dateFromString:[NSString stringWithFormat:@"%ld%02ld%02ld",year,month,day]];
}
#pragma mark-日期比较
-(NSInteger )compareDate:(NSDate *)date01 withDate:(NSDate *)date02{
    NSInteger ci;
    NSComparisonResult result = [date01 compare:date02];
    switch (result){
            //date02比date01大
        case NSOrderedAscending: ci=1; break;
            //date02比date01小
        case NSOrderedDescending: ci=-1; break;
            //date02=date01
        case NSOrderedSame: ci=0; break;
        default: NSLog(@"erorr dates %@, %@", date02, date01); break;
    }
    return ci;
}

#pragma mark -  计算两个日期之间的天数
- (NSInteger) calcDaysFromBegin:(NSDate *)beginDate end:(NSDate *)endDate{
    //创建日期格式化对象
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    //取两个日期对象的时间间隔：
    //这里的NSTimeInterval 并不是对象，是基本型，其实是double类型，是由c定义的:typedef double NSTimeInterval;
    NSTimeInterval time=[endDate timeIntervalSinceDate:beginDate];
    
    int days=((int)time)/(3600*24);
    return days;
}

- (void)closeButtonAction {
    if (self.clickCloseButton) {
        self.clickCloseButton();
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches.allObjects lastObject];
    BOOL result = [touch.view isDescendantOfView:self.whiteView];
    if (!result) {
        
        if (self.clickCloseButton) {
            self.clickCloseButton();
        }
    }
}

@end
