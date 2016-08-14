//
//  SR_FoundMainViewController.m
//  scanreader
//
//  Created by jbmac01 on 16/7/13.
//  Copyright © 2016年 jb. All rights reserved.
//

#import "SR_FoundMainViewController.h"
#import "SR_LoginViewController.h"
#import "SR_MineViewController.h"
#import "SR_OthersMineViewController.h"
#import "SR_AddBtnView.h"
#import "SR_FoundMainImageViewCell.h"
#import "SR_FoundMainVoiceViewCell.h"
#import "SR_FoundMainCollectionViewCell.h"
#import "SR_MineViewController.h"
#import "SR_FoundSearchTableViewController.h"
#import "SR_FoundMainTextViewCell.h"
#import "SR_FoundMainTextSelfViewCell.h"
#import "SR_FoundMainImageSelfViewCell.h"
#import "SR_FoundMainVoiceSelfViewCell.h"
#import "SR_FoundMainTextSelfViewCell.h"
#import "globalHeader.h"
#import "SR_FoundMainDynamicViewCell.h"
#import "SR_FoundMainBookClubBookMarkListViewController.h"
#import "SR_InterPageViewController.h"

#import "SR_ActionSheetVoiceView.h"
#import "httpTools.h"
#import <SVProgressHUD.h>
#import <MBProgressHUD.h>
#import "UserInfo.h"

@interface SR_FoundMainViewController ()<addBtnDelegate,UISearchBarDelegate,UIAlertViewDelegate>
@property(nonatomic,assign)BOOL isSelectBookClubBtn;
@end

@implementation SR_FoundMainViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    self.title = @"发现";
    
    UIBarButtonItem * mineItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"fx_twoman"] style:(UIBarButtonItemStyleDone) target:self action:@selector(clickMineItem)];
    UIBarButtonItem * searchItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"fx_ss"] style:(UIBarButtonItemStyleDone) target:self action:@selector(clickSearchItem)];
    self.navigationItem.rightBarButtonItems = @[mineItem,searchItem];
 
    [self relogin];
}

- (void)clickSearchItem{
//    SR_FoundSearchTableViewController * foundVC = [[SR_FoundSearchTableViewController alloc] init];
//    [self.navigationController pushViewController:foundVC animated:YES];
    SR_ActionSheetVoiceView * iamge = [[SR_ActionSheetVoiceView alloc] initActionSheetWith:nil voices:nil viewController:self];
    [iamge show];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 6;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 81;
    }else{
        return 0.01;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 8.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.isSelectBookClubBtn) {
        return 128;
    }else{
        if(indexPath.section == 1) return 108;
        if (indexPath.section > 3) return 115;
        return 146;
    }

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.isSelectBookClubBtn) {
        NSString * cellId = @"SR_FoundMainDynamicViewCell";
        SR_FoundMainDynamicViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[SR_FoundMainDynamicViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellId];
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }else{
        if (indexPath.section == 0) {
            NSString * cellId = @"SR_FoundMainVoiceViewCell";
            SR_FoundMainVoiceViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
            if (!cell) {
                cell = [[SR_FoundMainVoiceViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellId];
            }
            __weak typeof(self) weakSelf = self;
            [cell addBlock:^{
                SSLog(@"click header btn");
            }];
            [cell addInterBlock:^{
                SR_InterPageViewController * interPaageVC = [[SR_InterPageViewController alloc] init];
                [weakSelf.navigationController pushViewController:interPaageVC animated:YES];
            }];
            return cell;
        }else if (indexPath.section == 1){
            NSString * cellId = @"SR_FoundMainCollectionViewCell";
            SR_FoundMainCollectionViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
            if (!cell) {
                cell = [[SR_FoundMainCollectionViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellId];
            }
            [cell addBlock:^{
                SSLog(@"click header btn");
            }];
            return cell;
        } else if(indexPath.section == 2){
            NSString * cellId = @"SR_FoundMainImageViewCell";
            SR_FoundMainImageViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
            if (!cell) {
                cell = [[SR_FoundMainImageViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellId];
            }
            [cell addBlock:^{
                SSLog(@"click header btn");
            }];
            return cell;
        }else if(indexPath.section == 3){
            NSString * cellId = @"SR_FoundMainTextViewCell";
            SR_FoundMainTextViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
            if (!cell) {
                cell = [[SR_FoundMainTextViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellId];
            }
            [cell addBlock:^{
                SSLog(@"click header btn");
            }];
            return cell;
        }else if(indexPath.section == 4){
            NSString * cellId = @"SR_FoundMainTextSelfViewCell";
            SR_FoundMainTextSelfViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
            if (!cell) {
                cell = [[SR_FoundMainTextSelfViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellId];
            }
            [cell addBlock:^{
                SSLog(@"click header btn");
            }];
            return cell;
        }else if(indexPath.section == 5){
            NSString * cellId = @"SR_FoundMainImageSelfViewCell";
            SR_FoundMainImageSelfViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
            if (!cell) {
                cell = [[SR_FoundMainImageSelfViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellId];
            }
            [cell addBlock:^{
                SSLog(@"click header btn");
            }];
            return cell;
        }else{
            NSString * cellId = @"SR_FoundMainVoiceSelfViewCell";
            SR_FoundMainVoiceSelfViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
            if (!cell) {
                cell = [[SR_FoundMainVoiceSelfViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellId];
            }
            [cell addBlock:^{
                SSLog(@"click header btn");
            }];
            return cell;
        }

    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.isSelectBookClubBtn) {//读书会
        SR_FoundMainBookClubBookMarkListViewController * bookMarkListVC = [[SR_FoundMainBookClubBookMarkListViewController alloc] init];
        [self.navigationController pushViewController:bookMarkListVC animated:YES];
    }else{//动态
        
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 125)];
        headerView.backgroundColor = [UIColor whiteColor];
        
        UIView * headerNotiBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 36)];
        headerView.backgroundColor = kColor(0xe2, 0xea, 0xe8);
        [headerView addSubview:headerNotiBgView];
        
        UIImageView * headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 3, 30, 30)];
        headerImageView.layer.cornerRadius = 15;
        headerImageView.backgroundColor = [UIColor redColor];
        [headerView addSubview:headerImageView];
        
        UILabel * notiLabel = [[UILabel alloc] initWithFrame:CGRectMake(headerImageView.frame.origin.x + headerImageView.frame.size.width + 10, 0, kScreenWidth - 30 - 10 - headerImageView.frame.size.width, 36)];
        notiLabel.text = @"小明刚才扫描了《天龙八部》";
        notiLabel.textColor = baseblackColor;
        notiLabel.font = [UIFont systemFontOfSize:13.0];
        notiLabel.textAlignment = NSTextAlignmentCenter;
        [headerView addSubview:notiLabel];
        
        NSArray * titles = @[@"动态",@"读书会"];
        for (int i = 0; i < 2; i ++) {
            UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(i*(kScreenWidth/2), notiLabel.frame.origin.y + notiLabel.frame.size.height, kScreenWidth/2, 42)];
            [btn setTitle:titles[i] forState:(UIControlStateNormal)];
            [btn setTitleColor:baseColor forState:(UIControlStateNormal)];
            [btn setTitle:titles[i] forState:(UIControlStateSelected)];
            [btn setTitleColor:kColor(0x88, 0x88, 0x88) forState:(UIControlStateSelected)];
            btn.titleLabel.font = [UIFont systemFontOfSize:16.0];
            if (i == 0) {
                [btn setSelected:self.isSelectBookClubBtn];
                
            }else{
                [btn setSelected:!self.isSelectBookClubBtn];
            }
            btn.tag = i;
            [btn addTarget:self action:@selector(clickHeaderBtn:) forControlEvents:(UIControlEventTouchUpInside)];
            [headerView addSubview:btn];
        }
        
        UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth/2, notiLabel.frame.size.height + notiLabel.frame.origin.y + 2, 1, 40)];
        lineView.backgroundColor = [UIColor lightGrayColor];
        [headerView addSubview:lineView];
        
        UIView * notiLabelBottomLineView = [[UIView alloc] initWithFrame:CGRectMake(0, notiLabel.frame.origin.y + notiLabel.frame.size.height, kScreenWidth, 0.5)];
        notiLabelBottomLineView.backgroundColor = [UIColor lightGrayColor];
        [headerView addSubview:notiLabelBottomLineView];
        
        return headerView;
    }else{
        return nil;
    }
}

- (void)clickMineItem{
    SR_MineViewController * mineVC = [[SR_MineViewController alloc] init];
    [self.navigationController pushViewController:mineVC animated:YES];
}

- (void)clickHeaderBtn:(UIButton *)btn{
    SSLog(@"btn tag:%d",btn.tag);
    self.isSelectBookClubBtn = !self.isSelectBookClubBtn;
    [self.tableView reloadData];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    SSLog(@"search text:%@",searchText);
}

- (void)relogin{
    NSString * phoneNumber = [UserInfo getUserPhoneNumber];
    NSString * password = [UserInfo getUserPassword];
    
    NSDictionary * param = @{@"username":phoneNumber,@"password":password};
    [httpTools post:LOGIN andParameters:param success:^(NSDictionary *dic) {
        SSLog(@"relogin:%@",dic);
        if ([dic[@"status"] isEqualToString:@"1"]) {
            NSDictionary * userDic = dic[@"data"][@"user"];
            [UserInfo saveUserAvatarWith:userDic[@"avatar"]];
            [UserInfo saveUserIDWith:userDic[@"id"]];
            [UserInfo saveUserTokenWith:dic[@"data"][@"user_token"]];
            [UserInfo saveUserNameWith:userDic[@"username"]];
        }else{//可能是token过期,就需要重新登录
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"获取该账号信息失败，请重新登录" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [UIApplication sharedApplication].keyWindow.rootViewController = [[SR_LoginViewController alloc] init];
}


@end
