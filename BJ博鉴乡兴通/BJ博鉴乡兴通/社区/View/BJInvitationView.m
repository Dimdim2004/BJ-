//
//  BJInvitationView.m
//  BJ博鉴乡兴通
//
//  Created by nanxun on 2025/2/6.
//

#import "BJInvitationView.h"
#import "BJInvitationTableViewCell.h"
#import "BJInvitationHeaderTableViewCell.h"
#import "Masonry.h"
@implementation BJInvitationView
- (void)setUI {
    self.backgroundColor = UIColor.whiteColor;
    self.mainView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 393, 762) style:UITableViewStylePlain];
    self.mainView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_mainView];
    self.mainView.estimatedRowHeight = 100;
    self.mainView.rowHeight = UITableViewAutomaticDimension;
}
- (void)setToolBar {
    
    UIView* toolView = [[UIView alloc] init];
    UIView* lineView = [[UIView alloc] init];
    lineView.backgroundColor = UIColor.lightGrayColor;
    toolView.backgroundColor = UIColor.whiteColor;
    UIButton* likeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [likeButton setImage:[UIImage imageNamed:@"likeInvat.png"] forState:UIControlStateNormal];
    [likeButton setTitle:@"123" forState:UIControlStateNormal];
    [likeButton setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    UIButton* starButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [starButton setImage:[UIImage imageNamed:@"starInvat.png"] forState:UIControlStateNormal];
    [starButton setTitle:@"123" forState:UIControlStateNormal];
    [starButton setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    UIButton* commentCountButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [commentCountButton setImage:[UIImage imageNamed:@"number.png"] forState:UIControlStateNormal];
    [commentCountButton setTitle:@"123" forState:UIControlStateNormal];
    [commentCountButton setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    self.postButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    UIColor* myColor = [UIColor colorWithRed:242.0 / 255.0 green:242.0 / 255.0 blue:242 / 255.0 alpha:1];
    
    self.commentTextView = [[UITextView alloc] init];
    self.commentTextView.text = @"说点什么";
    self.commentTextView.backgroundColor = myColor;
    self.commentTextView.layer.masksToBounds = YES;
    self.commentTextView.layer.cornerRadius = 20;
    self.commentTextView.textContainerInset = UIEdgeInsetsMake(13, 8, 0, 0);
    self.commentTextView.textColor = UIColor.lightGrayColor;
    self.commentTextView.font = [UIFont systemFontOfSize:13];
    [self addSubview:toolView];
    [toolView addSubview:lineView];
    [toolView addSubview:likeButton];
    [toolView addSubview:self.commentTextView];
    [toolView addSubview:starButton];
    [toolView addSubview:commentCountButton];
    self.toolBar = toolView;
    [toolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self);
        make.left.right.equalTo(self);
        make.height.equalTo(@90);
    }];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(toolView);
        make.left.width.equalTo(toolView);
        make.height.equalTo(@0.4);
    }];
    [self.commentTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(toolView).offset(10);
        make.width.equalTo(@165);
        make.top.equalTo(toolView).offset(15);
        make.height.equalTo(@40);
    }];
    [likeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.commentTextView.mas_right).offset(12);
        make.width.equalTo(@60);
        make.centerY.equalTo(self.commentTextView);
        make.height.equalTo(@30);
    }];
    [starButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(likeButton.mas_right).offset(12);
        make.width.equalTo(@60);
        make.centerY.equalTo(self.commentTextView);
        make.height.equalTo(@30);
    }];
    [commentCountButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(starButton.mas_right).offset(12);
        make.width.equalTo(@60);
        make.centerY.equalTo(self.commentTextView);
        make.height.equalTo(@30);
    }];
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUI];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
