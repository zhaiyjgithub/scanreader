//
//  SR_FoundSearchNoteViewController.m
//  scanreader
//
//  Created by jbmac01 on 16/8/22.
//  Copyright © 2016年 jb. All rights reserved.
//

#import "SR_FoundSearchNoteViewController.h"
#import "globalHeader.h"
#import "requestAPI.h"
#import "httpTools.h"
#import "SR_BookClubBookNoteModel.h"
#import "AVRefreshExtension.h"
#import "UserInfo.h"
#import "SR_FoundMainImageViewCell.h"
#import "SR_FoundMainVoiceViewCell.h"
#import "SR_FoundMainTextViewCell.h"
#import "SR_FoundMainTextSelfViewCell.h"
#import "SR_FoundMainImageSelfViewCell.h"
#import "SR_FoundMainVoiceSelfViewCell.h"
#import "SR_FoundMainTextSelfViewCell.h"
#import "SR_InterPageViewController.h"
#import "SR_FoundMainCollectionViewCell.h"
#import "SR_NoteDetailPageViewController.h"
#import "SR_OthersMineViewController.h"
#import "SR_MineViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <MJRefresh.h>

@interface SR_FoundSearchNoteViewController ()<UISearchBarDelegate>
@property(nonatomic,strong)UISearchBar * searchBar;
@property(nonatomic,assign)NSInteger noteSearchPageIndex;
@property(nonatomic,strong)AVPlayer * remotePlayer;
@property(nonatomic,assign)BOOL isFinishedPlay;
@property(nonatomic,strong)AVPlayerItem * playerItem;
@property(nonatomic,strong)NSMutableArray * noteList;
@end

@implementation SR_FoundSearchNoteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"笔记";
    [self setupSerchBar];
    self.tableView.av_footer = [AVFooterRefresh footerRefreshWithScrollView:self.tableView footerRefreshingBlock:^{
        [self loadData];
    }];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.searchBar resignFirstResponder];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  self.noteList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 8.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 8.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    SR_BookClubBookNoteModel * noteModel = self.noteList[indexPath.row];
    if ([noteModel.type isEqualToString:NOTE_TYPE_TEXT]) {
        return 146;
    }else if ([noteModel.type isEqualToString:NOTE_TYPE_PIX]){
        return 180;
    }else{
        return 146;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //根据type 来区分笔记的类型
    //        1文字
    //        2图片
    //        3语音
    //        4收藏
    SR_BookClubBookNoteModel * noteModel = self.noteList[indexPath.row];
    if ([noteModel.type isEqualToString:NOTE_TYPE_TEXT]) {//文字信息
        NSString * cellId = @"SR_FoundMainTextViewCell";
        SR_FoundMainTextViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[SR_FoundMainTextViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellId];
        }
        cell.noteModel = self.noteList[indexPath.row];
        __weak typeof(self) weakSelf = self;
        [cell addBlock:^{
            if ([noteModel.user.user_id isEqualToString:[UserInfo getUserId]]) {//自己的笔记跳转到自己的个人信息
                SR_MineViewController * mineVC = [[SR_MineViewController alloc] init];
                [weakSelf.navigationController pushViewController:mineVC animated:YES];
            }else{
                SR_OthersMineViewController * otherVC = [[SR_OthersMineViewController alloc] init];
                SR_BookClubBookNoteModel * noteModel = weakSelf.noteList[indexPath.row];
                otherVC.userModel = noteModel.user;
                [weakSelf.navigationController pushViewController:otherVC animated:YES];
            }
        }];
        return cell;
    }else if ([noteModel.type isEqualToString:NOTE_TYPE_PIX]){//图片
        NSString * cellId = @"SR_FoundMainImageViewCell";
        SR_FoundMainImageViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[SR_FoundMainImageViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellId];
        }
        cell.noteModel = self.noteList[indexPath.row];
        __weak typeof(self) weakSelf = self;
        [cell addBlock:^{
            if ([noteModel.user.user_id isEqualToString:[UserInfo getUserId]]) {//自己的笔记跳转到自己的个人信息
                
                SR_MineViewController * mineVC = [[SR_MineViewController alloc] init];
                [weakSelf.navigationController pushViewController:mineVC animated:YES];
            }else{
                SR_OthersMineViewController * otherVC = [[SR_OthersMineViewController alloc] init];
                SR_BookClubBookNoteModel * noteModel = weakSelf.noteList[indexPath.row];
                otherVC.userModel = noteModel.user;
                [weakSelf.navigationController pushViewController:otherVC animated:YES];
            }
        }];
        return cell;
        
    }else if ([noteModel.type isEqualToString:NOTE_TYPE_VOICE]){//语音
        NSString * cellId = @"SR_FoundMainVoiceViewCell";
        SR_FoundMainVoiceViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[SR_FoundMainVoiceViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellId];
        }
        cell.noteModel = self.noteList[indexPath.row];
        __weak typeof(self) weakSelf = self;
        [cell addBlock:^{
            if ([noteModel.user.user_id isEqualToString:[UserInfo getUserId]]) {//自己的笔记跳转到自己的个人信息
                SR_MineViewController * mineVC = [[SR_MineViewController alloc] init];
                [weakSelf.navigationController pushViewController:mineVC animated:YES];
            }else{
                SR_OthersMineViewController * otherVC = [[SR_OthersMineViewController alloc] init];
                SR_BookClubBookNoteModel * noteModel = weakSelf.noteList[indexPath.row];
                otherVC.userModel = noteModel.user;
                [weakSelf.navigationController pushViewController:otherVC animated:YES];
            }
        }];
        [cell addInterBlock:^{
            SR_InterPageViewController * interPaageVC = [[SR_InterPageViewController alloc] init];
            [weakSelf.navigationController pushViewController:interPaageVC animated:YES];
        }];
        
        [cell addVoiceBtnBlock:^(NSString *voiceUrl,float voiceTimeLength) {
            [weakSelf playVoiceWithFilePath:voiceUrl row:indexPath.row voiceTimeLength:voiceTimeLength];
        }];
        return cell;
    }else{//收藏
        NSString * cellId = @"SR_FoundMainCollectionViewCell";
        SR_FoundMainCollectionViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[SR_FoundMainCollectionViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellId];
        }
        __weak typeof(self) weakSelf = self;
        [cell addBlock:^{
            if ([noteModel.user.user_id isEqualToString:[UserInfo getUserId]]) {//自己的笔记跳转到自己的个人信息
                SR_MineViewController * mineVC = [[SR_MineViewController alloc] init];
                [weakSelf.navigationController pushViewController:mineVC animated:YES];
            }else{
                SR_OthersMineViewController * otherVC = [[SR_OthersMineViewController alloc] init];
                SR_BookClubBookNoteModel * noteModel = weakSelf.noteList[indexPath.row];
                otherVC.userModel = noteModel.user;
                [weakSelf.navigationController pushViewController:otherVC animated:YES];
            }
        }];
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SR_BookClubBookNoteModel * noteModel = self.noteList[indexPath.row];
    SR_NoteDetailPageViewController * noteDetailVC = [[SR_NoteDetailPageViewController alloc] init];
    noteDetailVC.noteModel = noteModel;
    [self.navigationController pushViewController:noteDetailVC animated:YES];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.searchBar resignFirstResponder];
}

- (void)playVoiceWithFilePath:(NSString *)filePath row:(int)row voiceTimeLength:(float)voiceTimeLength{
    static int lastRow = -1;
    if (lastRow != row) {
        if (lastRow != -1) {//如果不是第一次打开的就可以获取上一次的语音的cell
            NSIndexPath * indexPath = [NSIndexPath indexPathForRow:lastRow inSection:0];
            SR_FoundMainVoiceViewCell * lastVoiceViewCell = (SR_FoundMainVoiceViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
            UIView * progressView = lastVoiceViewCell.voiceProgressView;
            [progressView.layer removeAllAnimations];//清除上一次的动画
        }
        self.isFinishedPlay = NO;
        self.playerItem = [[AVPlayerItem alloc] initWithURL:[NSURL URLWithString:filePath]];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(playerItemDidReachEnd)
                                                     name:AVPlayerItemDidPlayToEndTimeNotification
                                                   object:self.playerItem];
        
        self.remotePlayer = [[AVPlayer alloc] initWithPlayerItem:self.playerItem];
        [self.remotePlayer play];
        NSIndexPath * indexPath = [NSIndexPath indexPathForRow:row inSection:0];
        SR_FoundMainVoiceViewCell * voiceViewCell = (SR_FoundMainVoiceViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        
        //
        voiceViewCell.voiceProgressView.backgroundColor = baseColor;
        CGRect voiceProgressViewFrame = voiceViewCell.voiceProgressView.frame;
        [UIView animateWithDuration:voiceTimeLength animations:^{
            voiceViewCell.voiceProgressView.frame = CGRectMake(voiceProgressViewFrame.origin.x, voiceProgressViewFrame.origin.y, voiceViewCell.barView.frame.size.width, voiceViewCell.barView.frame.size.height);
            voiceViewCell.voiceProgressView.backgroundColor = kColor(215, 215, 215);
        } completion:^(BOOL finished) {
            voiceViewCell.voiceProgressView.frame = CGRectMake(voiceViewCell.barView.frame.origin.x, voiceViewCell.barView.frame.origin.y, 1, voiceViewCell.barView.frame.size.height);
        }];
        
        lastRow = row;
    }else{
        //在这里查询当前播放的状态，如果在播放就停止，已经播放完毕之后就重新播放
        if (!self.isFinishedPlay) {//点击了正在播放就可以终止播放
            //停止当前的progressView动画
            NSIndexPath * indexPath = [NSIndexPath indexPathForRow:row inSection:0];
            SR_FoundMainVoiceViewCell * currentVoiceViewCell = (SR_FoundMainVoiceViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
            UIView * voiceProgressView = currentVoiceViewCell.voiceProgressView;
            [voiceProgressView.layer removeAllAnimations];
            
            [self.remotePlayer pause];
            self.isFinishedPlay = YES;
        }else{//已经完成播放的可以重新继续播放同一个语音
            self.isFinishedPlay = NO;
            self.playerItem = [[AVPlayerItem alloc] initWithURL:[NSURL URLWithString:filePath]];
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(playerItemDidReachEnd)
                                                         name:AVPlayerItemDidPlayToEndTimeNotification
                                                       object:self.playerItem];
            
            self.remotePlayer = [[AVPlayer alloc] initWithPlayerItem:self.playerItem];
            [self.remotePlayer play];
            
            //AVPlayerItem
            NSIndexPath * indexPath = [NSIndexPath indexPathForRow:row inSection:0];
            SR_FoundMainVoiceViewCell * voiceViewCell = (SR_FoundMainVoiceViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
            
            voiceViewCell.voiceProgressView.backgroundColor = baseColor;
            CGRect voiceProgressViewFrame = voiceViewCell.voiceProgressView.frame;
            [UIView animateWithDuration:voiceTimeLength animations:^{
                voiceViewCell.voiceProgressView.frame = CGRectMake(voiceProgressViewFrame.origin.x, voiceProgressViewFrame.origin.y, voiceViewCell.barView.frame.size.width, voiceViewCell.barView.frame.size.height);
                voiceViewCell.voiceProgressView.backgroundColor = kColor(215, 215, 215);
            } completion:^(BOOL finished) {
                voiceViewCell.voiceProgressView.frame = CGRectMake(voiceViewCell.barView.frame.origin.x, voiceViewCell.barView.frame.origin.y, 1, voiceViewCell.barView.frame.size.height);
            }];
        }
    }
}

- (void)playerItemDidReachEnd{
    NSLog(@"播放完毕");
    self.isFinishedPlay = YES;
}

- (void)setupSerchBar{
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth - 40, 44)];
    self.searchBar.tintColor = [UIColor blackColor];
    self.searchBar.delegate = self;
    self.navigationItem.titleView = self.searchBar;
    [self.searchBar becomeFirstResponder];
    self.searchBar.placeholder = @"搜索笔记";
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self.searchBar resignFirstResponder];
    [self.noteList removeAllObjects];
    NSLog(@"text:%@",searchBar.text);
    [searchBar resignFirstResponder];
    
    
    [self.noteList removeAllObjects];
    [self getListAll:PAGE_NUM pageIndex:self.noteSearchPageIndex q:self.searchBar.text];
}

- (void)loadData{
    [self getListAll:PAGE_NUM pageIndex:self.noteSearchPageIndex + 1 q:self.searchBar.text];
}

//笔记 /api/note/getList
//互动页 /api/page/getList
//书籍 /api/book/getList

///获取笔记以及收藏列表,这个列表就是动态的列表
- (void)getListAll:(NSInteger)pageNum pageIndex:(NSInteger)pageIndex q:(NSString *)q{
    NSString * limit = [NSString stringWithFormat:@"%d",pageNum];
    NSString * page = [NSString stringWithFormat:@"%d",pageIndex];
    NSDictionary * param = @{@"limit":limit,@"page":page,@"q":q};
    [httpTools post:GET_NOTE_LIST_ALL andParameters:param success:^(NSDictionary *dic) {
        SSLog(@"search note list:%@",dic);
        NSArray * list = dic[@"data"][@"list"];
        //区分不同类型的笔记进行不同model的转换
        //根据type 来区分笔记的类型
        //        1文字
        //        2图片
        //        3语音
        //        4收藏
        for (NSDictionary * item in list) {
            SR_BookClubBookNoteModel * noteModel = [SR_BookClubBookNoteModel modelWithDictionary:item];
            noteModel.note_id = item[@"id"];
            if ([item[@"book"] isKindOfClass:[NSDictionary class]]) {
                noteModel.book.book_id = item[@"book"][@"id"];
            }
            noteModel.user.user_id = item[@"user"][@"id"];
            [self.noteList addObject:noteModel];
        }
        self.noteSearchPageIndex = (self.noteList.count/PAGE_NUM) + (self.noteList.count%PAGE_NUM > 0 ? 1 : 0);
        [self.tableView.av_footer endFooterRefreshing];
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        SSLog(@"error:%@",error);
    }];
}

- (NSMutableArray *)noteList{
    if (!_noteList) {
        _noteList = [[NSMutableArray alloc] init];
    }
    return _noteList;
}

@end
