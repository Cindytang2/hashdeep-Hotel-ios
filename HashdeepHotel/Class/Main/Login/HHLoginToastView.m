//
//  HHLoginToastView.m
//  HashdeepHotel
//
//  Created by Cindy on 2022/11/23.
//

#import "HHLoginToastView.h"
#import <YYText/YYLabel.h>
#import <YYText/NSAttributedString+YYText.h>

@interface HHLoginToastView ()
@property (nonatomic, strong) UIView *whiteView;

@end
@implementation HHLoginToastView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self _createdViews];
    }
    return self;
}
- (void)_createdViews {
    
    self.whiteView = [[UIView alloc] init];
    self.whiteView.backgroundColor = kWhiteColor;
    self.whiteView.layer.cornerRadius = 15;
    self.whiteView.layer.masksToBounds = YES;
    [self addSubview:self.whiteView];
    [self.whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.width.offset(280);
        make.height.offset(165);
        make.top.offset((kScreenHeight-165)/2);
    }];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"服务协议与隐私政策";
    titleLabel.textColor = XLColor_mainTextColor;
    titleLabel.font = KBoldFont(16);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.whiteView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.offset(0);
        make.height.offset(50);
    }];
    
    UILabel *subTitleLabel = [[UILabel alloc] init];
    subTitleLabel.text = @"为了更好保护您的合法权益，请您先阅读";
    subTitleLabel.textColor = XLColor_mainTextColor;
    subTitleLabel.font = XLFont_subTextFont;
    subTitleLabel.textAlignment = NSTextAlignmentCenter;
    [self.whiteView addSubview:subTitleLabel];
    [subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.height.offset(20);
        make.right.offset(-10);
        make.top.equalTo(titleLabel.mas_bottom).offset(0);
    }];
    
    
    NSString *textStr = @"并同意《服务协议》以及《隐私政策》";
    YYLabel *bottomLabel = [[YYLabel alloc] init];
    bottomLabel.textVerticalAlignment =  YYTextVerticalAlignmentTop;//垂直属性，上  下 或居中显示
    //富文本属性
    NSMutableAttributedString  *attriStr = [[NSMutableAttributedString alloc] initWithString:textStr];
    
    NSRange range1 = [textStr rangeOfString:@"并同意" options:NSCaseInsensitiveSearch];
    [attriStr yy_setLineSpacing:5 range:NSMakeRange(0, textStr.length)];
    attriStr.yy_font = XLFont_subTextFont;
    YYTextHighlight *highlight1 = [YYTextHighlight new];
    [highlight1 setColor:XLColor_mainTextColor];
    [attriStr yy_setTextHighlight:highlight1 range:range1];
    [attriStr yy_setColor:XLColor_mainTextColor range:range1];
    
    //高亮显示文本 点击交互事件
    NSRange range2 = [textStr rangeOfString:@"《服务协议》" options:NSCaseInsensitiveSearch];
    [attriStr yy_setLineSpacing:5 range:NSMakeRange(0, textStr.length)];
    YYTextHighlight *highlight2 = [YYTextHighlight new];
    highlight2.tapAction = ^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect) {
        if (self.clickServiceAgreementAction) {
            self.clickServiceAgreementAction();
        }
        
    };
    [attriStr yy_setTextHighlight:highlight2 range:range2];
    [attriStr yy_setColor:XLColor_mainHHTextColor range:range2];
    [attriStr yy_setFont:XLFont_subTextFont range:range2];
    
    
    NSRange range3 = [textStr rangeOfString:@"以及" options:NSCaseInsensitiveSearch];
    [attriStr yy_setLineSpacing:5 range:NSMakeRange(0, textStr.length)];
    attriStr.yy_font = XLFont_subTextFont;
    YYTextHighlight *highlight3 = [YYTextHighlight new];
    [highlight3 setColor:XLColor_mainTextColor];
    [attriStr yy_setTextHighlight:highlight3 range:range3];
    [attriStr yy_setColor:XLColor_mainTextColor range:range3];
    
    //高亮显示文本 点击交互事件
    NSRange range4 = [textStr rangeOfString:@"《隐私政策》" options:NSCaseInsensitiveSearch];
    [attriStr yy_setLineSpacing:5 range:NSMakeRange(0, textStr.length)];
    YYTextHighlight *highlight4 = [YYTextHighlight new];
    highlight4.tapAction = ^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect) {
        if (self.clickPrivacyAgreementAction) {
            self.clickPrivacyAgreementAction();
        }
        
    };
    [attriStr yy_setTextHighlight:highlight4 range:range4];
    [attriStr yy_setColor:XLColor_mainHHTextColor range:range4];
    [attriStr yy_setFont:XLFont_subTextFont range:range4];
    
    CGFloat bottomLabelWidth = [LabelSize widthOfString:textStr font:XLFont_subSubTextFont height:20];
    CGSize introSize = CGSizeMake(bottomLabelWidth, CGFLOAT_MAX);
    YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:introSize text:attriStr];
    bottomLabel.textLayout = layout;
    [self.whiteView addSubview:bottomLabel];
    [bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.right.offset(-10);
        make.top.equalTo(subTitleLabel.mas_bottom).offset(5);
        make.height.offset(15);
    }];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.backgroundColor = XLColor_mainColor;
    [backButton setTitle:@"取消" forState:UIControlStateNormal];
    [backButton setTitleColor:XLColor_subTextColor forState:UIControlStateNormal];
    backButton.titleLabel.font = KBoldFont(14);
    [backButton addTarget:self action:@selector(backButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.whiteView addSubview:backButton];
    [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.offset(0);
        make.height.offset(45);
        make.width.offset(280/2);
    }];
    
    UIButton *againButton = [UIButton buttonWithType:UIButtonTypeCustom];
    againButton.backgroundColor = UIColorHex(b58e7f);
    [againButton setTitle:@"同意" forState:UIControlStateNormal];
    [againButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
    againButton.titleLabel.font = KBoldFont(14);
    [againButton addTarget:self action:@selector(againButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.whiteView addSubview:againButton];
    [againButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.offset(0);
        make.height.offset(45);
        make.width.offset(280/2);
    }];
    
}

- (void)againButtonAction {
    
    if(self.clickAgainAction){
        self.clickAgainAction();
    }
}

- (void)backButtonAction {
    
    if(self.clickCloseButton){
        self.clickCloseButton();
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
