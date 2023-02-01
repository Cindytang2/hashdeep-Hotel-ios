//
//  HHCommentModel.h
//  HashdeepHotel
//
//  Created by Cindy on 2022/7/29.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HHCommentModel : NSObject
@property (nonatomic, copy) NSString *user_head_img;
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *user_content;
@property (nonatomic, copy) NSString *hotel_content;
@property (nonatomic, copy) NSString *hotel_id;
@property (nonatomic, assign) CGFloat rating;
@property (nonatomic, copy) NSString *comment_desc;
@property (nonatomic, copy) NSString *comment_time;
@property (nonatomic, copy) NSString *comment_id;
@property (nonatomic, copy) NSString *user_name;
@property (nonatomic, strong) NSArray *file_path;
@property (nonatomic, assign) CGFloat totalHeight;
@property (nonatomic, assign) CGFloat imageHeight;
@property (nonatomic, assign) CGFloat commentHeight;
@property (nonatomic, strong) NSDictionary *reply_comment;
@property (nonatomic, assign) BOOL showAll;
@property (nonatomic, assign) BOOL is_reply;
@property (nonatomic, assign) BOOL hotel_showAll;
@property (nonatomic, assign) CGFloat userCommentHeight;
@property (nonatomic, assign) CGFloat hotelCommentHeight;

@end

NS_ASSUME_NONNULL_END
