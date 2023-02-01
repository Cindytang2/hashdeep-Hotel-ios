//
//  HHPersonalInformationViewController.m
//  HashdeepHotel
//
//  Created by Cindy on 2022/7/12.
//

#import "HHPersonalInformationViewController.h"
#import "HHPersonalInformationTableViewCell.h"
#import "AliUpLoadImageTool.h"
#import "HHEditNameViewController.h"
#import "HHEditMobileViewController.h"
#import "XLSetupBirthdayView.h"
#import "TUILogin.h"
@interface HHPersonalInformationViewController ()<UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSString *sexStr;
@property(nonatomic,strong) XLSetupBirthdayView *bottomView;

@end

@implementation HHPersonalInformationViewController

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
    
    self.view.backgroundColor = RGBColor(243, 244, 247);
    self.dataArray = [NSMutableArray array];
    
    //自定义导航栏
    [self _createdNavigationBar];
    
    //创建Views
    [self _createdViews];
    
    [self _loadData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moblieSuccess:) name:@"editMoblieSuccessNotification" object:nil];
}

- (void)moblieSuccess:(NSNotification *)notification{
    NSDictionary * infoDic = [notification object];
    NSMutableArray *twoArray = self.dataArray.lastObject;
    NSMutableDictionary *oneDic = twoArray.firstObject;
    oneDic[@"subTitle"] = infoDic[@"moblie"];
    [self.tableView reloadData];
}

- (void)_loadData {
    NSString *url = [NSString stringWithFormat:@"%@/user/info",BASE_URL];
    [PPHTTPRequest requestGetWithURL:url parameters:@{} success:^(id  _Nonnull response) {
        NSLog(@"response====%@",response);
        NSString *code = [NSString stringWithFormat:@"%@", response[@"code"]];
        if ([code isEqualToString:@"0"]) {//请求成功
            NSDictionary *data = response[@"data"];
            NSString *sex = [NSString stringWithFormat:@"%@",data[@"sex"]];
            NSString *user_head_img = data[@"user_head_img"];
            NSString *user_name = data[@"user_name"];
            NSString *user_phone = data[@"user_phone"];
            NSString *user_birth = data[@"user_birth"];
            
            [UserInfoManager sharedInstance].birthday = user_birth;
            [UserInfoManager sharedInstance].mobile = user_phone;
            [UserInfoManager sharedInstance].userNickName = user_name;
            [UserInfoManager sharedInstance].headImageStr = user_head_img;
            [UserInfoManager synchronize];
            
            NSString *name;
            if (user_name.length == 0) {
                name = @"请输入昵称";
            }else {
                name = user_name;
            }
            
            NSString *moblie;
            if (user_phone.length == 0) {
                moblie = @"请输入手机号";
            }else {
                moblie = user_phone;
            }
            
            NSString *birth;
            if (user_birth.length == 0) {
                birth = @"请选择您的生日";
            }else {
                birth = user_birth;
            }
            
            NSString *user_sex;
            if ([sex isEqualToString:@"0"]) {
                user_sex = @"请选择您的性别";
            }else {
                user_sex = sex;
            }
            
            NSMutableArray *oneArray = [NSMutableArray array];
            NSMutableDictionary *oneDic = @{}.mutableCopy;
            [oneDic setValue:@"头像" forKey:@"title"];
            [oneDic setValue:user_head_img forKey:@"subTitle"];
            [oneDic setValue:@"1" forKey:@"type"];
            [oneArray addObject:oneDic];
            
            NSMutableDictionary *twoDic = @{}.mutableCopy;
            [twoDic setValue:@"昵称" forKey:@"title"];
            [twoDic setValue:name forKey:@"subTitle"];
            [twoDic setValue:@"2" forKey:@"type"];
            [oneArray addObject:twoDic];
            
            NSMutableArray *twoArray = [NSMutableArray array];
            NSMutableDictionary *threeDic = @{}.mutableCopy;
            [threeDic setValue:@"手机号" forKey:@"title"];
            [threeDic setValue:moblie forKey:@"subTitle"];
            [threeDic setValue:@"2" forKey:@"type"];
            [twoArray addObject:threeDic];
            
            NSMutableDictionary *fourDic = @{}.mutableCopy;
            [fourDic setValue:@"生日" forKey:@"title"];
            [fourDic setValue:birth forKey:@"subTitle"];
            [fourDic setValue:@"2" forKey:@"type"];
            [twoArray addObject:fourDic];
            
            NSMutableDictionary *fiveDic = @{}.mutableCopy;
            [fiveDic setValue:@"性别" forKey:@"title"];
            [fiveDic setValue:user_sex forKey:@"subTitle"];
            [fiveDic setValue:@"2" forKey:@"type"];
            [twoArray addObject:fiveDic];
            
            [self.dataArray addObject:oneArray];
            [self.dataArray addObject:twoArray];
            [self.tableView reloadData];
        }else {
            [self.view makeToast:response[@"msg"] duration:2 position:CSToastPositionCenter];
        }
    } failure:^(NSError * _Nonnull error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view makeToast:@"网络异常，请检查网络后重试" duration:2 position:CSToastPositionCenter];
        });
    }];
}
#pragma mark -----------------------自定义导航栏-----------------------
- (void)_createdNavigationBar {
    [self createdNavigationBackButton];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"个人信息";
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
        if (UINavigateTop == 44) {
            make.bottom.offset(-80);
        }else {
            make.bottom.offset(-60);
        }
        make.right.offset(0);
    }];
    
    UIButton *logOutButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [logOutButton setTitle:@"退出登录" forState:UIControlStateNormal];
    [logOutButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
    logOutButton.backgroundColor = UIColorHex(b58e7f);
    logOutButton.layer.cornerRadius = 8;
    logOutButton.layer.masksToBounds = YES;
    logOutButton.titleLabel.font = XLFont_mainTextFont;
    [logOutButton addTarget:self action:@selector(logOutButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:logOutButton];
    [logOutButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.offset(-15);
        make.height.offset(45);
        if (UINavigateTop == 44) {
            make.bottom.offset(-35);
        }else {
            make.bottom.offset(-15);
        }
    }];
}

- (void)logOutButtonAction {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否退出登录？" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
        
    }];
    [cancelAction setValue:XLColor_subSubTextColor forKey:@"titleTextColor"];
    [alert addAction:cancelAction];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"退出登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
        NSString *url = [NSString stringWithFormat:@"%@/user/quit",BASE_URL];
        
        [PPHTTPRequest requestPostWithJSONForUrl:url parameters:@{} success:^(id  _Nonnull response) {
            NSLog(@"退出登录======%@",response);
            NSString *code = [NSString stringWithFormat:@"%@", response[@"code"]];
            if ([code isEqualToString:@"0"]) {//请求成功
                [UserInfoManager logout];
                [UserInfoManager removeInfo];
                NSLog(@"refresh_token================%@",[UserInfoManager sharedInstance].refresh_token);
                [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isLogin"];
                [[NSUserDefaults standardUserDefaults]setValue:@"0" forKey:@"hourlyCalendarOffsetY"];
                [[NSUserDefaults standardUserDefaults]setValue:@"0" forKey:@"countryCalendarOffsetY"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                [self.navigationController popViewControllerAnimated:YES];
                
                [TUILogin logout:^{
                    
                } fail:^(int code, NSString *msg) {
                    
                }];
                
            }else {
                [self.view makeToast:response[@"msg"] duration:2 position:CSToastPositionCenter];
                
            }
        } failure:^(NSError * _Nonnull error) {
           
        }];
        
       
    }];
    [okAction setValue:UIColorHex(b58e7f) forKey:@"titleTextColor"];
    [alert addAction:okAction];
    
    // 弹出对话框
    [self presentViewController:alert animated:true completion:nil];
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
    
    HHPersonalInformationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HHPersonalInformationTableViewCell" forIndexPath:indexPath];
    if(cell ==nil){
        cell =[[HHPersonalInformationTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"HHPersonalInformationTableViewCell"];
    }
    NSArray *array = self.dataArray[indexPath.section];
    cell.resultDictionary = array[indexPath.row];
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
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 65;
        }
    }
    
    return 55;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

//单元格点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    WeakSelf(weakSelf)
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            [self headAction];
            
        }else {
            HHEditNameViewController *vc = [[HHEditNameViewController alloc] init];
            vc.updateNickNameSuccess = ^(NSString * _Nonnull name) {
                NSMutableArray *oneArray = self.dataArray.firstObject;
                NSMutableDictionary *twoDic = oneArray.lastObject;
                twoDic[@"subTitle"] = name;
                [weakSelf.tableView reloadData];
            };
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
        
    }else {
        
        if (indexPath.row == 0) {
            HHEditMobileViewController *vc = [[HHEditMobileViewController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }else if(indexPath.row == 1) {
            WeakSelf(weakSelf)
            UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
            self.bottomView = [[XLSetupBirthdayView alloc] init];
            self.bottomView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
            self.bottomView.clickCancelAction = ^{
                [weakSelf.bottomView removeFromSuperview];
            };
            self.bottomView.clickDoneAction = ^(NSString * _Nonnull birthday) {
                [weakSelf.bottomView removeFromSuperview];
                [weakSelf brithdayAction:birthday];
            };
            [keyWindow addSubview:self.bottomView];
            [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.top.bottom.offset(0);
            }];
        }else {
            [self sexAction];
        }
    }
    
}

- (void)brithdayAction:(NSString *)birthday {
    
    NSString *url = [NSString stringWithFormat:@"%@/user/modify",BASE_URL];
    NSMutableDictionary *dic = @{}.mutableCopy;
    [dic setValue:birthday forKey:@"user_birth"];
    [PPHTTPRequest requestPostWithJSONForUrl:url parameters:dic success:^(id  _Nonnull response) {
        
        NSString *code = [NSString stringWithFormat:@"%@", response[@"code"]];
        if ([code isEqualToString:@"0"]) {//请求成功
            NSDictionary *data = response[@"data"];
            NSString *user_birth = data[@"user_birth"];
            
            NSMutableArray *twoArray = self.dataArray.lastObject;
            NSMutableDictionary *twoDic = twoArray[1];
            twoDic[@"subTitle"] = user_birth;
            [self.tableView reloadData];
            
        } else {
            [self.view makeToast:response[@"msg"] duration:2 position:CSToastPositionCenter];
        }
    } failure:^(NSError * _Nonnull error) {
        
    }];
}
- (void)sexAction {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil  message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *act1 = [UIAlertAction actionWithTitle:@"男" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.sexStr = @"1";
        [self updateSex];
    }];
    [act1 setValue:XLColor_mainTextColor forKey:@"titleTextColor"];
    [alert addAction:act1];
    
    UIAlertAction *act2 = [UIAlertAction actionWithTitle:@"女" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.sexStr = @"2";
        [self updateSex];
    }];
    [act2 setValue:XLColor_mainTextColor forKey:@"titleTextColor"];
    [alert addAction:act2];
    
    UIAlertAction *act3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [act3 setValue:XLColor_mainTextColor forKey:@"titleTextColor"];
    [alert addAction:act3];
    alert.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:alert animated:true completion:nil];
}

- (void)updateSex {
    NSString *url = [NSString stringWithFormat:@"%@/user/modify",BASE_URL];
    NSMutableDictionary *dic = @{}.mutableCopy;
    [dic setValue:self.sexStr forKey:@"sex"];
    [PPHTTPRequest requestPostWithJSONForUrl:url parameters:dic success:^(id  _Nonnull response) {
        
        NSString *code = [NSString stringWithFormat:@"%@", response[@"code"]];
        if ([code isEqualToString:@"0"]) {//请求成功
            NSDictionary *data = response[@"data"];
            NSString *sex = [NSString stringWithFormat:@"%@",data[@"sex"]];
            NSMutableArray *twoArray = self.dataArray.lastObject;
            NSMutableDictionary *twoDic = twoArray.lastObject;
            twoDic[@"subTitle"] = sex;
            [self.tableView reloadData];
            
        } else {
            [self.view makeToast:response[@"msg"] duration:2 position:CSToastPositionCenter];
        }
    } failure:^(NSError * _Nonnull error) {
        
    }];
    
}
- (void)headAction {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil  message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *act1 = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePickerController.delegate = self;
        imagePickerController.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:imagePickerController animated:YES completion:nil];
    }];
    [act1 setValue:XLColor_mainTextColor forKey:@"titleTextColor"];
    [alert addAction:act1];
    
    UIAlertAction *act2 = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController *imgPicker = [[UIImagePickerController alloc] init];
        //指定sourceType为拍照
        imgPicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        imgPicker.delegate = self;
        imgPicker.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:imgPicker animated:YES completion:nil];
    }];
    [act2 setValue:XLColor_mainTextColor forKey:@"titleTextColor"];
    [alert addAction:act2];
    
    UIAlertAction *act3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [act3 setValue:XLColor_mainTextColor forKey:@"titleTextColor"];
    [alert addAction:act3];
    alert.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:alert animated:true completion:nil];
}

#pragma mark - ----------UIImagePickerController delegate--------
//相册选取完成调用的协议方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    NSString *mediaType = info[UIImagePickerControllerMediaType];
    
    if ([mediaType isEqualToString:@"public.image"]) {
        
        UIImage *img = info[UIImagePickerControllerOriginalImage];
        
        [self updateHeadImage:img];
        
        //判断照片是否来自摄像头
        if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
            //保存到相册
            UIImageWriteToSavedPhotosAlbum(img, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        }
        
    }else if([mediaType isEqualToString:@"public.movie"]) {
        //处理选取视频...
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    //    XLLogInfo(@"保存相册成功...");
}
//取消按钮的点击事件
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    //    XLLogInfo(@"取消");
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -------------------上传头像-----------------
- (void)updateHeadImage:(UIImage *)img {
    NSData *imageData = UIImageJPEGRepresentation(img, 0.5);
    
    [[AliUpLoadImageTool shareIncetance] upLoadImageWithfileType:@"user_head_imgs" Pamgamar:@{} imageData:imageData success:^(NSString * _Nonnull objectKey) {
        
        NSString *url = [NSString stringWithFormat:@"%@/user/modify",BASE_URL];
        NSMutableDictionary *dic = @{}.mutableCopy;
        [dic setValue:objectKey forKey:@"user_head_img"];
        [PPHTTPRequest requestPostWithJSONForUrl:url parameters:dic success:^(id  _Nonnull response) {
            NSLog(@"头像上传结果====%@",response);
            NSString *code = [NSString stringWithFormat:@"%@", response[@"code"]];
            
            if ([code isEqualToString:@"0"]) {//请求成功
                NSDictionary *data = response[@"data"];
                NSString *user_head_img = data[@"user_head_img"];
                NSMutableArray *oneArray = self.dataArray.firstObject;
                NSMutableDictionary *oneDic = oneArray.firstObject;
                oneDic[@"subTitle"] = user_head_img;
                [self.tableView reloadData];
                
                [UserInfoManager sharedInstance].headImageStr = user_head_img;
                [UserInfoManager synchronize];
            } else {
                [self.view makeToast:response[@"msg"] duration:2 position:CSToastPositionCenter];
            }
        } failure:^(NSError * _Nonnull error) {
            
        }];
        
        
    } faile:^(NSError * _Nonnull error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view makeToast:@"网络异常，请检查网络后重试" duration:2 position:CSToastPositionCenter];
        });
    }];
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
        [_tableView registerClass:[HHPersonalInformationTableViewCell class] forCellReuseIdentifier:@"HHPersonalInformationTableViewCell"];
    }
    return _tableView;
}
@end
