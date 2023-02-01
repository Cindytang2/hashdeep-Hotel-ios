//
//  UserInfoManager.m
//  linlinlin
//
//  Created by yqm on 2020/6/11.
//  Copyright © 2020 yqm. All rights reserved.
//

#import "UserInfoManager.h"

@implementation UserInfoManager

#define kEncodedObjectPath_User ([[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"UserInfoManager"])

+ (instancetype)sharedInstance  {
   static UserInfoManager *single = nil;
   static dispatch_once_t onceToken;
   dispatch_once(&onceToken, ^{
      if([UserInfoManager isLogIn]) {
           single = [NSKeyedUnarchiver unarchiveObjectWithFile:kEncodedObjectPath_User];
       } else {
           single = [[UserInfoManager alloc] init];
       }
    });
   return single;
}

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"userID" : @"id",
             @"userMobile" : @"mobile",
             @"userHeadImage" : @"headImg",
             @"age" : @"ageTag",
             @"sex" : @"sex",
             @"true_name" : @"realName",
             @"birthday" : @"birthday",
             @"userNickName" : @"nickname"};
}

+ (BOOL)synchronize  {
   return [NSKeyedArchiver archiveRootObject:[UserInfoManager sharedInstance] toFile:kEncodedObjectPath_User];
}

+ (BOOL)isLogIn  {
   NSFileManager *fileManager = [NSFileManager defaultManager];
   return [fileManager fileExistsAtPath:kEncodedObjectPath_User];
}
 
+ (BOOL)logout  {
    
    UserInfoManager.sharedInstance.jwtToken = @"";
    [UserInfoManager sharedInstance].im_account = @"";
    [UserInfoManager sharedInstance].im_sign = @"";
    [UserInfoManager sharedInstance].refresh_token = @"";
    [UserInfoManager synchronize];
    
   NSFileManager *fileManager = [NSFileManager defaultManager];
   NSError *error;
   BOOL result = [fileManager removeItemAtPath:kEncodedObjectPath_User error:&error];
   if(!result){
    }
   return result;
}

//把一个对象从解码器中取出

- (id)initWithCoder:(NSCoder *)aDecoder  {
   self = [super init];
    if(self) {
       [self yy_modelInitWithCoder:aDecoder];
    }
   return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder  {
   [self yy_modelEncodeWithCoder:aCoder];

}
+ (void)removeInfo{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"token"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"id"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"mobile"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"headImg"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"nickname"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"birthday"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"im_account"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"im_sign"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"refresh_token"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}


@end
 
 
