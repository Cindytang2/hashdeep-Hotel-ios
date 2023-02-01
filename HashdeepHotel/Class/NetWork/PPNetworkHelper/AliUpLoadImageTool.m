//
//  AliUpLoadImageTool.m
//  Volunteer
//
//  Created by cindy on 2021/10/15.
//

#import "AliUpLoadImageTool.h"
#import <AliyunOSSiOS/OSSService.h>

@interface AliUpLoadImageTool ()
@property (nonatomic,strong) NSMutableArray *imageDataSourece;
@property (nonatomic,strong) NSMutableArray *videoDataSourece;
@end

@implementation AliUpLoadImageTool
+ (AliUpLoadImageTool *)shareIncetance {
    static AliUpLoadImageTool *tool_;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tool_ = [[AliUpLoadImageTool alloc] init];
    });
    return tool_;
}

- (NSMutableArray *)imageDataSourece {
    if (!_imageDataSourece) {
        _imageDataSourece = [[NSMutableArray alloc] init];
    }
    return _imageDataSourece;
}

- (NSMutableArray *)videoDataSourece {
    if (!_videoDataSourece) {
        _videoDataSourece = [[NSMutableArray alloc] init];
    }
    return _videoDataSourece;
}

-(void)upLoadImageWithfileType:(NSString *)fileType Pamgamar:(NSDictionary *)parmar imageData:(NSData *)imageData success:(void (^)(NSString *objectKey))successBlock faile:(void (^)(NSError *error))faile{
    
    //1.向服务器请求获取AccessKeyId AccessKeySecret SecurityToken
    NSString *url = [NSString stringWithFormat:@"%@/data/token",BASE_URL];
    NSMutableDictionary *dictionary = @{}.mutableCopy;
    [PPHTTPRequest requestGetWithURL:url parameters:dictionary success:^(id  _Nonnull response) {
        NSLog(@"请求获取AccessKeyId=====%@",response);
        NSString *code = [NSString stringWithFormat:@"%@", response[@"code"]];
        if ([code intValue] != 0) {
            return;
        }else {
            NSDictionary *data = response[@"data"];
            NSString *bucketName = data[@"bucket"];
            NSString *endpoint = data[@"endpoint"];
            NSString *stsAccessKeyId = data[@"accesskey_id"];
            NSString *stsAccessKeySecret = data[@"accesskey_secret"];
            NSString *stsSecurityToken = data[@"security_token"];
            
            id<OSSCredentialProvider> credential = [[OSSStsTokenCredentialProvider alloc] initWithAccessKeyId:stsAccessKeyId secretKeyId:stsAccessKeySecret securityToken:stsSecurityToken];
            OSSClientConfiguration * conf = [OSSClientConfiguration new];
            conf.maxRetryCount = 2;
            conf.timeoutIntervalForRequest = 30;
            conf.timeoutIntervalForResource = 24 * 60 * 60;
            conf.maxConcurrentRequestCount = 10;
            OSSClient *client = [[OSSClient alloc] initWithEndpoint:endpoint credentialProvider:credential clientConfiguration:conf];
            OSSPutObjectRequest * put = [OSSPutObjectRequest new];
            put.bucketName = bucketName;
            //当前时间
            NSInteger interval = (NSInteger)[[NSDate date]timeIntervalSince1970];
            UIImage *image = [UIImage imageWithData: imageData];
            NSInteger imageWidth = (kScreenWidth - 36)/2;
            NSInteger imageHeight = image.size.height *((kScreenWidth-36)/2/image.size.width);
            NSString *str = [NSString stringWithFormat:@"Frame_%ld_%ld_%ld.png",imageWidth,imageHeight,interval];
            NSString *objectKey = [NSString stringWithFormat:@"%@/%@",fileType,str];
            put.objectKey = objectKey;
            put.uploadingData = imageData; // 直接上传NSData
            OSSTask * putTask = [client putObject:put];
            // 上传阿里云
            [putTask continueWithBlock:^id(OSSTask *task) {
                task = [client presignPublicURLWithBucketName: bucketName withObjectKey:objectKey];
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (!task.error) {
                        
                        if (successBlock) {
                            successBlock(objectKey);
                        }
                    } else {
                        if (faile) {
                            faile(task.error);
                        }
                    }
                });
                return nil;
            }];
            
        }
    } failure:^(NSError * _Nonnull error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            UIViewController *vc = [HHAppManage getCurrentVC];
            for (UIView *view in vc.view.subviews ) {
                if (view.tag == 777) {
                    [view removeFromSuperview];
                }
            }
            
            UIView *view = [[UIView alloc] init];
            view.backgroundColor = kBlackColor;
            view.alpha = 0.7;
            view.layer.cornerRadius = 8;
            view.layer.masksToBounds = YES;
            view.tag = 777;
            [vc.view addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.offset(50);
                make.left.offset(50);
                make.right.offset(-50);
                make.centerY.equalTo(vc.view);
            }];
            
            UILabel *label = [[UILabel alloc] init];
            label.text = @"网络异常，请检查网络后重试";
            label.textColor = kWhiteColor;
            label.textAlignment = NSTextAlignmentCenter;
            label.font = XLFont_mainTextFont;
            [view addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.offset(0);
                make.left.offset(0);
                make.right.offset(0);
            }];
            
            [self performSelector:@selector(perform) withObject:nil afterDelay:1.5];
            
        });
    }];
    
}

/**
 这个方法用于上传多张图片到里云上
 fileType      文件类型 cert:证件； head: 头象； activity：活动
 @param imageDataArray 二进制图片数组
 @param parmar       这是参数是一个字典，直接将后台的字典传入
 @param successBlock 上传成功后的回调，你可以在这里处理UI
 @param faile        上传失败会走的回调
 */
- (void)upLoadMoreImageWithfileType:(NSString *)fileType Pamgamar:(NSDictionary *)parmar imageDataArray:(NSArray *)imageDataArray  success:(void (^)(NSArray *objectKeys))successBlock faile:(void (^)(NSError *error))faile{
    [self.imageDataSourece removeAllObjects];
    
    //1.向服务器请求获取AccessKeyId AccessKeySecret SecurityToken
    NSString *url = [NSString stringWithFormat:@"%@/data/token",BASE_URL];
    NSMutableDictionary *dictionary = @{}.mutableCopy;
    [PPHTTPRequest requestGetWithURL:url parameters:dictionary success:^(id  _Nonnull response) {
        NSLog(@"请求获取AccessKeyId=====%@",response);
        NSString *code = [NSString stringWithFormat:@"%@", response[@"code"]];
        if ([code intValue] != 0) {
            return;
        }else {
            NSDictionary *data = response[@"data"];
            NSString *bucketName = data[@"bucket"];
            NSString *endpoint = data[@"endpoint"];
            NSString *bucket_endpoint = data[@"bucket_endpoint"];
            NSString *stsAccessKeyId = data[@"accesskey_id"];
            NSString *stsAccessKeySecret = data[@"accesskey_secret"];
            NSString *stsSecurityToken = data[@"security_token"];
            
            id<OSSCredentialProvider> credential = [[OSSStsTokenCredentialProvider alloc] initWithAccessKeyId:stsAccessKeyId secretKeyId:stsAccessKeySecret securityToken:stsSecurityToken];
            OSSClientConfiguration * conf = [OSSClientConfiguration new];
            conf.maxRetryCount = 2;
            conf.timeoutIntervalForRequest = 30;
            conf.timeoutIntervalForResource = 24 * 60 * 60;
            conf.maxConcurrentRequestCount = 10;
            OSSClient *client = [[OSSClient alloc] initWithEndpoint:endpoint credentialProvider:credential clientConfiguration:conf];
            
            for (NSInteger i= 0; i<imageDataArray.count ; i ++) {
                [self.imageDataSourece addObject:@"notValue"];
                [self uploadOneImage:[imageDataArray objectAtIndex:i] bucket_endpoint:bucket_endpoint bucketName:bucketName fileKeyName:fileType oSSClient:client currentIndex:i  success:successBlock faile:faile];
            }
        }
    } failure:^(NSError * _Nonnull error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            UIViewController *vc = [HHAppManage getCurrentVC];
            for (UIView *view in vc.view.subviews ) {
                if (view.tag == 777) {
                    [view removeFromSuperview];
                }
            }
            
            UIView *view = [[UIView alloc] init];
            view.backgroundColor = kBlackColor;
            view.alpha = 0.7;
            view.layer.cornerRadius = 8;
            view.layer.masksToBounds = YES;
            view.tag = 777;
            [vc.view addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.offset(50);
                make.left.offset(50);
                make.right.offset(-50);
                make.centerY.equalTo(vc.view);
            }];
            
            UILabel *label = [[UILabel alloc] init];
            label.text = @"网络异常，请检查网络后重试";
            label.textColor = kWhiteColor;
            label.textAlignment = NSTextAlignmentCenter;
            label.font = XLFont_mainTextFont;
            [view addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.offset(0);
                make.left.offset(0);
                make.right.offset(0);
            }];
            
            [self performSelector:@selector(perform) withObject:nil afterDelay:1.5];
            
        });
    }];
}

- (void)perform {
    
    UIViewController *vc = [HHAppManage getCurrentVC];
    for (UIView *view in vc.view.subviews ) {
        if (view.tag == 777) {
            [view removeFromSuperview];
        }
    }
    return;
}

- (NSString *)qnFilePathConnectName{
    char data[16];//十六位防重字符
    for (int x=0;x<16;data[x++] = (char)('A' + (arc4random_uniform(26))));
    NSString *number = [[NSString alloc]initWithBytes:data length:16 encoding:NSUTF8StringEncoding];
    //当前时间
    NSInteger interval = (NSInteger)[[NSDate date]timeIntervalSince1970];
    
    NSString *name = [NSString stringWithFormat:@"%@/%ld.png",number,interval];
    
    return name;
}
- (void)uploadOneImage:(NSData *)imageData bucket_endpoint:(NSString *)bucket_endpoint bucketName:(NSString *)bucketName fileKeyName:(NSString *)fileKeyName oSSClient:(OSSClient *)client currentIndex:(NSInteger)index  success:(void (^)(NSArray *objectKeys))successBlock faile:(void (^)(NSError *))faile {
    OSSPutObjectRequest * put = [OSSPutObjectRequest new];
    put.bucketName = bucketName;
    
    NSString *str = [self qnFilePathConnectName];
    NSString *objectKey = [NSString stringWithFormat:@"%@/%@",fileKeyName,str];
    
    put.objectKey = objectKey;
    put.uploadingData = imageData; // 直接上传NSData
    OSSTask * putTask = [client putObject:put];
    // 上传阿里云
    [putTask continueWithBlock:^id(OSSTask *task) {
        task = [client presignPublicURLWithBucketName: bucketName withObjectKey:objectKey];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!task.error) {
                
                [self.imageDataSourece replaceObjectAtIndex:index withObject:objectKey];
                if (![self.imageDataSourece containsObject:@"notValue"]) {
                    NSMutableArray *arrM = [NSMutableArray array];
                    NSArray *array = [NSArray arrayWithArray:self.imageDataSourece];
                    for (int i=0; i<array.count; i++) {
                        NSString *str = [NSString stringWithFormat:@"%@/%@",bucket_endpoint,array[i]];
                        [arrM addObject:str];
                    }
                    
                    if (successBlock) {
                        successBlock(arrM);
                    }
                    [arrM removeAllObjects];
                    [self.imageDataSourece removeAllObjects];
                }
            } else {
                [self.imageDataSourece removeAllObjects];
                if (faile) {
                    faile(task.error);
                }
            }
        });
        return nil;
    }];
}

/// 上传视频
- (void)asyncUploadVideo:(NSURL *)data fileType:(NSString *)fileType success:(void (^)(NSArray *objectKeys))successBlock faile:(void (^)(NSError *error))faile{
    
    //1.向服务器请求获取AccessKeyId AccessKeySecret SecurityToken
    NSString *url = [NSString stringWithFormat:@"%@/data/token",BASE_URL];
    NSMutableDictionary *dictionary = @{}.mutableCopy;
    [PPHTTPRequest requestGetWithURL:url parameters:dictionary success:^(id  _Nonnull response) {
        NSLog(@"请求获取AccessKeyId=====%@",response);
        NSString *code = [NSString stringWithFormat:@"%@", response[@"code"]];
        if ([code intValue]  != 0) {//请求成功
            return;
        }else {
            NSDictionary *result = response[@"data"];
            NSString *bucketName = result[@"bucket"];
            NSString *bucket_endpoint = result[@"bucket_endpoint"];
            NSString *endpoint = result[@"endpoint"];
            NSString *stsAccessKeyId = result[@"accesskey_id"];
            NSString *stsAccessKeySecret = result[@"accesskey_secret"];
            NSString *stsSecurityToken = result[@"security_token"];
            
            id<OSSCredentialProvider> credential = [[OSSStsTokenCredentialProvider alloc] initWithAccessKeyId:stsAccessKeyId secretKeyId:stsAccessKeySecret securityToken:stsSecurityToken];
            OSSClientConfiguration * conf = [OSSClientConfiguration new];
            conf.maxRetryCount = 2;
            conf.timeoutIntervalForRequest = 30;
            conf.timeoutIntervalForResource = 24 * 60 * 60;
            conf.maxConcurrentRequestCount = 10;
            OSSClient *client = [[OSSClient alloc] initWithEndpoint:endpoint credentialProvider:credential clientConfiguration:conf];
            
            OSSPutObjectRequest * put = [OSSPutObjectRequest new];
            put.bucketName = bucketName;
            put.uploadingFileURL = data; // 直接上传NSData
            char numberData[16];//十六位防重字符
            for (int x=0;x<16;numberData[x++] = (char)('A' + (arc4random_uniform(26))));
            NSString *number = [[NSString alloc]initWithBytes:numberData length:16 encoding:NSUTF8StringEncoding];
            //当前时间
            NSInteger interval = (NSInteger)[[NSDate date]timeIntervalSince1970];
            
            NSString *name = [NSString stringWithFormat:@"video_%@%ld",number,interval];
            
            NSString *objectKey = [NSString stringWithFormat:@"%@/%@.mp4",fileType,name];
            put.objectKey = objectKey;
            OSSTask * putTask = [client putObject:put];
        
            // 上传阿里云
            [putTask continueWithBlock:^id(OSSTask *task) {
                task = [client presignPublicURLWithBucketName: bucketName withObjectKey:objectKey];
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (!task.error) {
                        [self.videoDataSourece removeAllObjects];

                        [self.videoDataSourece addObject:[NSString stringWithFormat:@"%@/%@",bucket_endpoint,objectKey]];
                        NSLog(@"task = %@",task.result);
                        if (successBlock) {
                            successBlock(self.videoDataSourece);
                        }
                    } else {
                        NSLog(@"错误信息 = %@",putTask.error.localizedDescription);
                        [self.videoDataSourece removeAllObjects];
                        if (faile) {
                            faile(task.error);
                        }
                    }
                });
                return nil;
            }];
        }
    } failure:^(NSError * _Nonnull error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            UIViewController *vc = [HHAppManage getCurrentVC];
            for (UIView *view in vc.view.subviews ) {
                if (view.tag == 777) {
                    [view removeFromSuperview];
                }
            }
            
            UIView *view = [[UIView alloc] init];
            view.backgroundColor = kBlackColor;
            view.alpha = 0.7;
            view.layer.cornerRadius = 8;
            view.layer.masksToBounds = YES;
            view.tag = 777;
            [vc.view addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.offset(50);
                make.left.offset(50);
                make.right.offset(-50);
                make.centerY.equalTo(vc.view);
            }];
            
            UILabel *label = [[UILabel alloc] init];
            label.text = @"网络异常，请检查网络后重试";
            label.textColor = kWhiteColor;
            label.textAlignment = NSTextAlignmentCenter;
            label.font = XLFont_mainTextFont;
            [view addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.offset(0);
                make.left.offset(0);
                make.right.offset(0);
            }];
            
            [self performSelector:@selector(perform) withObject:nil afterDelay:1.5];
            
        });
    }];
    
}
@end
