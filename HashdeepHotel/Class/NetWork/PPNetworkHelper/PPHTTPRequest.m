//
//  PPHTTPRequest.m
//  PPNetworkHelper
//
//  Created by AndyPang on 2017/4/10.
//  Copyright © 2017年 AndyPang. All rights reserved.
//

#import "PPHTTPRequest.h"
#import <CommonCrypto/CommonDigest.h>
#import "HHVerificationCodeLoginViewController.h"
#import "HHMainTabBarViewController.h"
#import "HHNavigationBarViewController.h"
NSString *const kApiPrefix = BASE_URL;
BOOL currentVCisLogin;

@implementation PPHTTPRequest
+ (NSURLSessionTask *)requestPostWithJSONForUrl:(NSString *)urlStr parameters:(NSDictionary *)parameters success:(PPRequestSuccess)success failure:(PPRequestFailure)failure {
    NSString *jsonString = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:parameters options:0 error:nil] encoding:NSUTF8StringEncoding];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURL *url = [NSURL URLWithString: urlStr];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"IOS" forHTTPHeaderField:@"From"];
    NSString *strToken = [UserInfoManager sharedInstance].jwtToken;
    if (strToken.length != 0) {
        strToken = [NSString stringWithFormat:@"Bearer %@",strToken];
        [request setValue: strToken forHTTPHeaderField:@"Authorization"];
    }else {
        //        [request setValue: @"Basic bWFsbC1hcHA6MTIzNDU2" forHTTPHeaderField:@"Authorization"];
    }
    NSLog(@"refresh_token================%@",[UserInfoManager sharedInstance].refresh_token);
    [request setValue: [UserInfoManager sharedInstance].refresh_token forHTTPHeaderField:@"Refresh-Token"];
    NSData *dataJson = [NSData data];
    dataJson = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    request.HTTPBody = dataJson;
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
//                [keyWindow makeToast:@"网络异常，请检查网络后重试" duration:2 position:CSToastPositionCenter];
            });
            failure(error);
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                id response = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                NSString *code = [NSString stringWithFormat:@"%@", response[@"code"]];
              if ([code isEqualToString:@"401"]) {
                    NSLog(@"没登录呀======%@",urlStr);
                    [UserInfoManager sharedInstance].jwtToken = @"";
                    [UserInfoManager synchronize];
                    [self login];
                    return;
                }else {
                    success (response);
                }
            });
        }
    }];
    [task resume];
    return task ;
}

+ (void)login {
    if (!currentVCisLogin) {
        [UMCommonHandler checkEnvAvailableWithAuthType:UMPNSAuthTypeLoginToken complete:^(NSDictionary*_Nullable resultDic){
            BOOL isSupport =[PNSCodeSuccess isEqualToString:[resultDic objectForKey:@"resultCode"]];
            if(isSupport) {
                [HGAppInitManager umQuickPhoneLoginVC:[HHAppManage getCurrentVC] complete:^(NSString * quickLoginStutas) {
                    currentVCisLogin = NO;
                }];
                
            }else {
                HHMainTabBarViewController *vc = (HHMainTabBarViewController *)[HHAppManage getCurrentVC];
                HHVerificationCodeLoginViewController *loginVC = [[HHVerificationCodeLoginViewController alloc] init];
                loginVC.loginSuccessAction = ^{
                    currentVCisLogin = NO;
                };
                loginVC.loginCancelAction = ^{
                    currentVCisLogin = NO;
                };
                loginVC.hidesBottomBarWhenPushed = YES;   //隐藏Tabbar
                HHNavigationBarViewController *loginNav = [[HHNavigationBarViewController alloc] initWithRootViewController:loginVC];   //使登陆界面的Navigationbar可以显示出来
                loginNav.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
                loginNav.modalPresentationStyle = UIModalPresentationFullScreen;
                [((UINavigationController *)vc.selectedViewController) presentViewController:loginNav animated:YES completion:nil]; //跳转登陆界面
            }
        }];
        
        
    }
    
}

+ (NSString *)randomHexLittleString {
    char data[32];
    for (int x=0;x<32;data[x++] = (char)('A'+ (arc4random_uniform(26))));
    return [[NSString alloc] initWithBytes:data length:32 encoding:NSUTF8StringEncoding];
}

// 业务中具体使用
+ (NSString *) _dictionaryToJson:(NSDictionary *)dic{
    NSError *error = nil;
    NSData *jsonData ;
    NSString *jsonString;
    if (@available(iOS 11.0, *)) {
        jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingSortedKeys error:&error];
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    } else {
        
    }
    return jsonString;
}

+ (NSString*)getCurrentTimes{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    //现在时间,你可以输出来看下是什么格式
    
    NSDate *datenow = [NSDate date];
    
    //----------将nsdate按formatter格式转成nsstring
    
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    
    NSLog(@"currentTimeString =  %@",currentTimeString);
    
    return currentTimeString;
    
}
/// md5加密
+ (NSString*)kj_bannerMD5WithString:(NSString*)string{
    const char *original_str = [string UTF8String];
    unsigned char digist[CC_MD5_DIGEST_LENGTH]; //CC_MD5_DIGEST_LENGTH = 16
    CC_MD5(original_str, (uint)strlen(original_str), digist);
    NSMutableString *outPutStr = [NSMutableString stringWithCapacity:10];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++){
        [outPutStr appendFormat:@"%02X", digist[i]];//小写x表示输出的是小写MD5，大写X表示输出的是大写MD5
    }
    return [outPutStr lowercaseString];
}

+ (NSURLSessionTask *)requestGetWithURL:(NSString *)urlStr parameters:(NSDictionary *)parameter success:(PPRequestSuccess)success failure:(PPRequestFailure)failure {
    NSData *dataJson = [NSData data];
    NSDictionary *json = parameter ;
    NSMutableString *jsonStr = [NSMutableString string];
    NSString *strJson;
    if (json.allKeys.count != 0) {
        for ( id key in json ) {
            [jsonStr appendFormat:@"%@=%@&", key, [ json objectForKey:key ]];
        }
        
        if (jsonStr.length > 1) {
            strJson = [jsonStr substringToIndex: jsonStr.length - 1];
        }
        strJson = [strJson stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"#%^{}\"[]|\\<> "].invertedSet];
        dataJson = [ strJson dataUsingEncoding:NSUTF8StringEncoding];
        urlStr = [NSString stringWithFormat:@"%@?%@",urlStr,strJson];
    }
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURL *url = [NSURL URLWithString: urlStr];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"GET";
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"IOS" forHTTPHeaderField:@"From"];
    NSString *strToken = [UserInfoManager sharedInstance].jwtToken;
    if (strToken.length != 0) {
        strToken = [NSString stringWithFormat:@"Bearer %@",strToken];
        [request setValue: strToken forHTTPHeaderField:@"Authorization"];
    }
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            failure(error);
        }else {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                id response = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                NSString *code = [NSString stringWithFormat:@"%@", response[@"code"]];
                
                if ([code isEqualToString:@"401"]) {
                    [UserInfoManager sharedInstance].jwtToken = @"";
                    [UserInfoManager synchronize];
                    [self login];
                    
                    return;
                }else {
                    success (response);
                }
            });
        }
    }];
    [task resume];
    return task ;
}


@end
