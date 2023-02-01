//
//  HHAboutViewController.m
//  HashdeepHotel
//
//  Created by Cindy on 2022/7/12.
//

#import "HHAboutViewController.h"
#import "HHAboutTableViewCell.h"
@interface HHAboutViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation HHAboutViewController
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
        @{@"title":@"检查更新", @"subTitle":@"已是最新版本", @"type":@"1"},
        @{@"title":@"为APP打分", @"subTitle":@"", @"type":@"2"}
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
    titleLabel.text = @"关于APP";
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
    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 230)];
    self.tableView.tableHeaderView = headView;
    
    UIImageView *imgView = [[UIImageView alloc] init];
    imgView.image = HHGetImage(@"icon_my_about");
    imgView.contentMode = UIViewContentModeScaleAspectFit;
    [headView addSubview:imgView];
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(headView);
        make.width.offset(80);
        make.height.offset(60);
        make.top.offset(60);
    }];
    
    UILabel *numberLabel = [[UILabel alloc] init];
    numberLabel.textColor = XLColor_subSubTextColor;
    NSString *string = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    numberLabel.text = [NSString stringWithFormat:@"版本号v%@",string];
    numberLabel.font = XLFont_subSubTextFont;
    numberLabel.textAlignment = NSTextAlignmentCenter;
    [headView addSubview:numberLabel];
    [numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.offset(-15);
        make.height.offset(20);
        make.top.equalTo(imgView.mas_bottom).offset(5);
    }];
}

#pragma mark ---------------UITableViewDelegate-----------
//每组单元格的数量
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

//创建单元格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HHAboutTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HHAboutTableViewCell" forIndexPath:indexPath];
    if(cell ==nil){
        cell =[[HHAboutTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"HHAboutTableViewCell"];
    }
    cell.resultDictionary = self.dataArray[indexPath.row];
    cell.backgroundColor = kWhiteColor;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}

//设置单元格的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55;
}

//单元格点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        
    }else {
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/cn/app/id1634393465?mt=8"]];
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
        [_tableView registerClass:[HHAboutTableViewCell class] forCellReuseIdentifier:@"HHAboutTableViewCell"];
    }
    return _tableView;
}



@end
