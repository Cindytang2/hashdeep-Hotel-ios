//
//  HHPrivacySetupViewController.m
//  HashdeepHotel
//
//  Created by Cindy on 2022/7/12.
//

#import "HHPrivacySetupViewController.h"
#import "HHPrivacySetupTableViewCell.h"
#import "HHThirdListViewController.h"
#import "HHAgreementViewController.h"
#import "HHMyListViewController.h"
@interface HHPrivacySetupViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation HHPrivacySetupViewController

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
    
    self.dataArray = @[
        @{
            @"title":@"系统权限管理",
            @"subTitle":@"管理您已授权在APP使用中的系统权限",
            @"type":@"1"},
        @{
            @"title":@"个性化推荐",
            @"subTitle":@"及时获取周边的优惠、促销信息",
            @"type":@"2"},
        @{
            @"title":@"隐私政策条款",
            @"subTitle":@"",
            @"type":@"3"},
        @{
            @"title":@"个人信息收集清单",
            @"subTitle":@"",
            @"type":@"3"},
        @{
            @"title":@"个人信息第三方共享清单",
            @"subTitle":@"",
            @"type":@"3"},
        
    ];
    
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
    titleLabel.text = @"隐私设置";
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
    
    UILabel *topLabel = [[UILabel alloc] init];
    topLabel.text = @"权限设置";
    topLabel.textColor = XLColor_mainTextColor;
    topLabel.font = XLFont_subSubTextFont;
    [self.view addSubview:topLabel];
    [topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.top.offset(UINavigateHeight);
        make.height.offset(40);
    }];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.top.equalTo(topLabel.mas_bottom).offset(0);
        make.bottom.offset(0);
        make.right.offset(0);
    }];
}

#pragma mark ---------------UITableViewDelegate-----------
//每组单元格的数量
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

//创建单元格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HHPrivacySetupTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HHPrivacySetupTableViewCell" forIndexPath:indexPath];
    if(cell ==nil){
        cell =[[HHPrivacySetupTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"HHPrivacySetupTableViewCell"];
    }
    cell.resultDictionary = self.dataArray[indexPath.row];
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
    if (indexPath.row == 0 || indexPath.row == 1) {
        return 65;
    }
    return 55;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

//单元格点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {//系统权限管理
        NSURL * appSettingURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if ([[UIApplication sharedApplication] canOpenURL:appSettingURL]){
            [[UIApplication sharedApplication] openURL:appSettingURL options:@{UIApplicationOpenURLOptionsSourceApplicationKey : @YES} completionHandler:^(BOOL success) {
                
            }];
        }
    }else if(indexPath.row == 1){
        
    }else if(indexPath.row == 2){//隐私政策条款
        HHAgreementViewController *vc = [[HHAgreementViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if(indexPath.row == 3){//个人信息收集清单
        HHMyListViewController *vc = [[HHMyListViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else {//个人信息第三方共享清单
        HHThirdListViewController *vc = [[HHThirdListViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
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
        [_tableView registerClass:[HHPrivacySetupTableViewCell class] forCellReuseIdentifier:@"HHPrivacySetupTableViewCell"];
    }
    return _tableView;
}


@end
