//
//  HHHotelMenuView.m
//  HashdeepHotel
//
//  Created by Cindy on 2022/7/18.
//

#import "HHHotelMenuView.h"
#import "HHHotelMenuModel.h"
#import "HHIntelligenceView.h"
#import "HHIntelligenceModel.h"
#import "HHScreenView.h"
#import "HHHomePriceView.h"
#import "HHMenuScreenModel.h"
#import "YLDropDownTableView.h"
@interface HHHotelMenuView ()
@property (nonatomic, strong) HHIntelligenceView *intelligenceView;
@property (nonatomic, strong) YLDropDownTableView *dropDownTableView;
@property (nonatomic, strong) HHHomePriceView *priceView;
@property (nonatomic, strong) HHScreenView *screenView;

@property (nonatomic, strong) NSMutableArray *screenArray;
@property (nonatomic, strong) NSMutableArray *positionArray;
@end

@implementation HHHotelMenuView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.screenArray = [NSMutableArray array];
        self.positionArray = [NSMutableArray array];
    }
    return self;
}

- (void)_createdViews {
    
    NSMutableArray *intArray = [NSMutableArray array];
    NSArray *arr = self.data[@"sorting_list"];
    for (int i=0; i<arr.count; i++) {
        NSDictionary *dic = arr[i];
        HHIntelligenceModel *model = [[HHIntelligenceModel alloc] init];
        model.tag_id = dic[@"tag_id"];
        model.tag_name = dic[@"tag_name"];
        if (i == 0) {
            model.isSelected = YES;
        }else {
            model.isSelected = NO;
        }
        [intArray addObject:model];
    }
    
    NSArray *array = self.data[@"screening_list"];
    if (array.count != 0) {
        self.screenArray = [HHMenuScreenModel mj_objectArrayWithKeyValuesArray:self.data[@"screening_list"]];
    }
    
    WeakSelf(weakSelf)
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    self.intelligenceView = [[HHIntelligenceView alloc] init];
    self.intelligenceView.hidden = YES;
    self.intelligenceView.tag = 100;
    self.intelligenceView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    self.intelligenceView.clickCloseButton = ^{
        weakSelf.intelligenceView.hidden = YES;
        UIButton *button = [weakSelf viewWithTag:10];
        button.selected = NO;
        UIImageView *imgView = [button viewWithTag:200];
        imgView.image = HHGetImage(@"icon_home_hotel_down");
    };
    self.intelligenceView.updateCellAction = ^(HHIntelligenceModel * _Nonnull model) {
        [weakSelf intelligence:model];
    };
    self.intelligenceView.array = intArray;
    [keyWindow addSubview:self.intelligenceView];
    [self.intelligenceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.offset(0);
        make.top.offset(UINavigateHeight+35);
    }];
}

- (void)intelligence:(HHIntelligenceModel *)model {
    self.intelligenceView.hidden = YES;
    UIButton *button = [self viewWithTag:10];
    button.selected = NO;
    UILabel *label = [button viewWithTag:100];
    label.text = model.tag_name;
    if([model.tag_name isEqualToString:@"智能排序"]){
        label.textColor = XLColor_mainTextColor;
    }else {
        label.textColor = UIColorHex(b58e7f);
    }
    
    CGFloat width = [LabelSize widthOfString:model.tag_name font:KBoldFont(14) height:40];
    width = width+1;
    [label mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.offset((kScreenWidth/4-width-7)/2);
        make.width.offset(width);
    }];
    
    UIImageView *imgView = [button viewWithTag:200];
    imgView.image = HHGetImage(@"icon_home_hotel_down");
    
    if (self.selectedIntelligenceSuccess) {
        self.selectedIntelligenceSuccess(model.tag_id);
    }
}

- (void)_createdScreenView {
    WeakSelf(weakSelf)
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    self.screenView = [[HHScreenView alloc] init];
    self.screenView.tag = 400;
    self.screenView.array = self.screenArray;
    self.screenView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    self.screenView.clickCloseButton = ^{
        [weakSelf.screenView removeFromSuperview];
        UIButton *button = [weakSelf viewWithTag:13];
        button.selected = NO;
        UIImageView *imgView = [button viewWithTag:200];
        imgView.image = HHGetImage(@"icon_home_hotel_down");
    };
    self.screenView.clickDoneButton = ^(NSArray * _Nonnull arr, NSString * _Nonnull str) {
        [weakSelf.screenView removeFromSuperview];
        UIButton *button = [weakSelf viewWithTag:13];
        button.selected = NO;
        
        UIImageView *imgView = [button viewWithTag:200];
        imgView.image = HHGetImage(@"icon_home_hotel_down");
        
        UILabel *label = [button viewWithTag:100];
        label.text = str;
        if(arr.count == 0){
            label.textColor = XLColor_mainTextColor;
        }else {
            label.textColor = UIColorHex(b58e7f);
        }
        CGFloat width = [LabelSize widthOfString:str font:KBoldFont(14) height:40];
        width = width+1;
        if (width> kScreenWidth/4-7) {
            width = kScreenWidth/4-7;
        }
        [label mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.offset((kScreenWidth/4-width-7)/2);
            make.width.offset(width);
        }];
        
        if (weakSelf.selectedScreenSuccess) {
            weakSelf.selectedScreenSuccess(arr);
        }
    };
    [keyWindow addSubview:self.screenView];
    [self.screenView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.offset(0);
        make.top.offset(UINavigateHeight+35);
    }];
}
- (void)_createdAdressView {
    
    WeakSelf(weakSelf)
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    
    self.dropDownTableView = [[YLDropDownTableView alloc] init];
    self.dropDownTableView.tag = 200;
    self.dropDownTableView.clickCloseButton = ^{
        [weakSelf.dropDownTableView removeFromSuperview];
        UIButton *button = [weakSelf viewWithTag:11];
        button.selected = NO;
        UIImageView *imgView = [button viewWithTag:200];
        imgView.image = HHGetImage(@"icon_home_hotel_down");
    };
    self.dropDownTableView.clickDoneButton = ^(NSString *distance_condition, NSString *location, BOOL is_location, NSString *str) {
        [weakSelf.dropDownTableView removeFromSuperview];
        UIButton *button = [weakSelf viewWithTag:11];
        button.selected = NO;
        UIImageView *imgView = [button viewWithTag:200];
        imgView.image = HHGetImage(@"icon_home_hotel_down");
        
        UILabel *label = [button viewWithTag:100];
        label.text = str;
        if([str isEqualToString:@"位置区域"]){
            label.textColor = XLColor_mainTextColor;
        }else {
            label.textColor = UIColorHex(b58e7f);
        }
        CGFloat width = [LabelSize widthOfString:str font:KBoldFont(14) height:40];
        width = width+1;
        if (width> kScreenWidth/4-7) {
            width = kScreenWidth/4-7;
        }
        [label mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.offset((kScreenWidth/4-width-7)/2);
            make.width.offset(width);
        }];
        if (weakSelf.selectedLocationSuccess) {
            weakSelf.selectedLocationSuccess(distance_condition,location,is_location);
        }
    };
    self.dropDownTableView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    [keyWindow addSubview:self.dropDownTableView];
    [self.dropDownTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.offset(0);
        make.top.offset(UINavigateHeight+35);
    }];
    
    NSArray *pArr = self.data[@"location_list"];
    if (pArr.count != 0) {
        NSArray *firstArr = [HHMenuScreenModel mj_objectArrayWithKeyValuesArray:self.data[@"location_list"]];
        [self.dropDownTableView reloadData:firstArr];
        [self.dropDownTableView show];
    }
}

- (void)_createdPriceView {
    WeakSelf(weakSelf)
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    
    self.priceView = [[HHHomePriceView alloc] init];
    if(self.type.intValue == 0){
        weakSelf.priceView.isHour = NO;
        weakSelf.priceView.isDormitory = NO;
    }else if(self.type.intValue == 1){
        weakSelf.priceView.isHour = YES;
        weakSelf.priceView.isDormitory = NO;
    }else {
        weakSelf.priceView.isHour = NO;
        weakSelf.priceView.isDormitory = YES;
    }
    self.priceView.type = @"top";
    self.priceView.tag = 300;
    self.priceView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    self.priceView.clickCloseButton = ^{
        [weakSelf.priceView removeFromSuperview];
        UIButton *button = [weakSelf viewWithTag:12];
        button.selected = NO;
        UIImageView *imgView = [button viewWithTag:200];
        imgView.image = HHGetImage(@"icon_home_hotel_down");
    };
    weakSelf.priceView.selectedWithDormitorySuccess = ^(NSString * _Nonnull dormitory, NSString * _Nonnull str, NSDictionary * _Nonnull dic) {
        [weakSelf price:dormitory str:str dic:dic];
    };
    
    self.priceView.selectedSuccess = ^(NSString * _Nonnull str, NSDictionary * _Nonnull dic) {
        [weakSelf price:@"" str:str dic:dic];
    };
    [keyWindow addSubview:self.priceView];
    [self.priceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.offset(0);
        make.top.offset(UINavigateHeight+35);
    }];
}
- (void)price:(NSString *)dormitoryStr str:(NSString *)str dic:(NSDictionary *)dic {
    [self.priceView removeFromSuperview];
    UIButton *button = [self viewWithTag:12];
    button.selected = NO;
    UILabel *label = [button viewWithTag:100];
    if(dormitoryStr.length == 0){
        
        if(str.length == 0) {
            label.text = @"价格星级";
        }else {
            label.text = str;
        }
    }else {
        if(str.length == 0) {
            label.text = [NSString stringWithFormat:@"%@",dormitoryStr];
        }else {
            label.text = [NSString stringWithFormat:@"%@,%@",dormitoryStr,str];
        }
    }
    
    if([label.text isEqualToString:@"价格星级"]){
        label.textColor = XLColor_mainTextColor;
    }else {
        label.textColor = UIColorHex(b58e7f);
    }
    
    CGFloat width = [LabelSize widthOfString:label.text font:KBoldFont(14) height:40];
    width = width+1;
    if (width> kScreenWidth/4-7) {
        width = kScreenWidth/4-7;
    }
    [label mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.offset((kScreenWidth/4-width-7)/2);
        make.width.offset(width);
    }];
    
    UIImageView *imgView = [button viewWithTag:200];
    imgView.image = HHGetImage(@"icon_home_hotel_down");
    
    if (self.selectedPriceSuccess) {
        self.selectedPriceSuccess(dic,dormitoryStr,str);
    }
}

- (void)setDataArray:(NSArray *)dataArray{
    _dataArray = dataArray;
    
    int xLeft = 0;
    for (int i=0; i<_dataArray.count; i++) {
        HHHotelMenuModel *model = _dataArray[i];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = 10+i;
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview: button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(xLeft);
            make.width.offset(kScreenWidth/4);
            make.height.offset(40);
            make.top.offset(0);
        }];
        
        xLeft = xLeft+kScreenWidth/4;
        UILabel *label = [[UILabel alloc] init];
        
        label.font = KBoldFont(14);
        if(i == 2){
            if(model.name.length == 0){
                label.text = @"价格星级";
                label.textColor = XLColor_mainTextColor;
            }else {
                label.text = model.name;
                if([model.name isEqualToString:@"价格星级"]){
                    label.textColor = XLColor_mainTextColor;
                }else{
                    label.textColor = UIColorHex(b58e7f);
                }
            }
        }else {
            label.text = model.name;
        }
        label.tag = 100;
        [button addSubview:label];
        CGFloat width;
        if(model.name.length == 0){
            width = [LabelSize widthOfString:@"价格星级" font:KBoldFont(14) height:50];
            
        }else {
            width = [LabelSize widthOfString:model.name font:KBoldFont(14) height:50];
            
        }
        width = width+1;
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.offset(0);
            
            if(i == 2){
                if(model.name.length == 0){
                    make.left.offset((kScreenWidth/4-width-7)/2);
                    make.width.offset(width);
                }else {
                    if([model.name isEqualToString:@"价格星级"]){
                        make.left.offset((kScreenWidth/4-width-7)/2);
                        make.width.offset(width);
                    }else{
                        CGFloat width = [LabelSize widthOfString:model.name font:KBoldFont(14) height:40];
                        width = width+1;
                        if (width> kScreenWidth/4-7) {
                            width = kScreenWidth/4-7;
                        }
                        make.left.offset((kScreenWidth/4-width-7)/2);
                        make.width.offset(width);
                    }
                }
                
            }else {
                make.left.offset((kScreenWidth/4-width-7)/2);
                make.width.offset(width);
                
            }
        }];
        
        UIImageView *imgView = [[UIImageView alloc] init];
        imgView.image = HHGetImage(@"icon_home_hotel_down");
        imgView.tag = 200;
        [button addSubview:imgView];
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(label.mas_right).offset(0);
            make.width.offset(7);
            make.height.offset(5);
            make.centerY.equalTo(button);
        }];
    }
}

- (void)setData:(NSDictionary *)data {
    _data = data;
    [self _createdViews];
}

- (void)buttonAction:(UIButton *)button {
    
    button.selected = !button.selected;
    if (button.selected) {
        if (button.tag == 10) {
            self.intelligenceView.hidden = NO;
            [self.dropDownTableView removeFromSuperview];
            [self.priceView removeFromSuperview];
            [self.screenView removeFromSuperview];
        }else if(button.tag == 11){
            self.intelligenceView.hidden = YES;
            [self _createdAdressView];
            [self.priceView removeFromSuperview];
            [self.screenView removeFromSuperview];
            
        }else if(button.tag == 12){
            self.intelligenceView.hidden = YES;
            [self.dropDownTableView removeFromSuperview];
            [self _createdPriceView];
            [self.screenView removeFromSuperview];
            
        }else if(button.tag == 13){
            self.intelligenceView.hidden = YES;
            [self.dropDownTableView removeFromSuperview];
            [self.priceView removeFromSuperview];
            [self _createdScreenView];
        }
    } else {
        self.intelligenceView.hidden = YES;
        [self.dropDownTableView removeFromSuperview];
        [self.priceView removeFromSuperview];
        [self.screenView removeFromSuperview];
    }
    
    for (int i=0; i<self.dataArray.count; i++) {
        UIButton *btn = [self viewWithTag:10+i];
        
        if (btn.tag == button.tag) {
            UIImageView *imgView = [btn viewWithTag:200];
            if (button.selected) {
                imgView.image = HHGetImage(@"icon_home_hotel_up");
            } else {
                imgView.image = HHGetImage(@"icon_home_hotel_down");
            }
            
        }else {
            btn.selected = NO;
            UIImageView *imgView = [btn viewWithTag:200];
            imgView.image = HHGetImage(@"icon_home_hotel_down");
        }
    }
}

- (void)hiddenSubViews {
    self.intelligenceView.hidden = YES;
    [self.dropDownTableView removeFromSuperview];
    [self.priceView removeFromSuperview];
    [self.screenView removeFromSuperview];
}
@end
