//
//  HHHotelDetailSectionView.m
//  HashdeepHotel
//
//  Created by Cindy on 2022/7/25.
//

#import "HHHotelDetailSectionView.h"
#import "HHHotelMenuModel.h"
@interface HHHotelDetailSectionView ()<UIScrollViewDelegate>
@property (nonatomic, strong) UILabel *beginDateLabel;
@property (nonatomic, strong) UILabel *beginWeekLabel;
@property (nonatomic, strong) UIView *beginDateRightLineView;
@property (nonatomic, strong) UILabel *numberLabel;
@property (nonatomic, strong) UILabel *endDateLabel;
@property (nonatomic, strong) UILabel *endWeekLabel;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *resultArray;
@property (nonatomic, strong) NSArray *array;
@end

@implementation HHHotelDetailSectionView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.resultArray = [NSMutableArray array];
        [self _addSubViews];
    }
    return self;
}

- (void)_addSubViews{
    self.whiteView = [[UIView alloc] init];
    self.whiteView.layer.cornerRadius = 10;
    self.whiteView.layer.masksToBounds = YES;
    self.whiteView.backgroundColor = kWhiteColor;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dateAction)];
    [self.whiteView addGestureRecognizer:tap];
    [self addSubview:self.whiteView];
    [self.whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.offset(-15);
        make.top.offset(0);
        make.height.offset(50);
    }];
    
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.bounces = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.equalTo(self.whiteView.mas_bottom).offset(10);
        make.height.offset(32);
    }];
    
    self.beginDateRightLineView = [[UIView alloc] init];
    self.beginDateRightLineView.backgroundColor = UIColorHex(b58e7f);
    [self.whiteView addSubview:self.beginDateRightLineView];
    [self.beginDateRightLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.whiteView);
        make.centerY.equalTo(self.whiteView);
        make.width.offset(50);
        make.height.offset(1);
    }];
    
    NSString *begindateString = [HHAppManage getDateWithString:[HashMainData shareInstance].startDateStr];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSDate *startDate = [formatter dateFromString:begindateString];
    
    NSString *endDateString = [HHAppManage getDateWithString:[HashMainData shareInstance].endDateStr];
    NSDateFormatter *formatter2 = [[NSDateFormatter alloc]init];
    formatter2.dateFormat = @"yyyy-MM-dd";
    NSDate *endDate = [formatter2 dateFromString:endDateString];
    
    NSInteger days = [HHAppManage calcDaysFromBegin:startDate end:endDate];
    
    self.numberLabel = [[UILabel alloc] init];
    self.numberLabel.textColor = UIColorHex(b58e7f);
    self.numberLabel.textAlignment = NSTextAlignmentCenter;
    self.numberLabel.layer.cornerRadius = 9;
    self.numberLabel.layer.masksToBounds = YES;
    self.numberLabel.backgroundColor = kWhiteColor;
    self.numberLabel.font = XLFont_subSubTextFont;
    self.numberLabel.layer.borderWidth = 1;
    self.numberLabel.text = [NSString stringWithFormat:@"%ld晚",days];
    self.numberLabel.layer.borderColor = UIColorHex(b58e7f).CGColor;
    [self.whiteView addSubview:self.numberLabel];
    [self.numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.whiteView);
        make.centerY.equalTo(self.whiteView);
        make.width.offset(30);
        make.height.offset(20);
    }];
 
    self.beginWeekLabel = [[UILabel alloc] init];
    self.beginWeekLabel.textColor = XLColor_subTextColor;
    self.beginWeekLabel.font = XLFont_subSubTextFont;
    self.beginWeekLabel.textAlignment = NSTextAlignmentRight;
    [self.whiteView addSubview:self.beginWeekLabel];
    [self.beginWeekLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.beginDateRightLineView.mas_left).offset(-15);
        make.top.bottom.offset(0);
    }];
    
    self.beginDateLabel = [[UILabel alloc] init];
    self.beginDateLabel.textColor = XLColor_mainTextColor;
    self.beginDateLabel.font = KBoldFont(16);
    self.beginDateLabel.textAlignment = NSTextAlignmentRight;
    [self.whiteView addSubview:self.beginDateLabel];
    [self.beginDateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.beginWeekLabel.mas_left).offset(-5);
        make.top.bottom.offset(0);
    }];
    
    self.endDateLabel = [[UILabel alloc] init];
    self.endDateLabel.textColor = XLColor_mainTextColor;
    self.endDateLabel.font = KBoldFont(16);
    self.endDateLabel.text = [HashMainData shareInstance].endDateStr;
    [self.whiteView addSubview:self.endDateLabel];
    [self.endDateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.beginDateRightLineView.mas_right).offset(15);
        make.top.bottom.offset(0);
    }];
    
    self.endWeekLabel = [[UILabel alloc] init];
    self.endWeekLabel.textColor = XLColor_subTextColor;
    self.endWeekLabel.font = XLFont_subSubTextFont;
    self.endWeekLabel.text = [HashMainData shareInstance].checkOutWeekStr;
    [self.whiteView addSubview:self.endWeekLabel];
    [self.endWeekLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.endDateLabel.mas_right).offset(5);
        make.top.bottom.offset(0);
    }];
    
    self.beginDateLabel.text = [HashMainData shareInstance].currentStartDateStr;
    self.beginWeekLabel.text = [HashMainData shareInstance].currentCheckInWeekStr;
    
}

-(void)dateAction{
    if (self.clickDateAction) {
        self.clickDateAction();
    }
}

- (void)updateUI:(NSArray *)array {
    
    if (array.count != 0) {
        self.array = array;
        UIButton *sender0;
        for (int i=0; i<array.count; i++) {
            HHHotelMenuModel *model = array[i];
            CGFloat titleWidth = [LabelSize widthOfString:model.desc font:XLFont_subTextFont height:32];
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.tag = i;
            [button setTitle:model.desc forState:UIControlStateNormal];
            [button setTitleColor:XLColor_mainTextColor forState:UIControlStateNormal];
            [button setTitle:model.desc forState:UIControlStateSelected];
            [button setTitleColor:UIColorHex(b58e7f) forState:UIControlStateSelected];
            button.titleLabel.font = XLFont_subTextFont;
            button.backgroundColor = kWhiteColor;
            button.layer.cornerRadius = 5;
            button.layer.masksToBounds = YES;
            if (model.isSelected) {
                button.selected = YES;
                [self.resultArray addObject:model.room_type];
            }
            [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
            [self.scrollView addSubview:button];
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(sender0 ? sender0.mas_right : self.scrollView).offset(15);
                make.top.offset(0);
                make.width.offset(titleWidth+20);
                make.height.offset(32);
                if (i == array.count-1) {
                    make.right.offset(-15);
                }
            }];
            sender0 = button;
        }
        
    }
}

#pragma mark -------栏目按钮点击事件----------
- (void)buttonAction:(UIButton *)button {
    button.selected = !button.selected;
    HHHotelMenuModel *model = self.array[button.tag];
    if (button.selected) {
        model.isSelected = YES;
        [self.resultArray addObject:model.room_type];
        [self scrollTitleButtonSelectededCenter:button];
    }else {
        model.isSelected = NO;
        [self.resultArray removeObject:model.room_type];
    }
    if (self.clickButtonAction) {
        self.clickButtonAction(self.resultArray);
    }
}


//滚动标题选中居中 */
- (void)scrollTitleButtonSelectededCenter:(UIButton *)button {
    // 获取最大滚动范围
    CGFloat maxOffsetX = self.scrollView.contentSize.width - kScreenWidth;
    if (maxOffsetX < 0){
        return;
    }
    
    // 计算偏移量
    CGFloat offsetX = button.center.x - kScreenWidth * 0.5;
    
    if (offsetX < 0)
        offsetX = 0;
    
    if (offsetX > maxOffsetX)
        offsetX = maxOffsetX;
    
    // 滚动标题滚动条
    [self.scrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
}

- (void)updateDate{
    
    if(self.dateType == 0){
        self.beginDateLabel.text = [HashMainData shareInstance].startDateStr;
        self.beginWeekLabel.text = [HashMainData shareInstance].checkInWeekStr;
        self.beginDateRightLineView.hidden = NO;
        self.numberLabel.hidden = NO;
        self.endDateLabel.hidden = NO;
        self.endWeekLabel.hidden = NO;
        
        self.numberLabel.text = [NSString stringWithFormat:@"%ld晚",[HashMainData shareInstance].day];
        self.endDateLabel.text = [HashMainData shareInstance].endDateStr;
        self.endWeekLabel.text = [HashMainData shareInstance].checkOutWeekStr;
        
        [self.beginWeekLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.beginDateRightLineView.mas_left).offset(-15);
            make.top.bottom.offset(0);
        }];
        
        [self.beginDateLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.beginWeekLabel.mas_left).offset(-5);
            make.top.bottom.offset(0);
        }];
    }else {
        self.beginDateLabel.text = [HashMainData shareInstance].hourStartDateStr;
        self.beginWeekLabel.text = [HashMainData shareInstance].hourCheckInWeekStr;
        self.beginDateRightLineView.hidden = YES;
        self.numberLabel.hidden = YES;
        self.endDateLabel.hidden = YES;
        self.endWeekLabel.hidden = YES;
        [self.beginWeekLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.beginDateLabel.mas_right).offset(10);
            make.top.bottom.offset(0);
        }];
       
        [self.beginDateLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(15);
            make.top.bottom.offset(0);
        }];
    }
}
@end
