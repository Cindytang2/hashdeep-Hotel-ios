//
//  HHMyViewController.m
//  HashdeepHotel
//
//  Created by Cindy on 2022/7/11.
//

#import "HHMyViewController.h"
#import "HHMyView.h"
#import "HHSetupViewController.h"
#import "HHVerificationCodeLoginViewController.h"
#import "HHNavigationBarViewController.h"
#import "HHPersonalInformationViewController.h"
#import "HHBrowseHistoryViewController.h"
#import "HHCollectionViewController.h"
#import "HHOrderViewController.h"
#import "HHFeedBackViewController.h"
#import "HHMyInvoiceViewController.h"
#import "HHMainTabBarViewController.h"
#import "HHConversationController.h"
#import "V2TIMManager+Conversation.h"
#import "HGAppInitManager.h"

@interface HHMyViewController ()<V2TIMConversationListener>
@property (nonatomic, strong) HHMyView *myView;
@end

@implementation HHMyViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"isLogin"]) {
        [self.myView.headerImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.offset(12);
        }];
   
        [self.myView.topGradLayer setColors:@[kWhiteColor,kWhiteColor]];//渐变数组
        self.myView.topWhiteView.backgroundColor = kWhiteColor;
        self.myView.gradeImageView.hidden = YES;
        self.myView.gradeLabel.hidden = YES;
        self.myView.nameLabel.text = @"注册/登录";
        CGFloat nameWidth = [LabelSize widthOfString:@"注册/登录" font:KBoldFont(20) height:20];
        [self.myView.nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.offset(25);
            make.width.offset(nameWidth+1);
        }];
        [self.myView.headerImageView sd_setImageWithURL:[NSURL URLWithString:[HashMainData shareInstance].user_head_img]];
        [self.myView.topWhiteView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset(70);
        }];
        
        [self.myView.unreadNumberLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.height.offset(0);
        }];
        
    }else {
        [self loadMyData];
        [self.myView.topGradLayer setColors:@[(id)[RGBColor(171, 217, 253) CGColor],(id)[RGBColor(233, 231, 239) CGColor]]];//渐变数组
        
        
        [self.myView.headerImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.offset(15);
        }];
        
        self.myView.gradeImageView.hidden = NO;
        self.myView.gradeLabel.hidden = NO;
        self.myView.nameLabel.text = [UserInfoManager sharedInstance].userNickName;
        CGFloat nameWidth = [LabelSize widthOfString:[UserInfoManager sharedInstance].userNickName font:KBoldFont(20) height:20];
        [self.myView.nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.offset(15);
            make.width.offset(nameWidth+1);
        }];
        [self.myView.headerImageView sd_setImageWithURL:[NSURL URLWithString:[UserInfoManager sharedInstance].headImageStr]];
        [self.myView.topWhiteView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset(260);
        }];
    }
    self.navigationController.navigationBar.hidden = YES;
    [[V2TIMManager sharedInstance] addConversationListener:self];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)onConversationChanged:(NSArray<V2TIMConversation*> *) conversationList {
    [[V2TIMManager sharedInstance]getTotalUnreadMessageCount:^(UInt64 totalCount) {
        NSLog(@"未读数总数：%llu",totalCount);
        if(totalCount == 0){
            [self.myView.unreadNumberLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.height.offset(0);
            }];
        }else {
            self.myView.unreadNumberLabel.text = [NSString stringWithFormat:@"%llu",totalCount];
            
            [self.myView.unreadNumberLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.height.offset(14);
            }];
        }
        
    } fail:^(int code, NSString *desc) {
        
    }];
}

- (void)onTotalUnreadMessageCountChanged:(UInt64)totalUnreadCount{
    NSLog(@"未读数总数111：%llu",totalUnreadCount);
    if(totalUnreadCount == 0){
        [self.myView.unreadNumberLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.height.offset(0);
        }];
    }else {
        self.myView.unreadNumberLabel.text = [NSString stringWithFormat:@"%llu",totalUnreadCount];
        
        [self.myView.unreadNumberLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.height.offset(14);
        }];
    }
    
}

#pragma mark --------- 重新登录通知方法 ------
- (void)againLoginNotification:(NSNotification *)aNotification{
    [self login];
}

- (void)loadMyData {
    NSString *url = [NSString stringWithFormat:@"%@/member/info",BASE_URL];
    
    [PPHTTPRequest requestGetWithURL:url parameters:@{} success:^(id  _Nonnull response) {
        
        NSString *code = [NSString stringWithFormat:@"%@", response[@"code"]];
        if ([code isEqualToString:@"0"]) {//请求成功
            NSDictionary *data = response[@"data"];
            [self.myView updateUIForData:data];
            NSLog(@"会员========%@",response);
        } else {
            [self.view makeToast:response[@"msg"] duration:2 position:CSToastPositionCenter];
        }
        
    } failure:^(NSError * _Nonnull error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view makeToast:@"网络异常，请检查网络后重试" duration:2 position:CSToastPositionCenter];
        });
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //监听重新登录的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(againLoginNotification:) name:@"againLogin" object:nil];
    
    self.myView = [[HHMyView alloc] init];
    self.myView.backgroundColor = XLColor_mainColor;
    [self.view addSubview:self.myView];
    [self.myView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.bottom.offset(0);
    }];
    
    
    
    WeakSelf(weakSelf)
    //消息
    self.myView.clickNoticeButtonAction = ^{
        if (![[NSUserDefaults standardUserDefaults] boolForKey:@"isLogin"]) {
            [weakSelf login];
        }else {
            HHConversationController *vc = [[HHConversationController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }
    };
    
    //设置
    self.myView.clickSetupButtonAction = ^{
        HHSetupViewController *vc = [[HHSetupViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    
    //资料编辑
    self.myView.clickGoinftButtonAction = ^{
        if (![[NSUserDefaults standardUserDefaults] boolForKey:@"isLogin"]) {
            [weakSelf login];
        }else {
            HHPersonalInformationViewController *vc = [[HHPersonalInformationViewController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }
    };
    
    //全部订单  待支付  待入住  待评价
    self.myView.clickCenterButtonAction = ^(NSInteger tag) {
        if (![[NSUserDefaults standardUserDefaults] boolForKey:@"isLogin"]) {
            [UMCommonHandler checkEnvAvailableWithAuthType:UMPNSAuthTypeLoginToken complete:^(NSDictionary*_Nullable resultDic){
                BOOL isSupport =[PNSCodeSuccess isEqualToString:[resultDic objectForKey:@"resultCode"]];
                if(isSupport) {
                    [HGAppInitManager umQuickPhoneLoginVC:weakSelf complete:^(NSString * quickLoginStutas) {
                        
                    }];
                    
                }else {
                    HHVerificationCodeLoginViewController *loginVC = [[HHVerificationCodeLoginViewController alloc] init];
                    loginVC.loginSuccessAction = ^{
                        [weakSelf goOrderVC:tag];
                    };
                    loginVC.hidesBottomBarWhenPushed = YES;
                    UINavigationController *loginNav = [[UINavigationController alloc] initWithRootViewController:loginVC];
                    loginNav.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
                    loginNav.modalPresentationStyle = UIModalPresentationFullScreen;
                    [weakSelf presentViewController:loginNav animated:YES completion:nil];
                }
            }];
        }else {
            [weakSelf goOrderVC:tag];
        }
    };
    
    //收藏  最近浏览  意见反馈 我的发票  在线客服
    self.myView.clickBottomButtonAction = ^(NSInteger tag) {
        if (tag == 0) {
            if (![[NSUserDefaults standardUserDefaults] boolForKey:@"isLogin"]) {
                [UMCommonHandler checkEnvAvailableWithAuthType:UMPNSAuthTypeLoginToken complete:^(NSDictionary*_Nullable resultDic){
                    BOOL isSupport =[PNSCodeSuccess isEqualToString:[resultDic objectForKey:@"resultCode"]];
                    if(isSupport) {
                        [HGAppInitManager umQuickPhoneLoginVC:weakSelf complete:^(NSString * quickLoginStutas) {
                            
                        }];
                        
                    }else {
                        HHVerificationCodeLoginViewController *loginVC = [[HHVerificationCodeLoginViewController alloc] init];
                        loginVC.loginSuccessAction = ^{
                            HHCollectionViewController *vc = [[HHCollectionViewController alloc] init];
                            vc.hidesBottomBarWhenPushed = YES;
                            [weakSelf.navigationController pushViewController:vc animated:YES];
                        };
                        loginVC.hidesBottomBarWhenPushed = YES;
                        UINavigationController *loginNav = [[UINavigationController alloc] initWithRootViewController:loginVC];
                        loginNav.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
                        loginNav.modalPresentationStyle = UIModalPresentationFullScreen;
                        [weakSelf presentViewController:loginNav animated:YES completion:nil];
                    }
                }];
            }else {
                HHCollectionViewController *vc = [[HHCollectionViewController alloc] init];
                vc.hidesBottomBarWhenPushed = YES;
                [weakSelf.navigationController pushViewController:vc animated:YES];
            }
            
        }else if(tag == 1){
            if (![[NSUserDefaults standardUserDefaults] boolForKey:@"isLogin"]) {
                [UMCommonHandler checkEnvAvailableWithAuthType:UMPNSAuthTypeLoginToken complete:^(NSDictionary*_Nullable resultDic){
                    BOOL isSupport =[PNSCodeSuccess isEqualToString:[resultDic objectForKey:@"resultCode"]];
                    if(isSupport) {
                        [HGAppInitManager umQuickPhoneLoginVC:weakSelf complete:^(NSString * quickLoginStutas) {
                            
                        }];
                        
                    }else {
                        HHVerificationCodeLoginViewController *loginVC = [[HHVerificationCodeLoginViewController alloc] init];
                        loginVC.loginSuccessAction = ^{
                            HHBrowseHistoryViewController *vc = [[HHBrowseHistoryViewController alloc] init];
                            vc.hidesBottomBarWhenPushed = YES;
                            [weakSelf.navigationController pushViewController:vc animated:YES];
                        };
                        loginVC.hidesBottomBarWhenPushed = YES;
                        UINavigationController *loginNav = [[UINavigationController alloc] initWithRootViewController:loginVC];
                        loginNav.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
                        loginNav.modalPresentationStyle = UIModalPresentationFullScreen;
                        [weakSelf presentViewController:loginNav animated:YES completion:nil];
                    }
                }];
            }else {
                HHBrowseHistoryViewController *vc = [[HHBrowseHistoryViewController alloc] init];
                vc.hidesBottomBarWhenPushed = YES;
                [weakSelf.navigationController pushViewController:vc animated:YES];
            }
        }else if(tag == 2){
            HHFeedBackViewController *vc = [[HHFeedBackViewController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }else if(tag == 3){
            HHMyInvoiceViewController *vc = [[HHMyInvoiceViewController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }else {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                NSString *str = [NSString stringWithFormat:@"telprompt://%@",[HashMainData shareInstance].tel];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str] options:nil completionHandler:^(BOOL success) {
                    
                }];
            });
        }
    };
    
    [[V2TIMManager sharedInstance] addConversationListener:self];
    [[V2TIMManager sharedInstance] getTotalUnreadMessageCount:^(UInt64 totalCount) {
        if(totalCount == 0){
            [self.myView.unreadNumberLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.height.offset(0);
            }];
        }else {
            self.myView.unreadNumberLabel.text = [NSString stringWithFormat:@"%llu",totalCount];
            
            [self.myView.unreadNumberLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.height.offset(14);
            }];
        }
    } fail:^(int code, NSString *desc) {
        
    }];
}

- (void)goOrderVC:(NSInteger )tag {
    HHOrderViewController *vc = [[HHOrderViewController alloc] init];
    vc.index = tag;
    if (tag == 0) {
        vc.order_status = @"";
    }else if(tag == 1){
        vc.order_status = @"1";
    }else if(tag == 2){
        vc.order_status = @"3";
    }else if(tag == 3){
        vc.order_status = @"5";
    }
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)login {
    WeakSelf(weakSelf)
    [UMCommonHandler checkEnvAvailableWithAuthType:UMPNSAuthTypeLoginToken complete:^(NSDictionary*_Nullable resultDic){
        BOOL isSupport =[PNSCodeSuccess isEqualToString:[resultDic objectForKey:@"resultCode"]];
        if(isSupport) {
            [HGAppInitManager umQuickPhoneLoginVC:weakSelf complete:^(NSString * quickLoginStutas) {
                
            }];
            
        }else {
            HHVerificationCodeLoginViewController *loginVC = [[HHVerificationCodeLoginViewController alloc] init];
            loginVC.loginSuccessAction = ^{
                weakSelf.tabBarController.selectedIndex = 2;
                weakSelf.myView.nameLabel.text = [UserInfoManager sharedInstance].userNickName;
                [weakSelf.myView.headerImageView sd_setImageWithURL:[NSURL URLWithString:[UserInfoManager sharedInstance].headImageStr] placeholderImage:HHGetImage(@"icon_my_head")];
                [weakSelf.myView.topWhiteView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.offset(70);
                }];
            };
            loginVC.hidesBottomBarWhenPushed = YES;
            HHNavigationBarViewController *loginNav = [[HHNavigationBarViewController alloc] initWithRootViewController:loginVC];
            loginNav.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
            loginNav.modalPresentationStyle = UIModalPresentationFullScreen;
            [weakSelf presentViewController:loginNav animated:YES completion:nil];
        }
    }];
}

@end
