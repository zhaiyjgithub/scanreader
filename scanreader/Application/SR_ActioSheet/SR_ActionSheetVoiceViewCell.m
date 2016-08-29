//
//  SR_ActionSheetVoiceViewCell.m
//  scanreader
//
//  Created by jbmac01 on 16/8/29.
//  Copyright © 2016年 jb. All rights reserved.
//

#import "SR_ActionSheetVoiceViewCell.h"
#import "globalHeader.h"

@implementation SR_ActionSheetVoiceViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupCell];
    }
    return self;
}

- (void)setupCell{
    UIView * barView = [[UIView alloc] initWithFrame:CGRectMake(10, 24, (kScreenWidth - 30 - 20), 42)];
    barView.backgroundColor = kColor(215, 215, 215);
    barView.layer.cornerRadius = 21.0;
    [self.contentView addSubview:barView];
    
    UIButton * voiceBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    voiceBtn.frame = CGRectMake(0, 0, 70, 70);
    voiceBtn.center = CGPointMake(barView.frame.size.width/2 + 10, 45);
    voiceBtn.backgroundColor = baseColor;
    [voiceBtn setTitle:@"语音" forState:(UIControlStateNormal)];
    [voiceBtn setTitleColor:baseblackColor forState:(UIControlStateNormal)];
    voiceBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
    voiceBtn.layer.cornerRadius = 35;
    [voiceBtn addTarget:self action:@selector(clickBtn:) forControlEvents:(UIControlEventTouchUpInside)];
    voiceBtn.tag = 0;
    [self.contentView addSubview:voiceBtn];
    
    UIButton * deleteBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    deleteBtn.frame  = CGRectMake(0, 0, 17, 17);
    deleteBtn.center = CGPointMake(barView.frame.origin.x + barView.frame.size.width - 4, barView.frame.origin.y);
    deleteBtn.tag = 1;
    [deleteBtn setImage:[UIImage imageNamed:@"zbj_del"] forState:(UIControlStateNormal)];
    [deleteBtn addTarget:self action:@selector(clickBtn:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.contentView addSubview:deleteBtn];
}

- (void)clickBtn:(UIButton *)btn{
    if (self.block) {
        self.block(btn);
    }
}

- (void)addBlock:(SR_ActionSheetVoiceViewCellBlock)block{
    self.block = block;
}


@end
