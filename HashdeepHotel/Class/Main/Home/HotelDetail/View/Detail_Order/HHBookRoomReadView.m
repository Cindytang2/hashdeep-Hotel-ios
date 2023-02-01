//
//  HHBookRoomReadView.m
//  HashdeepHotel
//
//  Created by Cindy on 2022/7/28.
//

#import "HHBookRoomReadView.h"

@interface HHBookRoomReadView ()
@property (nonatomic, strong) UIView *whiteView;
@end

@implementation HHBookRoomReadView
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
        make.height.offset(100);
        make.bottom.offset(0);
    }];
    
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeButton setImage:HHGetImage(@"icon_home_search_close") forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(closeButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.whiteView addSubview:closeButton];
    [closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(15);
        make.right.offset(-15);
        make.top.offset(17);
    }];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"订房必读";
    titleLabel.textColor = XLColor_mainTextColor;
    titleLabel.font = KBoldFont(16);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.whiteView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.height.offset(50);
        make.top.offset(0);
    }];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = XLColor_mainColor;
    [self.whiteView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.height.offset(1);
        make.top.offset(50);
    }];
    
}
- (void)setPolicy_info:(NSArray *)policy_info {
    _policy_info = policy_info;
    
    if (_policy_info.count != 0) {
        int yBottom = 61;
        for (int i=0; i<_policy_info.count; i++) {
            NSDictionary *dic = _policy_info[i];
            CGFloat h = [LabelSize heightOfString:dic[@"desc"] font:XLFont_subSubTextFont width:kScreenWidth-20-80];
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [self.whiteView addSubview:button];
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.offset(15);
                make.top.offset(yBottom);
                make.height.offset(h+1);
                make.right.offset(-15);
            }];
         
            UILabel *leftLabel = [[UILabel alloc] init];
            leftLabel.textColor = XLColor_mainTextColor;
            leftLabel.font = XLFont_subSubTextFont;
            leftLabel.text = dic[@"title"];
            [button addSubview:leftLabel];
            [leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.offset(0);
                make.width.offset(80);
                make.top.offset(0);
                make.height.offset(15);
            }];
            
            UILabel *rightLabel = [[UILabel alloc] init];
            rightLabel.textColor = XLColor_mainTextColor;
            rightLabel.font = XLFont_subSubTextFont;
            rightLabel.text = dic[@"desc"];
            rightLabel.numberOfLines = 0;
            [button addSubview:rightLabel];
            [rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(leftLabel.mas_right).offset(0);
                make.top.bottom.offset(0);
                make.right.offset(-5);
            }];
            
            yBottom = yBottom+h+20;
        }
        
        [self.whiteView mas_updateConstraints:^(MASConstraintMaker *make) {
            
            if (UINavigateTop == 44) {
                make.height.offset(yBottom+40);
            }else {
                make.height.offset(yBottom+40);
            }
        }];
        
        if (UINavigateTop == 44) {
            [HHAppManage mq_setRect:CGRectMake(0, 0, kScreenWidth, yBottom+40) cornerRect:UIRectCornerTopLeft|UIRectCornerTopRight radius:20 view:self.whiteView];
        }else {
            [HHAppManage mq_setRect:CGRectMake(0, 0, kScreenWidth, yBottom+40) cornerRect:UIRectCornerTopLeft|UIRectCornerTopRight radius:20 view:self.whiteView];
        }
      
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

- (void)closeButtonAction {
    
    if (self.clickCloseButton) {
        self.clickCloseButton();
    }
}

@end
