//
//  HHBrowseHistoryViewController.m
//  HashdeepHotel
//
//  Created by Cindy on 2022/7/21.
//

#import "HHBrowseHistoryViewController.h"
#import "HHHotelListCell.h"
#import "HHHoteNoDataCell.h"
#import "HHHotelModel.h"
#import "HHHotelDetailViewController.h"
#import "HHDormitoryDetailViewController.h"
@interface HHBrowseHistoryViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *indexLineView;
@property (nonatomic, strong) UIButton *selectedBt;

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *tableList;
@property (nonatomic, assign) BOOL isLoad;
@property (nonatomic, assign) NSInteger collect_type;

@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIButton *allSelectedButton;
@property (nonatomic, strong) UIButton *editButton;

@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, assign) BOOL is_delete_all;
@property (nonatomic, strong) NSMutableArray *selectedDataArray;
@property (nonatomic, strong) NSMutableArray *resultDataArray;
@end

@implementation HHBrowseHistoryViewController
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
    
    self.view.backgroundColor = kWhiteColor;
    self.page = 1;
    self.collect_type = 1;
    self.dataArray = @[].mutableCopy;
    self.tableList = [NSMutableArray array];
    self.resultDataArray = [NSMutableArray array];
    self.selectedDataArray = [NSMutableArray array];
    
    //自定义导航栏
    [self _createdNavigationBar];
    
    //创建Views
    [self _createdViews];
    
    [self _loadData];
}

- (void)_loadData {
    
    NSString *url = [NSString stringWithFormat:@"%@/hotel/his/list",BASE_URL];
    NSMutableDictionary *dic = @{}.mutableCopy;
    [dic setValue:@(self.page) forKey:@"page"];
    [dic setValue:@(10) forKey:@"size"];
    [dic setValue:[UserInfoManager sharedInstance].longitude forKey:@"longitude"];
    [dic setValue:[UserInfoManager sharedInstance].latitude forKey:@"latitude"];
    [dic setValue:@(self.collect_type) forKey:@"collect_type"];
    WeakSelf(weakSelf)
    [PPHTTPRequest requestPostWithJSONForUrl:url parameters:dic success:^(id  _Nonnull response) {
        weakSelf.isLoad = YES;
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        
        NSLog(@"response====%@",response);
        NSString *code = [NSString stringWithFormat:@"%@", response[@"code"]];
        if ([code isEqualToString:@"0"]) {//请求成功
            
            if (self.page == 1) {
                [self.dataArray removeAllObjects];
            }
            NSDictionary *data = response[@"data"];
            NSArray *list = data[@"list"];
            if (list.count !=0) {
                [self.dataArray addObjectsFromArray:[HHHotelModel mj_objectArrayWithKeyValuesArray:list]];
            }
            if (list.count < 10) {
                if (weakSelf.page == 1) {
                    weakSelf.tableView.mj_footer.hidden = YES;
                }else {
                    weakSelf.tableView.mj_footer.hidden = NO;
                    [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                }
            }else {
                weakSelf.tableView.mj_footer.hidden = NO;
                [weakSelf.tableView.mj_footer resetNoMoreData];
            }
            
            if (self.dataArray.count == 0) {
                self.editButton.hidden = YES;
            }else {
                self.editButton.hidden = NO;
            }
            [weakSelf.tableView reloadData];
        }else {
            [self.view makeToast:response[@"msg"] duration:2 position:CSToastPositionCenter];
        }
    } failure:^(NSError * _Nonnull error) {
        weakSelf.isLoad = YES;
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        
    }];
    
}

#pragma mark -----------------------自定义导航栏-----------------------
- (void)_createdNavigationBar {
    
    [self createdNavigationBackButton];
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"浏览历史";
    titleLabel.textColor = XLColor_mainTextColor;
    titleLabel.font = KBoldFont(18);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.offset(UINavigateTop+10);
        make.height.offset(20);
    }];
    
    self.editButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.editButton setTitle:@"编辑" forState:UIControlStateNormal];
    [self.editButton setTitleColor:XLColor_mainTextColor forState:UIControlStateNormal];
    self.editButton.titleLabel.font = XLFont_mainTextFont;
    [self.editButton addTarget:self action:@selector(editButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.editButton];
    [self.editButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(0);
        make.top.offset(UINavigateTop+10);
        make.height.offset(20);
        make.width.offset(50);
    }];
}

- (void)editButtonAction:(UIButton *)button {
    button.selected = !button.selected;
    if (button.selected) {
        self.isSelected = YES;
        [button setTitle:@"取消编辑" forState:UIControlStateNormal];
        [button mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.offset(90);
        }];
        
        if (UINavigateTop == 44) {
            self.scrollView.frame = CGRectMake(0, UINavigateHeight+51, kScreenWidth, kScreenHeight-UINavigateHeight-51-80);
            self.scrollView.contentSize = CGSizeMake(kScreenWidth*2, kScreenHeight-UINavigateHeight-51-80);
        }else {
            self.scrollView.frame = CGRectMake(0, UINavigateHeight+51, kScreenWidth, kScreenHeight-UINavigateHeight-51-60);
            self.scrollView.contentSize = CGSizeMake(kScreenWidth*2, kScreenHeight-UINavigateHeight-51-60);
        }
        self.bottomView.hidden = NO;
    }else{
        self.isSelected = NO;
        [button setTitle:@"编辑" forState:UIControlStateNormal];
        [button mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.offset(50);
        }];
        
        self.scrollView.frame = CGRectMake(0, UINavigateHeight+51, kScreenWidth, kScreenHeight-UINavigateHeight-51);
        self.scrollView.contentSize = CGSizeMake(kScreenWidth*2, kScreenHeight-UINavigateHeight-51);
        
        self.bottomView.hidden = YES;
    }
    
    [self.tableView reloadData];
}

#pragma mark ---------------------创建Views---------------------
- (void)_createdViews {
    NSArray *titleArray = @[@"酒店",@"民宿"];
    CGFloat xleft;
    for (int i=0; i<titleArray.count; i++) {
        NSString *string = titleArray[i];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = 70+i;
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:string forState:UIControlStateNormal];
        [button setTitleColor:XLColor_mainTextColor forState:UIControlStateNormal];
        [button setTitle:string forState:UIControlStateSelected];
        [button setTitleColor:UIColorHex(b58e7f) forState:UIControlStateSelected];
        button.titleLabel.font = XLFont_mainTextFont;
        if (i== 0) {
            button.selected = YES;
            self.selectedBt = button;
        }
        [self.view addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(xleft*i);
            make.top.offset(UINavigateHeight);
            make.width.offset(kScreenWidth/2);
            make.height.offset(50);
        }];
        xleft = kScreenWidth/2;
    }
    
    UIView *bottomLineView = [[UIView alloc] init];
    bottomLineView.backgroundColor = XLColor_mainColor;
    [self.view addSubview:bottomLineView];
    [bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.height.offset(1);
        make.top.offset(UINavigateHeight+50);
    }];
    
    self.indexLineView = [[UIView alloc] init];
    self.indexLineView.backgroundColor = UIColorHex(b58e7f);
    self.indexLineView.layer.cornerRadius = 1.5;
    self.indexLineView.layer.masksToBounds = YES;
    [self.view addSubview:self.indexLineView];
    [self.indexLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        CGFloat width = kScreenWidth/2;
        make.left.offset((kScreenWidth/2-30)/2);
        make.top.offset(UINavigateHeight+42);
        make.height.offset(3);
        make.width.offset(30);
    }];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, UINavigateHeight+51, kScreenWidth, kScreenHeight-UINavigateHeight-51)];
    self.scrollView.contentSize = CGSizeMake(kScreenWidth*2, kScreenHeight-UINavigateHeight-51);
    self.scrollView.tag = 9999;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.bounces = NO;
    self.scrollView.delegate = self;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.scrollView];
    
    for (int i = 0; i < 4; i ++) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(i*kScreenWidth, 0, kScreenWidth, self.scrollView.height) style:UITableViewStylePlain];
        tableView.dataSource = self;
        tableView.delegate =self;
        tableView.estimatedRowHeight = 0;
        tableView.estimatedSectionHeaderHeight = 0;
        tableView.estimatedSectionFooterHeight = 0;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.tag = 100+i;
        tableView.backgroundColor = XLColor_mainColor;
        [self.scrollView addSubview:tableView];
        [tableView registerClass:[HHHotelListCell class] forCellReuseIdentifier:@"HHHotelListCell"];
        [tableView registerClass:[HHHoteNoDataCell class] forCellReuseIdentifier:@"HHHoteNoDataCell"];
        
        WeakSelf(weakSelf)
        tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            //下拉刷新
            weakSelf.page = 1 ;
            [weakSelf _loadData];
        }];
        
        tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            weakSelf.page ++;
            [weakSelf _loadData];
        }];
        tableView.mj_footer.hidden = YES;
        [self.tableList addObject:tableView];
    }
    self.tableView = self.tableList[0];
    [self.scrollView setContentOffset:CGPointMake(0, 0)animated:YES];
    
    self.bottomView = [[UIView alloc] init];
    self.bottomView.backgroundColor = kWhiteColor;
    self.bottomView.hidden = YES;
    [self.view addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(60);
        if (UINavigateTop == 44) {
            make.bottom.offset(-20);
        }else {
            make.bottom.offset(0);
        }
        make.left.right.offset(0);
    }];
    
    self.allSelectedButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.allSelectedButton setImage:HHGetImage(@"icon_login_normal") forState:UIControlStateNormal];
    [self.allSelectedButton setImage:HHGetImage(@"icon_login_selected") forState:UIControlStateSelected];
    [self.allSelectedButton setTitle:@"全选" forState:UIControlStateNormal];
    [self.allSelectedButton setTitleColor:XLColor_mainTextColor forState:UIControlStateNormal];
    self.allSelectedButton.titleLabel.font = XLFont_mainTextFont;
    [self.allSelectedButton addTarget:self action:@selector(allSelectedButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:self.allSelectedButton];
    [self.allSelectedButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(30);
        make.width.offset(120);
        make.top.offset(15);
        make.left.offset(0);
    }];
    
    UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [deleteButton setTitle:@"删除" forState:UIControlStateNormal];
    [deleteButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
    deleteButton.titleLabel.font = XLFont_mainTextFont;
    deleteButton.layer.cornerRadius = 15;
    deleteButton.layer.masksToBounds = YES;
    deleteButton.backgroundColor = UIColorHex(b58e7f);
    [deleteButton addTarget:self action:@selector(deleteButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:deleteButton];
    [deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(30);
        make.width.offset(90);
        make.top.offset(15);
        make.right.offset(-15);
    }];
}

#pragma mark - ------------------------UIScrollViewDelegate-------------------
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView.tag == 9999) {
        NSInteger page = scrollView.contentOffset.x / scrollView.bounds.size.width;
        UIButton *button = [self.view viewWithTag:70+page];
        [self updateListUI:page button:button tableView:self.tableList[page]];
    }
}

- (void)buttonAction:(UIButton *)button {
    UITableView *tableView =(UITableView *)[self.scrollView viewWithTag:100-70+button.tag];
    [self updateListUI:button.tag-70 button:button tableView:tableView];
}

- (void)updateListUI:(NSInteger )number button:(UIButton *)button tableView:(UITableView *)tableView {
    
    [self.selectedBt setTitleColor:XLColor_mainTextColor forState:UIControlStateNormal];
    self.selectedBt.selected = NO;
    button.selected = YES;
    self.selectedBt = button;
    if (self.selectedBt.selected) {
        [self.selectedBt setTitleColor:UIColorHex(b58e7f) forState:UIControlStateNormal];
    }
    
    if (button.tag == 70) {
        self.collect_type = 1;
    }else {
        self.collect_type = 3;
    }
    
    CGFloat width = kScreenWidth/2;
    [self.indexLineView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.offset((width*number+(kScreenWidth/2-30)/2));
    }];
    
    
    [self.scrollView setContentOffset:CGPointMake(number *_scrollView.bounds.size.width, 0)animated:YES];
    
    self.page = 1;
    self.tableView = tableView;
    [self _loadData];
}

- (void)allSelectedButtonAction:(UIButton *)button {
    button.selected = !button.selected;
    if (button.selected) {
        for (HHHotelModel *model in self.dataArray) {
            model.isSelected = YES;
            [self.selectedDataArray addObject:model];
            [self.resultDataArray addObject:model.pid];
        }
        self.is_delete_all = YES;
    }else {
        
        for (HHHotelModel *model in self.dataArray) {
            model.isSelected = NO;
        }
        [self.selectedDataArray removeAllObjects];
        [self.resultDataArray removeAllObjects];
        self.is_delete_all = NO;
    }
    [self.tableView reloadData];
}

- (void)deleteButtonAction:(UIButton *)button {
    button.enabled = NO;
    if (self.selectedDataArray.count == 0) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            button.enabled = YES;
        });
        return;
    }
    
    NSString *url = [NSString stringWithFormat:@"%@/hotel/his/delete",BASE_URL];
    NSMutableDictionary *dic = @{}.mutableCopy;
    [dic setValue:@(self.is_delete_all) forKey:@"is_delete_all"];
    [dic setValue:self.resultDataArray forKey:@"delete_list"];
    WeakSelf(weakSelf)
    [PPHTTPRequest requestPostWithJSONForUrl:url parameters:dic success:^(id  _Nonnull response) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            button.enabled = YES;
        });
        NSLog(@"response====%@",response);
        NSString *code = [NSString stringWithFormat:@"%@", response[@"code"]];
        if ([code isEqualToString:@"0"]) {//请求成功
            for (HHHotelModel *model in self.selectedDataArray) {
                [self.dataArray removeObject:model];
            }
            [self.selectedDataArray removeAllObjects];
            [self.resultDataArray removeAllObjects];
            
            if (self.is_delete_all) {
                [self.editButton removeFromSuperview];
                self.scrollView.frame = CGRectMake(0, UINavigateHeight+51, kScreenWidth, kScreenHeight-UINavigateHeight-51);
                self.scrollView.contentSize = CGSizeMake(kScreenWidth*2, kScreenHeight-UINavigateHeight-51);
                self.bottomView.hidden = YES;
            }else {
                if (UINavigateTop == 44) {
                    self.scrollView.frame = CGRectMake(0, UINavigateHeight+51, kScreenWidth, kScreenHeight-UINavigateHeight-51-80);
                    self.scrollView.contentSize = CGSizeMake(kScreenWidth*2, kScreenHeight-UINavigateHeight-51-80);
                }else {
                    self.scrollView.frame = CGRectMake(0, UINavigateHeight+51, kScreenWidth, kScreenHeight-UINavigateHeight-51-60);
                    self.scrollView.contentSize = CGSizeMake(kScreenWidth*2, kScreenHeight-UINavigateHeight-51-60);
                }
                
                self.bottomView.hidden = NO;
            }
            
            [weakSelf.tableView reloadData];
        }else {
            [self.view makeToast:response[@"msg"] duration:2 position:CSToastPositionCenter];
        }
    } failure:^(NSError * _Nonnull error) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            button.enabled = YES;
        });
    }];
    
}

#pragma mark ---------------UITableViewDelegate-----------
//每组单元格的数量
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.dataArray.count == 0 && self.isLoad) {
        return 1;
    }else {
        return self.dataArray.count;
    }
}

//创建单元格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.dataArray.count > 0) {
        HHHotelListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HHHotelListCell" forIndexPath:indexPath];
        if(cell ==nil){
            cell =[[HHHotelListCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"HHHotelListCell"];
        }
        cell.collect_type = self.collect_type;
        cell.isSelected = self.isSelected;
        cell.type = @"0";
        cell.model = self.dataArray[indexPath.row];
        cell.backgroundColor = kWhiteColor;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else {
        HHHoteNoDataCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HHHoteNoDataCell" forIndexPath:indexPath];
        if(cell ==nil){
            cell =[[HHHoteNoDataCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"HHHoteNoDataCell"];
        }
        
        [cell updateUI:@"icon_my_history_nodata" title:@"暂无浏览记录" width:160 height:140 topHeight:(kScreenHeight-UINavigateHeight-230)/2];
        cell.backgroundColor = kWhiteColor;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}


//设置单元格的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.dataArray.count != 0) {
        HHHotelModel *model = self.dataArray[indexPath.row];
        model.collect_type = self.collect_type;
        model.type = @"0";
        return model.totalHeight;
    }else {
        return kScreenHeight-UINavigateHeight;
    }
}

//单元格点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.dataArray.count != 0) {
        
        if (self.isSelected) {
            HHHotelModel *model = self.dataArray[indexPath.row];
            if (model.isSelected) {
                model.isSelected = NO;
                [self.selectedDataArray removeObject:model];
                [self.resultDataArray removeObject:model.pid];
            }else {
                model.isSelected = YES;
                [self.selectedDataArray addObject:model];
                [self.resultDataArray addObject:model.pid];
            }
            
            if (self.selectedDataArray.count == self.dataArray.count) {
                self.is_delete_all = YES;
                self.allSelectedButton.selected = YES;
            }else {
                self.allSelectedButton.selected = NO;
                self.is_delete_all = NO;
            }
            [self.tableView reloadData];
        }else {
            
            HHHotelModel *model = self.dataArray[indexPath.row];
            if(self.collect_type == 3){
                HHDormitoryDetailViewController *vc = [[HHDormitoryDetailViewController alloc] init];
                vc.backType = @"MyGo";
                vc.homestay_id = model.pid;
                vc.homestay_room_id = model.room_id;
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }else {
                HHHotelDetailViewController *vc = [[HHHotelDetailViewController alloc] init];
                vc.backType = @"MyGo";
                vc.hotel_id = model.pid;
                vc.dateType = 0;
                vc.updateCollectionSuccess = ^(NSString * _Nonnull hotel_id) {
                    [self.dataArray removeObject:model];
                };
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
    }
}


@end
