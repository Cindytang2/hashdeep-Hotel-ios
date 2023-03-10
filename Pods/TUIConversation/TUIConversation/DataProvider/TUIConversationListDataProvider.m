//
//  TConversationListViewModel.m
//  TXIMSDK_TUIKit_iOS
//
//  Created by annidyfeng on 2019/5/17.
//

#import "TUIConversationListDataProvider.h"
#import "TUICore.h"
#import "TUILogin.h"
#import "TUIDefine.h"

#define Default_PagePullCount 100

@interface TUIConversationListDataProvider ()<V2TIMConversationListener, V2TIMGroupListener>
@property (nonatomic, assign) uint64_t nextSeq;
@property (nonatomic, assign) uint64_t isFinished;
@property (nonatomic, strong) NSMutableDictionary<NSString *, TUIConversationCellData *> *dataDic;
@end

@implementation TUIConversationListDataProvider

- (instancetype)init
{
    if (self = [super init]) {
        
        [[V2TIMManager sharedInstance] addConversationListener:self];
        [[V2TIMManager sharedInstance] addGroupListener:self];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didTopConversationListChanged:)
                                                     name:kTopConversationListChangedNotification
                                                   object:nil];
        self.dataDic = [NSMutableDictionary dictionary];
        self.pagePullCount = Default_PagePullCount;
        self.nextSeq = 0;
        self.isFinished = NO;
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - V2TIMConversationListener
- (void)onNewConversation:(NSArray<V2TIMConversation*> *) conversationList {
    [self updateConversation:conversationList];
}

- (void)onConversationChanged:(NSArray<V2TIMConversation*> *) conversationList {
    [self updateConversation:conversationList];
}

#pragma mark - V2TIMGroupListener
- (void)onGroupDismissed:(NSString *)groupID opUser:(V2TIMGroupMemberInfo *)opUser {
    
    TUIConversationCellData *data = [self cellDataOfGroupID:groupID];
    if (data) {
        [TUITool makeToast:[NSString stringWithFormat:TUIKitLocalizableString(TUIKitGroupDismssTipsFormat), data.groupID]];
        [self removeData:data];
    }
}

- (void)onGroupRecycled:(NSString *)groupID opUser:(V2TIMGroupMemberInfo *)opUser {
    
    TUIConversationCellData *data = [self cellDataOfGroupID:groupID];
    if (data) {
        [TUITool makeToast:[NSString stringWithFormat:TUIKitLocalizableString(TUIKitGroupRecycledTipsFormat), data.groupID]];
        [self removeData:data];
    }
}

- (void)onMemberKicked:(NSString *)groupID opUser:(V2TIMGroupMemberInfo *)opUser memberList:(NSArray<V2TIMGroupMemberInfo *>*)memberList {
    for (V2TIMGroupMemberInfo *info in memberList) {
        if ([info.userID isEqualToString:[TUILogin getUserID]]) {
            TUIConversationCellData *data = [self cellDataOfGroupID:groupID];
            if (data) {
                [TUITool makeToast:[NSString stringWithFormat:TUIKitLocalizableString(TUIKitGroupKickOffTipsFormat), data.groupID]];
                [self removeData:data];
            }
            return;
        }
    }
}

- (void)onQuitFromGroup:(NSString *)groupID {
    TUIConversationCellData *data = [self cellDataOfGroupID:groupID];
    if (data) {
        [TUITool makeToast:[NSString stringWithFormat:TUIKitLocalizableString(TUIKitGroupDropoutTipsFormat), data.groupID]];
        [self removeData:data];
    }
}

- (void)onGroupInfoChanged:(NSString *)groupID changeInfoList:(NSArray <V2TIMGroupChangeInfo *> *)changeInfoList
{
    if (groupID.length == 0) {
        return;
    }
    NSString *conversationID = [NSString stringWithFormat:@"group_%@", groupID];
    TUIConversationCellData *tmpData = nil;
    for (TUIConversationCellData *cellData in self.dataList) {
        if ([cellData.conversationID isEqual:conversationID]) {
            tmpData = cellData;
            break;
        }
    }
    if (tmpData == nil) {
        return;
    }
    __weak typeof(self) weakSelf = self;
    [V2TIMManager.sharedInstance getConversation:conversationID succ:^(V2TIMConversation *conv) {
        [weakSelf updateConversation:@[conv]];
    } fail:^(int code, NSString *desc) {
        
    }];
}


#pragma mark -

- (void)didTopConversationListChanged:(NSNotification *)no
{
    NSMutableArray *dataList = [NSMutableArray arrayWithArray:self.dataList];
    [self sortDataList:dataList];
    self.dataList = dataList;
}

- (void)loadConversation
{
    if (self.isFinished) {
        return;
    }
    @weakify(self)
    [[V2TIMManager sharedInstance] getConversationList:self.nextSeq count:self.pagePullCount succ:^(NSArray<V2TIMConversation *> *list, uint64_t nextSeq, BOOL isFinished) {
        @strongify(self)
        self.nextSeq = nextSeq;
        self.isFinished = isFinished;
        [self updateConversation:list];
    } fail:^(int code, NSString *msg) {
        self.isFinished = YES;
        NSLog(@"getConversationList failed, code:%d msg:%@", code, msg);
    }];
}

- (void)updateConversation:(NSArray *)convList
{
    for (V2TIMConversation *conv in convList) {
        // ????????????
        if ([self filteConversation:conv]) {
            continue;
        }
        // ??????cellData
        TUIConversationCellData *data = [[TUIConversationCellData alloc] init];
        data.conversationID = conv.conversationID;
        data.groupID = conv.groupID;
        data.groupType = conv.groupType;
        data.userID = conv.userID;
        data.title = conv.showName;
        data.faceUrl = conv.faceUrl;
        data.subTitle = [self getLastDisplayString:conv];
        data.atMsgSeqs = [self getGroupatMsgSeqs:conv];
        data.time = [self getLastDisplayDate:conv];
        data.isOnTop = conv.isPinned;
        data.unreadCount = conv.unreadCount;
        data.draftText = conv.draftText;
        data.isNotDisturb = ![conv.groupType isEqualToString:GroupType_Meeting] && (V2TIM_RECEIVE_NOT_NOTIFY_MESSAGE == conv.recvOpt);
        data.orderKey = conv.orderKey;
        data.avatarImage = (conv.type == V2TIM_C2C ? DefaultAvatarImage : DefaultGroupAvatarImage);
        
        if (data && data.conversationID) {
            [self.dataDic setObject:data forKey:data.conversationID];
        }
    }
    NSMutableArray *newDataList = [NSMutableArray arrayWithArray:self.dataDic.allValues];
    // UI ?????????????????? orderKey ????????????
    [self sortDataList:newDataList];
    self.dataList = newDataList;
}

- (NSString *)getDraftContent:(V2TIMConversation *)conv
{
    NSString *draft = conv.draftText;
    if (draft.length == 0) {
        return nil;
    }
    
    NSError *error = nil;
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:[draft dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:&error];
    if (error || jsonDict == nil) {
        return draft;
    }
    
    // ????????????
    NSString *draftContent = [jsonDict.allKeys containsObject:@"content"] ? jsonDict[@"content"] : @"";
    return draftContent;
}

- (BOOL)filteConversation:(V2TIMConversation *)conv
{
    // ??????AVChatRoom???????????????
    if ([conv.groupType isEqualToString:@"AVChatRoom"]) {
        return YES;
    }
    
    // ??????????????????
    if ([self getLastDisplayDate:conv] == nil) {
        if (conv.unreadCount != 0) {
            // ?????? ???????????????????????????data.time???nil?????????????????????????????????????????????lastMessage??????(v1conv???lastmessage)?????????????????????????????????????????????????????????????????????????????????
            // ????????????????????????????????????????????????
            NSString *userID = conv.userID;
            if (userID.length > 0) {
                [[V2TIMManager sharedInstance] markC2CMessageAsRead:userID succ:^{
                    
                } fail:^(int code, NSString *msg) {
                    
                }];
            }
            NSString *groupID = conv.groupID;
            if (groupID.length > 0) {
                [[V2TIMManager sharedInstance] markGroupMessageAsRead:groupID succ:^{
                    
                } fail:^(int code, NSString *msg) {
                    
                }];
            }
        }
        return YES;
    }
    
    return NO;
}

- (NSMutableArray<NSNumber *> *)getGroupatMsgSeqs:(V2TIMConversation *)conv {
    NSMutableArray *seqList = [NSMutableArray array];
    for (V2TIMGroupAtInfo *atInfo in conv.groupAtInfolist) {
        [seqList addObject:@(atInfo.seq)];
    }
    if (seqList.count > 0) {
        return seqList;
    }
    return nil;
}

- (NSString *)getGroupAtTipString:(V2TIMConversation *)conv {
    NSString *atTipsStr = @"";
    BOOL atMe = NO;
    BOOL atAll = NO;
    for (V2TIMGroupAtInfo *atInfo in conv.groupAtInfolist) {
        switch (atInfo.atType) {
            case V2TIM_AT_ME:
                atMe = YES;
                continue;;
            case V2TIM_AT_ALL:
                atAll = YES;
                continue;;
            case V2TIM_AT_ALL_AT_ME:
                atMe = YES;
                atAll = YES;
                continue;;
            default:
                continue;;
        }
    }
    if (atMe && !atAll) {
        atTipsStr = TUIKitLocalizableString(TUIKitConversationTipsAtMe); // @"[??????@???]";
    }
    if (!atMe && atAll) {
        atTipsStr = TUIKitLocalizableString(TUIKitConversationTipsAtAll); // @"[@?????????]";
    }
    if (atMe && atAll) {
        atTipsStr = TUIKitLocalizableString(TUIKitConversationTipsAtMeAndAll); // @"[??????@???][@?????????]";
    }
    return atTipsStr;
}

- (NSMutableAttributedString *)getLastDisplayString:(V2TIMConversation *)conv
{
    // ???????????? @ ???????????? @ ??????
    NSString *atStr = [self getGroupAtTipString:conv];
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",atStr]];
    NSDictionary *attributeDict = @{NSForegroundColorAttributeName:[UIColor d_systemRedColor]};
    [attributeString setAttributes:attributeDict range:NSMakeRange(0, attributeString.length)];
    
    // ????????????????????????????????????????????????
    if(conv.draftText.length > 0){
        [attributeString appendAttributedString:[[NSAttributedString alloc] initWithString:TUIKitLocalizableString(TUIKitMessageTypeDraftFormat) attributes:@{NSForegroundColorAttributeName:RGB(250, 81, 81)}]];
        [attributeString appendAttributedString:[[NSAttributedString alloc] initWithString:[self getDraftContent:conv] attributes:@{NSForegroundColorAttributeName:[UIColor d_systemGrayColor]}]];
    } else {
        // ?????????????????????????????? lastMsg ??????
        NSString *lastMsgStr = @"";
        
        // ??????????????????????????????????????? lastMsg ????????????
        if (self.delegate && [self.delegate respondsToSelector:@selector(getConversationDisplayString:)]) {
            lastMsgStr = [self.delegate getConversationDisplayString:conv];
        }
        
        // ?????????????????????????????????????????? lastMsg ????????????
        if (lastMsgStr.length == 0 && conv.lastMessage) {
            NSDictionary *param = @{TUICore_TUIChatService_GetDisplayStringMethod_MsgKey:conv.lastMessage};
            lastMsgStr = [TUICore callService:TUICore_TUIChatService method:TUICore_TUIChatService_GetDisplayStringMethod param:param];
        }
        
        // ???????????? lastMsg ??????????????????????????????????????????????????? nil
        if (lastMsgStr.length == 0) {
            return nil;
        }
        [attributeString appendAttributedString:[[NSAttributedString alloc] initWithString:lastMsgStr]];
    }
    
    // ??????????????????????????????????????????????????????
    // Meeting ??????????????? V2TIM_RECEIVE_NOT_NOTIFY_MESSAGE ?????????UI ??????????????????
    if (![conv.groupType isEqualToString:GroupType_Meeting] && V2TIM_RECEIVE_NOT_NOTIFY_MESSAGE == conv.recvOpt && conv.unreadCount > 0) {
        NSAttributedString *unreadString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"[%d???] ", conv.unreadCount]];
        [attributeString insertAttributedString:unreadString atIndex:0];
    }
    
    // ???????????? lastMsg ????????????????????????????????????????????????????????????????????????????????????????????????
    if (!conv.draftText && (V2TIM_MSG_STATUS_SENDING == conv.lastMessage.status || V2TIM_MSG_STATUS_SEND_FAIL == conv.lastMessage.status)) {
        UIFont *textFont = [UIFont systemFontOfSize:14];
        NSAttributedString *spaceString = [[NSAttributedString alloc] initWithString:@" " attributes:@{NSFontAttributeName: textFont}];
        NSTextAttachment *attchment = [[NSTextAttachment alloc] init];
        UIImage *image = nil;
        if (V2TIM_MSG_STATUS_SENDING == conv.lastMessage.status) {
            image = TUIConversationCommonBundleImage(@"msg_sending_for_conv");
        } else {
            image = TUIConversationCommonBundleImage(@"msg_error_for_conv");
        }
        attchment.image = image;
        attchment.bounds = CGRectMake(0, -(textFont.lineHeight-textFont.pointSize)/2, textFont.pointSize, textFont.pointSize);
        NSAttributedString *imageString = [NSAttributedString attributedStringWithAttachment:(NSTextAttachment *)(attchment)];
        [attributeString insertAttributedString:spaceString atIndex:0];
        [attributeString insertAttributedString:imageString atIndex:0];
    }
    return attributeString;
}

- (NSDate *)getLastDisplayDate:(V2TIMConversation *)conv
{
    if(conv.draftText.length > 0){
        return conv.draftTimestamp;
    }
    if (conv.lastMessage) {
        return conv.lastMessage.timestamp;
    }
    return [NSDate distantPast];
}

- (TUIConversationCellData *)cellDataOfGroupID:(NSString *)groupID
{
    NSString *conversationID = [NSString stringWithFormat:@"group_%@",groupID];
    return self.dataDic[conversationID];
}

- (void)sortDataList:(NSMutableArray<TUIConversationCellData *> *)dataList
{
    [dataList sortUsingComparator:^NSComparisonResult(TUIConversationCellData *obj1, TUIConversationCellData *obj2) {
        return obj1.orderKey < obj2.orderKey;
    }];
}

- (void)removeData:(TUIConversationCellData *)data
{
    NSMutableArray *list = [NSMutableArray arrayWithArray:self.dataList];
    [list removeObject:data];
    self.dataList = list;
    [self.dataDic removeObjectForKey:data.conversationID];
    [[V2TIMManager sharedInstance] deleteConversation:data.conversationID succ:nil fail:nil];
}

- (void)clearGroupHistoryMessage:(NSString *)groupID {
    [V2TIMManager.sharedInstance clearGroupHistoryMessage:groupID succ:^{
        NSLog(@"clear group history messages, success");
    } fail:^(int code, NSString *desc) {
        NSLog(@"clear group history messages, error|code:%d|desc:%@", code, desc);
    }];
}

- (void)clearC2CHistoryMessage:(NSString *)userID {
    [V2TIMManager.sharedInstance clearC2CHistoryMessage:userID succ:^{
        NSLog(@"clear c2c history messages, success");
    } fail:^(int code, NSString *desc) {
        NSLog(@"clear c2c history messages, error|code:%d|desc:%@", code, desc);
    }];
}

@end
