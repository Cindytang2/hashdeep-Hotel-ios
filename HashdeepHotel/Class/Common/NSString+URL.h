//
//  NSString+URL.h
//  HashdeepHotel
//
//  Created by Cindy on 2022/9/15.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (URL)
/**
 *  URLEncode
 */
- (NSString *)URLEncodedString;

/**
 *  URLDecode
 */
-(NSString *)URLDecodedString;
@end

NS_ASSUME_NONNULL_END
