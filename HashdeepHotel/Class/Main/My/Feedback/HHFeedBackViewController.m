//
//  HHFeedBackViewController.m
//  HashdeepHotel
//
//  Created by Cindy on 2022/7/29.
//

#import "HHFeedBackViewController.h"

@interface HHFeedBackViewController ()<UITextViewDelegate>
@property (nonatomic, strong) UITextView *textView;//输入的文字
@end

@implementation HHFeedBackViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kWhiteColor;
    
    //自定义导航栏
    [self _createdNavigationBar];
    
    //创建Views
    [self _createdViews];
}

#pragma mark -----------------------自定义导航栏-----------------------
- (void)_createdNavigationBar {
    
    [self createdNavigationBackButton];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"意见反馈";
    titleLabel.textColor = XLColor_mainTextColor;
    titleLabel.font = KBoldFont(18);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.offset(UINavigateTop+10);
        make.height.offset(20);
    }];
}

#pragma mark ---------------------创建Views---------------------
- (void)_createdViews {
    
    UILabel *topLabel = [[UILabel alloc] init];
    topLabel.text = @"您好，欢迎进入安住会用户反馈意见收集页面，您的反馈将帮助我们为您和他人提供更优质的服务。";
    topLabel.textColor = XLColor_mainTextColor;
    topLabel.font = XLFont_subTextFont;
    topLabel.numberOfLines = 0;
    [self.view addSubview:topLabel];
    [topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.offset(-15);
        make.top.offset(UINavigateHeight+30);
        make.height.offset(40);
    }];
    
    UILabel *detailLabel = [[UILabel alloc] init];
    detailLabel.text = @"请在下列输入框中描述您所遇到的问题或您的建议";
    detailLabel.textColor = XLColor_mainTextColor;
    detailLabel.font = XLFont_subSubTextFont;
    [self.view addSubview:detailLabel];
    [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.offset(-15);
        make.top.equalTo(topLabel.mas_bottom).offset(10);
        make.height.offset(20);
    }];
    
    UIView *textSuperView = [[UIView alloc] init];
    textSuperView.backgroundColor = kWhiteColor;
    textSuperView.layer.cornerRadius = 15;
    textSuperView.layer.masksToBounds = YES;
    textSuperView.layer.borderWidth = 1;
    textSuperView.layer.borderColor = XLColor_subSubTextColor.CGColor;
    [self.view addSubview:textSuperView];
    [textSuperView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.offset(-15);
        make.top.equalTo(detailLabel.mas_bottom).offset(10);
        make.height.offset(200);
    }];
    
    self.textView = [[UITextView alloc] init];
    self.textView.textColor = XLColor_subSubTextColor;
    self.textView.text = @"请输入内容";
    self.textView.delegate = self;
    self.textView.font = XLFont_subTextFont;
    self.textView.textAlignment = NSTextAlignmentLeft;
    [textSuperView addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.top.offset(5);
        make.right.offset(-15);
        make.bottom.offset(-5);
    }];
 
    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [doneButton setTitle:@"提交反馈" forState:UIControlStateNormal];
    [doneButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
    doneButton.backgroundColor = UIColorHex(b58e7f);
    doneButton.layer.cornerRadius = 8;
    doneButton.layer.masksToBounds = YES;
    doneButton.titleLabel.font = XLFont_mainTextFont;
    doneButton.layer.shadowColor = kBlackColor.CGColor;
    //shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用  (0,0)时是四周都有阴影
    doneButton.layer.shadowOffset = CGSizeMake(0, 0);
    //阴影透明度，默认0
    doneButton.layer.shadowOpacity = 0.3;
    //阴影半径，默认3
    doneButton.clipsToBounds = NO;
    doneButton.layer.shadowRadius = 3;
    [doneButton addTarget:self action:@selector(doneButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:doneButton];
    [doneButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.offset(-15);
        make.height.offset(45);
        make.top.equalTo(textSuperView.mas_bottom).offset(20);
    }];
}

- (void)doneButtonAction:(UIButton *)button {
    button.enabled = NO;
    if ([self.textView.text isEqualToString:@"请输入内容"] && self.textView.text.length !=0 ) {
        [self.view makeToast:@"请输入内容" duration:2 position:CSToastPositionCenter];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            button.enabled = YES;
       });
        return;
    }
    if([HHAppManage isBlankString:self.textView.text]){
        [self.view makeToast:@"内容不能为空" duration:2 position:CSToastPositionCenter];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            button.enabled = YES;
       });
        return;
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        button.enabled = YES;
   });
    [self.view makeToast:@"提交成功" duration:2 position:CSToastPositionCenter];
    
    [self performSelector:@selector(perform) withObject:nil afterDelay:1];
}

- (void)perform {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark ----------------textViewDelegate---------
//是否开始编辑
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    if ([textView.text isEqualToString:@"请输入内容"]) {
        textView.text = @"";
    }
    textView.textColor = XLColor_mainTextColor;
    return YES;
}

//是否结束编辑
- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    
    if ([textView.text isEqualToString:@""]) {
        textView.text = @"请输入内容";
        textView.textColor = XLColor_subSubTextColor;
    }else{
        
        textView.textColor = XLColor_mainTextColor;
    }
    
    return YES;
}
- (void)textViewDidChange:(UITextView *)textView {
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        //在这里做你响应return键的代码
        [self.view endEditing:YES];
        
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    return YES;
}
@end
