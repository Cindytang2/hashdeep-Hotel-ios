//
//  HHHomeHeadCollectionReusableView.m
//  HashdeepHotel
//
//  Created by Cindy on 2022/7/13.
//

#import "HHHomeHeadCollectionReusableView.h"
#import "HHCountryView.h"
#import "NSDate+XZY.h"
#import "WMZBannerView.h"

@interface HHHomeHeadCollectionReusableView ()<UIScrollViewDelegate>
@property (nonatomic, strong) WMZBannerView *bannerView;
@property(nonatomic,strong)WMZBannerParam *bannerParam;
@property (nonatomic, strong) UIView *whiteView;
@property (nonatomic, strong) UIView *indexLineView;
@property (nonatomic, strong) UIButton *selectedBt;

@end

@implementation HHHomeHeadCollectionReusableView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self _addSubViews];
    }
    return self;
}

#pragma mark ---------bannerUI-------------
- (void)updateUIForBanner:(NSArray *)bannerData withResultData:(NSArray *)resultData{
    [self.bannerView removeFromSuperview];
    self.bannerParam =  BannerParam()
        .wAutoScrollSet(YES)
        .wFrameSet(CGRectMake(0, 0, kScreenWidth, 220))
        .wDataSet(bannerData)
        .wRepeatSet(YES)
        .wEventClickSet(^(id anyID, NSInteger index) {
            
        });
    self.bannerView = [[WMZBannerView alloc]initConfigureWithModel:self.bannerParam];
    self.bannerView.layer.cornerRadius = 10;
    self.bannerView.resultArray = resultData;
    self.bannerView.layer.masksToBounds = YES;
    [self insertSubview:self.bannerView atIndex:0];
    
}

- (void)_addSubViews{
    WeakSelf(weakSelf)
    self.whiteView = [[UIView alloc] init];
    self.whiteView.backgroundColor = kWhiteColor;
    self.whiteView.layer.cornerRadius = 20;
    self.whiteView.layer.masksToBounds = YES;
    self.whiteView.layer.shadowColor = kBlackColor.CGColor;
    //shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用  (0,0)时是四周都有阴影
    self.whiteView.layer.shadowOffset = CGSizeMake(0, 0);
    //阴影透明度，默认0
    self.whiteView.layer.shadowOpacity = 0.3;
    //阴影半径，默认3
    self.whiteView.layer.shadowRadius = 3;
    self.whiteView.clipsToBounds = NO;
    [self addSubview:self.whiteView];
    [self.whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(20);
        make.right.offset(-20);
        make.height.offset(350);
        make.top.offset(160);
    }];
    
    //顶部菜单
    NSArray *titleArray = @[@"国内/国际",@"时租房",@"民宿"];
    int xLeft = 30;
    for (int i=0; i<titleArray.count; i++) {
        NSString *string = titleArray[i];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = 100+i;
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:string forState:UIControlStateNormal];
        [button setTitleColor:XLColor_mainTextColor forState:UIControlStateNormal];
        [button setTitle:string forState:UIControlStateSelected];
        [button setTitleColor:UIColorHex(b58e7f) forState:UIControlStateSelected];
        button.titleLabel.font = KBoldFont(18);
        if (i== 0) {
            button.selected = YES;
            self.selectedBt = button;
        }
        [self.whiteView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(xLeft);
            make.top.offset(0);
            make.width.offset((kScreenWidth-110)/3);
            make.height.offset(50);
        }];
        xLeft = xLeft+(kScreenWidth-110)/3;
    }
    
    self.indexLineView = [[UIView alloc] init];
    self.indexLineView.backgroundColor = UIColorHex(b58e7f);
    self.indexLineView.layer.cornerRadius = 1.5;
    self.indexLineView.layer.masksToBounds = YES;
    [self.whiteView addSubview:self.indexLineView];
    [self.indexLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(25);
        make.height.offset(3);
        make.top.offset(44);
        make.centerX.equalTo(self.selectedBt);
    }];
    
    self.countryView = [[HHCountryView alloc] init];
    [self.whiteView addSubview:self.countryView];
    [self.countryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.offset(51);
        make.height.offset(350-51);
    }];
    self.countryView.clickAddressAction = ^{
        if (weakSelf.selectedAddress) {
            weakSelf.selectedAddress();
        }
    };
    self.countryView.clickCurrentLocationAction = ^(UILabel * _Nonnull label) {
        if (weakSelf.currentLocationAction) {
            weakSelf.currentLocationAction(label);
        }
    };
    self.countryView.clickSearchAction = ^(NSString * _Nonnull str) {
        if (weakSelf.searchAction) {
            weakSelf.searchAction(str);
        }
    };
    self.countryView.clickLookupAction = ^{
        if (weakSelf.lookupAction) {
            weakSelf.lookupAction(weakSelf.countryView.searchResultLabel.text);
        }
    };
    self.countryView.selectedSetupSuccess = ^{
        if (weakSelf.selectedSetupAction) {
            weakSelf.selectedSetupAction();
        }
    };
    self.countryView.clickDeleteSearchKey = ^{
        if (weakSelf.deleteSearchKey) {
            weakSelf.deleteSearchKey();
        }
    };
    self.countryView.clickDateAction = ^{
        if(weakSelf.index == 1){
            if (weakSelf.dateAction) {
                weakSelf.dateAction([HashMainData shareInstance].hourlyStartModel,[HashMainData shareInstance].endModel);
            }
        }else {
            if (weakSelf.dateAction) {
                weakSelf.dateAction([HashMainData shareInstance].startModel,[HashMainData shareInstance].endModel);
            }
        }
        
    };
    
    UILabel *recommendLabel = [[UILabel alloc] init];
    recommendLabel.text = @"推荐";
    recommendLabel.textColor = XLColor_mainTextColor;
    recommendLabel.font = KBoldFont(18);
    [self addSubview:recommendLabel];
    [recommendLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(25);
        make.top.equalTo(self.whiteView.mas_bottom).offset(16);
        make.height.offset(30);
        make.width.offset(60);
    }];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = UIColorHex(b58e7f);
    lineView.layer.cornerRadius = 1.5;
    lineView.layer.masksToBounds = YES;
    [self addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(30);
        make.width.offset(25);
        make.height.offset(3);
        make.top.equalTo(recommendLabel.mas_bottom).offset(0);
    }];
}

#pragma mark -------栏目按钮点击事件----------
- (void)buttonAction:(UIButton *)button {
    button.enabled = NO;
    self.selectedBt.selected = NO;
    button.selected = YES;
    self.selectedBt = button;
    
    if(self.selectedBt){
        [self.selectedBt setTitleColor:UIColorHex(b58e7f) forState:UIControlStateSelected];
    }
    
    if(button.tag-100 == 1){//时租
        CGFloat w = [LabelSize widthOfString:@"关键字/位置/品牌/酒店名" font:XLFont_mainTextFont height:50];
        w = w+1;
        [self.countryView.searchImgView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.offset((kScreenWidth-50-w-19)/2);
        }];
        
        self.countryView.searchLabel.text = @"关键字/位置/品牌/酒店名";
        self.countryView.checkInDateLabel.text = [HashMainData shareInstance].hourStartDateStr;
        self.countryView.checkInWeekLabel.text = [HashMainData shareInstance].hourCheckInWeekStr;
        
        self.countryView.leaveDateLabel.hidden = YES;
        self.countryView.leaveWeekLabel.hidden = YES;
        self.countryView.leaveLabel.hidden = YES;
        self.countryView.numberDayLabel.hidden = YES;
        
        [HashMainData shareInstance].currentStartDateStr = [HashMainData shareInstance].hourStartDateStr;
        [HashMainData shareInstance].currentCheckInWeekStr = [HashMainData shareInstance].hourCheckInWeekStr;
        [HashMainData shareInstance].currentEndDateStr = @"";
        [HashMainData shareInstance].currentCheckOutWeekStr = @"";
        [HashMainData shareInstance].currentDay = 0;
        [HashMainData shareInstance].currentStartDateTimeStamp = [HashMainData shareInstance].hourStartDateTimeStamp;
        [HashMainData shareInstance].currentEndDateTimeStamp = [NSString stringWithFormat:@"%ld", [HashMainData shareInstance].hourStartDateTimeStamp.integerValue+1];
    }else {
        if(button.tag-100 == 2){
            self.countryView.searchLabel.text = @"搜索/位置/关键词";
            CGFloat w = [LabelSize widthOfString:@"搜索/位置/关键词" font:XLFont_mainTextFont height:50];
            w = w+1;
            [self.countryView.searchImgView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.offset((kScreenWidth-50-w-19)/2);
            }];
        }else {
            self.countryView.searchLabel.text = @"关键字/位置/品牌/酒店名";
            CGFloat w = [LabelSize widthOfString:@"关键字/位置/品牌/酒店名" font:XLFont_mainTextFont height:50];
            w = w+1;
            [self.countryView.searchImgView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.offset((kScreenWidth-50-w-19)/2);
            }];
        }
        
        self.countryView.checkInDateLabel.text = [HashMainData shareInstance].startDateStr;
        self.countryView.checkInWeekLabel.text = [HashMainData shareInstance].checkInWeekStr;
        self.countryView.leaveDateLabel.text = [HashMainData shareInstance].endDateStr;
        self.countryView.leaveWeekLabel.text = [HashMainData shareInstance].checkOutWeekStr;
        self.countryView.numberDayLabel.text = [NSString stringWithFormat:@"共 %ld 晚", [HashMainData shareInstance].day];
        
        self.countryView.leaveDateLabel.hidden = NO;
        self.countryView.leaveWeekLabel.hidden = NO;
        self.countryView.leaveLabel.hidden = NO;
        self.countryView.numberDayLabel.hidden = NO;
        
        [HashMainData shareInstance].currentStartDateStr = [HashMainData shareInstance].startDateStr;
        [HashMainData shareInstance].currentCheckInWeekStr = [HashMainData shareInstance].checkInWeekStr;
        [HashMainData shareInstance].currentEndDateStr = [HashMainData shareInstance].endDateStr;
        [HashMainData shareInstance].currentCheckOutWeekStr = [HashMainData shareInstance].checkOutWeekStr;
        [HashMainData shareInstance].currentDay = [HashMainData shareInstance].day;
        [HashMainData shareInstance].currentStartDateTimeStamp = [HashMainData shareInstance].startDateTimeStamp;
        [HashMainData shareInstance].currentEndDateTimeStamp = [HashMainData shareInstance].endDateTimeStamp;
    }
    
    [self.indexLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(25);
        make.height.offset(3);
        make.top.offset(44);
        make.centerX.equalTo(self.selectedBt);
    }];
    
    if (self.clickColumnAction) {
        self.clickColumnAction(button);
    }
}

- (void)updateCountryAddress:(NSString *)str {
    self.countryView.addressLabel.text = str;
    self.countryView.currentLocationLabel.text = @"当前位置";
}

- (void)updateSearch:(NSString *)str {
    [self.countryView updateCountrySearch:str];
}

- (void)updateSetup:(NSString *)str{
    
    if ([str isEqualToString:@"价格星级"]||str.length == 0) {
        self.countryView.setupLabel.text = @"安全评分/检测时间/价格";
        self.countryView.setupLabel.textColor = XLColor_subSubTextColor;
        self.countryView.setupLabel.font = XLFont_mainTextFont;
        
    }else {
        self.countryView.setupLabel.text = str;
        self.countryView.setupLabel.textColor = XLColor_mainTextColor;
        self.countryView.setupLabel.font = KBoldFont(14);
    }
}

- (void)updateTime:(NSInteger )num{
    
    if(num == 1){//时租
        
        self.countryView.checkInDateLabel.text = [HashMainData shareInstance].hourStartDateStr;
        self.countryView.checkInWeekLabel.text = [HashMainData shareInstance].hourCheckInWeekStr;
        
        self.countryView.leaveDateLabel.hidden = YES;
        self.countryView.leaveWeekLabel.hidden = YES;
        self.countryView.leaveLabel.hidden = YES;
        self.countryView.numberDayLabel.hidden = YES;
        
    }else {
        
        self.countryView.checkInDateLabel.text = [HashMainData shareInstance].startDateStr;
        self.countryView.checkInWeekLabel.text = [HashMainData shareInstance].checkInWeekStr;
        self.countryView.leaveDateLabel.text = [HashMainData shareInstance].endDateStr;
        self.countryView.leaveWeekLabel.text = [HashMainData shareInstance].checkOutWeekStr;
        self.countryView.numberDayLabel.text = [NSString stringWithFormat:@"共 %ld 晚", [HashMainData shareInstance].day];
        
        self.countryView.leaveDateLabel.hidden = NO;
        self.countryView.leaveWeekLabel.hidden = NO;
        self.countryView.leaveLabel.hidden = NO;
        self.countryView.numberDayLabel.hidden = NO;
        
    }
}

- (void)updateDateUI:(NSInteger )num dic:(NSDictionary *)dic startModel:(DayModel *)startModel endModel:(DayModel *)endModel{
    
    //UI赋值
    self.countryView.numberDayLabel.text = [NSString stringWithFormat:@"共 %@ 晚",dic[@"days"]];
    self.countryView.checkInDateLabel.text = dic[@"startDate"];
    self.countryView.checkInWeekLabel.text = dic[@"checkInWeek"];
    self.countryView.leaveDateLabel.text = dic[@"endDate"];
    self.countryView.leaveWeekLabel.text = dic[@"checkOutWeek"];
    
    if(num == 1){//时租
        self.countryView.leaveDateLabel.hidden = YES;
        self.countryView.leaveWeekLabel.hidden = YES;
        self.countryView.leaveLabel.hidden = YES;
        self.countryView.numberDayLabel.hidden = YES;
        //更新时租房的日期
        [HashMainData shareInstance].hourlyStartModel = startModel;
        [HashMainData updateHourlyDateWithDic:dic];
    }else {
        self.countryView.leaveDateLabel.hidden = NO;
        self.countryView.leaveWeekLabel.hidden = NO;
        self.countryView.leaveLabel.hidden = NO;
        self.countryView.numberDayLabel.hidden = NO;
        [HashMainData shareInstance].startModel = startModel;
        [HashMainData shareInstance].endModel = endModel;
        //更新国内/国际的日期
        [HashMainData updateDateWithDic:dic];
    }
}

- (void)updateDeleteSearch{
    self.countryView.searchResultLabel.hidden = YES;
    self.countryView.closeButton.hidden = YES;
    self.countryView.searchLabel.hidden = NO;
    self.countryView.searchImgView.hidden = NO;
    self.countryView.searchResultLabel.text = @"";
}

@end
