//
//  UserInfoManager.h
//  linlinlin
//
//  Created by yqm on 2020/6/11.
//  Copyright © 2020 yqm. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UserInfoManager : NSObject
@property (nonatomic, copy) NSString *im_account;
@property (nonatomic, copy) NSString *im_sign;
@property (nonatomic, copy) NSString *userID;   //用户ID
@property (nonatomic, copy) NSString *mobile; // 手机号
@property (nonatomic, copy) NSString *headImageStr; //头像地址
@property (nonatomic, copy) NSString *sex; //性别
@property (nonatomic, copy) NSString *birthday; //生日
@property (nonatomic, copy) NSString *userNickName; //昵称
@property (nonatomic, copy) NSString *jwtToken; // 自己服务器的token
@property (nonatomic, copy) NSString *latitude;//维度
@property (nonatomic, copy) NSString *longitude;//经度
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *refresh_token;

//用户模型单例
+ (instancetype)sharedInstance;

 //存储用户信息
+ (BOOL)synchronize;

 //是否登录
+ (BOOL)isLogIn;

//退出App 
+ (BOOL)logout;
+ (void)removeInfo;

@end

NS_ASSUME_NONNULL_END
