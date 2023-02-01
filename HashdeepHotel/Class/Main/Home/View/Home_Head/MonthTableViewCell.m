
//
//  MonthTableViewCell.m
//  BJTResearch
//
//  Created by yunlong on 17/5/12.
//  Copyright © 2017年 yunlong. All rights reserved.
//

#import "MonthTableViewCell.h"
#import "MonthModel.h"
#import "DayCollectionViewCell.h"

@interface MonthTableViewCell ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UILabel *dateLabel;
@end
@implementation MonthTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self _createdViews];
    }
    return self;
}

- (void)_createdViews{
    self.dateLabel = [[UILabel alloc] init];
    self.dateLabel.textColor = XLColor_mainTextColor;
    self.dateLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightHeavy];
    [self.contentView addSubview:self.dateLabel];
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.offset(-15);
        make.top.offset(0);
        make.height.offset(60);
    }];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.minimumLineSpacing = 3;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.sectionInset = UIEdgeInsetsMake(3, 3, 3, 3);
    flowLayout.itemSize = CGSizeMake((kScreenWidth-21)/7, 70);
    
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.bounces = NO;
    self.collectionView.scrollEnabled = NO;
    self.collectionView.backgroundColor = kWhiteColor;
    [self.collectionView registerClass:[DayCollectionViewCell class] forCellWithReuseIdentifier:@"DayCollectionViewCellID"];
    [self.contentView addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.equalTo(self.dateLabel.mas_bottom).offset(0);
        make.bottom.offset(3);
    }];
}

#pragma mark - 设置内容
- (void)setModel:(MonthModel *)model{
    _model = model;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        CGRect frame = self.collectionView.frame;
        frame.size.height = model.cellHight - 70;
        self.collectionView.frame = frame;
    });
    self.dateLabel.text = [NSString stringWithFormat:@"%04ld年%02ld月",model.year ,model.month];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.collectionView reloadData];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _model.cellNum;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    DayCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DayCollectionViewCellID" forIndexPath:indexPath];
    
    if ((indexPath.row < _model.cellStartNum) || (indexPath.row >= (_model.days.count + _model.cellStartNum))) {
        cell.model = nil;
    }else{
        DayModel *model = _model.days[indexPath.row - _model.cellStartNum];
        cell.model = model;
        if (model.state == DayModelStateUnSelected) {
            cell.userInteractionEnabled = NO;
            cell.backgroundColor = kWhiteColor;
            cell.dayLabel.textColor = RGBColor(142, 142, 144);
        }else{
            cell.userInteractionEnabled = YES;
        }
    }
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if ((indexPath.row < _model.cellStartNum) || (indexPath.row >= (_model.days.count + _model.cellStartNum))) {
        return;
    }else{
        DayModel *model = _model.days[indexPath.row - _model.cellStartNum];
        if (self.selectedDay) {
            self.selectedDay(model);
        }
    }
}

@end
