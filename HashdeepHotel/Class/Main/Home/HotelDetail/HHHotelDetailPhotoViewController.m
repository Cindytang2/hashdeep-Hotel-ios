//
//  HHHotelDetailPhotoViewController.m
//  HashdeepHotel
//
//  Created by Cindy on 2022/7/27.
//

#import "HHHotelDetailPhotoViewController.h"
#import "HHSeeImageViewController.h"
@interface HHHotelDetailPhotoViewController ()
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) NSArray *hotel_files_details;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *imgArray;
@property (nonatomic, weak) UIButton *selectedBtn;
@property (nonatomic, assign) BOOL isPath;
@end

@implementation HHHotelDetailPhotoViewController
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
    self.dataArray = [NSMutableArray array];
    self.imgArray = [NSMutableArray array];
    //自定义导航栏
    [self _createdNavigationBar];
    
    //创建Views
    [self _createdViews];
    
    [self _loadData];
}

#pragma mark -----------------------自定义导航栏-----------------------
- (void)_createdNavigationBar {
    
    [self createdNavigationBackButton];
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"官方图片";
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
    
    self.topView = [[UIView alloc] init];
    [self.view addSubview:self.topView];
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.offset(UINavigateHeight);
        make.height.offset(60);
    }];
    
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.bounces = NO;
    [self.view addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.offset(0);
        make.top.equalTo(self.topView.mas_bottom).offset(0);
    }];
}

- (void)_loadData {
    
    NSString *url = [NSString stringWithFormat:@"%@/hotel/detail/photoslist",BASE_URL];
    NSMutableDictionary *dic = @{}.mutableCopy;
    [dic setValue:self.hotel_id forKey:@"hotel_id"];
    
    [PPHTTPRequest requestPostWithJSONForUrl:url parameters:dic success:^(id  _Nonnull response) {
        
        NSLog(@"相册====%@",response);
        NSString *code = [NSString stringWithFormat:@"%@", response[@"code"]];
        if ([code isEqualToString:@"0"]) {//请求成功
            NSDictionary *data = response[@"data"];
            NSString *all_size = [NSString stringWithFormat:@"%@",data[@"all_size"]];
            self.hotel_files_details = data[@"hotel_files_details"];
            
            [self.dataArray addObject:[NSString stringWithFormat:@"全部(%@)",all_size]];
            for (int i=0; i<self.hotel_files_details.count; i++) {
                NSDictionary *dii = self.hotel_files_details[i];
                [self.imgArray addObject:dii];
                NSString *category_name = dii[@"category_name"];
                NSString *size = [NSString stringWithFormat:@"%@",dii[@"size"]];
                [self.dataArray addObject:[NSString stringWithFormat:@"%@(%@)",category_name,size]];
            }
            
            int xLeft = 15;
            int yBottom = 10;
            int lineNumber = 1;
            for (int b= 0; b<self.dataArray.count; b++) {
                NSString *str = self.dataArray[b];
                CGFloat buttonWidth = [LabelSize widthOfString:str font:XLFont_subSubTextFont height:32];
                
                if (xLeft+buttonWidth+15+7 > kScreenWidth-15) {
                    xLeft = 15;
                    yBottom = yBottom+32+10;
                    lineNumber++;
                }
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                [button setTitle:str forState:UIControlStateNormal];
                [button setTitleColor:XLColor_mainTextColor forState:UIControlStateNormal];
                button.titleLabel.font = XLFont_subSubTextFont;
                button.backgroundColor = XLColor_mainColor;
                button.layer.cornerRadius = 5;
                button.layer.masksToBounds = YES;
                button.layer.borderWidth = 1;
                button.layer.borderColor = XLColor_mainColor.CGColor;
                button.tag = b;
                [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
                if (b == 0) {
                    button.selected = YES;
                    self.selectedBtn = button;
                    self.selectedBtn.layer.borderColor = UIColorHex(b58e7f).CGColor;
                    self.selectedBtn.backgroundColor = kWhiteColor;
                }
                [self.topView addSubview:button];
                [button mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.offset(xLeft);
                    make.width.offset(buttonWidth+15);
                    make.height.offset(32);
                    make.top.offset(yBottom);
                }];
                
                xLeft = xLeft+buttonWidth+15+7;
            }
            
            [self.topView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.offset(lineNumber*32+lineNumber*10+12);
            }];
            
            [self _createdscrollSubView];
        }else {
            [self.view makeToast:response[@"msg"] duration:2 position:CSToastPositionCenter];
        }
        
    } failure:^(NSError * _Nonnull error) {
        
    }];
}

- (void)_createdscrollSubView{
    for (UIView *view in self.scrollView.subviews) {
        [view removeFromSuperview];
    }
    
    int yBottom = 15;
    for (int i=0; i<self.imgArray.count; i++) {
        NSDictionary *dic = self.imgArray[i];
        NSString *category_name = dic[@"category_name"];
        NSString *size = [NSString stringWithFormat:@"%@",dic[@"size"]];
        NSString *title = [NSString stringWithFormat:@"%@(%@)",category_name,size];
        
        UIView *pSuperView = [[UIView alloc] init];
        pSuperView.tag = i;
        [self.scrollView addSubview:pSuperView];
        [pSuperView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.offset(0);
            make.centerX.offset(0);
            make.top.offset(yBottom);
            make.height.offset(100);
            if(i == self.imgArray.count-1){
                if (UINavigateTop == 44) {
                    make.bottom.offset(-35);
                }else {
                    make.bottom.offset(-15);
                }
                
            }
        }];
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.font = KBoldFont(18);
        titleLabel.textColor = XLColor_mainTextColor;
        titleLabel.text = title;
        [pSuperView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(15);
            make.top.offset(0);
            make.height.offset(50);
            make.right.offset(-15);
        }];
        NSArray *file_list = dic[@"file_list"];
        int xLeft = 15;
        int yy_bottom = 50;
        int lineNumber = 1;
        for (int a= 0; a<file_list.count; a++) {
            NSDictionary *dict = file_list[a];
            
            if (xLeft+(kScreenWidth-40)/2 > kScreenWidth-15) {
                xLeft = 15;
                yy_bottom = yy_bottom+150+10;
                lineNumber++;
            }
            UIImageView *imgView = [[UIImageView alloc] init];
            [imgView sd_setImageWithURL:[NSURL URLWithString:dict[@"path"]]];
            imgView.layer.cornerRadius = 12;
            imgView.layer.masksToBounds = YES;
            imgView.contentMode = UIViewContentModeScaleAspectFill;
            imgView.userInteractionEnabled = YES;
            imgView.tag = a;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imgViewAction:)];
            [imgView addGestureRecognizer:tap];
            [pSuperView addSubview:imgView];
            [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.offset(xLeft);
                make.top.offset(yy_bottom);
                make.width.offset((kScreenWidth-40)/2);
                make.height.offset(150);
            }];
            xLeft = xLeft+(kScreenWidth-40)/2+10;
        }
        
        [pSuperView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset(50+lineNumber*150+lineNumber*10-10);
        }];
        yBottom = yBottom+50+lineNumber*150+lineNumber*10-10;
    }
    
}
-(void)imgViewAction:(id)sender{
    self.isPath = NO;
    UITapGestureRecognizer *tap = (UITapGestureRecognizer*)sender;
    UIView *views = (UIView*) tap.view;
    NSDictionary *dic = self.imgArray[views.superview.tag];
    NSArray *file_list = dic[@"file_list"];
    NSDictionary *dict = file_list[views.tag];
    NSString *path = dict[@"path"];
    
    
    NSMutableArray *array = [NSMutableArray array];
    for (int a=0; a<self.imgArray.count; a++) {
        NSDictionary *dictionary = self.imgArray[a];
        NSArray *file_list = dictionary[@"file_list"];
        for (NSDictionary *dddddd in file_list) {
            [array addObject:dddddd[@"path"]];
        }
    }
    
    int number = 0;
    for (int i=0; i<self.imgArray.count; i++) {
        if (self.isPath) {
            break;
        }
        NSDictionary *dictionary = self.imgArray[i];
        NSArray *file_list = dictionary[@"file_list"];
        for (int c=0; c<file_list.count; c++) {
            NSDictionary *ddrrrr = file_list[c];
            if ([ddrrrr[@"path"] isEqualToString:path]) {
                self.isPath = YES;
                break;
            }
            number++;
        }
    }
    
    HHSeeImageViewController *vc = [[HHSeeImageViewController alloc] init];
    vc.dataArray = array;
    vc.number = number+1;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)buttonAction:(UIButton *)button {
    
    self.selectedBtn.backgroundColor = XLColor_mainColor;
    self.selectedBtn.layer.borderColor = XLColor_mainColor.CGColor;
    self.selectedBtn.selected = NO;
    button.selected = YES;
    self.selectedBtn = button;
    if (self.selectedBtn.selected) {
        self.selectedBtn.backgroundColor = kWhiteColor;
        self.selectedBtn.layer.borderColor = UIColorHex(b58e7f).CGColor;
    }
    
    [self.imgArray removeAllObjects];
    
    
    NSString *title = self.selectedBtn.titleLabel.text;
    NSArray *array = [title componentsSeparatedByString:@"("]; //从字符A中分隔成2个元素的数组
    title = array.firstObject;
    if ([title isEqualToString:@"全部"]) {
        for (int i=0; i<self.hotel_files_details.count; i++) {
            NSDictionary *dii = self.hotel_files_details[i];
            [self.imgArray addObject:dii];
        }
    }else {
        for (int i=0; i<self.hotel_files_details.count; i++) {
            NSDictionary *dii = self.hotel_files_details[i];
            if ([dii[@"category_name"] isEqualToString:title]) {
                [self.imgArray addObject:dii];
            }
        }
    }
    [self _createdscrollSubView];
}
@end
