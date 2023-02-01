//
//  AliUpLoadImageTool.h
//  Volunteer
//
//  Created by cindy on 2021/10/15.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AliUpLoadImageTool : NSObject

/**
 返回对象

 @return AliUpLoadImageTool
 */
+ (AliUpLoadImageTool *)shareIncetance;
@property (strong, nonatomic) void(^showError)(void);


/**
 这个方法用于上传单张图片到阿里云
 
 @param parmar       这是参数是一个字典，直接将后台的字典传入
 @param successBlock 上传成功后的回调，你可以在这里处理UI
 @param faile        上传失败会走的回调
 */
-(void)upLoadImageWithfileType:(NSString *)fileType Pamgamar:(NSDictionary *)parmar imageData:(NSData *)imageData success:(void (^)(NSString *objectKey))successBlock faile:(void (^)(NSError *error))faile;
/**
 这个方法用于上传多张图片到里云上
 
 @param parmar       这是参数是一个字典，直接将后台的字典传入
 @param successBlock 上传成功后的回调，你可以在这里处理UI
 @param faile        上传失败会走的回调
 */
- (void)upLoadMoreImageWithfileType:(NSString *)fileType Pamgamar:(NSDictionary *)parmar imageDataArray:(NSArray *)imageDataArray  success:(void (^)(NSArray *objectKeys))successBlock faile:(void (^)(NSError *error))faile;

- (void)asyncUploadVideo:(NSURL *)data fileType:(NSString *)fileType success:(void (^)(NSArray *objectKeys))successBlock faile:(void (^)(NSError *error))faile;

@end

NS_ASSUME_NONNULL_END
