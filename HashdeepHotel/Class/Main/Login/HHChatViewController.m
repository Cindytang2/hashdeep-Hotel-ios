//
//  HHChatViewController.m
//  HashdeepHotel
//
//  Created by Cindy on 2022/9/21.
//

#import "HHChatViewController.h"
#import "TUIChatConversationModel.h"
#import "TUIC2CChatViewController.h"
@interface HHChatViewController ()

@end

@implementation HHChatViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self _createdNavigationBar];
    
    // 创建会话信息
    TUIChatConversationModel *data = [[TUIChatConversationModel alloc] init];
    data.userID = self.hotel_im_account;
    // 创建 TUIC2CChatViewController
    TUIC2CChatViewController *vc = [[TUIC2CChatViewController alloc] init];
    
    [vc setConversationData:data];
    vc.moreMenus = @[TUIInputMoreCellData.photoData,TUIInputMoreCellData.pictureData,TUIInputMoreCellData.videoData];
    // 把 TUIC2CChatViewController 添加到自己的 ViewController
    [self addChildViewController:vc];
    [self.view addSubview:vc.view];
    vc.view.frame = CGRectMake(0, UINavigateHeight, kScreenWidth, kScreenHeight- UINavigateHeight);
}

#pragma mark -----------------------自定义导航栏-----------------------
-(void)_createdNavigationBar {
   
   UIView *view = [[UIView alloc]init];
   view.backgroundColor = [UIColor whiteColor];
   [self.view addSubview:view];
   [view mas_makeConstraints:^(MASConstraintMaker *make) {
       make.left.right.top.mas_equalTo(self.view);
       make.height.offset(UINavigateHeight);
   }];
    
   [self createdNavigationBackButton];
    
   UILabel *titleLabel = [[UILabel alloc] init];
   titleLabel.text = self.hotelName;
   titleLabel.textColor = XLColor_mainTextColor;
   titleLabel.font = KBoldFont(18);
   titleLabel.textAlignment = NSTextAlignmentCenter;
   [self.view addSubview:titleLabel];
   [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       make.left.right.offset(0);
       make.top.offset(UINavigateTop+10);
       make.height.offset(20);
   }];
}

@end
