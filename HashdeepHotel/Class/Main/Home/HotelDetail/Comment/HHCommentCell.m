//
//  HHCommentCell.m
//  HashdeepHotel
//
//  Created by Cindy on 2022/7/29.
//

#import "HHCommentCell.h"
#import "HHCommentModel.h"
#import <YYText/YYLabel.h>
#import <YYText/NSAttributedString+YYText.h>
#import "NSString+LeeLabelAddtion.h"

#import "HHImageAndVideoCollectionViewCell.h"
#import "YBIBUtilities.h"
#import "YBImageBrowser.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface HHCommentCell ()<UICollectionViewDataSource, UICollectionViewDelegate, YBImageBrowserDataSource, YBImageBrowserDelegate>
@property (nonatomic, strong) UIView *whiteView;
@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, strong) UIView *safetyView;
@property (nonatomic, strong) YYLabel *commentLabel;
@property (nonatomic, strong) UIView *grayView;
@property (nonatomic, strong) YYLabel *replyLabel;
@property (nonatomic, strong) NSMutableArray *imageArray;
@property (nonatomic, strong) UICollectionView *collectionView;
@end

@implementation HHCommentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.imageArray = [NSMutableArray array];
        //创建子视图
        [self _createView];
    }
    return self;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        CGFloat padding = 5, cellLength = (kScreenWidth-70)/3;
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.itemSize = CGSizeMake(cellLength, cellLength);
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        layout.minimumLineSpacing = 12;
        layout.minimumInteritemSpacing = 5;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        [_collectionView registerClass:[HHImageAndVideoCollectionViewCell class] forCellWithReuseIdentifier:@"HHImageAndVideoCollectionViewCell"];
        
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.alwaysBounceVertical = YES;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
    }
    return _collectionView;
}

- (void)_createView {
    
    self.whiteView = [[UIView alloc] init];
    self.whiteView.backgroundColor = kWhiteColor;
    self.whiteView.layer.cornerRadius = 12;
    self.whiteView.layer.masksToBounds = YES;
    [self.contentView addSubview:self.whiteView];
    [self.whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.offset(-15);
        make.top.offset(10);
        make.bottom.offset(0);
    }];
    
    self.headImageView = [[UIImageView alloc] init];
    self.headImageView.layer.cornerRadius = 38/2;
    self.headImageView.layer.masksToBounds = YES;
    self.headImageView.backgroundColor = XLColor_mainColor;
    [self.whiteView addSubview:self.headImageView];
    [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.width.height.offset(38);
        make.top.offset(12);
    }];
    
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.textColor = XLColor_mainTextColor;
    self.nameLabel.font = XLFont_mainTextFont;
    [self.whiteView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImageView.mas_right).offset(10);
        make.right.offset(-15);
        make.height.offset(19);
        make.top.offset(12);
    }];
    
    UIView *grayStarView = [[UIView alloc] init];
    [self.whiteView addSubview:grayStarView];
    [grayStarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel).offset(0);
        make.width.offset(15*5);
        make.height.offset(15);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(3.5);
    }];
    
    int gray_xLeft = 0;
    for (int i=0; i<5; i++) {
        UIImageView *imgView = [[UIImageView alloc] init];
        imgView.image = HHGetImage(@"icon_home_grayStar");
        [grayStarView addSubview:imgView];
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.offset(15);
            make.left.offset(gray_xLeft);
            make.centerY.equalTo(grayStarView);
        }];
        gray_xLeft = gray_xLeft+15;
    }
    
    self.safetyView = [[UIView alloc] init];
    self.safetyView.clipsToBounds = YES;
    [self.whiteView addSubview:self.safetyView];
    [self.safetyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel).offset(0);
        make.width.offset(15*5);
        make.height.offset(15);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(3.5);
    }];
    
    int xLeft = 0;
    for (int i=0; i<5; i++) {
        UIImageView *imgView = [[UIImageView alloc] init];
        imgView.image = HHGetImage(@"icon_home_redStar");
        [self.safetyView addSubview:imgView];
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.offset(15);
            make.left.offset(xLeft);
            make.centerY.equalTo(self.safetyView);
        }];
        xLeft = xLeft+15;
    }
    
    self.detailLabel = [[UILabel alloc] init];
    self.detailLabel.textColor = XLColor_mainTextColor;
    self.detailLabel.font = XLFont_subSubTextFont;
    [self.whiteView addSubview:self.detailLabel];
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.offset(-15);
        make.top.equalTo(self.headImageView.mas_bottom).offset(10);
        make.height.offset(15);
    }];
    
    self.commentLabel = [[YYLabel alloc] init];
    self.commentLabel.textColor = XLColor_mainTextColor;
    self.commentLabel.font = XLFont_subTextFont;
    self.commentLabel.numberOfLines = 0;
    [self.whiteView addSubview:self.commentLabel];
    [self.commentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.offset(-15);
        make.height.offset(19);
        make.top.equalTo(self.detailLabel.mas_bottom).offset(10);
    }];
   
    [self.whiteView addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.top.equalTo(self.commentLabel.mas_bottom).offset(12);
        make.width.offset(kScreenWidth-60);
        make.height.offset(0);
    }];
    
    self.grayView = [[UIView alloc] init];
    self.grayView.backgroundColor = XLColor_mainColor;
    self.grayView.layer.cornerRadius = 8;
    self.grayView.layer.masksToBounds = YES;
    [self.whiteView addSubview:self.grayView];
    [self.grayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.offset(-15);
        make.top.equalTo(self.collectionView.mas_bottom).offset(0);
        make.height.offset(50);
    }];
    
    self.replyLabel = [[YYLabel alloc] init];
    self.replyLabel.textColor = XLColor_mainTextColor;
    self.replyLabel.font = XLFont_subTextFont;
    self.replyLabel.numberOfLines = 0;
    [self.grayView addSubview:self.replyLabel];
    [self.replyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.offset(-15);
        make.height.offset(0);
        make.top.offset(10);
    }];
}

- (void)setModel:(HHCommentModel *)model {
    _model = model;
    
    [self.imageArray removeAllObjects];
    if(_model.file_path.count != 0){
        for (NSDictionary *dii in _model.file_path) {
            NSString *file_path = dii[@"file_path"];
            [self.imageArray addObject:file_path];
        }
    }
    
    NSLog(@"self.imageArray.count===============%ld",self.imageArray.count);
   
    
    self.detailLabel.text = _model.comment_desc;
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:_model.user_head_img]];
    self.nameLabel.text = _model.user_name;
    
    [self.safetyView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.offset(_model.rating*15);
    }];
    
    if(_model.is_reply){
        self.grayView.hidden = NO;
        self.replyLabel.hidden = NO;
    }else {
        self.grayView.hidden = YES;
        self.replyLabel.hidden = YES;
    }
    //图片
    if (_model.file_path.count == 0) {
        [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.offset(0);
            make.height.offset(0);
        }];
    }else {
        [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.offset(kScreenWidth-60);
            make.height.offset(_model.imageHeight);
        }];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView reloadData];
    });
    
    NSString *desc = model.user_content;
    if (desc) {
        //计算文本高度
        CGFloat height = [desc heightWithStrAttri:@{NSFontAttributeName:XLFont_subTextFont, NSForegroundColorAttributeName: XLColor_mainTextColor,NSParagraphStyleAttributeName:[self paragraphStyle]} withLabelWidth:kScreenWidth-60];
        if (height > 110) { //超过5行
            if (model.showAll) {
                self.commentLabel.truncationToken = nil;
                [self setShowTextWithDesc:desc withLabel:self.commentLabel withTage:1];
            } else {
                [self setAdjustableTextWithDesc:desc withLabel:self.commentLabel withTage:1];
            }
        } else {
            NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:desc attributes:@{ NSFontAttributeName:XLFont_subTextFont, NSParagraphStyleAttributeName : [self paragraphStyle]}];
            self.commentLabel.attributedText = text;
        }
    }
    
    [self.commentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.offset(_model.userCommentHeight);
    }];
    
    NSString *content = _model.reply_comment[@"content"];
    if (content) {
        //计算文本高度
        CGFloat height = [content heightWithStrAttri:@{NSFontAttributeName:XLFont_subTextFont, NSForegroundColorAttributeName: XLColor_mainTextColor,NSParagraphStyleAttributeName:[self paragraphStyle]} withLabelWidth:kScreenWidth-60];
        if (height > 45) { //超过3行
            if (model.hotel_showAll) {
                self.replyLabel.truncationToken = nil;
                [self setShowTextWithDesc:content withLabel:self.replyLabel withTage:2];
            } else {
                [self setAdjustableTextWithDesc:content withLabel:self.replyLabel withTage:2];
            }
        } else {
            NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:content attributes:@{ NSFontAttributeName:XLFont_subTextFont, NSParagraphStyleAttributeName : [self paragraphStyle]}];
            self.replyLabel.attributedText = text;
        }
    }
    
    
    [self.replyLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.offset(_model.hotelCommentHeight);
    }];
    
    [self.grayView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.offset(_model.hotelCommentHeight+20);
    }];
}

- (void)setShowTextWithDesc:(NSString *)desc withLabel:(YYLabel *)label withTage:(NSInteger )tag{
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@   收起",desc] attributes:@{ NSFontAttributeName:XLFont_subTextFont, NSParagraphStyleAttributeName : [self paragraphStyle]}];
    
    WeakSelf(weakSelf);
    //设置高亮色和点击事件
    [text yy_setTextHighlightRange:[[text string] rangeOfString:@"收起"] color:RGBColor(182, 143, 128) backgroundColor:[UIColor clearColor] tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        if(tag == 1){
            weakSelf.model.showAll = NO;
        }else {
            weakSelf.model.hotel_showAll = NO;
        }
        if (weakSelf.updateCommentCellBlock) {
            weakSelf.updateCommentCellBlock();
        }
    }];
    label.attributedText = text;
}

- (void)setAdjustableTextWithDesc:(NSString *)desc withLabel:(YYLabel *)label withTage:(NSInteger )tag{
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:desc attributes:@{ NSFontAttributeName:XLFont_subTextFont, NSParagraphStyleAttributeName : [self paragraphStyle]}];
    label.attributedText = text;
    
    WeakSelf(weakSelf);
    NSMutableAttributedString *showAll = [[NSMutableAttributedString alloc] initWithString:@"...展开" attributes:nil];
    YYTextHighlight *hi = [YYTextHighlight new];
    [hi setColor:RGBColor(182, 143, 128)];
    hi.tapAction = ^(UIView *containerView,NSAttributedString *text,NSRange range, CGRect rect) {
        if(tag == 1){
            weakSelf.model.showAll = YES;
        }else {
            weakSelf.model.hotel_showAll = YES;
        }
        if (weakSelf.updateCommentCellBlock) {
            weakSelf.updateCommentCellBlock();
        }
    };
    
    NSRange range = [showAll.string rangeOfString:@"展开"];
    [showAll yy_setColor:RGBColor(182, 143, 128) range:range];
    [showAll yy_setTextHighlight:hi range:range];
    showAll.yy_font = XLFont_subTextFont;
    YYLabel *seeMore = [YYLabel new];
    seeMore.attributedText = showAll;
    [seeMore sizeToFit];
    seeMore.height += 2.f;
    NSAttributedString *truncationToken = [NSAttributedString yy_attachmentStringWithContent:seeMore contentMode:UIViewContentModeCenter attachmentSize:seeMore.frame.size alignToFont:XLFont_subTextFont alignment:YYTextVerticalAlignmentTop];
    label.truncationToken = truncationToken;
}

- (NSMutableParagraphStyle *)paragraphStyle {
    NSMutableParagraphStyle *para = [NSMutableParagraphStyle new];
    para.lineSpacing = 5.f;
    return para;
}

#pragma mark - <UICollectionViewDataSource, UICollectionViewDelegate>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.imageArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HHImageAndVideoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HHImageAndVideoCollectionViewCell" forIndexPath:indexPath];
    cell.data = self.imageArray[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    [self showBrowserForMixedCaseWithIndex:indexPath.row];
}

#pragma mark - Show 'YBImageBrowser' : Mixed case
- (void)showBrowserForMixedCaseWithIndex:(NSInteger)index {
    
    NSMutableArray *browserDataArr = [NSMutableArray array];
    [self.imageArray enumerateObjectsUsingBlock:^(NSString *_Nonnull imageStr, NSUInteger idx, BOOL * _Nonnull stop) {

        // 此处只是为了判断测试用例的数据源是否为视频，并不是仅支持 MP4。
        if ([imageStr hasSuffix:@".mp4"] || [imageStr hasSuffix:@".MP4"]) {
            if ([imageStr hasPrefix:@"http"]) {
                
                // Type 1 : 网络视频 / Network video
                YBVideoBrowseCellData *data = [YBVideoBrowseCellData new];
                data.url = [NSURL URLWithString:imageStr];
                data.sourceObject = [self sourceObjAtIdx:idx];
                [browserDataArr addObject:data];
                
            } else {
                
                // Type 2 : 本地视频 / Local video
                NSString *path = [[NSBundle mainBundle] pathForResource:imageStr.stringByDeletingPathExtension ofType:imageStr.pathExtension];
                NSURL *url = [NSURL fileURLWithPath:path];
                YBVideoBrowseCellData *data = [YBVideoBrowseCellData new];
                data.url = url;
                data.sourceObject = [self sourceObjAtIdx:idx];
                [browserDataArr addObject:data];
                
            }
        } else if ([imageStr hasPrefix:@"http"]) {
            
            // Type 3 : 网络图片 / Network image
            YBImageBrowseCellData *data = [YBImageBrowseCellData new];
            data.url = [NSURL URLWithString:imageStr];
            data.sourceObject = [self sourceObjAtIdx:idx];
            [browserDataArr addObject:data];
            
        } else {
            
            // Type 4 : 本地图片 / Local image
            YBImageBrowseCellData *data = [YBImageBrowseCellData new];
            data.imageBlock = ^YBImage *{ return [YBImage imageNamed:imageStr]; };
            data.sourceObject = [self sourceObjAtIdx:idx];
            [browserDataArr addObject:data];
            
        }
    }];
    
    YBImageBrowser *browser = [YBImageBrowser new];
    browser.dataSourceArray = browserDataArr;
    browser.currentIndex = index;
    [browser show];
}

- (id)sourceObjAtIdx:(NSInteger)idx {
    HHImageAndVideoCollectionViewCell *cell = (HHImageAndVideoCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:idx inSection:0]];
    return cell ? cell.mainImageView : nil;
}

@end

