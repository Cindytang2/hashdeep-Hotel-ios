//
//  HHSelectedRegionHeadView.m
//  HashdeepHotel
//
//  Created by Cindy on 2022/7/14.
//

#import "HHSelectedRegionHeadView.h"
#import "SelectedRegionModel.h"
@interface HHSelectedRegionHeadView ()
@property (nonatomic, strong) NSArray *hotArray;
@property (nonatomic, strong) UIView *hotSuperView;
@end
@implementation HHSelectedRegionHeadView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self _addSubViews];
    }
    return self;
}

- (void)_addSubViews{
    UILabel *currentLabel = [[UILabel alloc] init];
    currentLabel.text = @"当前位置";
    currentLabel.font = XLFont_subTextFont;
    currentLabel.textColor = XLColor_mainTextColor;
    [self addSubview:currentLabel];
    [currentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.top.offset(25);
        make.height.offset(20);
        make.right.offset(-150);
    }];
    
    UIButton *refreshLocationButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [refreshLocationButton addTarget:self action:@selector(refreshLocationButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:refreshLocationButton];
    [refreshLocationButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-15);
        make.top.offset(12);
        make.height.offset(50);
        make.width.offset(105);
    }];
    
    UIImageView *locationImageView = [[UIImageView alloc] init];
    locationImageView.image = HHGetImage(@"icon_home_updateLocaton");
    [refreshLocationButton addSubview:locationImageView];
    [locationImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(5);
        make.width.height.offset(22);
        make.centerY.equalTo(refreshLocationButton);
    }];
    
    self.refreshLocationLabel = [[UILabel alloc] init];
    self.refreshLocationLabel.text = @"刷新位置";
    self.refreshLocationLabel.textColor = UIColorHex(b58e7f);
    self.refreshLocationLabel.font = XLFont_mainTextFont;
    [refreshLocationButton addSubview:self.refreshLocationLabel];
    [self.refreshLocationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(locationImageView.mas_right).offset(7);
        make.centerY.equalTo(refreshLocationButton);
        make.height.offset(20);
    }];
    
    UIImageView *addressImageView = [[UIImageView alloc] init];
    addressImageView.image = HHGetImage(@"icon_home_address");
    [self addSubview:addressImageView];
    [addressImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.width.offset(22);
        make.height.offset(20);
        make.top.equalTo(currentLabel.mas_bottom).offset(15);
    }];
    
    self.addressLabel = [[UILabel alloc] init];
    self.addressLabel.textColor = XLColor_mainTextColor;
    self.addressLabel.font = KFont(18);
    [self addSubview:self.addressLabel];
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(addressImageView.mas_right).offset(10);
        make.top.equalTo(currentLabel.mas_bottom).offset(15);
        make.height.offset(20);
        make.right.offset(-15);
    }];
    
    UIView *lineView = [[UIView alloc ] init];
    lineView.backgroundColor = XLColor_mainColor;
    [self addSubview: lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.top.equalTo(self.addressLabel.mas_bottom).offset(15);
        make.height.offset(1);
        make.right.offset(-15);
    }];
    
    UILabel *hotLabel = [[UILabel alloc] init];
    hotLabel.text = @"热门城市";
    hotLabel.font = XLFont_subTextFont;
    hotLabel.textColor = XLColor_mainTextColor;
    [self addSubview:hotLabel];
    [hotLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.top.equalTo(lineView.mas_bottom).offset(15);
        make.height.offset(25);
        make.right.offset(-150);
    }];
    
    self.hotSuperView = [[UIView alloc] init];
    [self addSubview:self.hotSuperView];
    [self.hotSuperView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.equalTo(hotLabel.mas_bottom).offset(15);
        make.bottom.offset(-10);
    }];
}

- (CGFloat)updateHotUI:(NSArray *)array {
    self.hotArray = array;
    int xLeft = 15;
    int yBottom = 0;
    int lineNumber = 1;
    for (int i=0; i<array.count; i++) {
        SelectedRegionModel *model = array[i];
    
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = i;
        if (xLeft+(kScreenWidth-51)/4 > kScreenWidth) {
            xLeft = 15;
            yBottom  = yBottom+7+50;
            lineNumber++;
        }
        button.frame = CGRectMake(xLeft, yBottom, (kScreenWidth-51)/4, 50);
        button.backgroundColor = XLColor_mainColor;
        button.layer.cornerRadius = 7;
        button.layer.masksToBounds = YES;
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.hotSuperView addSubview:button];
        xLeft = xLeft+(kScreenWidth-51)/4+7;
        
        
        UILabel *label = [[UILabel alloc] init];
        label.text = model.city_name;
        label.numberOfLines = 0;
        label.font = XLFont_subSubTextFont;
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = XLColor_mainTextColor;
        [button addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(5);
            make.right.offset(-5);
            make.top.bottom.offset(0);
        }];
    }
    
    return 130+lineNumber*57+15;
}

- (void)buttonAction:(UIButton *)button {
    
    SelectedRegionModel *model = self.hotArray[button.tag];
    if (self.clickHotAddress) {
        self.clickHotAddress(model.city_name,model.city_longitude,model.city_latitude);
    }
}

- (void)refreshLocationButtonAction {
    if (self.clickUpdateLocation) {
        self.clickUpdateLocation();
    }
}
@end
