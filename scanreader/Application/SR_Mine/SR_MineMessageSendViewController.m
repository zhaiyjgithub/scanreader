//
//  SR_MineMessageSendViewController.m
//  scanreader
//
//  Created by jbmac01 on 16/7/19.
//  Copyright © 2016年 jb. All rights reserved.
//

#import "SR_MineMessageSendViewController.h"
#import "globalHeader.h"
#import "SR_MineMessageSendDialogMineViewCell.h"
#import "UserInfo.h"
#import "httpTools.h"
#import "requestAPI.h"
#import "SR_MineMessageModel.h"
#import "AVRefreshExtension.h"
#import "SR_MineMessageFrameModel.h"
#import "SR_MineMessageSendDialogMineSendViewCell.h"
#import <SVProgressHUD.h>

@interface SR_MineMessageSendViewController ()<UITextViewDelegate,UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)NSMutableArray * dataSource;
@property(nonatomic,strong)UIView * toolBar;
@property(nonatomic,strong)UITextView * toolBarTextView;
@property(nonatomic,strong)UIButton * toolBarSendBtn;

//@property(nonatomic,assign)NSInteger numOfRows;
@property(nonatomic,assign)NSInteger messageListPageIndex;
@end

@implementation SR_MineMessageSendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"对话";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = [UIColor whiteColor];
    
    [self setupToolBar];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    SR_MineMessageFrameModel * frameModel = self.dataSource[indexPath.row];
    return frameModel.cellMessageLableSize.height + 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SR_MineMessageFrameModel * frameModel = self.dataSource[indexPath.row];
    if (frameModel.messageModel.isMyAccount) {
        NSString * cellId = @"SR_MineMessageSendDialogMineSendViewCell";
        SR_MineMessageSendDialogMineSendViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[SR_MineMessageSendDialogMineSendViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellId];
        }
        cell.frameModel = self.dataSource[indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }else{
        NSString * cellId = @"SR_MineMessageSendDialogMineViewCell";
        SR_MineMessageSendDialogMineViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[SR_MineMessageSendDialogMineViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellId];
        }
        cell.frameModel = self.dataSource[indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
}

- (void)setupToolBar{
    self.toolBar = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight - 53, kScreenWidth, 53)];
    self.toolBar.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:self.toolBar];
    
    self.toolBarTextView = [[UITextView alloc] initWithFrame:CGRectMake(10, 8, kScreenWidth - 10 - 10 - 10 - 35, 35)];
    self.toolBarTextView.backgroundColor = [UIColor whiteColor];
    self.toolBarTextView.delegate = self;
    self.toolBarTextView.layer.cornerRadius = 5.0;
    self.toolBarTextView.font = [UIFont systemFontOfSize:15.0];
    [self.toolBar addSubview:self.toolBarTextView];
    
    self.toolBarSendBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    self.toolBarSendBtn.frame = CGRectMake(kScreenWidth - 10 - 44, 8, 44, 35);
    [self.toolBarSendBtn setTitle:@"发送" forState:(UIControlStateNormal)];
    [self.toolBarSendBtn setTitleColor:baseColor forState:(UIControlStateNormal)];
    [self.toolBarSendBtn setTitle:@"发送" forState:(UIControlStateHighlighted)];
    [self.toolBarSendBtn setTitleColor:[UIColor lightGrayColor] forState:(UIControlStateHighlighted)];
    [self.toolBarSendBtn addTarget:self action:@selector(clickSendBtn) forControlEvents:(UIControlEventTouchUpInside)];
    [self.toolBar addSubview:self.toolBarSendBtn];
}

- (void)clickSendBtn{
    if (!self.toolBarTextView.text.length) {
        [SVProgressHUD showErrorWithStatus:@"输入内容不能为空"];
        return;
    }
    NSString * receipentId = [[[self.dataSource firstObject] messageModel] sender_id];
    [self sendMessage:receipentId content:self.toolBarTextView.text];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}

- (void)setMessageModelsList:(NSMutableArray *)messageModelsList{
    _messageModelsList = messageModelsList;
    for (SR_MineMessageModel * messageModel in messageModelsList) {
        SR_MineMessageFrameModel * frameModel = [[SR_MineMessageFrameModel alloc] init];
        frameModel.messageModel = messageModel;
        [self.dataSource addObject:frameModel];
    }
}
#pragma mark Responding to keyboard events
- (void)keyboardWillShow:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    CGRect keyBoardRect = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    if (!keyBoardRect.size.height) {
        return;
    }
    [UIView animateWithDuration:animationDuration animations:^{
        self.toolBar.frame = CGRectMake(0, kScreenHeight - keyBoardRect.size.height - 53, kScreenWidth, 53);
        self.tableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - keyBoardRect.size.height - 53);
    } completion:^(BOOL finished) {
        if (finished) {
            NSIndexPath * indexpath = [NSIndexPath indexPathForRow:(self.dataSource.count - 1) inSection:0];
            [self.tableView scrollToRowAtIndexPath:indexpath atScrollPosition:(UITableViewScrollPositionBottom) animated:YES];
        }
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    NSDictionary* userInfo = [notification userInfo];
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    [UIView animateWithDuration:animationDuration animations:^{
        self.toolBar.frame = CGRectMake(0, kScreenHeight - 53, kScreenWidth, 53);
        self.tableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - 53);
    } completion:^(BOOL finished) {
        
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    return YES;
}

#pragma mark -UI控件
- (UITableView *)tableView {
    if (!_tableView) {
        UITableView * tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 53) style:UITableViewStylePlain];
        //当前使用原生的分割线，不适用图片的方式加载分割线
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.tintColor=[UIColor orangeColor];
        
        _tableView=tableView;
    }
    return _tableView;
}
#pragma mark -数据源
- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] initWithCapacity:1];
    }
    return _dataSource;
}

///发送消息
- (void)sendMessage:(NSString * )recipient_id content:(NSString *)content{
    NSString * userId = [UserInfo getUserId];
    NSString * userToken = [UserInfo getUserToken];
    NSDictionary * param = @{@"user_id":userId,@"user_token":userToken,@"recipient_id":recipient_id,
                             @"content":content};
    
    [httpTools post:SEND_MESSAGE andParameters:param success:^(NSDictionary *dic) {
       // NSLog(@"send message result:%@",dic);
        SR_MineMessageModel * newMessageModel = [[SR_MineMessageModel alloc] init];
        newMessageModel.content = self.toolBarTextView.text;
        newMessageModel.time_create = [[NSDate date] timeIntervalSince1970];
        Sender * sender = [[Sender alloc] init];
        sender.sender_id = [UserInfo getUserId];
        sender.avatar = [UserInfo getUserAvatar];
        sender.username = [UserInfo getUserName];
        newMessageModel.sender = sender;
        newMessageModel.isMyAccount = YES;
        
        SR_MineMessageFrameModel * newFrameModel = [[SR_MineMessageFrameModel alloc] init];
        newFrameModel.messageModel = newMessageModel;
        [self.dataSource addObject:newFrameModel];
        NSIndexPath * indexpath = [NSIndexPath indexPathForRow:self.dataSource.count - 1 inSection:0];
        [self.tableView insertRowsAtIndexPaths:@[indexpath] withRowAnimation:(UITableViewRowAnimationBottom)];
        [self.tableView scrollToRowAtIndexPath:indexpath atScrollPosition:(UITableViewScrollPositionBottom) animated:YES];

    } failure:^(NSError *error) {
        SSLog(@"error:%@",error);
    }];
}


@end
