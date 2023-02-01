//
//  HHPriceInfoView.m
//  HashdeepHotel
//
//  Created by Cindy on 2022/11/26.
//

#import "HHPriceInfoView.h"

@interface HHPriceInfoView ()
@property (nonatomic, strong) UIView *whiteView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *numberLabel;
@property (nonatomic, strong) UILabel *roomPriceLabel;
@property (nonatomic, strong) UILabel *roomPriceResultLabel;
@property (nonatomic, strong) UIView *priceView;

@end
@implementation HHPriceInfoView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self _addSubViews];
    }
    return self;
}

- (void)_addSubViews{
    
    self.whiteView = [[UIView alloc] init];
    self.whiteView.backgroundColor = kWhiteColor;
    [self addSubview:self.whiteView];
    [self.whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.height.offset(200);
        make.bottom.offset(0);
    }];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.text = @"在线支付";
    self.titleLabel.textColor = XLColor_mainTextColor;
    self.titleLabel.font = KBoldFont(16);
    [self.whiteView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.top.offset(15);
        make.height.offset(20);
        make.width.offset(80);
    }];
    
    self.priceLabel = [[UILabel alloc] init];
    self.priceLabel.font = KBoldFont(16);
    self.priceLabel.textColor = UIColorHex(FF7E67);
    self.priceLabel.textAlignment = NSTextAlignmentRight;
    [self.whiteView addSubview:self.priceLabel];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(15);
        make.right.offset(-15);
        make.height.offset(20);
    }];
    
    self.numberLabel = [[UILabel alloc] init];
    self.numberLabel.textColor = XLColor_mainTextColor;
    self.numberLabel.font = KBoldFont(16);
    self.numberLabel.textAlignment = NSTextAlignmentRight;
    [self.whiteView addSubview:self.numberLabel];
    [self.numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.priceLabel.mas_left).offset(-10);
        make.top.offset(15);
        make.height.offset(20);
    }];
        
    UIView *priceBottomLineView = [[UIView alloc] init];
    priceBottomLineView.backgroundColor = XLColor_mainColor;
    [self.whiteView addSubview:priceBottomLineView];
    [priceBottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.offset(-15);
        make.height.offset(1);
        make.top.offset(50);
    }];
    
    self.roomPriceLabel = [[UILabel alloc] init];
    self.roomPriceLabel.text = @"房费";
    self.roomPriceLabel.textColor = XLColor_mainTextColor;
    self.roomPriceLabel.font = KBoldFont(14);
    [self.whiteView addSubview:self.roomPriceLabel];
    [self.roomPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.top.offset(51);
        make.height.offset(50);
    }];
    
    self.roomPriceResultLabel = [[UILabel alloc] init];
    self.roomPriceResultLabel.textColor = XLColor_mainTextColor;
    self.roomPriceResultLabel.font = KBoldFont(16);
    self.roomPriceResultLabel.textAlignment = NSTextAlignmentRight;
    [self.whiteView addSubview:self.roomPriceResultLabel];
    [self.roomPriceResultLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-15);
        make.top.offset(51);
        make.height.offset(50);
    }];
    
    self.priceView = [[UIView alloc] init];
    [self.whiteView addSubview:self.priceView];
    [self.priceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.equalTo(self.roomPriceLabel.mas_bottom).offset(0);
        make.height.offset(50);
    }];
    
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

- (void)setData:(NSDictionary *)data {
    _data = data;
    
    NSDictionary *payment_info = _data[@"payment_info"];
    self.titleLabel.text = @"在线支付";
    self.numberLabel.text = payment_info[@"room_info_desc"];
    self.priceLabel.text = payment_info[@"payment_price"];
    self.roomPriceLabel.text = @"房费";
    self.roomPriceResultLabel.text = payment_info[@"total_price"];
    
    NSArray *payment_map = payment_info[@"payment_map"];
    if (payment_map.count != 0) {
        int ybottom = 0;
        for (int i=0; i<payment_map.count; i++) {
            NSDictionary *dic = payment_map[i];
          
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [self.priceView addSubview:button];
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.offset(15);
                make.top.offset(ybottom);
                make.height.offset(20);
                make.right.offset(-15);
            }];
         
            UILabel *leftLabel = [[UILabel alloc] init];
            leftLabel.textColor = XLColor_mainTextColor;
            leftLabel.font = XLFont_subSubTextFont;
            leftLabel.text = dic[@"desc"];
            [button addSubview:leftLabel];
            [leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.offset(0);
                make.centerY.equalTo(button);
                make.height.offset(15);
            }];
            
            UILabel *rightLabel = [[UILabel alloc] init];
            rightLabel.textColor = XLColor_mainTextColor;
            rightLabel.font = XLFont_subSubTextFont;
            rightLabel.text = dic[@"price_text"];
            rightLabel.textAlignment = NSTextAlignmentRight;
            [button addSubview:rightLabel];
            [rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.offset(0);
                make.centerY.equalTo(button);
                make.height.offset(15);
            }];
            
            ybottom = ybottom+20;
        }
        
        [self.priceView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset(ybottom-10);
        }];
        
        if(self.isBackstage){
            
            UILabel *yifuLabel = [[UILabel alloc] init];
            yifuLabel.text = payment_info[@"paid_price_desc"];
            yifuLabel.textColor = XLColor_mainTextColor;
            yifuLabel.font = KBoldFont(14);
            [self.priceView addSubview:yifuLabel];
            [yifuLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.offset(15);
                make.top.offset(ybottom+10);
                make.height.offset(20);
                make.width.offset(60);
            }];
            
            UILabel *yifuResultLabel = [[UILabel alloc] init];
            yifuResultLabel.text = payment_info[@"paid_price"];
            yifuResultLabel.textColor = XLColor_mainTextColor;
            yifuResultLabel.font =  KBoldFont(14);;
            yifuResultLabel.textAlignment = NSTextAlignmentRight;
            [self.priceView addSubview:yifuResultLabel];
            [yifuResultLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.offset(-15);
                make.top.offset(ybottom+10);
                make.height.offset(20);
                make.width.offset(60);
            }];
            
            UILabel *yifuBottomLabel = [[UILabel alloc] init];
            yifuBottomLabel.text = payment_info[@"remain_desc"];
            yifuBottomLabel.textColor = XLColor_mainTextColor;
            yifuBottomLabel.font = KBoldFont(14);
            [self.priceView addSubview:yifuBottomLabel];
            [yifuBottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.offset(15);
                make.top.offset(ybottom+30);
                make.height.offset(20);
                make.width.offset(60);
            }];
            
            UILabel *yifuBottomResultLabel = [[UILabel alloc] init];
            yifuBottomResultLabel.text = payment_info[@"remain_price"];
            yifuBottomResultLabel.textColor = UIColorHex(FF7E67);
            yifuBottomResultLabel.font =  KBoldFont(14);;
            yifuBottomResultLabel.textAlignment = NSTextAlignmentRight;
            [self.priceView addSubview:yifuBottomResultLabel];
            [yifuBottomResultLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.offset(-15);
                make.top.offset(ybottom+30);
                make.height.offset(20);
                make.width.offset(60);
            }];
            
            
            [self.priceView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.offset(ybottom+60);
            }];
        }
        
    }
    
    [self layoutIfNeeded];
    CGFloat h2 = CGRectGetMaxY(self.priceView.frame);
    
    [self.whiteView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.offset(h2+15);
    }];
    
    [HHAppManage mq_setRect:CGRectMake(0, 0, kScreenWidth, h2+15) cornerRect:UIRectCornerTopLeft|UIRectCornerTopRight radius:20 view:self.whiteView];
}

- (CGFloat )priceInfoHeight {
    [self layoutIfNeeded];
    CGFloat h2 = CGRectGetMaxY(self.priceView.frame);
    return h2+15;
}

- (void)updataUI:(NSDictionary *)data withRoomNumber:(NSInteger)roomNumber{
    
    NSDictionary *payment_info = data[@"payment_info"];
    self.numberLabel.text = payment_info[@"room_info_desc"];
    self.priceLabel.text = payment_info[@"payment_price"];
    self.roomPriceResultLabel.text = payment_info[@"total_price"];
    
    for (UIView *view in self.priceView.subviews) {
        [view removeFromSuperview];
    }
    
    NSArray *payment_map = payment_info[@"payment_map"];
    if (payment_map.count != 0) {
        int ybottom = 0;
        for (int i=0; i<payment_map.count; i++) {
            NSDictionary *dic = payment_map[i];
          
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [self.priceView addSubview:button];
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.offset(15);
                make.top.offset(ybottom);
                make.height.offset(20);
                make.right.offset(-15);
            }];
         
            UILabel *leftLabel = [[UILabel alloc] init];
            leftLabel.textColor = XLColor_mainTextColor;
            leftLabel.font = XLFont_subSubTextFont;
            leftLabel.text = dic[@"desc"];
            [button addSubview:leftLabel];
            [leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.offset(0);
                make.centerY.equalTo(button);
                make.height.offset(15);
            }];
            
            UILabel *rightLabel = [[UILabel alloc] init];
            rightLabel.textColor = XLColor_mainTextColor;
            rightLabel.font = XLFont_subSubTextFont;
            rightLabel.text = dic[@"price_text"];
            rightLabel.textAlignment = NSTextAlignmentRight;
            [button addSubview:rightLabel];
            [rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.offset(0);
                make.centerY.equalTo(button);
                make.height.offset(15);
            }];
            
            ybottom = ybottom+20;
        }
        
        [self.priceView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset(ybottom-10);
        }];
        
        if(self.isBackstage){
            
            UILabel *yifuLabel = [[UILabel alloc] init];
            yifuLabel.text = payment_info[@"paid_price_desc"];
            yifuLabel.textColor = XLColor_mainTextColor;
            yifuLabel.font = KBoldFont(14);
            [self.priceView addSubview:yifuLabel];
            [yifuLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.offset(15);
                make.top.offset(ybottom+10);
                make.height.offset(20);
                make.width.offset(60);
            }];
            
            UILabel *yifuResultLabel = [[UILabel alloc] init];
            yifuResultLabel.text = payment_info[@"paid_price"];
            yifuResultLabel.textColor = XLColor_mainTextColor;
            yifuResultLabel.font =  KBoldFont(14);;
            yifuResultLabel.textAlignment = NSTextAlignmentRight;
            [self.priceView addSubview:yifuResultLabel];
            [yifuResultLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.offset(-15);
                make.top.offset(ybottom+10);
                make.height.offset(20);
                make.width.offset(60);
            }];
            
            UILabel *yifuBottomLabel = [[UILabel alloc] init];
            yifuBottomLabel.text = payment_info[@"remain_desc"];
            yifuBottomLabel.textColor = XLColor_mainTextColor;
            yifuBottomLabel.font = KBoldFont(14);
            [self.priceView addSubview:yifuBottomLabel];
            [yifuBottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.offset(15);
                make.top.offset(ybottom+30);
                make.height.offset(20);
                make.width.offset(60);
            }];
            
            UILabel *yifuBottomResultLabel = [[UILabel alloc] init];
            yifuBottomResultLabel.text = payment_info[@"remain_price"];
            yifuBottomResultLabel.textColor = UIColorHex(FF7E67);
            yifuBottomResultLabel.font =  KBoldFont(14);;
            yifuBottomResultLabel.textAlignment = NSTextAlignmentRight;
            [self.priceView addSubview:yifuBottomResultLabel];
            [yifuBottomResultLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.offset(-15);
                make.top.offset(ybottom+30);
                make.height.offset(20);
                make.width.offset(60);
            }];
            
            [self.priceView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.offset(ybottom+60);
            }];
        }
        
    }
    
    [self layoutIfNeeded];
    CGFloat h2 = CGRectGetMaxY(self.priceView.frame);
    
    [self.whiteView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.offset(h2+15);
    }];
    
    [HHAppManage mq_setRect:CGRectMake(0, 0, kScreenWidth, h2+15) cornerRect:UIRectCornerTopLeft|UIRectCornerTopRight radius:20 view:self.whiteView];
    
   
}



@end
