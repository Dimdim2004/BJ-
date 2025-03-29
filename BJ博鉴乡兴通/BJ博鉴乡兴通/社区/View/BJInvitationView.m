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
    self.likeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.likeButton setImage:[UIImage imageNamed:@"likeInvat.png"] forState:UIControlStateNormal];
    [self.likeButton setImage:[UIImage imageNamed:@"likeBig.png"] forState:UIControlStateSelected];
    [self.likeButton setTitle:@"123" forState:UIControlStateNormal];
    [self.likeButton setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    self.starButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.starButton setImage:[UIImage imageNamed:@"starInvat.png"] forState:UIControlStateNormal];
    [self.starButton setImage:[UIImage imageNamed:@"starBig.png"] forState:UIControlStateSelected];
    [self.starButton setTitle:@"123" forState:UIControlStateNormal];
    [self.starButton setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    self.commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.commentButton setImage:[UIImage imageNamed:@"number.png"] forState:UIControlStateNormal];
    [self.commentButton setTitle:@"123" forState:UIControlStateNormal];
    [self.commentButton setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    self.postButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.postButton setTitle:@"发表" forState:UIControlStateNormal];
    self.postButton.layer.masksToBounds = YES;
    self.postButton.layer.cornerRadius = 10;
    self.postButton.frame = CGRectMake(0, 0, 80, 30);
    self.postButton.layer.borderWidth = 1;
    
    self.postButton.layer.masksToBounds = YES;
    self.postButton.layer.cornerRadius = 13;
    UIColor* postColor = [UIColor colorWithRed:98.0 / 255.0 green:184.0 / 255.0 blue:120 / 255.0 alpha:1];\
    self.postButton.layer.borderColor = postColor.CGColor;
    self.postButton.backgroundColor = postColor;
    [self.postButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    
    UIColor* myColor = [UIColor colorWithRed:242.0 / 255.0 green:242.0 / 255.0 blue:242 / 255.0 alpha:1];
    
    self.activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleLarge];
    
    
    self.footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 393, 30)];
    [self.footerView addSubview:self.activity];
    [self.activity mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.footerView);
    }];
    
    self.commentTextView = [[UITextView alloc] init];
    self.commentTextView.tag = 200;
    self.commentTextView.text = @"说点什么";
    self.commentTextView.backgroundColor = myColor;
    self.commentTextView.layer.masksToBounds = YES;
    self.commentTextView.layer.cornerRadius = 20;
    self.commentTextView.textContainerInset = UIEdgeInsetsMake(13, 8, 0, 0);
    self.commentTextView.textColor = UIColor.lightGrayColor;
    self.commentTextView.font = [UIFont systemFontOfSize:13];
    [self addSubview:toolView];
    [toolView addSubview:lineView];
    [toolView addSubview:self.postButton];
    [toolView addSubview:self.likeButton];
    [toolView addSubview:self.commentTextView];
    [toolView addSubview:self.starButton];
    [toolView addSubview:self.commentButton];
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
    [self.likeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.commentTextView.mas_right).offset(12);
        make.width.equalTo(@60);
        make.centerY.equalTo(self.commentTextView);
        make.height.equalTo(@30);
    }];
    [self.starButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.likeButton.mas_right).offset(12);
        make.width.equalTo(@60);
        make.centerY.equalTo(self.commentTextView);
        make.height.equalTo(@30);
    }];
    [self.commentButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.starButton.mas_right).offset(12);
        make.width.equalTo(@60);
        make.centerY.equalTo(self.commentTextView);
        make.height.equalTo(@30);
    }];
    [_postButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-20);
        make.width.equalTo(@60);
        make.top.equalTo(self.commentTextView.mas_bottom).offset(3);
        make.height.equalTo(@30);
    }];
    self.postButton.hidden = YES;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUI];
    }
    return self;
}
- (void)selectLike:(UIButton*)btn {
    btn.selected = !btn.selected;
}
- (void)loadActivity:(BOOL)loading {
    if (loading) {
        self.mainView.tableFooterView = self.footerView;
        [self.activity startAnimating];
    } else {
        self.mainView.tableFooterView = nil;
        [self.activity stopAnimating];
    }
}
-(void)endLoadActivity {
    [self.activity removeFromSuperview];
    self.mainView.tableFooterView = self.footerView;
    UILabel* label = [[UILabel alloc] init];
    label.text = @"暂时没有更多评论了";
    [self.footerView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.footerView);
    }];
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
