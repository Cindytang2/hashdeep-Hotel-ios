//
//  HHSetupViewController.m
//  HashdeepHotel
//
//  Created by Cindy on 2022/7/12.
//

#import "HHSetupViewController.h"
#import "HHSetupTableViewCell.h"
#import "HHAccountSetupViewController.h"
#import "HHPrivacySetupViewController.h"
#import "HHSystemSetupViewController.h"
#import "HHAboutViewController.h"
#import "HHCancellationViewController.h"
#import "HHVerificationCodeLoginViewController.h"
#import "HHNavigationBarViewController.h"
@interface HHSetupViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation HHSetupViewController
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
    NSArray *oneArray = @[@"账户设置"];
    NSArray *twoArray = @[@"隐私设置", @"系统设置"];
    NSArray *threeArray = @[@"注销账户", @"关于APP"];
    self.dataArray = @[oneArray,twoArray,threeArray];
    
    self.view.backgroundColor = RGBColor(243, 244, 247);
    
    //自定义导航栏
    [self _createdNavigationBar];
    
    //创建Views
    [self _createdViews];
}

#pragma mark -----------------------自定义导航栏-----------------------
- (void)_createdNavigationBar {
    
    [self createdNavigationBackButton];
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"设置";
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

#pragma mark ---------------------创建Views---------------------
- (void)_createdViews {
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.top.offset(UINavigateHeight);
        make.bottom.offset(0);
        make.right.offset(0);
    }];
}

#pragma mark ---------------UITableViewDelegate-----------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}
//每组单元格的数量
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *array = self.dataArray[section];
    return array.count;
}

//创建单元格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HHSetupTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HHSetupTableViewCell" forIndexPath:indexPath];
    if(cell ==nil){
        cell =[[HHSetupTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"HHSetupTableViewCell"];
    }
    NSArray *array = self.dataArray[indexPath.section];
    cell.title = array[indexPath.row];
    cell.backgroundColor = kWhiteColor;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
    lineView.backgroundColor = RGBColor(243, 244, 247);
    return lineView;
}

//设置单元格的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

//单元格点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        if (![[NSUserDefaults standardUserDefaults] boolForKey:@"isLogin"]) {
            [self login];
        }else {
            HHAccountSetupViewController *vc = [[HHAccountSetupViewController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else if(indexPath.section == 1){
        
        if (indexPath.row == 0) {//隐私设置
            HHPrivacySetupViewController *vc = [[HHPrivacySetupViewController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
            
        }else {//系统设置
            HHSystemSetupViewController *vc = [[HHSystemSetupViewController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else {
        if (indexPath.row == 0) {//注销账户
            HHCancellationViewController *vc = [[HHCancellationViewController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
            
        }else if(indexPath.row == 1){//关于APP
            HHAboutViewController *vc = [[HHAboutViewController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.bounces = NO;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.backgroundColor = RGBColor(243, 244, 247);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[HHSetupTableViewCell class] forCellReuseIdentifier:@"HHSetupTableViewCell"];
    }
    return _tableView;
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
                HHAccountSetupViewController *vc = [[HHAccountSetupViewController alloc] init];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
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
