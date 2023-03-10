//
//  TUIConversationSelectModel.m
//  TXIMSDK_TUIKit_iOS
//
//  Created by xiangzhang on 2021/6/25.
//

#import "TUIConversationSelectDataProvider.h"
#import "TUIDefine.h"


@interface TUIConversationSelectDataProvider ()
@property (nonatomic, strong) NSMutableArray<V2TIMConversation *> *localConvList;
@end

@implementation TUIConversationSelectDataProvider

- (void)loadConversations
{
    __weak typeof(self) weakSelf = self;
    [[V2TIMManager sharedInstance] getConversationList:0 count:INT_MAX succ:^(NSArray<V2TIMConversation *> *list, uint64_t lastTS, BOOL isFinished) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf updateConversation:list];
    } fail:^(int code, NSString *msg) {
        // 拉取会话列表失败
        NSLog(@"getConversationList failed");
    }];
}

- (void)updateConversation:(NSArray *)convList
{
    // 更新 UI 会话列表，如果 UI 会话列表有新增的会话，就替换，如果没有，就新增
    for (int i = 0 ; i < convList.count ; ++ i) {
        V2TIMConversation *conv = convList[i];
        BOOL isExit = NO;
        for (int j = 0; j < self.localConvList.count; ++ j) {
            V2TIMConversation *localConv = self.localConvList[j];
            if ([localConv.conversationID isEqualToString:conv.conversationID]) {
                [self.localConvList replaceObjectAtIndex:j withObject:conv];
                isExit = YES;
                break;
            }
        }
        if (!isExit) {
            [self.localConvList addObject:conv];
        }
    }
    // 更新 cell data
    NSMutableArray *dataList = [NSMutableArray array];
    for (V2TIMConversation *conv in self.localConvList) {
        // 屏蔽会话
        if ([self filteConversation:conv]) {
            continue;
        }
        
        // 创建cellData
        TUIConversationCellData *data = [[TUIConversationCellData alloc] init];
        data.conversationID = conv.conversationID;
        data.groupID = conv.groupID;
        data.userID = conv.userID;
        data.title = conv.showName;
        data.faceUrl = conv.faceUrl;
        data.unreadCount = 0;
        data.draftText = @"";
        data.subTitle = [[NSMutableAttributedString alloc] initWithString:@""];
        if (conv.type == V2TIM_C2C) {   // 设置会话的默认头像
            data.avatarImage = DefaultAvatarImage;
        } else {
            data.avatarImage = DefaultGroupAvatarImage;
        }
        
        [dataList addObject:data];
    }
    // UI 会话列表根据 lastMessage 时间戳重新排序
    [self sortDataList:dataList];
    self.dataList = dataList;
}

- (BOOL)filteConversation:(V2TIMConversation *)conv
{
    // 屏蔽AVChatRoom的群聊会话
    if ([conv.groupType isEqualToString:@"AVChatRoom"]) {
        return YES;
    }
    return NO;
}

- (void)sortDataList:(NSMutableArray<TUIConversationCellData *> *)dataList
{
    // 按时间排序，最近会话在上
    [dataList sortUsingComparator:^NSComparisonResult(TUIConversationCellData *obj1, TUIConversationCellData *obj2) {
        return [obj2.time compare:obj1.time];
    }];

    // 将置顶会话固定在最上面
    NSArray *topList = [[TUIConversationPin sharedInstance] topConversationList];
    int existTopListSize = 0;
    for (NSString *convID in topList) {
        int userIdx = -1;
        for (int i = 0; i < dataList.count; i++) {
            if ([dataList[i].conversationID isEqualToString:convID]) {
                userIdx = i;
                dataList[i].isOnTop = YES;
                break;
            }
        }
        if (userIdx >= 0 && userIdx != existTopListSize) {
            TUIConversationCellData *data = dataList[userIdx];
            [dataList removeObjectAtIndex:userIdx];
            [dataList insertObject:data atIndex:existTopListSize];
            existTopListSize++;
        }
    }
}

- (NSArray<TUIConversationCellData *> *)dataList
{
    if (_dataList == nil) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}

- (NSMutableArray<V2TIMConversation *> *)localConvList
{
    if (_localConvList == nil) {
        _localConvList = [NSMutableArray array];
    }
    return _localConvList;
}

@end
