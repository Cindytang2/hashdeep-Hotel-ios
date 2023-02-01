//
//  HHSearchGroupModel.h
//  HashdeepHotel
//
//  Created by Cindy on 2022/7/14.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HHSearchGroupModel : NSObject
@property (nonatomic, strong) NSArray *selecttype_list;
@property (nonatomic, copy) NSString *selecttype_category;
@property (nonatomic, copy) NSString *selecttype_category_desc;
@property(nonatomic, assign) BOOL isSelect;
@end

NS_ASSUME_NONNULL_END
