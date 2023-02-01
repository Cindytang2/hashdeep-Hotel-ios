//
//  HHSearchViewController.m
//  HashdeepHotel
//
//  Created by Cindy on 2022/7/14.
//

#import "HHSearchViewController.h"
#import "HHHomeSearchTableViewCell.h"
#import "HHSearchGroupModel.h"
#import "HHSearchHeadView.h"
@interface HHSearchViewController ()<UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) HHSearchHeadView *headView;
@property (nonatomic, strong) NSMutableArray *searchArray;
@end

@implementation HHSearchViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = kWhiteColor;
    self.dataArray = [NSMutableArray array];
    self.searchArray = [NSMutableArray array];
    
    //自定义导航栏
    [self _createdNavigationBar];
    
    //创建Views
    [self _createdViews];
    
    [self _loadData];
}

- (void)_loadData {
    
    NSString *url = [NSString stringWithFormat:@"%@/hotel/get/selectlist",BASE_URL];
    NSMutableDictionary *dic = @{}.mutableCopy;
    [dic setValue:[UserInfoManager sharedInstance].longitude forKey:@"longitude"];
    [dic setValue:[UserInfoManager sharedInstance].latitude forKey:@"latitude"];
    [PPHTTPRequest requestPostWithJSONForUrl:url parameters:dic success:^(id  _Nonnull response) {
        NSLog(@"response====%@",response);
        NSString *code = [NSString stringWithFormat:@"%@", response[@"code"]];
        if ([code isEqualToString:@"0"]) {//请求成功
            NSArray *data = response[@"data"];
            if (data.count != 0) {
                [self.dataArray addObjectsFromArray:[HHSearchGroupModel mj_objectArrayWithKeyValuesArray:data]];
                
                for (HHSearchGroupModel *model in self.dataArray) {
                    model.isSelect = NO;
                }
            }
            
            [self.tableView reloadData];
        }else {
            [self.view makeToast:response[@"msg"] duration:2 position:CSToastPositionCenter];
        }
    } failure:^(NSError * _Nonnull error) {
        
    }];
}

#pragma mark -----------------------自定义导航栏-----------------------
- (void)_createdNavigationBar {
    [self createdNavigationBackButton];
    
    UIView *searchView = [[UIView alloc] init];
    searchView.layer.cornerRadius = 5;
    searchView.layer.masksToBounds = YES;
    searchView.backgroundColor = XLColor_mainColor;
    [self.view addSubview:searchView];
    [searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(70);
        make.right.offset(-15);
        make.top.offset(UINavigateTop+5);
        make.height.offset(36);
    }];
    
    UIImageView *searchImgView = [[UIImageView alloc] init];
    searchImgView.image = HHGetImage(@"icon_home_search");
    [searchView addSubview:searchImgView];
    [searchImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.centerY.equalTo(searchView);
        make.width.offset(17);
        make.height.offset(16);
    }];
    
    self.textField = [[UITextField alloc] init];
    self.textField.borderStyle = UITextBorderStyleNone;
    self.textField.font = XLFont_mainTextFont;
    self.textField.textColor = XLColor_mainTextColor;
    self.textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"关键字/位置/品牌/酒店名" attributes:@{
        NSForegroundColorAttributeName:XLColor_subSubTextColor
    }];
    self.textField.text = self.searchStr;
    self.textField.textAlignment = NSTextAlignmentLeft;
    self.textField.keyboardType = UIKeyboardTypeTwitter;
    self.textField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.textField.delegate = self;
    self.textField.returnKeyType = UIReturnKeySearch;
    self.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    //    [self.textField becomeFirstResponder];
    [searchView addSubview:self.textField];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(searchImgView.mas_right).offset(10);
        make.top.bottom.offset(0);
        make.right.offset(-15);
    }];
    
}

#pragma mark ---------------------创建Views---------------------
- (void)_createdViews {
    
    WeakSelf(weakSelf)
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.offset(0);
        make.top.offset(UINavigateHeight);
    }];
    
    NSArray *historyArray = [[NSUserDefaults standardUserDefaults] objectForKey: @"home_search_History"];
    self.headView = [[HHSearchHeadView alloc] init];
    
    if (historyArray.count != 0) {
        NSInteger lineNumber = [NSString stringWithFormat:@"%.f",ceilf(historyArray.count/4.0)].integerValue;
        self.headView.frame = CGRectMake(0, 0, kScreenWidth, 55+lineNumber*50+lineNumber*7-7+15);
        self.headView.hidden = NO;
        [self.headView updateHistoryUI:historyArray];
    }else {
        self.headView.frame = CGRectMake(0, 0, 0, 0);
        self.headView.hidden = YES;
    }
    self.headView.clickButtonAction = ^(NSString * _Nonnull str) {
        if (weakSelf.selectedAction) {
            weakSelf.selectedAction(str);
        }
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    self.headView.clickClearAction = ^{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否要清空历史记录？" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
            
        }];
        [cancelAction setValue:XLColor_subSubTextColor forKey:@"titleTextColor"];
        [alert addAction:cancelAction];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"home_search_History"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            weakSelf.headView.frame = CGRectMake(0, 0, 0, 0);
            weakSelf.headView.hidden = YES;
            [weakSelf.tableView reloadData];
        }];
        [okAction setValue:UIColorHex(b58e7f) forKey:@"titleTextColor"];
        [alert addAction:okAction];
        
        // 弹出对话框
        [weakSelf presentViewController:alert animated:true completion:nil];
    };
    self.tableView.tableHeaderView = self.headView;
    
}

#pragma mark -----------UITableViewDelegate------------
//组的数量
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

//每组单元格的数量
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

//创建单元格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HHSearchGroupModel *model = self.dataArray[indexPath.section];
    HHHomeSearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HHHomeSearchTableViewCell" forIndexPath:indexPath];
    if(cell ==nil){
        cell =[[HHHomeSearchTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"HHHomeSearchTableViewCell"];
    }
    cell.array = model.selecttype_list;
    cell.backgroundColor = kWhiteColor;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.clipsToBounds = YES;
    cell.clickButtonAction = ^(NSString * _Nonnull str) {
        if (self.selectedAction) {
            self.selectedAction(str);
        }
        [self.navigationController popViewControllerAnimated:YES];
    };
    return cell;
}
//组的头视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    HHSearchGroupModel *model = self.dataArray[section];
    UIButton *sectionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sectionButton.frame = CGRectMake(0, 0, kScreenWidth, 30);
    sectionButton.tag = 100+section;
    
    [sectionButton addTarget:self action:@selector(clickItem:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = model.selecttype_category_desc;
    titleLabel.textColor = XLColor_mainTextColor;
    titleLabel.font = KBoldFont(16);
    [sectionButton addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.offset(-50);
        make.top.bottom.offset(0);
    }];
    
    if (model.selecttype_list.count > 8) {
        UIImageView *rightImageView = [[UIImageView alloc] init];
        if(!model.isSelect){
            rightImageView.image = HHGetImage(@"icon_home_down");
        }else {
            rightImageView.image = HHGetImage(@"icon_home_up");
        }
        [sectionButton addSubview:rightImageView];
        [rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.offset(-15);
            make.centerY.equalTo(sectionButton);
            make.width.offset(15);
            make.height.offset(8);
        }];
    }
    return sectionButton;
}

-(void)clickItem:(UIControl *)control{
    NSInteger section = control.tag-100;
    HHSearchGroupModel *sectionModel = self.dataArray[section];
    sectionModel.isSelect = !sectionModel.isSelect;
    [_tableView reloadData];
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

//组头的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

//设置单元格的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    HHSearchGroupModel *model = self.dataArray[indexPath.section];
    
    NSInteger lineNumber = [NSString stringWithFormat:@"%.f",ceilf(model.selecttype_list.count/4.0)].integerValue;
    if (model.isSelect) {//展开的时候，显示全部按钮
        return 15+lineNumber*50+lineNumber*7-7;
    }else {
        if (model.selecttype_list.count == 0) {
            return 0;
        }else if(model.selecttype_list.count > 8){//最多显示8个按钮
            return 15+2*50+2*7-7;
        }else {//不足8个的时候，显示全部按钮
            return 15+lineNumber*50+lineNumber*7-7;
        }
    }
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.bounces = NO;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.backgroundColor = kWhiteColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[HHHomeSearchTableViewCell class] forCellReuseIdentifier:@"HHHomeSearchTableViewCell"];
    }
    return _tableView;
}

#pragma mark ------------UITextFieldDelegate--------------
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    BOOL b = [HHAppManage isBlankString:textField.text];
    if (b) {
        [textField resignFirstResponder];
        [self.view makeToast:@"请输入搜索内容" duration:1 position:CSToastPositionCenter];
    }else {
        NSArray *searchArray = [[NSUserDefaults standardUserDefaults] objectForKey: @"home_search_History"];
        if (searchArray.count == 0) {
            [self.searchArray addObject:textField.text];
        }else {
            self.searchArray = [searchArray mutableCopy];
            
            if (![searchArray containsObject:textField.text]) {//如果么有这个字符串
                [self.searchArray insertObject:textField.text atIndex:0]; 
            }
        }
        
        [[NSUserDefaults standardUserDefaults] setObject: self.searchArray forKey: @"home_search_History"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        if (self.selectedAction) {
            self.selectedAction(textField.text);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
    return YES;
}

@end
