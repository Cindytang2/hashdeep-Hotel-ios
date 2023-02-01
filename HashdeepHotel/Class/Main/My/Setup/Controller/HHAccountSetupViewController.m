//
//  HHAccountSetupViewController.m
//  HashdeepHotel
//
//  Created by Cindy on 2022/7/12.
//

#import "HHAccountSetupViewController.h"
#import "HHAccountSetupTableViewCell.h"
#import "HHAccountModel.h"
#import "RSA.h"
#import "HGAppLoginTool.h"
#import "HHUnbindingView.h"
#import <AlipaySDK/AlipaySDK.h>
#import <AuthenticationServices/AuthenticationServices.h>///苹果登录按钮
@interface HHAccountSetupViewController ()<UITableViewDelegate,UITableViewDataSource,ASAuthorizationControllerDelegate,ASAuthorizationControllerPresentationContextProviding>
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) HHUnbindingView *toastView;
@end

@implementation HHAccountSetupViewController
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
    
    //监听微信登录成功的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wxChatLoginNotification:) name:@"WXChatLoginSuccess" object:nil];
    
    self.dataArray = [NSMutableArray array];
    self.view.backgroundColor = RGBColor(243, 244, 247);
    
    //自定义导航栏
    [self _createdNavigationBar];
    
    //创建Views
    [self _createdViews];
    
    [self _loadData];
}

#pragma mark --------- 微信通知方法 ------
- (void)wxChatLoginNotification:(NSNotification *)aNotification{
    NSDictionary *diction = aNotification.userInfo;
    NSString *code = diction[@"code"];
    
    NSMutableDictionary *dic = @{}.mutableCopy;
    [dic setValue:@(1) forKey:@"login_type"];
    [dic setValue:code forKey:@"open_id"];
    
    //要加密的数据
    NSString *str = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:dic options:0 error:nil] encoding:NSUTF8StringEncoding];
    //公钥
    NSString *publicKey = @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQC6qJw3LeebGRaBAfcJQoVAGLNcMK9dp7nhgyekcVqEvZnr+A2XibnGPgwYULb+04f0vZWWBwhqcHY2NH3DK3mceNihIvZAtxbv4vkH4LXwkdw5QAetlK2KsI+WWe3ElV7y7RQtqsdTpXYV1DHMg9iGk+ZGNH/M6KZYCnFPWS2TJwIDAQAB";
    //公钥加密
    NSString *encryptStr = [RSA encryptString:str publicKey:publicKey];
    
    NSString *url = [NSString stringWithFormat:@"%@/user/third/party/custom/bind",BASE_URL];
    NSMutableDictionary *dictionary = @{}.mutableCopy;
    [dictionary setValue:@(1) forKey:@"bind_type"];
    [dictionary setValue:encryptStr forKey:@"bind_token"];
    [PPHTTPRequest requestPostWithJSONForUrl:url parameters:dictionary success:^(id  _Nonnull response) {
        
        NSLog(@"微信绑定结果====%@",response);
        NSString *code = [NSString stringWithFormat:@"%@", response[@"code"]];
        if ([code isEqualToString:@"0"]) {//请求成功
            [self.view makeToast:@"绑定成功" duration:1 position:CSToastPositionCenter];
            HHAccountModel *model = self.dataArray.firstObject;
            model.is_bind = YES;
            [self.tableView reloadData];
        } else {
            [self.view makeToast:response[@"msg"] duration:2 position:CSToastPositionCenter];
        }
    } failure:^(NSError * _Nonnull error) {
        
    }];
    
}

- (void)_loadData {
    NSString *url = [NSString stringWithFormat:@"%@/user/third/party/list",BASE_URL];
    
    [PPHTTPRequest requestGetWithURL:url parameters:@{} success:^(id  _Nonnull response) {
        NSLog(@"账户设置=====%@",response);
        NSString *code = [NSString stringWithFormat:@"%@", response[@"code"]];
        if ([code isEqualToString:@"0"]) {//请求成功
            NSArray *data = response[@"data"];
            
            if (@available(iOS 13.0, *)) {
                
                for (int i=0; i<data.count; i++) {
                    NSDictionary *dii = data[i];
                    HHAccountModel *model = [[HHAccountModel alloc]init];
                    model.name = dii[@"name"];
                    model.type = [NSString stringWithFormat:@"%@",dii[@"type"]].integerValue;
                    model.is_bind = [NSString stringWithFormat:@"%@",dii[@"is_bind"]].boolValue;
                    [self.dataArray addObject:model];
                }
                
            } else {
                for (int i=0; i<data.count-1; i++) {
                    NSDictionary *dii = data[i];
                    HHAccountModel *model = [[HHAccountModel alloc]init];
                    model.name = dii[@"name"];
                    model.type = [NSString stringWithFormat:@"%@",dii[@"type"]].integerValue;
                    model.is_bind = [NSString stringWithFormat:@"%@",dii[@"is_bind"]].boolValue;
                    [self.dataArray addObject:model];
                }
            }
            
            [self.tableView reloadData];
            
        } else {
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
    titleLabel.text = @"账户设置";
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
    topLabel.text = @"你可以通过以下方式登录安住会";
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
    
    HHAccountSetupTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HHAccountSetupTableViewCell" forIndexPath:indexPath];
    if(cell ==nil){
        cell =[[HHAccountSetupTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"HHAccountSetupTableViewCell"];
    }
    cell.model = self.dataArray[indexPath.row];
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
    return 55;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

//单元格点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HHAccountModel *model = self.dataArray[indexPath.row];
    if (@available(iOS 13.0, *)) {
        
        if (indexPath.row == 0) {//微信
            if([[HGAppLoginTool sharedInstance] isWXAppInstalled] == YES){//有微信
                [self wechatAction:model];
            }else{//没有微信
                [self.view makeToast:@"微信未安装，请安装后重试" duration:2 position:CSToastPositionCenter];
                return;
            }
            
        }else if(indexPath.row == 1){//支付宝
            
            NSURL * url = [NSURL URLWithString:@"alipay://"];//注意设置白名单
            if (![[UIApplication sharedApplication]canOpenURL:url]) {//未安装
                [self.view makeToast:@"支付宝未安装，请安装后重试" duration:2 position:CSToastPositionCenter];
                return;
            }else {
                [self alipayAction:model];
            }
            
        }else {//苹果登录
            [self appleAction:model];
        }
        
    } else {
        if (indexPath.row == 0) {//微信
            if([[HGAppLoginTool sharedInstance] isWXAppInstalled] == YES){//有微信
                [self wechatAction:model];
            }else{//没有微信
                [self.view makeToast:@"微信未安装，请安装后重试" duration:2 position:CSToastPositionCenter];
                return;
            }
        }else {//支付宝
            NSURL * url = [NSURL URLWithString:@"alipay://"];//注意设置白名单
            if (![[UIApplication sharedApplication]canOpenURL:url]) {//未安装
                [self.view makeToast:@"支付宝未安装，请安装后重试" duration:2 position:CSToastPositionCenter];
                return;
            }else {
                [self alipayAction:model];
            }
        }
    }
    
}
- (void)appleAction:(HHAccountModel *)model {
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    WeakSelf(weakSelf)
    if(model.is_bind){//已绑定
        self.toastView = [[HHUnbindingView alloc] init];
        self.toastView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        self.toastView.subTitle = @"解除绑定后，您将无法使用苹果快捷登录安住会或享受相关服务。确定要解绑吗？";
        self.toastView.clickCancelAction = ^{
            [weakSelf.toastView removeFromSuperview];
        };
        self.toastView.clickDoneAction = ^{
            [weakSelf.toastView removeFromSuperview];
            [weakSelf _loadUnbinding:3];
        };
        [keyWindow addSubview:self.toastView];
        [self.toastView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.bottom.offset(0);
        }];
    }else {
        if (@available(iOS 13.0, *)) {
            ASAuthorizationAppleIDProvider *appleIDProvider = [[ASAuthorizationAppleIDProvider alloc] init];
            ASAuthorizationAppleIDRequest *appleIDRequest = [appleIDProvider createRequest];
            // 用户授权请求的联系信息
            appleIDRequest.requestedScopes = @[ASAuthorizationScopeFullName, ASAuthorizationScopeEmail];
            ASAuthorizationController *authorizationController = [[ASAuthorizationController alloc] initWithAuthorizationRequests:@[appleIDRequest]];
            // 设置授权控制器通知授权请求的成功与失败的代理
            authorizationController.delegate = self;
            // 设置提供 展示上下文的代理，在这个上下文中 系统可以展示授权界面给用户
            authorizationController.presentationContextProvider = self;
            // 在控制器初始化期间启动授权流
            [authorizationController performRequests];
            
        }
    }
    
}

- (void)alipayAction:(HHAccountModel *)model {
    
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    WeakSelf(weakSelf)
    if(model.is_bind){//已绑定
        self.toastView = [[HHUnbindingView alloc] init];
        self.toastView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        self.toastView.subTitle = @"解除绑定后，您将无法使用支付宝快捷登录安住会或享受相关服务。确定要解绑吗？";
        self.toastView.clickCancelAction = ^{
            [weakSelf.toastView removeFromSuperview];
        };
        self.toastView.clickDoneAction = ^{
            [weakSelf.toastView removeFromSuperview];
            [weakSelf _loadUnbinding:2];
        };
        [keyWindow addSubview:self.toastView];
        [self.toastView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.bottom.offset(0);
        }];
    }else {
        NSString *url = [NSString stringWithFormat:@"%@/aly/auth",BASE_URL];
        [PPHTTPRequest requestGetWithURL:url parameters:@{} success:^(id  _Nonnull response) {
            
            NSString *code = [NSString stringWithFormat:@"%@", response[@"code"]];
            if ([code isEqualToString:@"0"]) {//请求成功
                NSString *data = response[@"data"];
                
                NSString *appScheme = @"HashdeepHotels";
                [[AlipaySDK defaultService] auth_V2WithInfo:data fromScheme:appScheme callback:^(NSDictionary *resultDic) {
                    NSLog(@"支付宝登录结果=====%@",resultDic);
                    NSString *result = resultDic[@"result"];
                    if(result.length != 0){
                        NSArray *arr = [result componentsSeparatedByString:@"alipay_open_id="];
                        NSArray *arr2 = [arr.lastObject componentsSeparatedByString:@"&user_id"];
                        
                        NSMutableDictionary *dic = @{}.mutableCopy;
                        [dic setValue:@(2) forKey:@"login_type"];
                        [dic setValue:arr2.firstObject forKey:@"open_id"];
                        
                        //要加密的数据
                        NSString *str = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:dic options:0 error:nil] encoding:NSUTF8StringEncoding];
                        //公钥
                        NSString *publicKey = @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQC6qJw3LeebGRaBAfcJQoVAGLNcMK9dp7nhgyekcVqEvZnr+A2XibnGPgwYULb+04f0vZWWBwhqcHY2NH3DK3mceNihIvZAtxbv4vkH4LXwkdw5QAetlK2KsI+WWe3ElV7y7RQtqsdTpXYV1DHMg9iGk+ZGNH/M6KZYCnFPWS2TJwIDAQAB";
                        //公钥加密
                        NSString *encryptStr = [RSA encryptString:str publicKey:publicKey];
                        
                        NSString *bindUrl = [NSString stringWithFormat:@"%@/user/third/party/custom/bind",BASE_URL];
                        NSMutableDictionary *dictionary = @{}.mutableCopy;
                        [dictionary setValue:@(1) forKey:@"bind_type"];
                        [dictionary setValue:encryptStr forKey:@"bind_token"];
                        [PPHTTPRequest requestPostWithJSONForUrl:bindUrl parameters:dictionary success:^(id  _Nonnull response) {
                            
                            NSLog(@"支付宝绑定结果====%@",response);
                            NSString *code = [NSString stringWithFormat:@"%@", response[@"code"]];
                            if ([code isEqualToString:@"0"]) {//请求成功
                                [self.view makeToast:@"绑定成功" duration:1 position:CSToastPositionCenter];
                                HHAccountModel *model = self.dataArray[1];
                                model.is_bind = YES;
                                [self.tableView reloadData];
                            } else {
                                [self.view makeToast:response[@"msg"] duration:2 position:CSToastPositionCenter];
                            }
                        } failure:^(NSError * _Nonnull error) {
                            
                        }];
                    }
                    
                }];
            }else {
                [self.view makeToast:response[@"msg"] duration:2 position:CSToastPositionCenter];
            }
            
        } failure:^(NSError * _Nonnull error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.view makeToast:@"网络异常，请检查网络后重试" duration:2 position:CSToastPositionCenter];
            });
        }];
    }
    
    
}
- (void)wechatAction:(HHAccountModel *)model {
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    WeakSelf(weakSelf)
    if(model.is_bind){//已绑定
        self.toastView = [[HHUnbindingView alloc] init];
        self.toastView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        self.toastView.subTitle = @"解除绑定后，您将无法使用微信快捷登录安住会或享受相关服务。确定要解绑吗？";
        self.toastView.clickCancelAction = ^{
            [weakSelf.toastView removeFromSuperview];
        };
        self.toastView.clickDoneAction = ^{
            [weakSelf.toastView removeFromSuperview];
            [weakSelf _loadUnbinding:1];
        };
        [keyWindow addSubview:self.toastView];
        [self.toastView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.bottom.offset(0);
        }];
    }else {
        [HGAppLoginTool sharedInstance].type = HGLoginTypeWeChatLogin;
        [[HGAppLoginTool sharedInstance] wechatLogin];
    }
}

- (void)_loadUnbinding:(NSInteger )login_type {
    
    NSMutableDictionary *dic = @{}.mutableCopy;
    [dic setValue:@(login_type) forKey:@"login_type"];
    [dic setValue:@"" forKey:@"open_id"];
    
    //要加密的数据
    NSString *str = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:dic options:0 error:nil] encoding:NSUTF8StringEncoding];
    //公钥
    NSString *publicKey = @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQC6qJw3LeebGRaBAfcJQoVAGLNcMK9dp7nhgyekcVqEvZnr+A2XibnGPgwYULb+04f0vZWWBwhqcHY2NH3DK3mceNihIvZAtxbv4vkH4LXwkdw5QAetlK2KsI+WWe3ElV7y7RQtqsdTpXYV1DHMg9iGk+ZGNH/M6KZYCnFPWS2TJwIDAQAB";
    //公钥加密
    NSString *encryptStr = [RSA encryptString:str publicKey:publicKey];
    
    NSString *url = [NSString stringWithFormat:@"%@/user/third/party/custom/bind",BASE_URL];
    NSMutableDictionary *dictionary = @{}.mutableCopy;
    [dictionary setValue:@(2) forKey:@"bind_type"];
    [dictionary setValue:encryptStr forKey:@"bind_token"];
    [PPHTTPRequest requestPostWithJSONForUrl:url parameters:dictionary success:^(id  _Nonnull response) {
        
        NSLog(@"解绑结果====%@",response);
        NSString *code = [NSString stringWithFormat:@"%@", response[@"code"]];
        if ([code isEqualToString:@"0"]) {//请求成功
            [self.view makeToast:@"解绑成功" duration:1 position:CSToastPositionCenter];
            HHAccountModel *model;
            if (@available(iOS 13.0, *)) {
                if(login_type == 1){
                    model = self.dataArray.firstObject;
                }else if(login_type ==2){
                    model = self.dataArray[1];
                }else {
                    model = self.dataArray.lastObject;
                }
                
            }else {
                if(login_type == 1){
                    model = self.dataArray.firstObject;
                }else {
                    model = self.dataArray.lastObject;
                }
            }
            
            model.is_bind = NO;
            [self.tableView reloadData];
            
        } else {
            [self.view makeToast:response[@"msg"] duration:2 position:CSToastPositionCenter];
        }
    } failure:^(NSError * _Nonnull error) {
        
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
        [_tableView registerClass:[HHAccountSetupTableViewCell class] forCellReuseIdentifier:@"HHAccountSetupTableViewCell"];
    }
    return _tableView;
}

#pragma mark- ASAuthorizationControllerDelegate
- (void)authorizationController:(ASAuthorizationController *)controller didCompleteWithAuthorization:(ASAuthorization *)authorization  API_AVAILABLE(ios(13.0)){
    
    if ([authorization.credential isKindOfClass:[ASAuthorizationAppleIDCredential class]]) {
        // 用户登录使用ASAuthorizationAppleIDCredential
        ASAuthorizationAppleIDCredential *appleIDCredential = (ASAuthorizationAppleIDCredential *)authorization.credential;
        NSDictionary *params = @{
            @"openId": appleIDCredential.user ?: @"",
            @"phoneNo": @"",
            @"nickName": appleIDCredential.fullName.nickname ?:@"",
            @"familyName": appleIDCredential.fullName.familyName ?:@"",
            @"givenName": appleIDCredential.fullName.givenName ?:@"",
            @"email": appleIDCredential.email ?:@"",
            @"avatar": @"",
            @"gender": @(0),
            @"accountType": @(0),
        };
        
        [self loginWithParams:params and:HGLoginTypeAppleLogin];
        
        //NSString *user = appleIDCredential.user;
        // 使用过授权的，可能获取不到以下三个参数
        //NSString *familyName = appleIDCredential.fullName.familyName;
        //NSString *givenName = appleIDCredential.fullName.givenName;
        //NSString *email = appleIDCredential.email;
        
    } else if ([authorization.credential isKindOfClass:[ASPasswordCredential class]]) {
        // 用户登录使用现有的密码凭证（iCloud记录的）
        ASPasswordCredential *passwordCredential = (ASPasswordCredential *)authorization.credential;
        // 密码凭证对象的用户标识 用户的唯一标识
        //NSString *user = passwordCredential.user;
        // 密码凭证对象的密码
        //NSString *password = passwordCredential.password;
        NSDictionary *params = @{
            @"user": passwordCredential.user ?: @"",
            @"password": passwordCredential.password ?:@""
        };
        [self loginWithParams:params and:HGLoginTypeAppleLogin];
    } else {
        NSLog(@"授权信息均不符");
    }
}

#pragma mark -------------苹果授权回调后发起登录请求----------
- (void)loginWithParams:(NSDictionary *)params and:(HGLoginType)thirdLoinType{
    NSLog(@"授权信息%@",params);
    NSMutableDictionary *dic = @{}.mutableCopy;
    [dic setValue:@(3) forKey:@"login_type"];
    [dic setValue:params[@"openId"] forKey:@"open_id"];
    
    //要加密的数据
    NSString *str = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:dic options:0 error:nil] encoding:NSUTF8StringEncoding];
    //公钥
    NSString *publicKey = @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQC6qJw3LeebGRaBAfcJQoVAGLNcMK9dp7nhgyekcVqEvZnr+A2XibnGPgwYULb+04f0vZWWBwhqcHY2NH3DK3mceNihIvZAtxbv4vkH4LXwkdw5QAetlK2KsI+WWe3ElV7y7RQtqsdTpXYV1DHMg9iGk+ZGNH/M6KZYCnFPWS2TJwIDAQAB";
    //公钥加密
    NSString *encryptStr = [RSA encryptString:str publicKey:publicKey];
    
    NSString *bindUrl = [NSString stringWithFormat:@"%@/user/third/party/custom/bind",BASE_URL];
    NSMutableDictionary *dictionary = @{}.mutableCopy;
    [dictionary setValue:@(1) forKey:@"bind_type"];
    [dictionary setValue:encryptStr forKey:@"bind_token"];
    [PPHTTPRequest requestPostWithJSONForUrl:bindUrl parameters:dictionary success:^(id  _Nonnull response) {
        
        NSLog(@"苹果绑定结果====%@",response);
        NSString *code = [NSString stringWithFormat:@"%@", response[@"code"]];
        if ([code isEqualToString:@"0"]) {//请求成功
            [self.view makeToast:@"绑定成功" duration:1 position:CSToastPositionCenter];
            HHAccountModel *model = self.dataArray.lastObject;
            model.is_bind = YES;
            [self.tableView reloadData];
        } else {
            [self.view makeToast:response[@"msg"] duration:2 position:CSToastPositionCenter];
        }
    } failure:^(NSError * _Nonnull error) {
        
    }];
    
}

- (void)authorizationController:(ASAuthorizationController *)controller didCompleteWithError:(NSError *)error API_AVAILABLE(ios(13.0)) {
    
    NSString *errorMsg = nil;
    switch (error.code) {
        case ASAuthorizationErrorCanceled:
            errorMsg = @"用户取消了授权请求";
            break;
        case ASAuthorizationErrorFailed:
            errorMsg = @"授权请求失败";
            break;
        case ASAuthorizationErrorInvalidResponse:
            errorMsg = @"授权请求响应无效";
            break;
        case ASAuthorizationErrorNotHandled:
            errorMsg = @"未能处理授权请求";
            break;
        case ASAuthorizationErrorUnknown:
            errorMsg = @"授权请求失败未知原因";
            break;
            
        default:
            break;
    }
    if(errorMsg){
        [MBProgressHUD showError:errorMsg];
    }
}

#pragma mark- ASAuthorizationControllerPresentationContextProviding
- (ASPresentationAnchor)presentationAnchorForAuthorizationController:(ASAuthorizationController *)controller  API_AVAILABLE(ios(13.0)){
    UIViewController *vc = [HHAppManage getCurrentVC];
    return vc.view.window;
}
#pragma mark- apple授权状态 更改通知
- (void)handleSignInWithAppleStateChanged:(NSNotification *)notification{
    NSLog(@"%@", notification.userInfo);
}

@end
