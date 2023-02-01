//
//  HHConversationController.m
//  HashdeepHotel
//
//  Created by Cindy on 2022/9/21.
//

#import "HHConversationController.h"
#import "TUIConversationListController.h"
#import "HHChatViewController.h"
#import "V2TIMManager+Conversation.h"

@interface HHConversationController ()<TUIConversationListControllerListener,V2TIMConversationListener>
@property (strong, nonatomic) TUIConversationListController *convListVC;
@property (strong, nonatomic) UIView *nodataView;///缺醒页
@end

@implementation HHConversationController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = kWhiteColor;
    
    [self _createdNavigationBar];
    
    [[V2TIMManager sharedInstance] addConversationListener:self];
    
    ///取一条纯粹只是为了判断是不是有回话，没有就意味着需要加载缺醒页
    [[V2TIMManager sharedInstance] getConversationList:0 count:1 succ:^(NSArray<V2TIMConversation *> *list, uint64_t nextSeq, BOOL isFinished) {
        [self shouldAddNoDataView:list];
        
    } fail:^(int code, NSString *msg) {
        
    }];
}

- (TUIConversationListController *)convListVC {
    if(!_convListVC) {
        _convListVC = [[TUIConversationListController alloc] init];
        _convListVC.delegate = self;
        @weakify(self)
        [RACObserve(_convListVC.dataProvider, dataList) subscribeNext:^(id  _Nullable x) {
            NSLog(@"x:%@",x);
            @strongify(self)
            if([x isKindOfClass:[NSArray class]]) {
                NSArray *list = (NSArray *)x;
                [self shouldAddNoDataView:list];
            }
        }];
    }
    return _convListVC;
}
- (void)shouldAddNoDataView:(NSArray *)conversationList {
    ///在这个地方判断一下，如果conversationList.count>0移除缺醒
    if (conversationList.count > 0 ) {
        [self.nodataView removeFromSuperview];
        if (self.convListVC.parentViewController == nil) {
            [self addChildViewController:self.convListVC];
            [self.view addSubview:self.convListVC.view];
            self.convListVC.view.frame = CGRectMake(0, UINavigateHeight, kScreenWidth, kScreenHeight- UINavigateHeight);
        }
    }else{
        [self.convListVC removeFromParentViewController];
        [self.convListVC.view removeFromSuperview];
        [self.view addSubview:self.nodataView];
        [self.nodataView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.offset(0);
            make.top.bottom.offset(0);
        }];
    }
}

#pragma mark -----------------------自定义导航栏-----------------------
-(void)_createdNavigationBar {
    
    self.navigationController.navigationBar.backgroundColor = kWhiteColor;
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 25, 25);
    [backButton addTarget:self action:@selector(backButtonAction) forControlEvents:UIControlEventTouchUpInside] ;
    [backButton setImage: [UIImage imageNamed:@"icon_my_setup_back"] forState:UIControlStateNormal];
    UIBarButtonItem* barItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = barItem;
    
    self.title = @"聊天";
}

-(void)backButtonAction{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)conversationListController:(TUIConversationListController *)conversationController didSelectConversation:(TUIConversationCell *)conversation{
    
    HHChatViewController *vc = [[HHChatViewController alloc] init];
    vc.hotel_im_account = conversation.convData.userID;
    vc.hotelName = conversation.convData.title;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (UIView *)nodataView {
    if (!_nodataView) {
        _nodataView = [[UIView alloc] init];
        
        UIImageView *imgView = [[UIImageView alloc] init];
        imgView.image = HHGetImage(@"icon_home_noMessage");
        [_nodataView addSubview:imgView];
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.offset(80);
            make.height.offset(70);
            make.centerX.equalTo(_nodataView);
            make.top.offset((kScreenHeight-70-35)/2);
        }];
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.textColor = XLColor_mainTextColor;
        titleLabel.font = XLFont_mainTextFont;
        titleLabel.text = @"暂无消息";
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [_nodataView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.offset(0);
            make.height.offset(20);
            make.top.equalTo(imgView.mas_bottom).offset(15);
        }];
    }
    return _nodataView;
}


@end
