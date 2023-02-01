//
//  HHSystemSetupViewController.m
//  HashdeepHotel
//
//  Created by Cindy on 2022/7/12.
//

#import "HHSystemSetupViewController.h"
#import "HHSystemSetupTableViewCell.h"
#import "LBClearCacheTool.h"
#define filePath [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject]

@interface HHSystemSetupViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation HHSystemSetupViewController
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
    
    NSString *fileSize = [LBClearCacheTool getCacheSizeWithFilePath:filePath];
    self.dataArray = @[
        @{@"title":@"消息通知", @"subTitle":@"", @"type":@"1"},
        @{@"title":@"清除缓存", @"subTitle":fileSize, @"type":@"2"}
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
    titleLabel.text = @"系统设置";
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
//每组单元格的数量
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

//创建单元格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HHSystemSetupTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HHSystemSetupTableViewCell" forIndexPath:indexPath];
    if(cell ==nil){
        cell =[[HHSystemSetupTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"HHSystemSetupTableViewCell"];
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
    HHSystemSetupTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if(indexPath.row == 1){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定清除缓存吗?" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
            
        }];
        [cancelAction setValue:XLColor_subSubTextColor forKey:@"titleTextColor"];
        [alert addAction:cancelAction];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
            //清楚缓存
            BOOL isSuccess = [LBClearCacheTool clearCacheWithFilePath:filePath];
            if (isSuccess) {
                [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
                [SVProgressHUD showSuccessWithStatus:@"清除成功"];
                cell.subTitleLabel.text = @"0.0B";
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [SVProgressHUD dismiss];
                });
            }
        }];
        [okAction setValue:UIColorHex(b58e7f) forKey:@"titleTextColor"];
        [alert addAction:okAction];
        
        // 弹出对话框
        [self presentViewController:alert animated:true completion:nil];
        
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
        [_tableView registerClass:[HHSystemSetupTableViewCell class] forCellReuseIdentifier:@"HHSystemSetupTableViewCell"];
    }
    return _tableView;
}


@end
