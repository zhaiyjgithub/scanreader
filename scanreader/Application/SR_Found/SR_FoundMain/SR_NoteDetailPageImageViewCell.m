//
//  SR_NoteDetailPageImageViewCell.m
//  scanreader
//
//  Created by jbmac01 on 16/8/28.
//  Copyright © 2016年 jb. All rights reserved.
//

#import "SR_NoteDetailPageImageViewCell.h"
#import "globalHeader.h"
#import "NSDate+JJ.h"
#import "NSString+JJ.h"


@implementation SR_NoteDetailPageImageViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupCell];
    }
    return self;
}

- (void)setupCell{
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 125, 15)];
    self.titleLabel.text = @"笔记标题";
    self.titleLabel.font = [UIFont systemFontOfSize:15.0];
    self.titleLabel.textColor = [UIColor blackColor];
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:self.titleLabel];
    
    self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(15,self.titleLabel.frame.origin.y + self.titleLabel.frame.size.height + 8,120,16)];
    self.timeLabel.text = @"2016-06-28 12:30";
    self.timeLabel.textAlignment = NSTextAlignmentLeft;
    self.timeLabel.font = [UIFont systemFontOfSize:12.0];
    [self.contentView addSubview:self.timeLabel];
    
    self.imagebgView = [[UIView alloc] initWithFrame:CGRectMake((kScreenWidth - 300)/2, self.timeLabel.frame.origin.y + self.timeLabel.frame.size.height + 8,300, 300 + 10)];
    self.imagebgView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.contentView addSubview:self.imagebgView];
    
    self.subtitleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, self.imagebgView.frame.origin.y + self.imagebgView.frame.size.height + 11, 19, 19)];
    self.subtitleImageView.image = [UIImage imageNamed:@"fx_book"];
    [self.contentView addSubview:self.subtitleImageView];
    
    self.subtitleButton = [[UIButton alloc] initWithFrame:CGRectMake(self.subtitleImageView.frame.origin.x + self.subtitleImageView.frame.size.width + 5, self.subtitleImageView.frame.origin.y, 200, 19)];
    [self.subtitleButton setTitle:@"《论语》第十二页" forState:(UIControlStateNormal)];
    [self.subtitleButton setTitleColor:baseColor forState:(UIControlStateNormal)];
    [self.subtitleButton setTitleColor:[UIColor lightGrayColor] forState:(UIControlStateHighlighted)];
    self.subtitleButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.subtitleButton.titleLabel.font = [UIFont systemFontOfSize:12.0];
    [self.subtitleButton addTarget:self action:@selector(clickInterBtn) forControlEvents:(UIControlEventTouchUpInside)];
    [self.contentView addSubview:self.subtitleButton];
    
    UIImageView * messageImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, self.subtitleButton.frame.origin.y + self.subtitleButton.frame.size.height + 10, 17, 17)];
    messageImageView.image = [UIImage imageNamed:@"fx_hd"];
    self.messageImageView = messageImageView;
    [self.contentView addSubview:messageImageView];
    
    self.messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(messageImageView.frame.origin.x + messageImageView.frame.size.width + 10, messageImageView.frame.origin.y, 64, 17)];
    self.messageLabel.text = @"互动(20)";
    self.messageLabel.textColor = baseblackColor;
    self.messageLabel.textAlignment = NSTextAlignmentLeft;
    self.messageLabel.font = [UIFont systemFontOfSize:12.0];
    [self.contentView addSubview:self.messageLabel];
    
    UIImageView * bookFriendsView = [[UIImageView alloc] initWithFrame:CGRectMake(self.messageLabel.frame.origin.x + self.messageLabel.frame.size.width + 25, self.messageLabel.frame.origin.y, 17, 17)];
    bookFriendsView.image = [UIImage imageNamed:@"fx_twoman"];
    self.bookFriendsView = bookFriendsView;
    [self.contentView addSubview:bookFriendsView];
    
    self.bookFriendsLabel = [[UILabel alloc] initWithFrame:CGRectMake(bookFriendsView.frame.origin.x + bookFriendsView.frame.size.width + 10, bookFriendsView.frame.origin.y, 64, 17)];
    self.bookFriendsLabel.text = @"读友(85)";
    self.bookFriendsLabel.textColor = baseblackColor;
    self.bookFriendsLabel.textAlignment = NSTextAlignmentLeft;
    self.bookFriendsLabel.font = [UIFont systemFontOfSize:12.0];
    [self.contentView addSubview:self.bookFriendsLabel];
}

- (void)clickInterBtn{
    SSLog(@"click inter btn");
}

- (void)setNoteModel:(SR_BookClubBookNoteModel *)noteModel{
    _noteModel = noteModel;
    self.titleLabel.text = noteModel.title;
    NSDate * createData = [NSDate dateWithTimeIntervalSince1970:noteModel.time_create];
    NSString * time = [NSDate getRealDateTime:createData withFormat:@"yyyy-MM-dd HH:mm"];
    self.timeLabel.text = time;
//    CGSize contentSize = [noteModel.content sizeForFont:[UIFont systemFontOfSize:14.0] size:CGSizeMake(kScreenWidth - 30, MAXFLOAT) mode:(NSLineBreakByWordWrapping)];
//    self.imagebgView.frame = CGRectMake(15, self.timeLabel.frame.origin.y + self.timeLabel.frame.size.height + 8, (int)contentSize.width, (int)contentSize.height + 10);

    for (UIView * sonView in self.imagebgView.subviews) {
        [sonView removeFromSuperview];
    }
    
    NSMutableArray * resourceList = [NSMutableArray new];
    self.imagebgView.frame = CGRectMake((kScreenWidth - 300)/2, self.timeLabel.frame.origin.y + self.timeLabel.frame.size.height + 8, 300, (300 + 5)*noteModel.resourceList.count);
    int i = 0 ;
    for (NSDictionary * item in noteModel.resourceList) {
        SR_BookClubNoteResourceModel * resourceModel = [SR_BookClubNoteResourceModel modelWithDictionary:item];
        [resourceList addObject:resourceModel];
        YYAnimatedImageView * resouceImageView = [[YYAnimatedImageView alloc] init];
        resouceImageView.frame = CGRectMake(0, i*(300 + 5), 300, 300);
        [resouceImageView setImageWithURL:[NSURL URLWithString:resourceModel.path] placeholder:nil];
        [self.imagebgView addSubview:resouceImageView];
        i += 1;
    }
    
    
    if (!noteModel.page || [noteModel.page isEqualToString:@"null"]) {
        self.subtitleImageView.hidden = YES;
        self.subtitleButton.hidden = YES;
    }
    
    self.subtitleImageView.frame = CGRectMake(15, self.imagebgView.frame.origin.y + self.imagebgView.frame.size.height + 11, 19, 19);
    self.subtitleButton.frame = CGRectMake(self.subtitleImageView.frame.origin.x + self.subtitleImageView.frame.size.width + 5, self.subtitleImageView.frame.origin.y, 200, 19);
    self.messageImageView.frame = CGRectMake(15, self.subtitleButton.frame.origin.y + self.subtitleButton.frame.size.height + 10, 17, 17);
    self.messageLabel.frame = CGRectMake(self.messageImageView.frame.origin.x + self.messageImageView.frame.size.width + 10, self.messageImageView.frame.origin.y, 64, 17);
    self.bookFriendsView.frame = CGRectMake(self.messageLabel.frame.origin.x + self.messageLabel.frame.size.width + 25, self.messageLabel.frame.origin.y, 17, 17);
    self.bookFriendsLabel.frame =CGRectMake(self.bookFriendsView.frame.origin.x + self.bookFriendsView.frame.size.width + 10, self.bookFriendsView.frame.origin.y, 64, 17);
    
    
    [self.subtitleButton setTitle:noteModel.page forState:(UIControlStateNormal)];
    self.messageLabel.text = [NSString stringWithFormat:@"互动(%@)",noteModel.note_total];
    self.bookFriendsLabel.text = [NSString stringWithFormat:@"读友(%@)",noteModel.member_total];
    ;
}


@end
