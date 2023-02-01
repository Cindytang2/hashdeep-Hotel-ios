//
//  HHLandladyCommentViewController.m
//  HashdeepHotel
//
//  Created by Cindy on 2022/12/21.
//

#import "HHLandladyCommentViewController.h"
#import "HHCommentModel.h"
#import "HHHoteNoDataCell.h"
#import "HHCommentCell.h"
@interface HHLandladyCommentViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *dataArray;//列表数组
@property (nonatomic, strong) UIView *headView;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) BOOL isLoad;//是否加载了数据
@end
@implementation HHLandladyCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.page = 1;
    self.dataArray = [NSMutableArray array];
    [self createTableView];
    [self _loadData];
}

- (void)_loadData {
    
    NSString *url = [NSString stringWithFormat:@"%@/homestay/landlady/comment/list",BASE_URL];
    NSMutableDictionary *dic = @{}.mutableCopy;
    [dic setValue:self.homestay_id forKey:@"homestay_id"];
    [dic setValue:@(self.page) forKey:@"page"];
    [dic setValue:@(10) forKey:@"size"];
    
    [PPHTTPRequest requestPostWithJSONForUrl:url parameters:dic success:^(id  _Nonnull response) {
        self.isLoad = YES;
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
//        NSLog(@"response====%@",response);
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
                if (self.page == 1) {
                    self.tableView.mj_footer.hidden = YES;
                }else {
                    self.tableView.mj_footer.hidden = NO;
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }
            }else {
                self.tableView.mj_footer.hidden = NO;
                [self.tableView.mj_footer resetNoMoreData];
            }
            
            if(self.dataArray.count == 0){
                self.tableView.backgroundColor = kWhiteColor;
            }else {
                self.tableView.backgroundColor = XLColor_mainColor;
            }
            self.tableView.hidden = NO;
            [self.tableView reloadData];
        }else {
            [self.view makeToast:response[@"msg"] duration:2 position:CSToastPositionCenter];
        }
    } failure:^(NSError * _Nonnull error) {
        self.isLoad = YES;
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
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
        [cell updateUI:@"icon_my_comment_nodata" title:@"暂无评论记录" width:150 height:200 topHeight:(kScreenHeight-UINavigateHeight-140-50-200)/2-(UINavigateHeight/2)];
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
        return kScreenHeight-UINavigateHeight-80-140;
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
        _tableView.backgroundColor = kWhiteColor;
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

#pragma mark 创建tableview
- (void)createTableView{
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.offset(0);
        make.height.offset(kScreenHeight-UINavigateHeight);
    }];
    
    self.headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, self.headHeight+50)];
    _tableView.tableHeaderView = self.headView;
    _tableView.hidden = YES;
    self.headView.hidden = YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (self.moveAction) {
        self.moveAction(scrollView.contentOffset.y);
    }
    self.offerY = scrollView.contentOffset.y;
    if (scrollView.contentOffset.y <= 0) {
        scrollView.bounces = NO;
    }else {
        scrollView.bounces = YES;
    }
}

@end
