
#import "TUIMessageController.h"
#import "TUIBaseMessageController+ProtectedAPI.h"
#import "TUIChatSmallTongueView.h"
#import "TUITextMessageCell.h"
#import "TUIReplyMessageCell.h"
#import "TUIReplyMessageCellData.h"
#import "TUIReferenceMessageCell.h"
#import "TUIGlobalization.h"
#import "TUIThemeManager.h"
#import "TUIMessageSearchDataProvider.h"
#import "UIView+TUILayout.h"
#import "ReactiveObjC.h"
#import "TUIDefine.h"

#define MSG_GET_COUNT 20

@interface  TUIMessageController()<TUIChatSmallTongueViewDelegate>
@property (nonatomic, strong) UIActivityIndicatorView *bottomIndicatorView;
@property (nonatomic, assign) uint64_t locateGroupMessageSeq;
@property (nonatomic, strong) TUIChatSmallTongueView *tongueView;
@property (nonatomic, strong) NSMutableArray *receiveMsgs;
@end

@implementation TUIMessageController

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.bottomIndicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, TMessageController_Header_Height)];
    self.bottomIndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    self.tableView.tableFooterView = self.bottomIndicatorView;
    self.tableView.backgroundColor = TUIChatDynamicColor(@"chat_controller_bg_color", @"#FFFFFF");
    
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(keyboardWillShow) name:UIKeyboardWillShowNotification object:nil];
    
    if (self.conversationData.atMsgSeqs.count > 0) {
        TUIChatSmallTongue *tongue = [[TUIChatSmallTongue alloc] init];
        tongue.type = TUIChatSmallTongueType_SomeoneAtMe;
        tongue.atMsgSeqs = [self.conversationData.atMsgSeqs copy];
        [TUIChatSmallTongueManager showTongue:tongue delegate:self];
    }
    self.receiveMsgs = [NSMutableArray array];
}

- (void)dealloc
{
    [TUIChatSmallTongueManager removeTongue];
    [NSNotificationCenter.defaultCenter removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [TUIChatSmallTongueManager hideTongue:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [TUIChatSmallTongueManager hideTongue:YES];
}

#pragma mark - Notification

- (void)keyboardWillShow
{
    if (![self messageSearchDataProvider].isNewerNoMoreMsg) {
        [[self messageSearchDataProvider] removeAllSearchData];
        [self.tableView reloadData];
        [self loadMessages:YES];
    }
}

#pragma mark - Overrider
- (void)willShowMediaMessage:(TUIMessageCell *)cell
{
    [TUIChatSmallTongueManager hideTongue:YES];
}

- (void)didCloseMediaMessage:(TUIMessageCell *)cell
{
    [TUIChatSmallTongueManager hideTongue:NO];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [super scrollViewDidScroll:scrollView];
    if (scrollView.contentOffset.y <= TMessageController_Header_Height
       && ![self messageSearchDataProvider].isOlderNoMoreMsg) {
        // ??????????????????
        if (!self.indicatorView.isAnimating) {
            [self.indicatorView startAnimating];
        }
    }
    else if ([self isScrollToBottomIndicatorViewY:scrollView]) {
        if (![self messageSearchDataProvider].isNewerNoMoreMsg) {
            // ??????????????????
            if (!self.bottomIndicatorView.isAnimating) {
                [self.bottomIndicatorView startAnimating];
            }
        }
        // ?????? "??????????????????", "xxx????????????" ?????????
        if (self.isInVC) {
            [TUIChatSmallTongueManager removeTongue:TUIChatSmallTongueType_ScrollToBoom];
            [TUIChatSmallTongueManager removeTongue:TUIChatSmallTongueType_ReceiveNewMsg];
        }
    }
    else if (self.isInVC && 0 == self.receiveMsgs.count && self.tableView.contentSize.height - self.tableView.contentOffset.y >= Screen_Height * 2.0) {
        CGPoint point = [scrollView.panGestureRecognizer translationInView:scrollView];
        // ???????????????????????? "??????????????????" ?????????
        if (point.y > 0) {
            TUIChatSmallTongue *tongue = [[TUIChatSmallTongue alloc] init];
            tongue.type = TUIChatSmallTongueType_ScrollToBoom;
            [TUIChatSmallTongueManager showTongue:tongue delegate:self];
        }
    }
    else if (self.isInVC && self.tableView.contentSize.height - self.tableView.contentOffset.y >= 20) {
        // ?????? "?????? @ ???" ?????????
        [TUIChatSmallTongueManager removeTongue:TUIChatSmallTongueType_SomeoneAtMe];
    }
    else {
        if (self.indicatorView.isAnimating) {
            [self.indicatorView stopAnimating];
        }
        if (self.bottomIndicatorView.isAnimating) {
            [self.bottomIndicatorView stopAnimating];
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [super scrollViewDidEndDecelerating:scrollView];
    if (scrollView.contentOffset.y <= TMessageController_Header_Height
       && ![self messageSearchDataProvider].isOlderNoMoreMsg) {
        // ???????????????
        [self loadMessages:YES];
    }
    else if ([self isScrollToBottomIndicatorViewY:scrollView]
             && ![self messageSearchDataProvider].isNewerNoMoreMsg
             ) {
        // ??????????????????
        [self loadMessages:NO];
    }
}

- (BOOL)isScrollToBottomIndicatorViewY:(UIScrollView *)scrollView {
    return (scrollView.contentOffset.y + self.tableView.mm_h + 2) > (scrollView.contentSize.height - self.indicatorView.mm_h);
    // ???????????????,???+2??????
}

#pragma mark - Getters & Setters
- (void)setConversation:(TUIChatConversationModel *)conversationData
{
    self.conversationData = conversationData;
    self.messageDataProvider = [[TUIMessageSearchDataProvider alloc] initWithConversationModel:self.conversationData];
    self.messageDataProvider.dataSource = self;
    if (self.locateMessage) {
        [self loadLocateMessages:YES];
    } else {
        [[self messageSearchDataProvider] removeAllSearchData];
        [self loadMessages:YES];
    }
}

#pragma mark - Private Methods
- (TUIMessageSearchDataProvider *)messageSearchDataProvider {
    return (TUIMessageSearchDataProvider *)self.messageDataProvider;
}

// ??????????????????
- (void)loadLocateMessages:(BOOL)firstLoad
{
    @weakify(self);
    [[self messageSearchDataProvider] loadMessageWithSearchMsg:self.locateMessage
                                                  SearchMsgSeq:self.locateGroupMessageSeq
                                              ConversationInfo:self.conversationData
                                                  SucceedBlock:^(BOOL isOlderNoMoreMsg, BOOL isNewerNoMoreMsg, NSArray<TUIMessageCellData *> * _Nonnull newMsgs) {
        [self.indicatorView stopAnimating];
        self.indicatorView.mm_h = 0;
        self.bottomIndicatorView.mm_h = 0;
        [self.tableView reloadData];
        if (!firstLoad) {
            // ?????????????????????????????????????????? tableview ?????????????????????????????? scrollLocateMessage ???????????????????????????
            NSInteger index = self.messageDataProvider.uiMsgs.count > 0 ? self.messageDataProvider.uiMsgs.count - 1 : 0;
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]
                                  atScrollPosition:UITableViewScrollPositionBottom
                                          animated:NO];
        }
        [self.tableView layoutIfNeeded];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            @strongify(self)
            // ?????????????????????
            [self scrollLocateMessage:firstLoad];
            // ???????????????
            [self highlightKeyword];
        });
        
    } FailBlock:^(int code, NSString *desc) {
    }];
}

- (void)scrollLocateMessage:(BOOL)firstLoad
{
    // ????????? locateMsg ???????????????
    CGFloat offsetY = 0;
    NSInteger index = 0;
    for (TUIMessageCellData *uiMsg in [self messageSearchDataProvider].uiMsgs) {
        if ([self isLocateMessage:uiMsg]) {
            break;
        }
        offsetY += [uiMsg heightOfWidth:Screen_Width];
        index++;
    }
    
    // ????????????????????????
    if (index == [self messageSearchDataProvider].uiMsgs.count) {
        return;
    }
    
    // ??????????????? tableview ?????????
    offsetY -= self.tableView.frame.size.height / 2.0;
    if (offsetY <= TMessageController_Header_Height) {
        offsetY = TMessageController_Header_Height + 0.1;
    }

    if (offsetY > TMessageController_Header_Height) {
        if (firstLoad) {
            [self.tableView scrollRectToVisible:CGRectMake(0, self.tableView.contentOffset.y + offsetY, Screen_Width, self.tableView.bounds.size.height) animated:NO];
        } else {
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
        }
    }
}

- (void)highlightKeyword
{
    TUIMessageCellData *cellData = nil;
    for (TUIMessageCellData *tmp in [self messageSearchDataProvider].uiMsgs) {
        if ([self isLocateMessage:tmp]) {
            cellData = tmp;
            break;
        }
    }
    if (cellData == nil) {
        return;
    }
    
    @weakify(self)
    dispatch_async(dispatch_get_main_queue(), ^{
        @strongify(self)
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[[self messageDataProvider].uiMsgs indexOfObject:cellData] inSection:0];
        cellData.highlightKeyword = self.hightlightKeyword.length?self.hightlightKeyword:@"hightlight";
        TUIMessageCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        [cell fillWithData:cellData];
        @weakify(self)
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            @strongify(self)
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[[self messageDataProvider].uiMsgs indexOfObject:cellData] inSection:0];
            cellData.highlightKeyword = nil;
            TUIMessageCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            [cell fillWithData:cellData];
        });
    });
}

- (BOOL)isLocateMessage:(TUIMessageCellData *)uiMsg {
    if (self.locateMessage) {
        if ([uiMsg.innerMessage.msgID isEqualToString:self.locateMessage.msgID]) {
            return YES;
        }
    } else {
        if (self.conversationData.groupID.length > 0 && uiMsg.innerMessage && uiMsg.innerMessage.seq == self.locateGroupMessageSeq) {
            return YES;
        }
    }
    return NO;
}

/// @param order order=YES, ?????????????????????; order=NO, ?????????????????????
- (void)loadMessages:(BOOL)order
{
    // ?????????case
    if ([self messageSearchDataProvider].isLoadingData) {
        return;
    }
    
    // ?????????case
    if (order && [self messageSearchDataProvider].isOlderNoMoreMsg) {
        [self.indicatorView stopAnimating];
        return;
    }
    if (!order && [self messageSearchDataProvider].isNewerNoMoreMsg) {
        [self.bottomIndicatorView stopAnimating];
        return;
    }
    
    @weakify(self);
    [[self messageSearchDataProvider] loadMessageWithIsRequestOlderMsg:order
                                                      ConversationInfo:self.conversationData
                                                          SucceedBlock:^(BOOL isOlderNoMoreMsg, BOOL isNewerNoMoreMsg, BOOL isFirstLoad, NSArray<TUIMessageCellData *> * _Nonnull newUIMsgs) {
        @strongify(self);
        
        [self.indicatorView stopAnimating];
        [self.bottomIndicatorView stopAnimating];
        if (isOlderNoMoreMsg) {
            self.indicatorView.mm_h = 0;
        } else {
            self.indicatorView.mm_h = TMessageController_Header_Height;
        }
        if (isNewerNoMoreMsg) {
            self.bottomIndicatorView.mm_h = 0;
        } else {
            self.bottomIndicatorView.mm_h = TMessageController_Header_Height;
        }
                
        [self.tableView reloadData];
        [self.tableView layoutIfNeeded];
        
        if (isFirstLoad) {
            [self scrollToBottom:NO];
        } else {
            if (order) {
                CGFloat visibleHeight = 0;
                for (NSInteger i = 0; i < newUIMsgs.count; ++i) {
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
                    visibleHeight += [self tableView:self.tableView heightForRowAtIndexPath:indexPath];
                }
                if (isOlderNoMoreMsg) {
                    visibleHeight -= TMessageController_Header_Height;
                }
                [self.tableView setContentOffset:CGPointMake(0, self.tableView.contentOffset.y + visibleHeight)
                                        animated:NO];
            }
        }
        
    } FailBlock:^(int code, NSString *desc) {
        
    }];
}

- (void)showReplyMessage:(TUIReplyMessageCell *)cell
{
    [UIApplication.sharedApplication.keyWindow endEditing:YES];
    NSString *  originMsgID = @"";
    NSString *  msgAbstract = @"";
    if ([cell  isKindOfClass:TUIReplyMessageCell.class]) {
        TUIReplyMessageCell * acell = (TUIReplyMessageCell *)cell;
        TUIReplyMessageCellData *cellData = acell.replyData;
        originMsgID = cellData.messageRootID;
        msgAbstract = cellData.msgAbstract;
    }
    else if ([cell isKindOfClass:TUIReferenceMessageCell.class]) {
        TUIReferenceMessageCell * acell = (TUIReferenceMessageCell *)cell;
        TUIReferenceMessageCellData * cellData = acell.referenceData;
        originMsgID = cellData.originMsgID;
        msgAbstract = cellData.msgAbstract;
    }
    // ?????????????????? - ????????????????????????
    [(TUIMessageSearchDataProvider *)self.messageDataProvider findMessages:@[originMsgID?:@""] callback:^(BOOL success, NSString * _Nonnull desc, NSArray<V2TIMMessage *> * _Nonnull msgs) {
        if (!success) {
            [TUITool makeToast:TUIKitLocalizableString(TUIKitReplyMessageNotFoundOriginMessage)];
            return;
        }
        V2TIMMessage *message = msgs.firstObject;
        if (message == nil) {
            [TUITool makeToast:TUIKitLocalizableString(TUIKitReplyMessageNotFoundOriginMessage)];
            return;
        }
        
        // ???????????????????????????????????????
        if (message.status == V2TIM_MSG_STATUS_HAS_DELETED || message.status == V2TIM_MSG_STATUS_LOCAL_REVOKED) {
            [TUITool makeToast:TUIKitLocalizableString(TUIKitReplyMessageNotFoundOriginMessage)];
            return;
        }
        
        if ([cell isKindOfClass:TUIReplyMessageCell.class]) {
            [self jumpDetailPageByMessage:message];
        }
        else if ([cell isKindOfClass:TUIReferenceMessageCell.class]) {
            [self locateAssignMessage:message matchKeyWord:msgAbstract];
        }
    }];
}

- (void)jumpDetailPageByMessage:(V2TIMMessage *)message {
    NSMutableArray *uiMsgs = [self.messageDataProvider transUIMsgFromIMMsg:@[message]];
    [self.messageDataProvider preProcessMessage:uiMsgs callback:^{
        for (TUIMessageCellData *cellData in uiMsgs) {
            if ([cellData.innerMessage.msgID isEqual:message.msgID]) {
                [self onJumpToRepliesDetailPage:cellData];
                return;
            }
        }
    }];
}


- (void)locateAssignMessage:(V2TIMMessage *)message matchKeyWord:(NSString *)keyword
{
    if (message == nil) {
        return;
    }
    self.locateMessage = message;
    self.hightlightKeyword = keyword;
    
    // ????????????????????????????????????
    BOOL memoryExist = NO;
    for (TUIMessageCellData *cellData in self.messageDataProvider.uiMsgs) {
        if ([cellData.innerMessage.msgID isEqual:message.msgID]) {
            memoryExist = YES;
            break;
        }
    }
    if (memoryExist) {
        // ????????????
        [self scrollLocateMessage:NO];
        // ??????
        [self highlightKeyword];
        return;
    }
    
    // ??????
    TUIMessageSearchDataProvider *provider = (TUIMessageSearchDataProvider *)self.messageDataProvider;
    provider.isNewerNoMoreMsg = NO;
    provider.isOlderNoMoreMsg = NO;
    [self loadLocateMessages:NO];
}

#pragma mark - TUIMessageDataProviderDataSource
- (void)dataProvider:(TUIMessageDataProvider *)dataProvider
     ReceiveNewUIMsg:(TUIMessageCellData *)uiMsg {
    [super dataProvider:dataProvider ReceiveNewUIMsg:uiMsg];
    // ???????????????????????????????????????????????????????????????????????????????????? "xxx????????????"?????????
    if (self.isInVC && self.tableView.contentSize.height - self.tableView.contentOffset.y >= Screen_Height * 2.0) {
        [self.receiveMsgs addObject:uiMsg];
        TUIChatSmallTongue *tongue = [[TUIChatSmallTongue alloc] init];
        tongue.type = TUIChatSmallTongueType_ReceiveNewMsg;
        tongue.unreadMsgCount = self.receiveMsgs.count;
        [TUIChatSmallTongueManager showTongue:tongue delegate:self];
    }
}

- (void)dataProvider:(TUIMessageDataProvider *)dataProvider
  ReceiveRevokeUIMsg:(TUIMessageCellData *)uiMsg {
    // ????????????????????? "xxx????????????" ??????
    [super dataProvider:dataProvider ReceiveRevokeUIMsg:uiMsg];
    if ([self.receiveMsgs containsObject:uiMsg]) {
        [self.receiveMsgs removeObject:uiMsg];
        TUIChatSmallTongue *tongue = [[TUIChatSmallTongue alloc] init];
        tongue.type = TUIChatSmallTongueType_ReceiveNewMsg;
        tongue.unreadMsgCount = self.receiveMsgs.count;
        if (tongue.unreadMsgCount != 0) {
            [TUIChatSmallTongueManager showTongue:tongue delegate:self];
        } else {
            [TUIChatSmallTongueManager removeTongue:TUIChatSmallTongueType_ReceiveNewMsg];
        }
    }
}

#pragma mark - TUIChatSmallTongueViewDelegate
- (void)onChatSmallTongueClick:(TUIChatSmallTongue *)tongue {
    switch (tongue.type) {
        case TUIChatSmallTongueType_ScrollToBoom:
        {
            [self scrollToBottom:YES];
        }
            break;
        case TUIChatSmallTongueType_ReceiveNewMsg:
        {
            [TUIChatSmallTongueManager removeTongue:TUIChatSmallTongueType_ReceiveNewMsg];
            TUIMessageCellData *cellData = self.receiveMsgs.firstObject;
            if (cellData) {
                self.locateMessage = cellData.innerMessage;
                [self scrollLocateMessage:NO];
                [self highlightKeyword];
            }
            [self.receiveMsgs removeAllObjects];
        }
            break;
        case TUIChatSmallTongueType_SomeoneAtMe:
        {
            [TUIChatSmallTongueManager removeTongue:TUIChatSmallTongueType_SomeoneAtMe];
            [self.conversationData.atMsgSeqs removeAllObjects];;
            self.locateGroupMessageSeq = [tongue.atMsgSeqs.firstObject integerValue];
            for (TUIMessageCellData *cellData in self.messageDataProvider.uiMsgs) {
                if ([self isLocateMessage:cellData]) {
                    [self scrollLocateMessage:NO];
                    [self highlightKeyword];
                    return;
                }
            }
            [self loadLocateMessages:NO];
        }
            break;
        default:
            break;
    }
}
@end
