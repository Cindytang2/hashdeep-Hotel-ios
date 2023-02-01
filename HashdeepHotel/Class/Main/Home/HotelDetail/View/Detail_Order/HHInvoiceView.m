//
//  HHInvoiceView.m
//  HashdeepHotel
//
//  Created by Cindy on 2022/12/20.
//

#import "HHInvoiceView.h"

@interface HHInvoiceView ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, strong) UILabel *detailSubLabel;
@end

@implementation HHInvoiceView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self _addSubViews];
    }
    return self;
}

- (void)_addSubViews{
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.textColor = XLColor_mainTextColor;
    self.titleLabel.font = KBoldFont(16);
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.top.offset(15);
        make.height.offset(20);
        make.width.offset(80);
    }];
    
    self.detailLabel = [[UILabel alloc] init];
    self.detailLabel.textColor = XLColor_mainTextColor;
    self.detailLabel.font = XLFont_subTextFont;
    [self addSubview:self.detailLabel];
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.mas_right).offset(0);
        make.top.offset(15);
        make.height.offset(20);
        make.right.offset(-15);
    }];
    
    self.detailSubLabel = [[UILabel alloc] init];
    self.detailSubLabel.textColor = XLColor_subTextColor;
    self.detailSubLabel.font = XLFont_subSubTextFont;
    [self addSubview:self.detailSubLabel];
    [self.detailSubLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.mas_right).offset(0);
        make.top.equalTo(self.detailLabel.mas_bottom).offset(5);
        make.height.offset(20);
        make.right.offset(-15);
    }];
}

- (void)setInvoice_info:(NSDictionary *)invoice_info {
    _invoice_info = invoice_info;
    self.titleLabel.text = _invoice_info[@"invoice_tips"];
    self.detailLabel.text = @"下单后在订单页面预约";
    self.detailSubLabel.text = _invoice_info[@"invoice_tips_desc_cap"];
    
}

@end
