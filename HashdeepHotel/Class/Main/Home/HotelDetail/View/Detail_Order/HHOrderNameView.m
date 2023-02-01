//
//  HHOrderNameView.m
//  HashdeepHotel
//
//  Created by Cindy on 2022/9/23.
//

#import "HHOrderNameView.h"
#import "HHOrderNameTableViewCell.h"
#import "HHOrderNameModel.h"
@interface HHOrderNameView ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UIView *whiteView;

@end
@implementation HHOrderNameView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self _addSubViews];
    }
    return self;
}

- (void)_addSubViews{
    
    self.whiteView = [[UIView alloc] init];
    self.whiteView.backgroundColor = kWhiteColor;
    [self addSubview:self.whiteView];
    [self.whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.height.offset(100);
        make.bottom.offset(0);
    }];
    
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeButton setImage:HHGetImage(@"icon_home_search_close") forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(closeButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.whiteView addSubview:closeButton];
    [closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(15);
        make.right.offset(-15);
        make.top.offset(15);
    }];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = XLColor_mainTextColor;
    titleLabel.font = KBoldFont(16);
    titleLabel.text = @"已选1人";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.whiteView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.offset(-15);
        make.height.offset(20);
        make.top.offset(15);
    }];
    
    [self.whiteView addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.top.offset(50);
        make.bottom.offset(0);
        make.right.offset(0);
    }];
    
}
- (void)setDataArray:(NSArray *)dataArray{
    _dataArray = dataArray;
    CGFloat h = 50+_dataArray.count*45+50;
    if(h >kScreenHeight-150){
        h = kScreenHeight-150;
    }
    [self.whiteView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.offset(h);
    }];
    [HHAppManage mq_setRect:CGRectMake(0, 0, kScreenWidth, h) cornerRect:UIRectCornerTopLeft|UIRectCornerTopRight radius:15 view:self.whiteView];
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
        _tableView.backgroundColor = kWhiteColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[HHOrderNameTableViewCell class] forCellReuseIdentifier:@"HHOrderNameTableViewCell"];
    }
    return _tableView;
}

#pragma mark ---------------UITableViewDelegate-----------

//每组单元格的数量
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

//创建单元格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HHOrderNameTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HHOrderNameTableViewCell" forIndexPath:indexPath];
    if(cell ==nil){
        cell =[[HHOrderNameTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"HHOrderNameTableViewCell"];
    }
    cell.model = self.dataArray[indexPath.row];
    cell.backgroundColor = kWhiteColor;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}

//设置单元格的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45;
}

//单元格点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
 
    HHOrderNameModel *model = self.dataArray[indexPath.row];
    
    for (HHOrderNameModel *mm in self.dataArray) {
        if(mm == model){
            if (mm.isSelected) {
                mm.isSelected = NO;
             }else {
                 mm.isSelected = YES;
            }
        }else {
            mm.isSelected = NO;
        }
    }
   
    [self.tableView reloadData];
    
    if(self.selectedSuccess){
        self.selectedSuccess(model.link_man);
    }
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches.allObjects lastObject];
    BOOL result = [touch.view isDescendantOfView:self.whiteView];
    if (!result) {
        
        if (self.clickCloseButton) {
            self.clickCloseButton();
        }
    }
    
}

- (void)closeButtonAction {
    
    if (self.clickCloseButton) {
        self.clickCloseButton();
    }
}
@end
