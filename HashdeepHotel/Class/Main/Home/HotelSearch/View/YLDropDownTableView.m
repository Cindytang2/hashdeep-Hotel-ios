//
//  YLDropDownTableView.m
//  MMComboBoxDemo
//
//  Created by 张雨露 on 2017/3/13.
//  Copyright © 2017年 Raindew. All rights reserved.
//

#import "YLDropDownTableView.h"
#import "HHMenuScreenModel.h"
#import "HHPositionTableViewCell.h"
@interface YLDropDownTableView ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UIView *whiteView;
@property (nonatomic, strong) UITableView *leftTableView;
@property (nonatomic, strong) UITableView *midTableView;
@property (nonatomic, strong) UITableView *rightTableView;
@property (nonatomic, strong) NSMutableArray *titleArray;
@property (nonatomic, strong) NSArray *datasource;//原数据--重置功能使用
@property (nonatomic, assign) BOOL isStraight;//是否为直线距离--后续优化
@property (nonatomic, assign) BOOL hasThird;
@property (nonatomic, strong) HHMenuScreenModel *previouSelectedModel;//记录前一个
@property (nonatomic, strong) HHMenuScreenModel *firstSelectedModel;//记录直线距离第二列的数据，通过是否选中来判断直线距离是否选中
@property (nonatomic, strong) NSMutableArray *firstSelectedArray;
@property (nonatomic, strong) NSMutableArray *secondSelectedArray;//记录第二列选中的model数组
@property (nonatomic, strong) NSMutableArray *thirdSelectedArray;//记录第三列选中的数据
@property (nonatomic, copy) NSString *distance_condition;
@property (nonatomic, copy) NSString *location;
@property (nonatomic, assign) BOOL is_location;

@end
#define SelectedColor [UIColor colorWithRed:109/255. green:181/255. blue:149/255. alpha:1.]
@implementation YLDropDownTableView

#pragma mark -- 初始化
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 0)]) {
        self.hasThird = NO;
        self.firstSelectedArray = [NSMutableArray array];
        self.titleArray = [NSMutableArray array];
        self.secondSelectedArray = [NSMutableArray array];
        self.thirdSelectedArray = [NSMutableArray array];
        self.firstData = [NSMutableArray array];
        self.secondeData = [NSMutableArray array];
        self.thirdData = [NSMutableArray array];
    
        [self setupUI];
    }
    return self;
}
#pragma mark -- 设置UI
- (void)setupUI {
    
    self.whiteView = [[UIView alloc] init];
    [self addSubview:self.whiteView];
    [self.whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.offset(0);
        make.height.offset(44*8+46);
    }];
    [self.whiteView addSubview:self.leftTableView];
    [self.whiteView addSubview:self.rightTableView];
    [self.whiteView addSubview:self.midTableView];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = XLColor_mainColor;
    [self.whiteView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.equalTo(self.leftTableView.mas_bottom).offset(0);
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
        make.top.equalTo(lineView.mas_bottom).offset(0);
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
        make.top.equalTo(lineView.mas_bottom).offset(0);
    }];
    
}

- (void)againButtonAction {
    self.location = @"";
    self.distance_condition = @"";
    self.is_location = NO;
    [self.titleArray removeAllObjects];
    self.secondSelectedArray = [NSMutableArray array];
    self.thirdSelectedArray = [NSMutableArray array];
    self.firstSelectedArray = [NSMutableArray array];
    
    self.firstCurrentModel = nil;
    self.previouSelectedModel = nil;
    self.firstSelectedModel = nil;
    for (HHMenuScreenModel *first in self.datasource) {
        first.isSelected = NO;
        first.shouldCheck = NO;
        if (first.has_child) {
            for (HHMenuScreenModel *second in first.child_list) {
                second.isSelected = NO;
                second.shouldCheck = NO;
                if (second.has_child) {
                    for (HHMenuScreenModel *third in second.child_list) {
                        third.isSelected = NO;
                    }
                }
            }
        }
    }
    [self reloadData:self.datasource];
}

- (void)doneButtonAction {
    
    [self.titleArray removeAllObjects];
    NSLog(@"firstSelectedArray=======%ld",self.firstSelectedArray.count);
    if (self.firstSelectedArray.count != 0) {
        [self.titleArray addObject:self.firstSelectedModel.tag_name];
        self.distance_condition = self.firstSelectedModel.tag_id;
        
        if (self.secondSelectedArray.count == 0 && self.thirdSelectedArray.count == 0) {
            self.location = @"";
            self.is_location = NO;
        }else {
            
            if (self.thirdSelectedArray.count != 0) {
                
                for (HHMenuScreenModel *mm in self.thirdSelectedArray) {
                    self.location = mm.location;
                    self.is_location = mm.is_location;
                    [self.titleArray addObject:[NSString stringWithFormat:@"%@",mm.tag_name]];
                }
            }else {
                if (!self.hasThird) {
                    if (self.secondSelectedArray.count != 0) {
                        for (HHMenuScreenModel *mm in self.secondSelectedArray) {
                            self.location = mm.location;
                            self.is_location = mm.is_location;
                            [self.titleArray addObject:[NSString stringWithFormat:@"%@",mm.tag_name]];
                        }
                    }
                }
            }
        }
    }else {
        self.distance_condition = @"";
        if (self.secondSelectedArray.count == 0 && self.thirdSelectedArray.count == 0) {
            self.location = @"";
            self.is_location = NO;
        }else {
            if (self.thirdSelectedArray.count != 0) {
                
                for (HHMenuScreenModel *mm in self.thirdSelectedArray) {
                    self.location = mm.location;
                    self.is_location = mm.is_location;
                    [self.titleArray addObject:[NSString stringWithFormat:@"%@",mm.tag_name]];
                }
            }else {
                if (!self.hasThird) {
                    if (self.secondSelectedArray.count != 0) {
                        for (HHMenuScreenModel *mm in self.secondSelectedArray) {
                            self.location = mm.location;
                            self.is_location = mm.is_location;
                            [self.titleArray addObject:[NSString stringWithFormat:@"%@",mm.tag_name]];
                        }
                    }
                }
                
            }
        }
    }
    
    NSString *str;
    if (self.titleArray.count == 0) {
        str = @"位置区域";
    }else {
        str = [self.titleArray componentsJoinedByString:@","];
    }
    
    if (self.clickDoneButton) {
        self.clickDoneButton(self.distance_condition,self.location,self.is_location,str);
    }
}
#pragma mark -- 加载数据源
- (void)reloadData:(NSArray *)datasource {
    self.datasource = [NSArray arrayWithArray:datasource];
    [self.firstData removeAllObjects];
    [self.firstData addObjectsFromArray:datasource];
    if (self.firstData.count > 0) {
        HHMenuScreenModel *model = self.firstData.firstObject;
        model.isSelected = YES;// 直线距离默认选中
        self.firstCurrentModel = model;
        self.isStraight = YES;
        if (model.has_child) {// 如果包含子数据，本质上第二层应该都会有数据，但是还是做一层判断
            HHMenuScreenModel *secondModel = model.child_list.firstObject;//取第二列的第一个数据
            if (secondModel.has_child) { //说明包含第三列,则第二列第一个默认为选中状态
                secondModel.isSelected = YES;
                [self.thirdData removeAllObjects];
                [self.thirdData addObjectsFromArray:secondModel.child_list];
            }
            //第二列数据展示
            [self.secondSelectedArray removeAllObjects];
            [self.secondeData removeAllObjects];
            [self.secondeData addObjectsFromArray:model.child_list];
        }
    }
    if (self.thirdData.count != 0) {
        self.midTableView.backgroundColor = UIColorHex(FFFBF6);
        self.midTableView.frame = CGRectMake(90, 0, 110, 44*8);
        self.rightTableView.frame = CGRectMake(200, 0, self.frame.size.width - 200, 44*8);
    }else {
        self.midTableView.backgroundColor = kWhiteColor;
        self.midTableView.frame = CGRectMake(90, 0, kScreenWidth-90, 44*8);
        self.rightTableView.frame = CGRectMake(0, 0, 0, 0);
    }
    
    [self reloadData];
}
- (void)reloadData{
    [self.leftTableView reloadData];
    [self.midTableView reloadData];
    [self.rightTableView reloadData];
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.leftTableView) {
        if (self.firstData.count) {
            return self.firstData.count ? self.firstData.count : 0;
        }
        return 0;
    }else if (tableView == self.midTableView) {
        if (self.secondeData.count) {
            return self.secondeData.count ? self.secondeData.count : 0;
        }
        return 0;
        
    }else {
        if (self.thirdData.count) {
            return self.thirdData.count ? self.thirdData.count : 0;
        }
        return 0;
    }
}
//设置单元格的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HHPositionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HHPositionTableViewCell" forIndexPath:indexPath];
    if(cell ==nil){
        cell =[[HHPositionTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"HHPositionTableViewCell"];
    }
    
    if (tableView == self.leftTableView) {
        cell.type = @"1";
        cell.model = self.firstData[indexPath.row];
    }else if (tableView == self.midTableView) {
        if (self.thirdData.count != 0) {
            cell.type = @"2";
        }else {
            cell.type = @"3";
        }
        cell.model = self.secondeData[indexPath.row];
    }else {
        cell.type = @"3";
        cell.model = self.thirdData[indexPath.row];
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}

#pragma mark - UITableViewDelegate,

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == self.leftTableView) {
        //1.单选并记录当前第一列的model
        HHMenuScreenModel *model = self.firstData[indexPath.row];
        self.firstCurrentModel.isSelected = NO;
        model.isSelected = YES;
        self.firstCurrentModel = model;
        if (model != self.firstData.firstObject) { //不是直线距离
            self.isStraight = NO;
        }else{
            self.isStraight = YES;
        }
        
        [self.secondeData removeAllObjects];
        [self.secondeData addObjectsFromArray:model.child_list];
        [self.thirdData removeAllObjects];
        HHMenuScreenModel *secondModel = model.child_list.firstObject;//取第二列的第一个数据
        if (secondModel.has_child) { //说明包含第三列,则第二列第一个默认为选中状态
            [self.thirdData addObjectsFromArray:secondModel.child_list];
        }
        
        if (self.isStraight) { //如果是直线距离则特殊处理
            
        }else{
            if (self.previouSelectedModel == self.firstCurrentModel) {
                if (self.secondSelectedArray.count == 1) { // 说明是单选
                    
                    if (secondModel.has_child) {
                        if (self.thirdSelectedArray.count > 0) {
                            for (HHMenuScreenModel *md in secondModel.child_list) {
                                for (HHMenuScreenModel *third in self.thirdSelectedArray) {
                                    if (md == third) {
                                        md.isSelected = YES;
                                        continue;
                                    }
                                }
                            }
                        }
                    }
                }else{ // 多选
                    for (HHMenuScreenModel *second in model.child_list) {
                        for (HHMenuScreenModel *md in self.secondSelectedArray) {
                            if (second == md) {
                                second.isSelected = YES;
                                continue;
                            }
                        }
                    }
                }
            }else{
                
                for (HHMenuScreenModel *mmm in self.secondeData) {
                    mmm.isSelected = NO;
                }
                if (secondModel.has_child) {//说明包含第三列,则第二列第一个默认为选中状态
                    secondModel.isSelected = YES;
                }
            }
        }
        
        
        if (self.thirdData.count != 0) {
            self.midTableView.backgroundColor = UIColorHex(FFFBF6);
            self.midTableView.frame = CGRectMake(90, 0, 110, 44*8);
            self.rightTableView.frame = CGRectMake(200, 0, self.frame.size.width - 200, 44*8);
        }else {
            self.midTableView.backgroundColor = kWhiteColor;
            self.midTableView.frame = CGRectMake(90, 0, kScreenWidth-90, 44*8);
            self.rightTableView.frame = CGRectMake(0, 0, 0, 0);
        }
        [self reloadData];
        
    }else if (tableView == self.midTableView) {
        HHMenuScreenModel *model = self.secondeData[indexPath.row];
        model.isSelected = !model.isSelected;
        if (!self.isStraight) {//点击的不是直线距离的那一列
            if (!model.has_child && !model.is_multiple) {//意味着没有第三列,并且不能多选，则可以进行反选
                if (self.previouSelectedModel.shouldCheck && self.previouSelectedModel != self.firstCurrentModel) {
                    self.previouSelectedModel.shouldCheck = NO;
                    for (HHMenuScreenModel *md in self.previouSelectedModel.child_list) {
                        if (md.isSelected) {
                            md.isSelected = NO;
                        }
                        if (md.shouldCheck) {
                            md.shouldCheck = NO;
                        }
                        if ([self.secondSelectedArray containsObject:md]) {
                            [self.secondSelectedArray removeObject:md];
                        }
                    }
                }
                if (self.thirdSelectedArray.count > 0) {
                    for (HHMenuScreenModel *third in self.thirdSelectedArray) {
                        third.isSelected = NO;
                    }
                    [self.thirdSelectedArray removeAllObjects];
                }
                
                if (self.secondSelectedArray.count > 0) {
                    for (HHMenuScreenModel *second in self.secondSelectedArray) {
                        second.isSelected = NO;
                        if (second.shouldCheck) {
                            second.shouldCheck = NO;
                        }
                    }
                    [self.secondSelectedArray removeAllObjects];
                }
                
                
                if (model.isSelected) {
                    [self.secondSelectedArray addObject:model];
                }else{
                    [self.secondSelectedArray removeObject:model];
                }
                
                if (self.secondSelectedArray.count > 0) {
                    self.firstCurrentModel.shouldCheck = YES;
                    self.previouSelectedModel = self.firstCurrentModel;
                }else{
                    self.firstCurrentModel.shouldCheck = NO;
                }
            }else{
                if (model.has_child) {/// 有第三列
                    ///
                    for (HHMenuScreenModel *md in self.secondeData) {
                        if (md.isSelected) {
                            md.isSelected = NO;
                            if ([self.secondSelectedArray containsObject:md]) {
                                [self.secondSelectedArray removeObject:md];
                            }
                        }
                        
                    }
                    model.isSelected = YES;
                    //第三列数据更新
                    [self.thirdData removeAllObjects];
                    [self.thirdData addObjectsFromArray:model.child_list];
                }else{ //支持多选
                    NSLog(@"第二列选中的数组个数11：%d",self.secondSelectedArray.count);
                    if (self.previouSelectedModel.shouldCheck && self.previouSelectedModel != self.firstCurrentModel) {
                        self.previouSelectedModel.shouldCheck = NO;
                        for (HHMenuScreenModel *md in self.previouSelectedModel.child_list) {
                            if (md.isSelected) {
                                md.isSelected = NO;
                            }
                            if (md.shouldCheck) {
                                md.shouldCheck = NO;
                            }
                            if ([self.secondSelectedArray containsObject:md]) {
                                [self.secondSelectedArray removeObject:md];
                            }
                        }
                    }
                    if (self.thirdSelectedArray.count > 0) {
                        for (HHMenuScreenModel *third in self.thirdSelectedArray) {
                            if (third.isSelected) {
                                third.isSelected = NO;
                            }
                        }
                        [self.thirdSelectedArray removeAllObjects];
                    }
                    
                    if (model.isSelected) {
                        [self.secondSelectedArray addObject:model];
                    }else{
                        [self.secondSelectedArray removeObject:model];
                    }
                    if (self.secondSelectedArray.count > 0) {
                        self.firstCurrentModel.shouldCheck = YES;
                        self.previouSelectedModel = self.firstCurrentModel;
                    }else{
                        self.firstCurrentModel.shouldCheck = NO;
                    }
                }
            }
        }else{
            if (self.firstSelectedModel != model) {
                self.firstSelectedModel.isSelected = NO;
            }
            
            HHMenuScreenModel *first = self.firstData.firstObject;
            self.firstSelectedModel = model;//记录好直线距离的第二列是否选中的数据
            if (model.isSelected) {
                first.shouldCheck = YES;
                [self.firstSelectedArray addObject:self.firstCurrentModel];
            }else{
                first.shouldCheck = NO;
                [self.firstSelectedArray removeObject:self.firstCurrentModel];
            }
            
            
        }
        
        [self reloadData];
    }else {// 右边的数据处理
        HHMenuScreenModel *model = self.thirdData[indexPath.row];
        model.isSelected = !model.isSelected;
        if (model.is_multiple) {//支持多选
            
            if (model.isSelected) {
                [self.thirdSelectedArray addObject:model];
            }else{
                [self.thirdSelectedArray removeObject:model];
            }
        }else{
            HHMenuScreenModel *select = self.thirdSelectedArray.firstObject;
            if (select != model) {
                select.isSelected = NO;
            }
            [self.thirdSelectedArray removeAllObjects];
            
            if (model.isSelected) {
                [self.thirdSelectedArray addObject:model];
            }else{
                [self.thirdSelectedArray removeObject:model];
            }
        }
        NSLog(@"第三列选中的数组个数22：%d",self.thirdSelectedArray.count);
        
        if (self.previouSelectedModel.shouldCheck && self.previouSelectedModel != self.firstCurrentModel) {
            self.previouSelectedModel.shouldCheck = NO;
            for (HHMenuScreenModel *md in self.previouSelectedModel.child_list) {
                if (md.isSelected) {
                    md.isSelected = NO;
                }
                if (md.shouldCheck) {
                    md.shouldCheck = NO;
                }
                if ([self.secondSelectedArray containsObject:md]) {
                    [self.secondSelectedArray removeObject:md];
                }
            }
        }
        
        if (self.thirdSelectedArray.count > 0) {
            if (self.secondSelectedArray.count == 0) {//默认为第一个
                for (HHMenuScreenModel *second in self.secondeData) {
                    if (second.isSelected) {
                        self.hasThird = NO;
                        [self.secondSelectedArray addObject:second];
                        break;
                    }
                }
            }
            HHMenuScreenModel *second = self.secondSelectedArray.firstObject;
            for (HHMenuScreenModel *md in self.secondeData) {
                if (md != second && md.shouldCheck) {
                    md.shouldCheck = NO;
                }
            }
            second.shouldCheck = YES;
            self.firstCurrentModel.shouldCheck = YES;
            self.previouSelectedModel = self.firstCurrentModel;
        }else{
            self.hasThird = YES;
            HHMenuScreenModel *second = self.secondSelectedArray.firstObject;
            second.shouldCheck = NO;
            self.firstCurrentModel.shouldCheck = NO;
        }
        NSLog(@"第三列选中的数组个数444：%d",self.thirdSelectedArray.count);
        [self reloadData];
    }
    
}

#pragma mark -- show

- (void)show {
    self.leftTableView.frame = CGRectMake(0, 0, 90, 44*8);
    if (self.thirdData.count != 0) {
        self.midTableView.backgroundColor = UIColorHex(FFFBF6);
        self.midTableView.frame = CGRectMake(90, 0, 110, 44*8);
        self.rightTableView.frame = CGRectMake(200, 0, self.frame.size.width - 200, 44*8);
    }else {
        self.midTableView.backgroundColor = kWhiteColor;
        self.midTableView.frame = CGRectMake(90, 0, kScreenWidth-90, 44*8);
        self.rightTableView.frame = CGRectMake(0, 0, 0, 0);
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

#pragma mark -- 懒加载
- (UITableView *)leftTableView {
    if (nil == _leftTableView) {
        _leftTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _leftTableView.backgroundColor = RGBColor(242, 238, 232);
        _leftTableView.bounces = NO;
        _leftTableView.tableFooterView = [[UIView alloc] init];
        _leftTableView.delegate = self;
        _leftTableView.dataSource = self;
        _leftTableView.showsVerticalScrollIndicator = NO;
        _leftTableView.showsHorizontalScrollIndicator = NO;
        _leftTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_leftTableView registerClass:[HHPositionTableViewCell class] forCellReuseIdentifier:@"HHPositionTableViewCell"];
    }
    return _leftTableView;
}

- (UITableView *)midTableView {
    
    if (nil == _midTableView) {
        _midTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _midTableView.backgroundColor = UIColorHex(FFFBF6);
        _midTableView.tableFooterView = [[UIView alloc] init];
        _midTableView.bounces = NO;
        _midTableView.delegate = self;
        _midTableView.dataSource = self;
        _midTableView.showsVerticalScrollIndicator = NO;
        _midTableView.showsHorizontalScrollIndicator = NO;
        _midTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_midTableView registerClass:[HHPositionTableViewCell class] forCellReuseIdentifier:@"HHPositionTableViewCell"];
    }
    return _midTableView;
}

- (UITableView *)rightTableView {
    if (nil == _rightTableView) {
        _rightTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _rightTableView.backgroundColor = kWhiteColor;
        _rightTableView.bounces = NO;
        _rightTableView.tableFooterView = [[UIView alloc] init];
        //        _rightTableView.separatorInset = UIEdgeInsetsZero;//距离左右0间隙
        _rightTableView.delegate = self;
        _rightTableView.dataSource = self;
        _rightTableView.showsVerticalScrollIndicator = NO;
        _rightTableView.showsHorizontalScrollIndicator = NO;
        _rightTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_rightTableView registerClass:[HHPositionTableViewCell class] forCellReuseIdentifier:@"HHPositionTableViewCell"];
    }
    return _rightTableView;
}
@end
