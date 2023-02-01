//
//  HHAccountModel.h
//  HashdeepHotel
//
//  Created by Cindy on 2022/12/8.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HHAccountModel : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) BOOL is_bind;
@property (nonatomic, assign) NSInteger type;
@end

NS_ASSUME_NONNULL_END
