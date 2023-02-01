//
//  HHGuideViewController.m
//  HashdeepHotel
//
//  Created by Cindy on 2022/7/11.
//

#import "HHGuideViewController.h"
#import <YYText/YYLabel.h>
#import <YYText/NSAttributedString+YYText.h>
#import "AppDelegate.h"
#import "HHAgreementViewController.h"
#import "HHNavigationBarViewController.h"
@interface HHGuideViewController ()
@property (nonatomic,assign) BOOL isAgree;///阅读并同意隐私政策 YES NO
@end

@implementation HHGuideViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //创建Views
    [self _createdViews];
    
    self.view.backgroundColor = XLColor_mainColor;
}

#pragma mark ---------------------创建Views---------------------
- (void)_createdViews {

    UIImageView *bgImageView = [[UIImageView alloc] init];
    bgImageView.image = HHGetImage(@"icon_guide_bg");
    bgImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:bgImageView];
    [bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.offset(0);
    }];
    
    UIView *whiteview = [[UIView alloc] init];
    whiteview.backgroundColor = kWhiteColor;
    whiteview.layer.cornerRadius = 15;
    whiteview.layer.masksToBounds = YES;
    whiteview.layer.shadowColor = kBlackColor.CGColor;
    whiteview.layer.shadowOffset = CGSizeMake(0, 0);
    whiteview.layer.shadowOpacity = 0.3;//阴影透明度，默认0
    whiteview.clipsToBounds = NO;
    whiteview.layer.shadowRadius = 3;
    [self.view addSubview:whiteview];
    [whiteview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(35);
        make.right.offset(-35);
        make.height.offset(250);
        make.centerY.equalTo(self.view);
    }];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"安住会隐私说明";
    titleLabel.font = KBoldFont(16);
    titleLabel.textColor = XLColor_mainTextColor;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [whiteview addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.right.offset(0);
        make.height.offset(20);
        make.top.offset(15);
    }];
    
    UILabel *detailLabel = [[UILabel alloc] init];
    detailLabel.text = @"尊敬的用户您好，感谢您信任并使用安住会，为了更好的给您提供服务，我们提供了《服务协议及隐私政策》。请您阅读本条款，点击后继续使用安住会。我们将会为您提供高品质安全的服务。";
    detailLabel.font = XLFont_subTextFont;
    detailLabel.textColor = XLColor_mainTextColor;
    detailLabel.numberOfLines = 0;
    [whiteview addSubview:detailLabel];
    [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.offset(-15);
        make.top.equalTo(titleLabel.mas_bottom).offset(15);
    }];
    
    UIButton *selectedButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [selectedButton setImage:HHGetImage(@"icon_login_normal") forState:UIControlStateNormal];
    [selectedButton setImage:HHGetImage(@"icon_login_selected") forState:UIControlStateSelected];
    [selectedButton addTarget:self action:@selector(selectedButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [whiteview addSubview:selectedButton];
    [selectedButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.top.equalTo(detailLabel.mas_bottom).offset(23);
        make.width.height.offset(20);
    }];
    
    NSString *textStr = @"已阅读并同意《服务协议以及隐私政策》";
    YYLabel *bottomLabel = [[YYLabel alloc] init];
    bottomLabel.textVerticalAlignment =  YYTextVerticalAlignmentTop;//垂直属性，上  下 或居中显示
    //富文本属性
    NSMutableAttributedString  *attriStr = [[NSMutableAttributedString alloc] initWithString:textStr];
    
    NSRange range1 = [textStr rangeOfString:@"已阅读并同意" options:NSCaseInsensitiveSearch];
    [attriStr yy_setLineSpacing:5 range:NSMakeRange(0, textStr.length)];
    attriStr.yy_font = XLFont_subTextFont;
    YYTextHighlight *highlight3 = [YYTextHighlight new];
    [highlight3 setColor:XLColor_mainTextColor];
    [attriStr yy_setTextHighlight:highlight3 range:range1];
    [attriStr yy_setColor:XLColor_mainTextColor range:range1];
    
    //高亮显示文本 点击交互事件
    NSRange range2 = [textStr rangeOfString:@"《服务协议以及隐私政策》" options:NSCaseInsensitiveSearch];
    [attriStr yy_setLineSpacing:5 range:NSMakeRange(0, textStr.length)];
    YYTextHighlight *highlight4 = [YYTextHighlight new];
    highlight4.tapAction = ^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect) {
        
        HHAgreementViewController *vc = [[HHAgreementViewController alloc] init];
        vc.type = @"1";
        vc.hidesBottomBarWhenPushed = YES;   //隐藏Tabbar
        HHNavigationBarViewController *navVC = [[HHNavigationBarViewController alloc] initWithRootViewController:vc];   //使登陆界面的Navigationbar可以显示出来
        navVC.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        navVC.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:navVC animated:YES completion:nil]; //跳转登陆界面
    };
    [attriStr yy_setTextHighlight:highlight4 range:range2];
    [attriStr yy_setColor:XLColor_mainHHTextColor range:range2];
    [attriStr yy_setFont:XLFont_subTextFont range:range2];
    
    CGFloat bottomLabelWidth = [LabelSize widthOfString:textStr font:XLFont_subSubTextFont height:20];
    CGSize introSize = CGSizeMake(bottomLabelWidth, CGFLOAT_MAX);
    YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:introSize text:attriStr];
    bottomLabel.textLayout = layout;
    [whiteview addSubview:bottomLabel];
    [bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(selectedButton.mas_right).offset(5);
        make.right.offset(0);
        make.top.equalTo(detailLabel.mas_bottom).offset(25);
        make.height.offset(15);
    }];
    
    UIButton *agreeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [agreeButton setTitle:@"同意" forState:UIControlStateNormal];
    [agreeButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
    agreeButton.backgroundColor = UIColorHex(b58e7f);
    agreeButton.layer.cornerRadius = 8;
    agreeButton.layer.masksToBounds = YES;
    agreeButton.titleLabel.font = XLFont_mainTextFont;
    agreeButton.layer.shadowColor = kBlackColor.CGColor;
    //shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用  (0,0)时是四周都有阴影
    agreeButton.layer.shadowOffset = CGSizeMake(0, 0);
    //阴影透明度，默认0
    agreeButton.layer.shadowOpacity = 0.3;
    //阴影半径，默认3
    agreeButton.clipsToBounds = NO;
    agreeButton.layer.shadowRadius = 3;
    [agreeButton addTarget:self action:@selector(agreeButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [whiteview addSubview:agreeButton];
    [agreeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(whiteview);
        make.width.offset(150);
        make.height.offset(36);
        make.top.equalTo(bottomLabel.mas_bottom).offset(20);
    }];
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelButton setTitle:@"拒绝" forState:UIControlStateNormal];
    [cancelButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
    cancelButton.backgroundColor = UIColorHex(49494B);
    cancelButton.layer.cornerRadius = 8;
    cancelButton.layer.masksToBounds = YES;
    cancelButton.titleLabel.font = XLFont_mainTextFont;
    cancelButton.layer.shadowColor = kBlackColor.CGColor;
    //shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用  (0,0)时是四周都有阴影
    cancelButton.layer.shadowOffset = CGSizeMake(0, 0);
    //阴影透明度，默认0
    cancelButton.layer.shadowOpacity = 0.3;
    //阴影半径，默认3
    cancelButton.clipsToBounds = NO;
    cancelButton.layer.shadowRadius = 3;
    [cancelButton addTarget:self action:@selector(cancelButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [whiteview addSubview:cancelButton];
    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(whiteview);
        make.width.offset(150);
        make.height.offset(36);
        make.top.equalTo(agreeButton.mas_bottom).offset(12);
    }];
    
    [self.view layoutIfNeeded];
    CGFloat h = CGRectGetMaxY(cancelButton.frame);
    [whiteview mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.offset(h+20);
    }];
    
}

- (void)cancelButtonAction {
    if (self.clickCancelButtonAction) {
        self.clickCancelButtonAction();
    }
    exit(0);
}

- (void)agreeButtonAction {
    if (!self.isAgree) {
        [self.view makeToast:@"请阅读并同意安住会的《服务协议以及隐私政策》" duration:1.5 position:CSToastPositionCenter];
        return;
    }
    
    if (self.clickAgreeButtonAction) {
        self.clickAgreeButtonAction();
    }
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate goMain];//进入主界面
}

- (void)selectedButtonAction:(UIButton *)button {
    button.selected = !button.selected;
    if (button.selected) {
        self.isAgree = YES;
    }else {
        self.isAgree = NO;
    }
}
@end
