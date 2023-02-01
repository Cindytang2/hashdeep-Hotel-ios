//
//  HHScreenView.m
//  HashdeepHotel
//
//  Created by Cindy on 2022/7/19.
//

#import "HHScreenView.h"
#import "HHMenuScreenModel.h"

@interface HHScreenView ()
@property (nonatomic, strong) UIView *whiteView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *rightView;
@property (nonatomic, weak) UIButton *selectedBt;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) NSMutableArray *resultArray;
@property (nonatomic, strong) NSMutableArray *titleArray;

@end
@implementation HHScreenView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.index = 0;
        NSArray *saveArray =  [[NSUserDefaults standardUserDefaults] objectForKey: @"homeSearchScreenArray"];
        NSArray *saveTitleArray =  [[NSUserDefaults standardUserDefaults] objectForKey: @"homeSearchScreenTitleArray"];
        if(saveArray.count == 0){
            self.resultArray = [NSMutableArray array];
        }else {
            self.resultArray = [NSMutableArray arrayWithArray:saveArray];
        }
        if(saveTitleArray.count == 0){
            self.titleArray = [NSMutableArray array];
        }else {
            self.titleArray = [NSMutableArray arrayWithArray:saveTitleArray];
        }
        [self _createdViews];
    }
    return self;
}


- (void)_createdViews {
    
    self.whiteView = [[UIView alloc] init];
    self.whiteView.backgroundColor = kWhiteColor;
    [self addSubview:self.whiteView];
    [self.whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.offset(0);
        make.height.offset(346);
    }];
    
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.bounces = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.backgroundColor = RGBColor(242, 238, 232);
    [self.whiteView addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.offset(0);
        make.height.offset(300);
        make.width.offset(120);
    }];
    
    self.rightView = [[UIView alloc] init];
    self.rightView.backgroundColor =kWhiteColor;
    [self.whiteView addSubview:self.rightView];
    [self.rightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollView.mas_right).offset(0);
        make.top.offset(0);
        make.height.offset(300);
        make.right.offset(0);
    }];
    
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = XLColor_mainColor;
    [self.whiteView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.equalTo(self.scrollView.mas_bottom).offset(0);
        make.height.offset(1);
    }];
    
    UIButton *againButton = [UIButton buttonWithType:UIButtonTypeCustom];
    againButton.backgroundColor = kWhiteColor;
    [againButton setTitle:@"重置" forState:UIControlStateNormal];
    [againButton setTitleColor:UIColorHex(b58e7f) forState:UIControlStateNormal];
    againButton.titleLabel.font = XLFont_mainTextFont;
    [againButton addTarget:self action:@selector(againButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.whiteView addSubview:againButton];
    [againButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.height.offset(45);
        make.width.offset(150);
        make.bottom.offset(0);
    }];
    
    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    doneButton.backgroundColor = UIColorHex(b58e7f);
    [doneButton setTitle:@"完成" forState:UIControlStateNormal];
    [doneButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
    doneButton.titleLabel.font = XLFont_mainTextFont;
    [doneButton addTarget:self action:@selector(doneButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.whiteView addSubview:doneButton];
    [doneButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(0);
        make.height.offset(45);
        make.left.equalTo(againButton.mas_right).offset(0);
        make.bottom.offset(0);
    }];
    
}


- (void)setArray:(NSArray *)array {
    _array = array;
    
    for (UIView *view in self.scrollView.subviews) {
        [view removeFromSuperview];
    }
    
    for (UIView *view in self.rightView.subviews) {
        [view removeFromSuperview];
    }
    if (_array.count != 0) {
        [self _createdScrollSubView:_array];
    }
}

- (void)_createdScrollSubView:(NSArray *)array {
    int ybottom = 0;
   
    for (int i=0; i<array.count; i++) {
        HHMenuScreenModel *model = array[i];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:model.tag_name forState:UIControlStateNormal];
        [button setTitleColor:XLColor_mainTextColor forState:UIControlStateNormal];
        button.titleLabel.font = XLFont_subTextFont;
        if (i == 0) {
            button.selected = YES;
            self.selectedBt = button;
            [self.selectedBt setTitleColor:UIColorHex(b58e7f) forState:UIControlStateNormal];
            self.selectedBt.backgroundColor = kWhiteColor;
        }
        button.tag = i;
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.offset(0);
            make.centerX.offset(0);
            make.height.offset(45);
            make.top.offset(ybottom);
            if (i==array.count-1) {
                make.bottom.offset(0);
            }
        }];
        
        UIImageView *imgView = [[UIImageView alloc] init];
        imgView.image = HHGetImage(@"icon_home_hotel_selected");
        imgView.tag = 800;
        imgView.hidden = YES;
        [button addSubview:imgView];
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(7);
            make.width.offset(15);
            make.height.offset(13);
            make.centerY.equalTo(button);
        }];
        
        ybottom = ybottom+45;
    }
    
    int xLeft = 15;
    int right_yBottom = 0;
    for (int a = 0; a<array.count; a++) {
        HHMenuScreenModel *model = array[a];
        
        UIView *superView = [[UIView alloc] init];
        superView.tag = a;
        [self.rightView addSubview:superView];
        [superView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.offset(0);
            make.height.offset(0);
            make.top.offset(right_yBottom);
        }];
        
        UILabel *label = [[UILabel alloc] init];
        label.text = model.tag_name;
        label.font = KBoldFont(14);
        label.tag = 200;
        if (a == 0) {
            label.textColor = UIColorHex(b58e7f);
        }else {
            label.textColor = XLColor_mainTextColor;
        }
        [superView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(15);
            make.right.offset(-15);
            make.height.offset(45);
            make.top.offset(0);
        }];
        
        int right_smallYBottom = 45;
        int lineNumber = 1;
        for (int b=0; b<model.child_list.count; b++) {
            HHMenuScreenModel *subModel = model.child_list[b];
            if (xLeft+(kScreenWidth-150-14)/3 > kScreenWidth-135) {
                xLeft = 15;
                lineNumber++;
                right_smallYBottom = right_smallYBottom+45+10;
            }
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setTitle:subModel.tag_name forState:UIControlStateNormal];
            [button setTitleColor:XLColor_mainTextColor forState:UIControlStateNormal];
            button.titleLabel.font = XLFont_subSubTextFont;
            button.backgroundColor = RGBColor(242, 238, 232);
            button.tag = b;
            button.layer.borderWidth = 1;
            button.layer.borderColor = RGBColor(242, 238, 232).CGColor;
            button.layer.cornerRadius = 5;
            button.layer.masksToBounds = YES;
            [button addTarget:self action:@selector(subButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            [superView addSubview:button];
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.offset(xLeft);
                make.width.offset((kScreenWidth-150-14)/3);
                make.top.offset(right_smallYBottom);
                make.height.offset(45);
            }];
            xLeft = xLeft+(kScreenWidth-150-14)/3+7;
            
            UIImageView *imgView = [[UIImageView alloc] init];
            imgView.image = HHGetImage(@"icon_home_screen_selected");
            imgView.tag = 400;
            imgView.hidden = YES;
            [button addSubview:imgView];
            [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.offset(0);
                make.width.offset(15);
                make.height.offset(13);
                make.bottom.offset(0);
            }];
            
            if(self.resultArray.count != 0){
                for (NSString *tag_id in self.resultArray) {
                    if([tag_id isEqualToString:subModel.tag_id]){
                        button.selected = YES;
                        imgView.hidden = NO;
                        button.layer.borderColor = UIColorHex(b58e7f).CGColor;
                    }
                }
            }
            
        }
        
        right_yBottom = right_yBottom+45+lineNumber*45+lineNumber*10-10;
        xLeft = 15;
        [superView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset(45+lineNumber*45+lineNumber*10-10);
        }];
    }
}

- (void)subButtonAction:(UIButton *)button {
    HHMenuScreenModel *model = self.array[button.superview.tag];
    HHMenuScreenModel *subModel = model.child_list[button.tag];
    
    button.selected = !button.selected;
    UIImageView *buttom_ImgView = [button viewWithTag:400];
    NSLog(@"resultArray======%@",self.resultArray);
    if (button.selected) {
        buttom_ImgView.hidden = NO;
        button.layer.borderColor = UIColorHex(b58e7f).CGColor;
        subModel.isSelected = YES;
        model.isSelected = YES;
        
        if (self.resultArray.count != 0) {
            if (![self.resultArray containsObject:subModel.tag_id]) {
                [self.resultArray addObject:subModel.tag_id];
                [self.titleArray addObject:subModel.tag_name];
            }
        }else {
            [self.resultArray addObject:subModel.tag_id];
            [self.titleArray addObject:subModel.tag_name];
        }
        
    }else {
        buttom_ImgView.hidden = YES;
        button.layer.borderColor = RGBColor(242, 238, 232).CGColor;
        subModel.isSelected = NO;
        model.isSelected = NO;
        
        [self.resultArray removeObject:subModel.tag_id];
        [self.titleArray removeObject:subModel.tag_name];
        for (HHMenuScreenModel *ss in model.child_list) {
            if (ss.isSelected == YES) {
                model.isSelected = YES;
            }
        }
    }
    
    UIButton *leftButton = [self.scrollView viewWithTag:button.superview.tag];
    UIImageView *imgView = [leftButton viewWithTag:800];
    if (model.isSelected == YES) {
        imgView.hidden = NO;
    }else {
        imgView.hidden = YES;
    }
}

- (void)buttonAction:(UIButton *)button {
    self.index = button.tag;
    self.selectedBt.backgroundColor = RGBColor(242, 238, 232);;
    [self.selectedBt setTitleColor:XLColor_mainTextColor forState:UIControlStateNormal];
    self.selectedBt.selected = NO;
    button.selected = YES;
    self.selectedBt = button;
    if (self.selectedBt.selected) {
        self.selectedBt.backgroundColor = kWhiteColor;
        [self.selectedBt setTitleColor:UIColorHex(b58e7f) forState:UIControlStateNormal];
    }
    
    for (UIView *view in self.rightView.subviews) {
        UILabel *label = [view viewWithTag:200];
        if (view.tag == button.tag) {
            label.textColor = UIColorHex(b58e7f);
        }else {
            label.textColor = XLColor_mainTextColor;
        }
    }
}

- (void)againButtonAction {
    [self.resultArray removeAllObjects];
    [self.titleArray removeAllObjects];
    
    for (UIView *view in self.scrollView.subviews) {
        [view removeFromSuperview];
    }
    
    for (UIView *view in self.rightView.subviews) {
        [view removeFromSuperview];
    }
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"homeSearchScreenArray"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"homeSearchScreenTitleArray"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self _createdScrollSubView:self.array];
}

- (void)doneButtonAction {
  
    NSString *str;
    if (self.titleArray.count == 0) {
        str = @"筛选";
    }else {
        str = [self.titleArray componentsJoinedByString:@","];
    }
    
    [[NSUserDefaults standardUserDefaults] setObject: self.resultArray forKey: @"homeSearchScreenArray"];
    [[NSUserDefaults standardUserDefaults] setObject: self.titleArray forKey: @"homeSearchScreenTitleArray"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    if (self.clickDoneButton) {
        self.clickDoneButton(self.resultArray,str);
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
