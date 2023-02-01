//
//  HHHomeSearchTableViewCell.m
//  HashdeepHotel
//
//  Created by Cindy on 2022/7/14.
//

#import "HHHomeSearchTableViewCell.h"
@interface HHHomeSearchTableViewCell ()
@property (nonatomic, strong) UIView *whiteView;
@property (nonatomic, strong) NSMutableArray *searchArray;//搜索记录数组
@end

@implementation HHHomeSearchTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.searchArray = [NSMutableArray array];
        //创建子视图
        [self _createView];
    }
    return self;
}

- (void)_createView {
    self.whiteView = [[UIView alloc] init];
    [self.contentView addSubview:self.whiteView];
    [self.whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.offset(0);
    }];
}

- (void)setArray:(NSArray *)array{
    _array = array;
    
    for (UIView *view in self.whiteView.subviews) {
        [view removeFromSuperview];
    }
    
    if (_array.count != 0) {
        int xLeft = 15;
        int yBottom = 15;
        for (int i=0; i<_array.count; i++) {
            NSDictionary *dic = _array[i];

            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.tag = i;
            if (xLeft+(kScreenWidth-51)/4 > kScreenWidth) {
                xLeft = 15;
                yBottom  = yBottom+7+50;
            }
            button.frame = CGRectMake(xLeft, yBottom, (kScreenWidth-51)/4, 50);
            button.backgroundColor = RGBColor(234, 228, 218);
            button.layer.cornerRadius = 7;
            button.layer.masksToBounds = YES;
            [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
            [self.whiteView addSubview:button];
            xLeft = xLeft+(kScreenWidth-51)/4+7;

            UILabel *label = [[UILabel alloc] init];
            label.text = dic[@"selecttype_desc"];
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
    }
}

- (void)buttonAction:(UIButton *)button {
    NSDictionary *dic = self.array[button.tag];
    NSArray *searchArray = [[NSUserDefaults standardUserDefaults] objectForKey: @"home_search_History"];
    if (searchArray.count == 0) {
        [self.searchArray addObject:dic[@"selecttype_desc"]];
    }else {
        self.searchArray = [searchArray mutableCopy];
      
        if (![searchArray containsObject:dic[@"selecttype_desc"]]) {//如果么有这个字符串
            [self.searchArray insertObject:dic[@"selecttype_desc"] atIndex:0];
        }
    }
    
    [[NSUserDefaults standardUserDefaults] setObject: self.searchArray forKey: @"home_search_History"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    if (self.clickButtonAction) {
        self.clickButtonAction(dic[@"selecttype_desc"]);
    }
    
}
@end
