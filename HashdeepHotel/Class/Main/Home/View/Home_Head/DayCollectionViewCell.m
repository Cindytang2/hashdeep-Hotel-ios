//
//  DayCollectionViewCell.m
//  BJTResearch
//
//  Created by yunlong on 17/5/11.
//  Copyright © 2017年 yunlong. All rights reserved.
//

#import "DayCollectionViewCell.h"
#import "MonthModel.h"

@interface DayCollectionViewCell ()
@property (nonatomic, strong) UILabel *tipLabel;

@end
@implementation DayCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self _createSubviews];
    }
    return self;
}

- (void)_createSubviews {
    self.layer.cornerRadius = 8;
    self.layer.masksToBounds = YES;
    
    self.dayLabel = [[UILabel alloc] init];
    self.dayLabel.textColor = XLColor_mainTextColor;
    self.dayLabel.font = KBoldFont(14);
    self.dayLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.dayLabel];
    [self.dayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.height.offset(15);
        make.centerY.equalTo(self.contentView);
    }];
    
    self.tipLabel = [[UILabel alloc] init];
    self.tipLabel.textColor = kWhiteColor;
    self.tipLabel.font = XLFont_subSubTextFont;
    self.tipLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.tipLabel];
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.height.offset(15);
        make.top.offset(10);
    }];
    
}
    
-(void)setModel:(DayModel *)model{
    _model = model;
    if (model == nil) {
        self.dayLabel.text = @"";
        self.backgroundColor = kWhiteColor;
        self.tipLabel.hidden = YES;
    }else{
        
        self.dayLabel.text = [NSString stringWithFormat:@"%02ld",model.day];
        self.dayLabel.textColor = XLColor_mainTextColor;
        switch (model.state) {
            case DayModelStateNormal:{
                self.backgroundColor = kWhiteColor;
                self.dayLabel.textColor = XLColor_mainTextColor;
                self.alpha = 1;
                self.tipLabel.hidden = YES;
                break;
            }
            case DayModelStateStart:{
                self.backgroundColor = XLColor_mainHHTextColor;
                self.alpha = 1;
                self.dayLabel.textColor = kWhiteColor;
                self.tipLabel.text = @"入住";
                self.tipLabel.hidden = NO;
                break;
            }
            case DayModelStateEnd:{
                self.backgroundColor = XLColor_mainHHTextColor;
                self.alpha = 1;
                self.dayLabel.textColor = kWhiteColor;
                self.tipLabel.text = @"离店";
                self.tipLabel.hidden = NO;
                break;
            }
            case DayModelStateSelected:{
                self.backgroundColor = UIColorHex(FFF6E9);
                self.tipLabel.hidden = YES;
                self.dayLabel.textColor = XLColor_mainTextColor;
                break;
            }
            default:
                break;
                
        }
    }
    
}


@end
