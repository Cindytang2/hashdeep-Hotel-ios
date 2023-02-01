//
//  PPHTTPRequest.h
//  PPNetworkHelper
//
//  Created by AndyPang on 2017/4/10.
//  Copyright © 2017年 AndyPang. All rights reserved.
//

#import <Foundation/Foundation.h>

//#import "PPNetworkHelper.h"
NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger, kKPSourceType) {
    kKPSourceTypeUndifine   =   0,
    kKPSourceTypeImage      =   1,
    kKPSourceTypeVideo      =   2,
    kKPSourceTypeGif        =   3,
    kKPSourceTypeVoice      =   4,
    kKPSourceTypeTxt        =   5,
};

typedef void(^PPRequestSuccess)(id response);
typedef void(^PPRequestFailure)(NSError *error);


/// 上传回调
typedef void(^uploadCallblock)(BOOL success, NSString* msg, NSArray<NSString *>* keys);

@interface PPHTTPRequest : NSObject
+ (NSURLSessionTask *)requestPostWithJSONForUrl:(NSString *)urlStr parameters:(NSDictionary *)parameters success:(PPRequestSuccess)success failure:(PPRequestFailure)failure;

+ (NSURLSessionTask *)requestGetWithURL:(NSString *)urlStr parameters:(NSDictionary *)parameter success:(PPRequestSuccess)success failure:(PPRequestFailure)failure;


@end


NS_ASSUME_NONNULL_END
