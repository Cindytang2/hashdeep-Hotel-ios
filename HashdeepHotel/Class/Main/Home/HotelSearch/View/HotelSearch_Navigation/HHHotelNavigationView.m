//
//  HHHotelNavigationView.m
//  HashdeepHotel
//
//  Created by Cindy on 2022/7/18.
//

#import "HHHotelNavigationView.h"
@interface HHHotelNavigationView ()
@property (nonatomic, strong) UIView *searchSuperView;
@property (nonatomic, strong) UIButton *mapButton;
@property (nonatomic, strong) UIImageView *mapImageView;
@property (nonatomic, strong) UILabel *mapLabel;
@property (nonatomic, strong) UIView *histroySuperView;
@end

@implementation HHHotelNavigationView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self _addSubViews];
    }
    return self;
}

- (void)_addSubViews{
    self.searchSuperView = [[UIView alloc] init];
    self.searchSuperView.layer.cornerRadius = 18;
    self.searchSuperView.layer.masksToBounds = YES;
    self.searchSuperView.backgroundColor = kWhiteColor;
    self.searchSuperView.layer.borderColor = RGBColor(112, 112, 112).CGColor;
    self.searchSuperView.layer.borderWidth = 0.5;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(searchSuperViewAction)];
    [self.searchSuperView addGestureRecognizer:tap];
    [self addSubview:self.searchSuperView];
    [self.searchSuperView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.right.offset(-60);
        make.height.offset(36);
        make.centerY.equalTo(self);
    }];
    
    UIButton *dateButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [dateButton addTarget:self action:@selector(dateButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.searchSuperView addSubview:dateButton];
    [dateButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(80);
        make.left.top.bottom.offset(0);
    }];
    
    self.goInLabel = [[UILabel alloc]init];
    self.goInLabel.textColor = XLColor_subSubTextColor;
    self.goInLabel.font = XLFont_subSubTextFont;
    self.goInLabel.text = @"住";
    [dateButton addSubview:self.goInLabel];
    [self.goInLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.top.offset(3);
        make.height.offset(15);
        make.width.offset(15);
    }];
  
    self.checkInLabel = [[UILabel alloc]init];
    self.checkInLabel.textColor = UIColorHex(FF7E67);
    self.checkInLabel.font = XLFont_subSubTextFont;
    [dateButton addSubview:self.checkInLabel];
    [self.checkInLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.goInLabel.mas_right).offset(5);
        make.top.offset(3);
        make.height.offset(15);
        make.right.offset(0);
    }];
    
    self.leaveLabel = [[UILabel alloc]init];
    self.leaveLabel.textColor = XLColor_subSubTextColor;
    self.leaveLabel.font = XLFont_subSubTextFont;
    self.leaveLabel.text = @"离";
    [dateButton addSubview:self.leaveLabel];
    [self.leaveLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.top.equalTo(self.goInLabel.mas_bottom).offset(0);
        make.height.offset(15);
        make.width.offset(15);
    }];
    
    self.checkOutLabel = [[UILabel alloc]init];
    self.checkOutLabel.textColor = RGBColor(255, 126, 103);
    self.checkOutLabel.font = XLFont_subSubTextFont;
    [dateButton addSubview:self.checkOutLabel];
    [self.checkOutLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.goInLabel.mas_right).offset(5);
        make.top.equalTo(self.goInLabel.mas_bottom).offset(0);
        make.height.offset(15);
        make.right.offset(0);
    }];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = XLColor_mainColor;
    [self.searchSuperView addSubview: lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(dateButton.mas_right).offset(0);
        make.centerY.equalTo(self.searchSuperView);
        make.height.offset(20);
        make.width.offset(1);
    }];
    
    self.searchLabel = [[UILabel alloc]init];
    self.searchLabel.textColor = XLColor_subSubTextColor;
    self.searchLabel.font = XLFont_subTextFont;
    [self.searchSuperView addSubview:self.searchLabel];
    [self.searchLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lineView.mas_right).offset(15);
        make.top.bottom.offset(0);
        make.right.offset(-50);
    }];
    
    self.deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.deleteButton setImage:HHGetImage(@"icon_home_detail_room_close") forState:UIControlStateNormal];
    [self.deleteButton addTarget:self action:@selector(deleteButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.searchSuperView addSubview:self.deleteButton];
    [self.deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.searchSuperView);
        make.width.height.offset(17);
        make.right.offset(-15);
    }];
    
    
    self.mapButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.mapButton addTarget:self action:@selector(mapButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.mapButton];
    [self.mapButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(60);
        make.right.top.bottom.offset(0);
    }];
    
    self.mapImageView = [[UIImageView alloc] init];
    self.mapImageView.image = HHGetImage(@"icon_home_map");
    [self.mapButton addSubview:self.mapImageView];
    [self.mapImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mapButton);
        make.top.offset(5);
        make.width.offset(18);
        make.height.offset(15);
    }];
    
    self.mapLabel = [[UILabel alloc]init];
    self.mapLabel.textColor = XLColor_mainTextColor;
    self.mapLabel.font = XLFont_subSubTextFont;
    self.mapLabel.textAlignment = NSTextAlignmentCenter;
    self.mapLabel.text = @"地图";
    [self.mapButton addSubview:self.mapLabel];
    [self.mapLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.height.offset(15);
        make.top.equalTo(self.mapImageView.mas_bottom).offset(3);
    }];
    
    NSArray *beginarray = [[HashMainData shareInstance].currentStartDateStr componentsSeparatedByString:@"月"];
    NSString *beginyueStr = beginarray.firstObject;
    NSString *beginlastStr = beginarray.lastObject;
    NSArray *beginriArray = [beginlastStr componentsSeparatedByString:@"日"];
    NSString *beginriStr = beginriArray.firstObject;
    NSString *begindateString = [NSString stringWithFormat:@"%@.%@",beginyueStr,beginriStr];
    
    self.checkInLabel.text = begindateString;
    
    NSArray *endArray = [[HashMainData shareInstance].currentEndDateStr componentsSeparatedByString:@"月"];
    if([HashMainData shareInstance].currentDay != 0){
        NSString *endYueStr = endArray.firstObject;
        NSString *endlastStr = endArray.lastObject;
        NSArray *endRiArray = [endlastStr componentsSeparatedByString:@"日"];
        NSString *endRiStr = endRiArray.firstObject;
        NSString *endDateString = [NSString stringWithFormat:@"%@.%@",endYueStr,endRiStr];
        self.checkOutLabel.text = endDateString;
        
        [self.leaveLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset(15);
            make.width.offset(15);
        }];
        
        [self.checkOutLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset(15);
        }];
        
        [self.goInLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.offset(3);
        }];
        
        [self.checkInLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.offset(3);
        }];
        
    }else {
        [self.goInLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.offset(21/2);
        }];
        
        [self.checkInLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.offset(21/2);
        }];
        
        [self.leaveLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset(0);
            make.width.offset(0);
        }];
        
        [self.checkOutLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset(0);
        }];
    }

}


- (void)setIndex:(NSInteger)index {
    _index = index;
    if(_index == 2){
        [self.searchSuperView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.offset(-15);
        }];
        self.mapButton.hidden = YES;
    }else {
        [self.searchSuperView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.offset(-60);
        }];
        self.mapButton.hidden = NO;
    }
}

- (void)deleteButtonAction {
    self.searchLabel.text = @"关键字/位置/品牌";
    self.searchLabel.textColor = XLColor_subSubTextColor;
    
    self.deleteButton.hidden = YES;
    [self.searchLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-15);
    }];
    [self.deleteButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(0);
        make.right.offset(0);
    }];
    
    if(self.clickDeleteAction){
        self.clickDeleteAction();
    }
    
}

- (void)dateButtonAction {
    if (self.clickDateAction) {
        self.clickDateAction();
    }
}

- (void)searchSuperViewAction {
    if (self.clickSearchAction) {
        self.clickSearchAction();
    }
}

- (void)mapButtonAction:(UIButton *)button {
    button.enabled = NO;
    button.selected = !button.selected;
    if (button.selected) {
        self.mapImageView.image = HHGetImage(@"icon_home_search_list");
        self.mapLabel.text = @"列表";
    }else {
        self.mapImageView.image = HHGetImage(@"icon_home_map");
        self.mapLabel.text = @"地图";
    }
    if (self.clickMapAction) {
        self.clickMapAction(button);
    }
}
@end
