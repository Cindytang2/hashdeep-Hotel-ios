//
//  XLAddPhotoCollectionViewCell.m
//  linlinlin
//
//  Created by cindy on 2020/6/23.
//  Copyright © 2020 yqm. All rights reserved.
//

#import "XLAddPhotoCollectionViewCell.h"
#import "XLAddPhotoModel.h"
@implementation XLAddPhotoCollectionViewCell{
    UIImageView *playImageView;
    
}
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self _createSubviews];
    }
    return self;
}

- (void)_createSubviews {
    
    //图片
    self.imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, (kScreenWidth-60-14)/3, (kScreenWidth-60-14)/3)];
    self.imgView.layer.cornerRadius = 5;
    self.imgView.contentMode = UIViewContentModeScaleAspectFill;
    self.imgView.layer.masksToBounds = YES;
    self.imgView.userInteractionEnabled = YES;
    [self.contentView addSubview:self.imgView];
    
    playImageView = [[UIImageView alloc] init];
    playImageView.image = HHGetImage(@"icon_home_hotel_detail_play");
    playImageView.userInteractionEnabled = YES;
    [self.contentView addSubview:playImageView];
    [playImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.imgView);
        make.centerY.equalTo(self.imgView);
        make.height.width.offset(40);
    }];
    
    [self.contentView addSubview:self.deleteBtn];
    [self.deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self);
        make.right.mas_equalTo(self);
        make.width.offset(30);
        make.height.offset(30);
    }];
    
    [self.contentView addSubview:self.deleteBtn];
    [self.deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-5);
        make.top.offset(5);
        make.width.height.offset(25);
    }];
}

- (void)setModel:(XLAddPhotoModel *)model {
    _model = model;
    
    if (_model.isAdd) {
        if (_model.isVideo) {
            self.imgView.image = [UIImage imageNamed:@"ion_my_addVideo"];
            self.deleteBtn.hidden = YES;
        }else {
            self.imgView.image = [UIImage imageNamed:@"ion_my_addPhoto"];
            self.deleteBtn.hidden = YES;
        }
        playImageView.hidden = YES;
    }else{
        self.imgView.image = _model.image;
        self.deleteBtn.hidden = NO;
        if (_model.isVideo) {
            [playImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.offset(40);
            }];
            playImageView.hidden = NO;
        }else {
            playImageView.hidden = YES;
            [playImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.offset(0);
            }];
        }
    }
    
    
}

- (UIButton *)deleteBtn{
    if(!_deleteBtn){
        _deleteBtn = [[UIButton alloc]init];
        [_deleteBtn setImage:[UIImage imageNamed:@"icon_home_detail_room_close"] forState:UIControlStateNormal];
        [_deleteBtn addTarget:self action:@selector(deleteBtnClicK) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteBtn;
}

- (void)deleteBtnClicK{
    if(self.deleteBtnClickBlock){
        self.deleteBtnClickBlock(_model);
    }
}

@end
