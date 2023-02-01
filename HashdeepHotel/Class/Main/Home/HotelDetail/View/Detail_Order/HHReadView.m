//
//  HHReadView.m
//  HashdeepHotel
//
//  Created by Cindy on 2022/12/20.
//

#import "HHReadView.h"
@interface HHReadView ()
@property (nonatomic, strong) UIView *detailView;
@end

@implementation HHReadView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self _addSubViews];
    }
    return self;
}

- (void)_addSubViews{
    UILabel *readLabel = [[UILabel alloc] init];
    readLabel.textColor = XLColor_mainTextColor;
    readLabel.text = @"订房必读";
    readLabel.font = KBoldFont(14);
    [self addSubview:readLabel];
    [readLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.top.offset(10);
        make.height.offset(20);
        make.right.offset(-100);
    }];
    
    UIImageView *seeDetailGetIntoImgView = [[UIImageView alloc] init];
    seeDetailGetIntoImgView.image = HHGetImage(@"icon_my_getInto_right");
    [self addSubview:seeDetailGetIntoImgView];
    [seeDetailGetIntoImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-15);
        make.top.offset(15);
        make.width.offset(6);
        make.height.offset(11);
    }];
    
    UILabel *seeDetailLabel = [[UILabel alloc] init];
    seeDetailLabel.textColor = UIColorHex(b58e7f);
    seeDetailLabel.font = XLFont_subSubTextFont;
    seeDetailLabel.textAlignment = NSTextAlignmentRight;
    seeDetailLabel.text = @"查看详情";
    [self addSubview:seeDetailLabel];
    [seeDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-30);
        make.top.offset(10);
        make.height.offset(20);
    }];
    
    UIButton *bookRoomReadButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [bookRoomReadButton addTarget:self action:@selector(bookRoomReadButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:bookRoomReadButton];
    [bookRoomReadButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(0);
        make.top.offset(0);
        make.height.offset(40);
        make.width.offset(100);
    }];
    
    self.detailView = [[UIView alloc] init];
    [self addSubview:self.detailView];
    [self.detailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.equalTo(readLabel.mas_bottom).offset(0);
        make.height.offset(0);
    }];
}

- (CGFloat)updateDetailSubViews:(NSArray *)policy_info{
    CGFloat h = 0;
    if (policy_info.count != 0) {
        int yBottom = 10;
        for (int i=0; i<policy_info.count; i++) {
            NSDictionary *dic = policy_info[i];
            if(i == 3){
                break;
            }
            UILabel *label = [[UILabel alloc] init];
            label.textColor = XLColor_mainTextColor;
            label.font = XLFont_subSubTextFont;
            label.text = [NSString stringWithFormat:@"·%@", dic[@"desc"]];
            [self.detailView addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.offset(15);
                make.right.offset(-15);
                make.top.offset(yBottom);
                make.height.offset(15);
            }];
            
            yBottom = yBottom+22;
        }
        [self.detailView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset(yBottom+10);
        }];
        
        [self layoutIfNeeded];
        h = CGRectGetMaxY(self.detailView.frame);
    }else {
        h = 0;
    }
    return h;
}

- (void)bookRoomReadButtonAction:(UIButton *)button {
    button.enabled = NO;
    if (self.clickBookRoomReadAction) {
        self.clickBookRoomReadAction(button);
    }
}

@end
