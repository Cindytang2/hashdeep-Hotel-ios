//
//  HHHotelCommentViewController.m
//  HashdeepHotel
//
//  Created by Cindy on 2022/7/29.
//

#import "HHHotelCommentViewController.h"
#import "HHCommentCell.h"
#import "HHCommentModel.h"
#import "HHHoteNoDataCell.h"
#import "HHHotelCommentHeadView.h"
@interface HHHotelCommentViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) BOOL isLoad;
@property (nonatomic, strong) HHHotelCommentHeadView *headView;
@property (nonatomic, assign) NSInteger comment_level;
@end

@implementation HHHotelCommentViewController

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
    self.page = 1;
    self.dataArray = [NSMutableArray array];
    self.comment_level = 0;
    self.view.backgroundColor = kWhiteColor;
    
    //自定义导航栏
    [self _createdNavigationBar];
    
    //创建Views
    [self _createdViews];
    
    //    [self _loadHeadData];
    
    [self _loadData];
}

- (void)_loadHeadData{
    
    NSString *url = [NSString stringWithFormat:@"%@/merchant/hotel/comment/rating",BASE_URL];
    NSMutableDictionary *dic = @{}.mutableCopy;
    [dic setValue:self.hotel_id forKey:@"hotel_id"];
    WeakSelf(weakSelf)
    [PPHTTPRequest requestPostWithJSONForUrl:url parameters:dic success:^(id  _Nonnull response) {
        weakSelf.isLoad = YES;
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        
        //        NSLog(@"评论列表====%@",response);
        NSString *code = [NSString stringWithFormat:@"%@", response[@"code"]];
        if ([code isEqualToString:@"0"]) {//请求成功
            NSDictionary *data = response[@"data"];
            self.headView.hidden = NO;
            NSArray *tags = data[@"tags"];
            NSDictionary *hotel_comment_rating = @{
                @"total_rating":data[@"total_rating"],
                @"total_rating_cleaning":data[@"total_rating_cleaning"],
                @"total_rating_comfort":data[@"total_rating_comfort"],
                @"total_rating_equipment":data[@"total_rating_equipment"],
                @"total_rating_location":data[@"total_rating_location"],
                @"total_rating_service":data[@"total_rating_service"]
            };
            self.headView.hotel_comment_rating = hotel_comment_rating;
            self.headView.tags = tags;
            
        }else {
            [self.view makeToast:response[@"msg"] duration:2 position:CSToastPositionCenter];
        }
    } failure:^(NSError * _Nonnull error) {
        
    }];
    
}


- (void)_loadData {
    
    NSString *url = [NSString stringWithFormat:@"%@/hotel/comment/list",BASE_URL];
    NSMutableDictionary *dic = @{}.mutableCopy;
    [dic setValue:self.hotel_id forKey:@"hotel_id"];
    [dic setValue:@(self.page) forKey:@"page"];
    [dic setValue:@(10) forKey:@"size"];
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
                [self.dataArray addObjectsFromArray:[HHCommentModel mj_objectArrayWithKeyValuesArray:list]];
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
    titleLabel.text = @"住客点评";
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
    //    WeakSelf(weakSelf)
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.top.offset(UINavigateHeight);
        make.bottom.offset(0);
        make.right.offset(0);
    }];
    
    //    self.headView = [[HHHotelCommentHeadView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 326)];
    //    self.headView.hidden = YES;
    //    self.headView.backgroundColor = XLColor_mainColor;
    //
    //    self.headView.clickButtonActionBlock = ^(NSDictionary * _Nonnull dic) {
    //        weakSelf.comment_level = [NSString stringWithFormat:@"%@",dic[@"rating_tag"]].integerValue;
    //        weakSelf.page = 1;
    //        [weakSelf _loadData];
    //    };
    //
    //    self.tableView.tableHeaderView = self.headView;
    
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
    WeakSelf(weakSelf)
    if (self.dataArray.count > 0) {
        HHCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HHCommentCell" forIndexPath:indexPath];
        if(cell ==nil){
            cell =[[HHCommentCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"HHCommentCell"];
        }
        HHCommentModel *model = self.dataArray[indexPath.row];
        cell.model = model;
        cell.updateCommentCellBlock = ^{
            [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        };
        cell.backgroundColor = XLColor_mainColor;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else {
        HHHoteNoDataCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HHHoteNoDataCell" forIndexPath:indexPath];
        if(cell ==nil){
            cell =[[HHHoteNoDataCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"HHHoteNoDataCell"];
        }
        [cell updateUI:@"icon_my_comment_nodata" title:@"暂无评论记录" width:150 height:200 topHeight:(kScreenHeight-UINavigateHeight-200)/2-(UINavigateHeight/2)];
        cell.backgroundColor = kWhiteColor;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}


//设置单元格的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.dataArray.count != 0) {
        HHCommentModel *model = self.dataArray[indexPath.row];
        return model.totalHeight;
    }else {
        return kScreenHeight-UINavigateHeight;
    }
}

//单元格点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.backgroundColor = XLColor_mainColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[HHCommentCell class] forCellReuseIdentifier:@"HHCommentCell"];
        [_tableView registerClass:[HHHoteNoDataCell class] forCellReuseIdentifier:@"HHHoteNoDataCell"];
        WeakSelf(weakSelf)
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            //下拉刷新
            weakSelf.page = 1;
            [weakSelf _loadData];
        }];
        
        _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            weakSelf.page ++;
            [weakSelf _loadData];
        }];
        _tableView.mj_footer.hidden = YES;
    }
    return _tableView;
}

@end
