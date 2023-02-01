//
//  HHHotelDetailFooterView.m
//  HashdeepHotel
//
//  Created by Cindy on 2022/7/26.
//

#import "HHHotelDetailFooterView.h"
#import "HHHotelListCell.h"
#import "HHHoteNoDataCell.h"
#import "HHHotelModel.h"
#import "HHHotelDetailViewController.h"
#import "HHHotelDetailCell.h"
#import "HomeModel.h"
@interface HHHotelDetailFooterView ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UILabel *hourLabel;
@property (nonatomic, strong) UIView *hourView;
@property (nonatomic, strong) UIView *checkInWhiteView;

@end

@implementation HHHotelDetailFooterView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self _addSubViews];
    }
    return self;
}

- (void)setDateType:(NSInteger)dateType {
    _dateType = dateType;
    if(_dateType == 0){
        [self.hourView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset(60);
        }];
        self.hourLabel.hidden = NO;
        [self.hourTableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset(0);
        }];
    }else {
        [self.hourView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset(0);
        }];
        self.hourLabel.hidden = YES;
        [self.hourTableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset(0);
        }];
    }
  
}

- (void)_addSubViews{
    
    self.hourView = [[UIView alloc] init];
    [self addSubview:self.hourView];
    [self.hourView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.height.offset(60);
        make.top.offset(0);
        make.right.offset(0);
    }];
    
    self.hourLabel = [[UILabel alloc] init];
    self.hourLabel.text = @"时租房";
    self.hourLabel.textColor = XLColor_mainTextColor;
    self.hourLabel.font = KBoldFont(18);
    [self.hourView addSubview:self.hourLabel];
    [self.hourLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.height.offset(60);
        make.top.offset(0);
        make.right.offset(-15);
    }];
    
    [self.hourView addSubview:self.hourTableView];
    [self.hourTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.right.offset(0);
        make.top.equalTo(self.hourLabel.mas_bottom).offset(0);
        make.height.offset(0);
    }];
    
    UILabel *securityLabel = [[UILabel alloc] init];
    securityLabel.text = @"安全日志";
    securityLabel.textColor = XLColor_mainTextColor;
    securityLabel.font = KBoldFont(18);
    [self addSubview:securityLabel];
    [securityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.height.offset(60);
        make.top.equalTo(self.hourView.mas_bottom).offset(0);
        make.right.offset(-15);
    }];
    
//    UILabel *securitySubTitleLabel = [[UILabel alloc] init];
//    securitySubTitleLabel.text = @"大床房";
//    securitySubTitleLabel.textColor = XLColor_subTextColor;
//    securitySubTitleLabel.font = XLFont_mainTextFont;
//    [self addSubview:securitySubTitleLabel];
//    [securitySubTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.offset(15);
//        make.height.offset(20);
//        make.top.equalTo(securityLabel.mas_bottom).offset(0);
//        make.right.offset(-15);
//    }];
    
    UIView *whiteView = [[UIView alloc] init];
    whiteView.backgroundColor = kWhiteColor;
    whiteView.layer.cornerRadius = 12;
    whiteView.layer.masksToBounds = YES;
    [self addSubview:whiteView];
    [whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.height.offset(270);
        make.top.equalTo(securityLabel.mas_bottom).offset(0);
        make.right.offset(-15);
    }];
    
    NSMutableArray *arr = [NSMutableArray array];
    NSDictionary *dic1 = @{
        @"icon":@"icon_hotel_detail_timeanquan",
        @"title":@"检测时间",
        @"detail":@"2022年7月15日",
        @"type":@"1"
    };
    NSDictionary *dic2 = @{
        @"icon":@"icon_hotel_detail_people",
        @"title":@"检测人",
        @"detail":@"陈云",
        @"type":@"1"
    };
    NSDictionary *dic3 = @{
        @"icon":@"icon_hotel_detail_jiancejieguo",
        @"title":@"检测结果",
        @"detail":@"未发现异常",
        @"type":@"1"
    };
    NSDictionary *dic4 = @{
        @"icon":@"icon_hotel_detail_dengji",
        @"title":@"安全星级",
        @"detail":@"",
        @"type":@"2"
    };
    [arr addObject:dic1];
    [arr addObject:dic2];
    [arr addObject:dic3];
    [arr addObject:dic4];
    
    
    int yBottom = 15;
    for (int i=0; i<arr.count; i++) {
        NSDictionary *dic = arr[i];
        UIView *checkInDetailView = [[UIView alloc] init];
        [whiteView addSubview:checkInDetailView];
        [checkInDetailView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.offset(0);
            make.top.offset(yBottom);
            make.height.offset(50);
        }];
        
        UIImageView *imgView = [[UIImageView alloc] init];
        imgView.image = HHGetImage(dic[@"icon"]);
        [checkInDetailView addSubview:imgView];
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(15);
            make.top.offset(0);
            make.width.height.offset(22);
        }];
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.text = dic[@"title"];
        titleLabel.textColor = XLColor_mainTextColor;
        titleLabel.font = KBoldFont(16);
        [checkInDetailView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(imgView.mas_right).offset(15);
            make.top.offset(0);
            make.right.offset(-15);
            make.height.offset(20);
        }];
        
        NSString *type = dic[@"type"];
        if ([type isEqualToString:@"1"]) {
            UILabel *detailLabel = [[UILabel alloc] init];
            detailLabel.text = dic[@"detail"];
            detailLabel.textColor = XLColor_mainTextColor;
            detailLabel.font = XLFont_subSubTextFont;
            [checkInDetailView addSubview:detailLabel];
            [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(imgView.mas_right).offset(15);
                make.top.offset(25);
                make.right.offset(-15);
                make.height.offset(20);
            }];
        }else {
            UIView *safetyView = [[UIView alloc] init];
            safetyView.clipsToBounds = YES;
            [checkInDetailView addSubview:safetyView];
            [safetyView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(imgView.mas_right).offset(15);
                make.top.offset(25);
                make.right.offset(-15);
                make.height.offset(20);
            }];
            
            int xLeft = 0;
            for (int i=0; i<5; i++) {
                UIImageView *imgView = [[UIImageView alloc] init];
                imgView.image = HHGetImage(@"icon_home_anquan_redStar");
                imgView.contentMode = UIViewContentModeScaleAspectFill;
                [safetyView addSubview:imgView];
                [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.width.height.offset(15);
                    make.left.offset(xLeft);
                    make.centerY.equalTo(safetyView);
                }];
                xLeft = xLeft+15+5;
            }
        }
        yBottom = yBottom+50+15;
      
    }
    
//    UILabel *whiteBottomLabel = [[UILabel alloc] init];
//    whiteBottomLabel.text = @"检测时间：xx月xx日 房间号：xxx";
//    whiteBottomLabel.textColor = XLColor_subTextColor;
//    whiteBottomLabel.textAlignment = NSTextAlignmentCenter;
//    whiteBottomLabel.font = XLFont_subTextFont;
//    [self addSubview:whiteBottomLabel];
//    [whiteBottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.offset(15);
//        make.height.offset(20);
//        make.top.equalTo(whiteView.mas_bottom).offset(12);
//        make.right.offset(-15);
//    }];
//
//    UILabel *openLabel = [[UILabel alloc] init];
//    openLabel.text = @"展开更多视频";
//    openLabel.textColor = UIColorHex(FF7E67);
//    openLabel.textAlignment = NSTextAlignmentRight;
//    openLabel.font = XLFont_subTextFont;
//    [self addSubview:openLabel];
//    [openLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.offset(15);
//        make.height.offset(20);
//        make.top.equalTo(whiteBottomLabel.mas_bottom).offset(7);
//        make.right.offset(-15);
//    }];
    
    UILabel *checkInLabel = [[UILabel alloc] init];
    checkInLabel.text = @"入住须知";
    checkInLabel.textColor = XLColor_mainTextColor;
    checkInLabel.font = KBoldFont(18);
    [self addSubview:checkInLabel];
    [checkInLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.height.offset(60);
        make.top.equalTo(whiteView.mas_bottom).offset(0);
        make.right.offset(-15);
    }];
    
    self.checkInWhiteView = [[UIView alloc] init];
    self.checkInWhiteView.backgroundColor = kWhiteColor;
    self.checkInWhiteView.layer.cornerRadius = 12;
    self.checkInWhiteView.layer.masksToBounds = YES;
    [self addSubview:self.checkInWhiteView];
    [self.checkInWhiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.height.offset(400);
        make.top.equalTo(checkInLabel.mas_bottom).offset(0);
        make.right.offset(-15);
    }];
    
    UILabel *peripheryLabel = [[UILabel alloc] init];
    peripheryLabel.text = @"周边";
    peripheryLabel.textColor = XLColor_mainTextColor;
    peripheryLabel.font = KBoldFont(18);
    [self addSubview:peripheryLabel];
    [peripheryLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.height.offset(60);
        make.top.equalTo(self.checkInWhiteView.mas_bottom).offset(0);
        make.right.offset(-15);
    }];
    
    [self addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.offset(-15);
        make.top.equalTo(peripheryLabel.mas_bottom).offset(0);
        if (UINavigateTop == 44) {
            make.bottom.offset(-35);
        }else {
            make.bottom.offset(-15);
        }
    }];
    
}

- (CGFloat)updateUI:(NSArray *)array{
    
    int yBottom = 15;
    
    if(array.count != 0){
        
        for (int i=0; i<array.count; i++) {
            NSDictionary *dic = array[i];
            UIView *checkInDetailView = [[UIView alloc] init];
            [self.checkInWhiteView addSubview:checkInDetailView];
            [checkInDetailView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.offset(0);
                make.top.offset(yBottom);
                make.height.offset(20);
            }];
            
            UIImageView *imgView = [[UIImageView alloc] init];
            [imgView sd_setImageWithURL:[NSURL URLWithString:dic[@"icon"]]];
            [checkInDetailView addSubview:imgView];
            [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.offset(15);
                make.top.offset(0);
                make.width.height.offset(22);
            }];
            
            UILabel *titleLabel = [[UILabel alloc] init];
            titleLabel.text = dic[@"desc"];
            titleLabel.textColor = XLColor_mainTextColor;
            titleLabel.font = KBoldFont(16);
            [checkInDetailView addSubview:titleLabel];
            [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(imgView.mas_right).offset(15);
                make.top.offset(0);
                make.right.offset(-15);
                make.height.offset(20);
            }];
            
            NSArray *desc_list = dic[@"desc_list"];
            if (desc_list.count == 0) {
                UILabel *label = [[UILabel alloc] init];
                label.text = @"无";
                label.textColor = XLColor_subTextColor;
                label.font = XLFont_subSubTextFont;
                [checkInDetailView addSubview:label];
                [label mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(imgView.mas_right).offset(15);
                    make.top.equalTo(titleLabel.mas_bottom).offset(7);
                    make.right.offset(-15);
                    make.height.offset(20);
                }];
                
                [checkInDetailView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.offset(20+7+20);
                }];
                
                yBottom = yBottom+47+15;
            }else {
                
                int yy = 27;
                
                for (int a = 0; a<desc_list.count; a++) {
                    NSString *ss = desc_list[a];
                    UILabel *label = [[UILabel alloc] init];
                    label.text = ss;
                    label.textColor = XLColor_subTextColor;
                    label.font = XLFont_subSubTextFont;
                    [checkInDetailView addSubview:label];
                    CGFloat hh = [LabelSize heightOfString:ss font:XLFont_subSubTextFont width:kScreenWidth-60-25-15];
                    [label mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.equalTo(imgView.mas_right).offset(15);
                        make.top.offset(yy);
                        make.right.offset(-15);
                        make.height.offset(hh+1);
                    }];
                    yy = yy+hh+7;
                }
                
                [checkInDetailView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.offset(yy);
                }];
                
                yBottom = yBottom+yy+15;
            }
            [self.checkInWhiteView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.offset(yBottom);
            }];
            
        }
    }
    
    return yBottom;
}

#pragma mark ---------------UITableViewDelegate-----------
//每组单元格的数量
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView.tag == 100) {
        return self.hourArray.count;
    }else {
        if (self.dataArray.count == 0) {
            return 1;
        }else {
            return self.dataArray.count;
        }
    }
}

//创建单元格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WeakSelf(weakSelf)
    if (tableView.tag == 100) {
        HHHotelDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HHHotelDetailCell" forIndexPath:indexPath];
        if(cell ==nil){
            cell =[[HHHotelDetailCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"HHHotelDetailCell"];
        }
        cell.type = @"1";
        cell.model = self.hourArray[indexPath.row];
        cell.clickLowerOrderAction = ^(HomeModel * _Nonnull model, UIButton * _Nonnull button) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                button.enabled = YES;
           });
            if (weakSelf.clickPayAction) {
                weakSelf.clickPayAction(model);
            }
        };
        cell.backgroundColor = RGBColor(243, 244, 247);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else {
        if (self.dataArray.count > 0) {
            HHHotelListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HHHotelListCell" forIndexPath:indexPath];
            if(cell ==nil){
                cell =[[HHHotelListCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"HHHotelListCell"];
            }
            cell.type = @"6";
            cell.model = self.dataArray[indexPath.row];
            cell.backgroundColor = kWhiteColor;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else {
            HHHoteNoDataCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HHHoteNoDataCell" forIndexPath:indexPath];
            if(cell ==nil){
                cell =[[HHHoteNoDataCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"HHHoteNoDataCell"];
            }
            [cell updateUI:@"icon_home_hotelSearch_nodata" title:@"暂无数据" width:130 height:150 topHeight:25];
            cell.backgroundColor = kWhiteColor;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }
    
}
//设置单元格的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag == 100) {
        return 150;
    }else {
        if (self.dataArray.count != 0) {
            HHHotelModel *model = self.dataArray[indexPath.row];
            model.type = @"6";
            return model.totalHeight;
        }else {
            return 200;
        }
    }
    
}

//单元格点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag == 100) {
        HomeModel *model = self.hourArray[indexPath.row];
        if(self.clickRoomInfoAction){
            self.clickRoomInfoAction(model);
        }
    }else {
        HHHotelModel *model = self.dataArray[indexPath.row];
        if(self.clickCellAction){
            self.clickCellAction(model.pid);
        }
    }
}

- (UITableView *)tableView {
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.bounces = NO;
        _tableView.tag = 200;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.layer.cornerRadius = 12;
        _tableView.layer.masksToBounds = YES;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.backgroundColor = kWhiteColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[HHHotelListCell class] forCellReuseIdentifier:@"HHHotelListCell"];
        [_tableView registerClass:[HHHoteNoDataCell class] forCellReuseIdentifier:@"HHHoteNoDataCell"];
        
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        if (@available(iOS 15.0, *)) {
            _tableView.sectionHeaderTopPadding = 0.f;
        }
      
    }
    return _tableView;
}

- (UITableView *)hourTableView {
    if (!_hourTableView) {
        
        _hourTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _hourTableView.dataSource = self;
        _hourTableView.delegate = self;
        _hourTableView.bounces = NO;
        _hourTableView.tag = 100;
        _hourTableView.showsVerticalScrollIndicator = NO;
        _hourTableView.showsHorizontalScrollIndicator = NO;
        _hourTableView.backgroundColor = XLColor_mainColor;
        _hourTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_hourTableView registerClass:[HHHotelDetailCell class] forCellReuseIdentifier:@"HHHotelDetailCell"];
        if (@available(iOS 11.0, *)) {
            _hourTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        if (@available(iOS 15.0, *)) {
            _hourTableView.sectionHeaderTopPadding = 0.f;
        }
    }
    return _hourTableView;
}

- (void)setHourArray:(NSArray *)hourArray {
    _hourArray = hourArray;
    if (_hourArray.count == 0) {
        self.hourView.hidden = YES;
        [self.hourView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset(0);
        }];
    }else {
        self.hourView.hidden = NO;
        [self.hourView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset(60+_hourArray.count*150);
        }];
        [self.hourTableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset(_hourArray.count*150);
        }];
    }
}
@end
