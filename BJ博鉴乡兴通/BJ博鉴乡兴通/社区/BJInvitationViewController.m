//
//  BJInvitationViewController.m
//  BJ博鉴乡兴通
//
//  Created by nanxun on 2025/2/2.
//

#import "BJInvitationViewController.h"
#import "BJInvitationTableViewCell.h"
#import "BJInvitationHeaderTableViewCell.h"
#import "BJInvitationSubCommentsTableViewCell.h"
#import "SubCommentsModel+DealWithComment.h"
#import "Masonry.h"
#import "BJCommentsModel.h"
#import "SDWebImage/SDWebImage.h"
#import "BJNetworkingManger.h"
#import "BJSubCommentsModel.h"
#import "BJAttentionDataModel.h"
#import "BJImageModel.h"
#import "BJUploadCommentModel.h"
#import "BJCommunityViewController.h"
@interface BJInvitationViewController () {
    NSInteger _pageId;
    NSInteger _pageSize;
    BOOL _scrollFlag;
    NSTimer* _timer;
    NSInteger _replyId;
    NSInteger _parentId;
    NSInteger _commentId;
    NSInteger _commentUserId;
    NSInteger _currentSection;
    BOOL _loadMore;
    BOOL _isLoading;
    BOOL isMyself;
}

@end

@implementation BJInvitationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.commityModel.userId == [BJNetworkingManger sharedManger].userId) {
        isMyself = YES;
    } else {
        isMyself = NO;
    }
    _loadMore = YES;
    _isLoading = YES;
    _replyId = 0;
    _parentId = 0;
    _commentId = 0;
    id manger = [BJNetworkingManger sharedManger];
    _scrollFlag = NO;
    _pageId = 1;
    _pageSize = 3;
    _currentSection = 1;
    self.dicty = [NSMutableDictionary dictionary];
    self.view.backgroundColor = UIColor.whiteColor;
    self.iView = [[BJInvitationView alloc] initWithFrame:self.view.bounds];
    [self.iView setToolBar];
    [self registerTableview];
    [self.view addSubview:self.iView];
    [self setButtonSelected];
    self.iView.commentTextView.delegate = self;
    self.iView.mainView.tag = 300;
    [self setNavgationBar];
    
    __weak BJInvitationViewController* weakSelf = self;
    [manger loadWithCommentWithWorkId:_workId CommentId:0 withType:1 withPage:_pageId withPageSize:_pageSize WithSuccess:^(BJCommentsModel * _Nonnull commentModel) {
        __strong BJInvitationViewController* strongSelf = weakSelf;
        strongSelf->_isLoading = NO;
        weakSelf.commentModel = commentModel;
        if (commentModel.commentList == nil) {
            weakSelf.commentModel.commentList = [NSMutableArray array];
        }
        for (int i = 0; i < weakSelf.commentModel.commentList.count; i++) {
            BJSubCommentsModel* subModel = weakSelf.commentModel.commentList[i];
            subModel.pageId = 1;
        }
        [weakSelf.iView.mainView reloadData];
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"load loacl View");
    }];
    [self.iView.postButton addTarget:self action:@selector(postComment) forControlEvents:UIControlEventTouchUpInside];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification  object:nil];
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification  object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification  object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(commentTextDidChange:) name:UITextViewTextDidChangeNotification  object:self.iView.commentTextView];
    // Do any additional setup after loading the view.
}

- (void)setButtonSelected {
    [self.iView.likeButton addTarget:self action:@selector(selectLike:) forControlEvents:UIControlEventTouchUpInside];
    [self.iView.starButton addTarget:self action:@selector(selectLike:) forControlEvents:UIControlEventTouchUpInside];
    if (self.commityModel.isFavorite == 1) {
        self.iView.likeButton.selected = 1;
        [self.iView.likeButton setTitle:[NSString stringWithFormat:@"%ld", self.commityModel.favoriteCount] forState:UIControlStateSelected];
        [self.iView.likeButton setTitle:[NSString stringWithFormat:@"%ld", self.commityModel.favoriteCount - 1] forState:UIControlStateNormal];
    } else {
        [self.iView.likeButton setTitle:[NSString stringWithFormat:@"%ld", self.commityModel.favoriteCount] forState:UIControlStateNormal];
        [self.iView.likeButton setTitle:[NSString stringWithFormat:@"%ld", self.commityModel.favoriteCount + 1] forState:UIControlStateSelected];
    }
    
    NSLog(@"评论个数%ld, 文章内容%@, 文章标题%@", self.commityModel.commentCount, self.commityModel.content, self.commityModel.title);
    [self.iView.commentButton setTitle:[NSString stringWithFormat:@"%ld", self.commityModel.commentCount] forState:UIControlStateNormal];
}

- (void)registerTableview {
    [self.iView.mainView registerClass:[BJInvitationTableViewCell class] forCellReuseIdentifier:@"comments"];
    [self.iView.mainView registerClass:[BJInvitationHeaderTableViewCell class] forCellReuseIdentifier:@"header"];
    [self.iView.mainView registerClass:[BJInvitationSubCommentsTableViewCell class] forCellReuseIdentifier:@"subComments"];
    [self.iView.mainView registerClass:[BJInvitationSubCommentsTableViewCell class] forCellReuseIdentifier:@"noComment"];
    [self.view addSubview:self.iView];
    self.iView.mainView.delegate = self;
    self.iView.mainView.dataSource = self;
}
- (void)textViewDidBeginEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:@"说点什么"]) {
        textView.font = [UIFont systemFontOfSize:18];
        textView.text = @"";
        textView.textColor = UIColor.blackColor;
    }
}
- (void)textViewDidEndEditing:(UITextView *)textView {
    if (textView.text.length < 1) {
        textView.text = @"说点什么";
        textView.textColor = UIColor.lightGrayColor;
    } else {
        
    }
}
-(void)keyboardWillShow:(NSNotification*)notification {
    CGRect frame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat height = frame.origin.y;
    CGFloat y = height - frame.size.height;
    CGFloat animationTime  = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    //[self.iView.commentTextView removeFromSuperview];
    if (!self.iView.backView) {
        self.iView.backView = [[UIView alloc] initWithFrame:self.view.bounds];
        self.iView.backView.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.5];
        self.iView.backView.alpha = 0;
        [self.iView addSubview:self.iView.backView];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyborad)];
        tapGesture.numberOfTapsRequired = 1;
        tapGesture.numberOfTouchesRequired = 1;
        [self.iView.backView addGestureRecognizer:tapGesture];
        self.iView.backView.hidden = NO;
    } else {
        self.iView.backView.hidden = NO;
    }
    [self.iView bringSubviewToFront:self.iView.toolBar];
    void (^animation)(void) = ^void(void) {
        self.iView.backView.alpha = 1;
        self.iView.toolBar.transform = CGAffineTransformMakeTranslation(0, - frame.size.height);
        
        [self.iView.commentTextView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.iView.toolBar).offset(5);
            make.left.equalTo(self.iView).offset(10);
            make.right.equalTo(self.iView).offset(-10);
            make.height.equalTo(@50);
            }];
        self.iView.postButton.hidden = NO;
        
    };
    if (animationTime > 0) {
        __weak BJInvitationViewController* weakSelf = self;
        [UIView animateWithDuration:animationTime animations:animation completion:^(BOOL finished) {
            weakSelf.iView.backView.hidden = NO;
        }];
    } else {
        animation();
        
    }
//    [self.iView.commentTextView mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.iView.backView.mas_bottom);
//        make.left.right.equalTo(self.iView);
//        make.height.equalTo(@50);
//    }];
    
}
-(void)hideKeyborad {
    self.iView.commentTextView.text = @"说点什么";
    self.iView.commentTextView.textColor = UIColor.lightGrayColor;
    [self.iView.commentTextView resignFirstResponder];
}
-(void)keyboardWillHide:(NSNotification*)notification {
    CGFloat animationTime  = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    void (^animation)(void) = ^void(void) {
        self.iView.toolBar.transform = CGAffineTransformIdentity;
        [self.iView.commentTextView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.iView.toolBar).offset(10);
            make.width.equalTo(@165);
            make.top.equalTo(self.iView.toolBar).offset(15);
            make.height.equalTo(@40);
        }];
        self.iView.postButton.hidden = YES;
    };
    if (animationTime > 0) {
        [UIView animateWithDuration:animationTime animations:animation];
    } else {
        animation();
    }
    
    self.iView.backView.hidden = YES;
    NSLog(@"hide");
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.commentModel !=  nil) {
        NSLog(@"%@", self.commentModel.commentList);
        if (self.commentModel.commentList == nil) {
            self.commentModel.commentList = [NSMutableArray array];
        }
        return self.commentModel.commentList.count == 0 ? 2 : self.commentModel.commentList.count + 1;
    } else {
        return 2;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else {
        if (self.commentModel.commentList.count > 0) {
            BJSubCommentsModel* commentModel = self.commentModel.commentList[section - 1];
            NSLog(@"加载高度时候查询得到当前的一个commentId%ld", commentModel.commentId);
            if (_dicty[@(commentModel.commentId)]) {
                BJCommentsModel* currentCommentModel = _dicty[@(commentModel.commentId)];
                NSLog(@"当前的一个row个数%ld", currentCommentModel.commentList.count);
                return currentCommentModel.commentList.count + 1;
            } else {
                NSLog(@"123123123当前没有展开一条子评论");
                return 1;
            }
        } else {
            return 1;
        }
        
        
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (indexPath.section == 0) {
        
        BJInvitationHeaderTableViewCell* headerCell = [self.iView.mainView dequeueReusableCellWithIdentifier:@"header"];
        headerCell.selectionStyle = UITableViewCellSelectionStyleNone;
        headerCell.titleLabel.text = self.commityModel.title;
        headerCell.contentLabel.text = self.commityModel.content;
        headerCell.headScrollerView.delegate = self;
        
        NSMutableArray<NSString*>* mutableAry = [NSMutableArray array];
        for (int i = 0; i < self.commityModel.images.count; i++) {
            BJImageModel* model = self.commityModel.images[i];
            [mutableAry addObject:model.url];
            NSLog(@"打印%@url", model.url);
        }
        
        NSArray* ary = [NSArray arrayWithArray:mutableAry];
        [headerCell addUrlImageToScrollerView:ary];
        self.page = headerCell.mypage;
        return headerCell;
    }
    if (self.commentModel != nil) {
        if (self.commentModel.commentList.count == 0) {
            BJInvitationSubCommentsTableViewCell* noCommentCell = [self.iView.mainView dequeueReusableCellWithIdentifier:@"noComment"];
            return noCommentCell;
        }
        if (indexPath.row == 0) {
            BJInvitationTableViewCell* commentCell = [self.iView.mainView dequeueReusableCellWithIdentifier:@"comments"];
            [self addTapToCommentCell:commentCell atIndexPath:indexPath];
            //commentCell.selectionStyle = UITableViewCellSelectionStyleNone;
            BJSubCommentsModel* currentModel = self.commentModel.commentList[indexPath.section - 1];
            [commentCell.replyButton addTarget:self action:@selector(showKeyboard:) forControlEvents:UIControlEventTouchUpInside];
            if (currentModel.total > 0 && self.dicty[@(currentModel.commentId)] == nil) {
                commentCell.commentButton.hidden = NO;
                [commentCell.commentButton addTarget:self action:@selector(expandSubComment:) forControlEvents:UIControlEventTouchUpInside];
                [commentCell.timeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.bottom.equalTo(commentCell.commentButton.mas_top).offset(-5).priorityHigh();
                }];
            } else {
                commentCell.commentButton.hidden = YES;
                [commentCell.timeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.bottom.equalTo(commentCell.contentView.mas_bottom).offset(-5).priorityHigh();
                }];
            }
            
            commentCell.textView.text = currentModel.content;
            if ([currentModel.username isEqualToString:[BJNetworkingManger sharedManger].username]) {
                commentCell.nameLabel.text = @"我";
            } else {
                commentCell.nameLabel.text = currentModel.username;
            }
            
            
            if ([currentModel.avatar isEqualToString:@""]) {
                NSLog(@"设置默认图片");
                [commentCell.image setImage:[UIImage imageNamed:@"title.jpg"]];
            } else {
                NSLog(@"123");
                [commentCell.image sd_setImageWithURL:[NSURL URLWithString:currentModel.avatar]];
            }
            NSLog(@"%@", currentModel.timeString);
            commentCell.timeLabel.text = [currentModel dealWithTime];
        //        commentCell.textView.text = currentModel.content;
        //        commentCell.nameLabel.text = currentModel.username;
            [commentCell.likeButton setTitle:@"0" forState:UIControlStateNormal];
            [commentCell.likeButton setTitle:@"1" forState:UIControlStateSelected];
            commentCell.likeButton.selected = currentModel.isLike;
            NSLog(@"当前这%ld行主评论对应的一个按钮是否被点过赞%ld", indexPath.section - 1, currentModel.isLike);
            
            [commentCell.likeButton addTarget:self action:@selector(selectLike:) forControlEvents:UIControlEventTouchUpInside];
            return commentCell;
        } else {
            NSLog(@"处理展开后的评论");
            BJInvitationSubCommentsTableViewCell* subCommentCell = [self.iView.mainView dequeueReusableCellWithIdentifier:@"subComments"];
            [self addTapToCommentCell:subCommentCell atIndexPath:indexPath];
            subCommentCell.selectionStyle = UITableViewCellSelectionStyleNone;
            BJSubCommentsModel* currentModel = self.commentModel.commentList[indexPath.section - 1];
            NSInteger commentId = currentModel.commentId;
            BJCommentsModel* subCommentModel = (BJCommentsModel*)self.dicty[@(commentId)];
            [subCommentCell.replyButton addTarget:self action:@selector(showKeyboard:) forControlEvents:UIControlEventTouchUpInside];
            if (indexPath.row != subCommentModel.commentList.count) {
                subCommentCell.commentButton.hidden = YES;
                [subCommentCell.timeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.bottom.equalTo(subCommentCell.contentView.mas_bottom).offset(-5).priorityHigh();
                }];
            } else if (currentModel.total - indexPath.row > 0){
                subCommentCell.commentButton.hidden = NO;
                [subCommentCell.commentButton addTarget:self action:@selector(expandSubComment:) forControlEvents:UIControlEventTouchUpInside];
            } else {
                subCommentCell.commentButton.hidden = YES;
                [subCommentCell.timeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.bottom.equalTo(subCommentCell.contentView.mas_bottom).offset(-5).priorityHigh();
                }];
            }
            
            BJSubCommentsModel* currentCommentModel = subCommentModel.commentList[indexPath.row - 1];
            NSLog(@"%@", currentCommentModel.content);
            subCommentCell.textView.text = currentCommentModel.content;
            subCommentCell.timeLabel.text = [currentCommentModel dealWithTime];
        //        commentCell.textView.text = currentModel.content;
        //        commentCell.nameLabel.text = currentModel.username;
            [subCommentCell.likeButton setTitle:@"0" forState:UIControlStateNormal];
            [subCommentCell.likeButton setTitle:@"1" forState:UIControlStateSelected];
            subCommentCell.likeButton.selected = currentCommentModel.isLike;
            
            NSLog(@"当前这%ld行子评论对应的一个按钮是否被点过赞%d", indexPath.row - 1, currentCommentModel.isLike);
            if (currentCommentModel.userId == [BJNetworkingManger sharedManger].userId && [currentCommentModel.replyToUsername isEqualToString:[BJNetworkingManger sharedManger].username]) {
                subCommentCell.nameLabel.text = @"我";
            } else if (currentCommentModel.userId == [BJNetworkingManger sharedManger].userId) {
                subCommentCell.nameLabel.text = [NSString stringWithFormat:@"我回复%@", currentCommentModel.replyToUsername];
            } else if ([currentCommentModel.replyToUsername isEqualToString:[BJNetworkingManger sharedManger].username]) {
                subCommentCell.nameLabel.text = [NSString stringWithFormat:@"%@回复我", currentCommentModel.username];
            } else {
                subCommentCell.nameLabel.text = [NSString stringWithFormat:@"%@回复%@", currentCommentModel.username, currentCommentModel.replyToUsername];
            }
            
            [subCommentCell.likeButton addTarget:self action:@selector(selectLike:) forControlEvents:UIControlEventTouchUpInside];
            [subCommentCell.image sd_setImageWithURL:[NSURL URLWithString:currentCommentModel.avatar]];
            return subCommentCell;
        }
    } else {
        if (indexPath.section == 0) {
            BJInvitationHeaderTableViewCell* headerCell = [self.iView.mainView dequeueReusableCellWithIdentifier:@"header"];
            headerCell.titleLabel.text = @"这是一个标题";
            headerCell.contentLabel.text = @"d写入和读取同一个管道文件实现一个跨进程通信了。这里我们如果想实现一个管道间的通信的话，其实是通过fork创建一个子进程，创建的子进程会复制父进程的文件描述符，这浪就可以做到两个进程间的一个通信的，这样会做到两个进程各有两个`fd[0]` `fd[1]`,两个进程就可以通过各自的fd写入d写入和读取同一个管道文件实现一个跨进程通信了。这里我们如果想实现一个管道间的通信的话，其实是通过fork创建一个子进程，创建的子进程会复制父进程的文件描述符，这浪就可以                         做到两个进程间的一个通信的，这样会做到两个进程各有两个`fd[0]` `fd[1]`,两个进程就可以通过各自的fd写入";
            headerCell.headScrollerView.delegate = self;
            [headerCell addImageToScrollerView:@[[UIImage imageNamed:@"1.png"],[UIImage imageNamed:@"1.png"],[UIImage imageNamed:@"1.png"]]];
            self.page = headerCell.mypage;
            return headerCell;
        } else {
            if (self.commentModel.commentList == nil) {
                BJInvitationSubCommentsTableViewCell* noCommentCell = [self.iView.mainView dequeueReusableCellWithIdentifier:@"noComment"];
                return noCommentCell;
            }
            if (indexPath.row == 0) {
                BJInvitationTableViewCell* commentCell = [self.iView.mainView dequeueReusableCellWithIdentifier:@"comments"];
                BJSubCommentsModel* currentModel = self.commentModel.commentList[indexPath.section - 1];
                
                [commentCell.replyButton addTarget:self action:@selector(showKeyboard:) forControlEvents:UIControlEventTouchUpInside];
                if (currentModel.total == 0 || self.dicty[@(currentModel.commentId)]) {
                    commentCell.commentButton.hidden = YES;
                } else {
                    commentCell.commentButton.hidden = NO;
                    [commentCell.commentButton addTarget:self action:@selector(expandSubComment:) forControlEvents:UIControlEventTouchUpInside];
                }
                
                commentCell.textView.text = currentModel.content;
                commentCell.timeLabel.text = [currentModel dealWithTime];
        //        commentCell.textView.text = currentModel.content;
        //        commentCell.nameLabel.text = currentModel.username;
                [commentCell.likeButton setTitle:@"1233" forState:UIControlStateNormal];
                [commentCell.likeButton addTarget:self action:@selector(selectLike:) forControlEvents:UIControlEventTouchUpInside];
                [commentCell.image sd_setImageWithURL:[NSURL URLWithString:currentModel.avatar]];
                return commentCell;
            } else {
                BJInvitationSubCommentsTableViewCell* subCommentCell = [self.iView.mainView dequeueReusableCellWithIdentifier:@"subComments"];
                BJSubCommentsModel* currentModel = self.commentModel.commentList[indexPath.section - 1];
                NSInteger commentId = currentModel.commentId;
                NSArray* ary = self.dicty[@(commentId)];
                if (currentModel.total == 0 || self.dicty[@(currentModel.commentId)]) {
                    subCommentCell.commentButton.hidden = YES;
                } else {
                    subCommentCell.commentButton.hidden = NO;
                    [subCommentCell.commentButton addTarget:self action:@selector(expandSubComment:) forControlEvents:UIControlEventTouchUpInside];
                }
                BJSubCommentsModel* subCommentModel = ary[indexPath.row - 1];
                [subCommentCell.replyButton addTarget:self action:@selector(showKeyboard:) forControlEvents:UIControlEventTouchUpInside];
                subCommentCell.textView.text = subCommentModel.content;
                subCommentCell.timeLabel.text = [subCommentModel dealWithTime];
        //        commentCell.textView.text = currentModel.content;
        //        commentCell.nameLabel.text = currentModel.username;
                [subCommentCell.likeButton setTitle:@"1233" forState:UIControlStateNormal];
                [subCommentCell.likeButton addTarget:self action:@selector(selectLike:) forControlEvents:UIControlEventTouchUpInside];
                [subCommentCell.image sd_setImageWithURL:[NSURL URLWithString:subCommentModel.avatar]];
                return subCommentCell;
            }
        }
    }
}
-(void)expandSubComment:(UIButton*)btn {
    BJInvitationSubCommentsTableViewCell* cell = (BJInvitationSubCommentsTableViewCell*)btn.superview.superview;
    NSIndexPath* indexPath = [self.iView.mainView indexPathForCell:cell];
    BJSubCommentsModel* currentModel = self.commentModel.commentList[indexPath.section - 1];
    NSInteger commentId = currentModel.commentId;
    NSInteger pageId = currentModel.pageId;
    NSInteger currentSection = indexPath.section;
    
    [[BJNetworkingManger sharedManger] loadWithCommentWithWorkId:_workId CommentId:commentId withType:1 withPage:pageId withPageSize:3 WithSuccess:^(BJCommentsModel * _Nonnull commentModel) {
        NSLog(@"这是我们获取的一个二级评论");
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!self.dicty[@(commentId)]) {
                NSLog(@"还没有创建一个字店对应二级评论");
                self.dicty[@(commentId)] = commentModel;
                BJSubCommentsModel* subComment = commentModel.commentList[0];
                NSLog(@"%d", subComment.isLike);
                //NSLog(@"%d", commentModel.commentList[0].isLike);
                [UIView setAnimationsEnabled:NO];
                [self.iView.mainView performBatchUpdates:^{
                    [self.iView.mainView reloadSections:[NSIndexSet indexSetWithIndex:currentSection] withRowAnimation:UITableViewRowAnimationAutomatic];
                } completion:^(BOOL finished) {
                    [UIView setAnimationsEnabled:YES];
                }];
                
                currentModel.pageId++;
            } else {
                NSLog(@"创建过一个字店对应二级评论");
                BJCommentsModel* currentCommentModel = (BJCommentsModel*)self.dicty[@(commentId)];
                [currentCommentModel.commentList addObjectsFromArray:commentModel.commentList];
                [UIView setAnimationsEnabled:NO];
                [self.iView.mainView performBatchUpdates:^{
                    [self.iView.mainView reloadSections:[NSIndexSet indexSetWithIndex:currentSection] withRowAnimation:UITableViewRowAnimationAutomatic];
                } completion:^(BOOL finished) {
                    [UIView setAnimationsEnabled:YES];
                }];
                currentModel.pageId++;
            }
        });
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"加载二级评论失败error");
    }];
}
-(void)selectLike:(UIButton*)btn {
    __weak id weakSelf = self;
    
    if (btn == self.iView.likeButton) {
        [[BJNetworkingManger sharedManger] likeWork:self.workId andType:1 attenationSuccess:^(BJAttentionDataModel * _Nonnull dataModel) {
            
            __strong BJInvitationViewController* strongSelf = (BJInvitationViewController*)weakSelf;
            strongSelf.commityModel.isFavorite = !strongSelf.commityModel.isFavorite;
            [strongSelf.delegate updateFavourite:strongSelf.commityModel.isFavorite andCommentCount:strongSelf.commityModel.commentCount withWorkId:strongSelf.workId];
            NSLog(@"点赞操作成果");
        } error:^(NSError * _Nonnull error) {
            NSLog(@"点赞操作失败error");
        }];
    }
    if ([btn.superview.superview isKindOfClass:[BJInvitationTableViewCell class]]) {
        NSIndexPath* indexPath = [self.iView.mainView indexPathForCell:(BJInvitationHeaderTableViewCell*)btn.superview.superview];
        BJSubCommentsModel* subCommentModel = self.commentModel.commentList[indexPath.section - 1];
        subCommentModel.isLike = !btn.selected;
        [self.commentModel.commentList replaceObjectAtIndex:indexPath.section - 1 withObject:subCommentModel];
        NSLog(@"处理当前的主评论一个点击按钮%ld", subCommentModel.isLike);
    } else if ([btn.superview.superview isKindOfClass:[BJInvitationSubCommentsTableViewCell class]]) {
        NSIndexPath* indexPath = [self.iView.mainView indexPathForCell:(BJInvitationHeaderTableViewCell*)btn.superview.superview];
        BJSubCommentsModel* subCommentModel = self.commentModel.commentList[indexPath.section - 1];
        BJCommentsModel* commentModel = self.dicty[@(subCommentModel.commentId)];
        BJSubCommentsModel* currentCommentModel = commentModel.commentList[indexPath.row - 1];
        currentCommentModel.isLike = !btn.selected;
        NSLog(@"处理%ld子评论的一个点击按钮%ld", indexPath.row, currentCommentModel.isLike);
        [commentModel.commentList replaceObjectAtIndex:indexPath.row - 1 withObject:currentCommentModel];
    }
    btn.selected = !btn.selected;
    NSString* likeString = btn.titleLabel.text;
    NSString* newlikeString = [NSString stringWithFormat:@"%d", [likeString intValue] + (btn.selected ? 1 : -1)];
    if (btn.selected) {
        [btn setTitle:likeString forState:UIControlStateNormal];
        [btn setTitle:newlikeString forState:UIControlStateSelected];
    } else {
        [btn setTitle:newlikeString forState:UIControlStateSelected];
        [btn setTitle:likeString forState:UIControlStateNormal];
    }
    
}

- (void)downLoadComment {
    if (self.commentModel.commentList.count == 0) {
        return;
    }
    if (self->_loadMore == NO) {
        if (self.commentModel.commentList.count > 0) {
            [self.iView endLoadActivity];
            return;
        } else {
            [self.iView loadActivity:_loadMore];
        }
    }
    if (self->_isLoading) {
        NSLog(@"当前正在加载，直接退出这个函数");
        return;
    }
    _isLoading = YES;
    __weak id weakSelf = self;
    [self.iView loadActivity:_isLoading];
    [[BJNetworkingManger sharedManger] loadWithCommentWithWorkId:_workId CommentId:0 withType:1 withPage:(_pageId + 1) withPageSize:_pageSize WithSuccess:^(BJCommentsModel * _Nonnull commentModel) {
        
        for (int i = 0; i < commentModel.commentList.count; i++) {
            [self.commentModel.commentList addObject:commentModel.commentList[i]];
        }
        __strong BJInvitationViewController* strongSelf = weakSelf;
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (strongSelf->_commentModel)
            [strongSelf.iView.mainView reloadData];
            [strongSelf.iView loadActivity:strongSelf->_isLoading];
            strongSelf->_pageId++;
            strongSelf->_isLoading = NO;
            if (commentModel.commentList.count == 0) {
                strongSelf->_loadMore = NO;
            }
        });
    } failure:^(NSError * _Nonnull error) {
        
    }];
}

-(void)showKeyboard:(UIButton*)btn {
    if ([btn.superview.superview isKindOfClass:[BJInvitationTableViewCell class]]) {
        BJInvitationTableViewCell* cell = (BJInvitationTableViewCell*)btn.superview.superview;
        NSIndexPath* path = [self.iView.mainView indexPathForCell:cell];
        BJSubCommentsModel* iModel = self.commentModel.commentList[path.section - 1];
        _currentSection = path.section;
        _parentId = iModel.commentId; //设置回复的评论的id
        _replyId = iModel.userId; //设置回复的人的id
        _commentId = iModel.commentId;
        NSLog(@"回复一级评论的commnenId为%ld", _commentId);
    } else {
        BJInvitationSubCommentsTableViewCell* cell = (BJInvitationSubCommentsTableViewCell*)btn.superview.superview;
        NSIndexPath* path = [self.iView.mainView indexPathForCell:cell];
        NSLog(@"回复二级评论%ld", path.row);
        BJSubCommentsModel* iModel = self.commentModel.commentList[path.section - 1];
        BJCommentsModel* currentCommentModel = _dicty[@(iModel.commentId)];
        _commentId = iModel.commentId;
        NSLog(@"当前的currenModel%@", currentCommentModel.commentList);
        BJSubCommentsModel* currentModel = currentCommentModel.commentList[path.row - 1];
        _parentId = currentModel.commentId;  //设置回复的评论的id
        NSLog(@"回复的当前的一个commentid %ld", _parentId);
        _replyId = currentModel.userId; //设置回复的人的id
        _currentSection = path.section;

    }
    
    [self.iView.commentTextView becomeFirstResponder];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.tag == 100) {
        CGFloat offsetX = scrollView.contentOffset.x;
        CGFloat pageWidth = scrollView.frame.size.width;
        NSInteger currentPage = scrollView.contentOffset.x / pageWidth;
        self.page.currentPage = currentPage;
    } else if (scrollView.tag == 200) {
        if (_scrollFlag) {
            if (self.iView.commentTextView.contentSize.height > 70) {
                [self.iView.commentTextView setContentOffset:CGPointMake(0, self.iView.commentTextView.contentSize.height - 70 + 5)];
            } else {
                [self.iView.commentTextView setContentOffset:CGPointMake(0, 0)];
            }
        }
        
    } else if (scrollView.tag == 300) {
        CGFloat y = scrollView.contentOffset.y;
        CGFloat contentHeight = scrollView.contentSize.height;
        CGFloat height = scrollView.bounds.size.height;
        if (y + height >= contentHeight + 10) {
            [self downLoadComment];
        }
    }
    
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (scrollView.tag == 200) {
        _scrollFlag = YES;
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView.tag == 200) {
        _scrollFlag = NO;
    }
}
- (UIImage *)resizeImage:(UIImage *)image targetSize:(CGSize)targetSize {
    UIGraphicsBeginImageContextWithOptions(targetSize, NO, [UIScreen mainScreen].scale);
    [image drawInRect:CGRectMake(0, 0, targetSize.width, targetSize.height)];
    UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resizedImage;
}

- (void)setNavgationBar {
    UINavigationBarAppearance* apperance = [[UINavigationBarAppearance alloc] init];
    apperance.shadowColor = [UIColor clearColor];
    apperance.shadowImage = [[UIImage alloc] init];
    apperance.backgroundColor = UIColor.whiteColor;
    self.navigationController.navigationBar.standardAppearance = apperance;
    self.navigationController.navigationBar.scrollEdgeAppearance = apperance;
    NSString* string = @"back2.png";
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(popViewController) forControlEvents:UIControlEventTouchUpInside];
    [button setImage:[UIImage imageNamed:string] forState:UIControlStateNormal];
    
    UIButton *iconButton = [UIButton buttonWithType:UIButtonTypeCustom];
    iconButton.frame = CGRectMake(0, 0, 40, 40);
    iconButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    iconButton.imageView.clipsToBounds = YES;
    iconButton.layer.cornerRadius = 20;
    iconButton.layer.masksToBounds = YES;
    
    if (self.commityModel.avatar.length != 0) {
        NSLog(@"加载头像开始%@", self.commityModel.avatar);
        [iconButton sd_setImageWithURL:[NSURL URLWithString:self.commityModel.avatar]
                              forState:UIControlStateNormal
                      placeholderImage:[UIImage imageNamed:@"title.jpg"]
                               options:SDWebImageRefreshCached
                             completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            if (image) {
                UIImage *resizedImage = [self resizeImage:image targetSize:CGSizeMake(40, 40)];
                [iconButton setImage:resizedImage forState:UIControlStateNormal];
            }
        }];
    } else {
        [iconButton setImage:[UIImage imageNamed:@"title.jpg"] forState:UIControlStateNormal];
    }


    
    
    UIBarButtonItem *space = [[UIBarButtonItem alloc]
        initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
        target:nil action:nil];
    space.width = 8;
    
    UIBarButtonItem* leftButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    UIBarButtonItem* headButton = [[UIBarButtonItem alloc] initWithCustomView:iconButton];
    UILabel* nameLabel = [[UILabel alloc] init];
    if ([self.commityModel.username isEqualToString:[BJNetworkingManger sharedManger].username]) {
        nameLabel.text = @"我";
    } else {
        nameLabel.text = self.commityModel.username;
    }
    UIBarButtonItem* titleButton = [[UIBarButtonItem alloc] initWithCustomView:nameLabel];
    
    self.navigationItem.leftBarButtonItems = @[leftButton, space, headButton, space, titleButton];
    
    
    NSLog(@"当前有没有关注这个人%ld", self.commityModel.isFollowing);
    if (self.commityModel.userId != [BJNetworkingManger sharedManger].userId) {
        UIButton* attentionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        attentionButton.backgroundColor = UIColor.whiteColor;
        [attentionButton addTarget:self action:@selector(attention:) forControlEvents:UIControlEventTouchUpInside];
        [attentionButton setTitle:@"关注" forState:UIControlStateNormal];
        attentionButton.layer.masksToBounds = YES;
        attentionButton.layer.cornerRadius = 10;
        attentionButton.frame = CGRectMake(0, 0, 80, 30);
        attentionButton.layer.borderWidth = 1;
        
        attentionButton.layer.masksToBounds = YES;
        attentionButton.layer.cornerRadius = 13;
        attentionButton.selected = self.commityModel.isFollowing;
        UIColor* myColor = [UIColor colorWithRed:98.0 / 255.0 green:184.0 / 255.0 blue:120 / 255.0 alpha:1];
        if (attentionButton.selected) {
            [attentionButton setTitle:@"已关注" forState:UIControlStateNormal];
            [attentionButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
            attentionButton.backgroundColor = myColor;
        } else {
            [attentionButton setTitle:@"关注" forState:UIControlStateNormal];
            attentionButton.backgroundColor = UIColor.whiteColor;
            [attentionButton setTitleColor:myColor forState:UIControlStateNormal];
        }
        attentionButton.layer.borderColor = myColor.CGColor;
        UIBarButtonItem* rightButton = [[UIBarButtonItem alloc] initWithCustomView:attentionButton];
        self.navigationItem.rightBarButtonItems = @[rightButton, space];
    } else {
        ;
    }
    
    
}
- (void)attention:(UIButton*)btn {
    btn.selected = !btn.selected;
    UIColor* myColor = [UIColor colorWithRed:98.0 / 255.0 green:184.0 / 255.0 blue:120 / 255.0 alpha:1];
    NSLog(@"当前给谁点击关注%ld", self.commityModel.userId);
    [[BJNetworkingManger sharedManger] attentionSomeone:self.commityModel.userId follow:btn.selected attenationSuccess:^(BJAttentionDataModel * _Nonnull dataModel) {
        NSLog(@"success");
    } error:^(NSError * _Nonnull error) {
        NSLog(@"error");
    }];
    if (btn.selected) {
        [btn setTitle:@"已关注" forState:UIControlStateNormal];
        [btn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        btn.backgroundColor = myColor;
    } else {
        [btn setTitle:@"关注" forState:UIControlStateNormal];
        btn.backgroundColor = UIColor.whiteColor;
        [btn setTitleColor:myColor forState:UIControlStateNormal];
    }
}
- (void)popViewController {
    self.tabBarController.hidesBottomBarWhenPushed = NO;
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)postComment {
    NSString* commentString = self.iView.commentTextView.text;
    __block NSInteger currentSection = _currentSection;
    __weak BJInvitationViewController* weakSelf = self;
    NSInteger parentId = _parentId;
    NSInteger replyId = _replyId;
    
    [[BJNetworkingManger sharedManger] uploadWithComment:commentString andPraentId:parentId replyId:replyId workId:_workId type:1 postCommentSuccess:^(BJUploadCommentModel * _Nonnull commityModel) {
        dispatch_async(dispatch_get_main_queue(), ^{
            __strong BJInvitationViewController* strongSelf = weakSelf;
            BJSubCommentsModel* postModel = [[BJSubCommentsModel alloc] init];
            postModel.username = [BJNetworkingManger sharedManger].username;
            postModel.avatar = [BJNetworkingManger sharedManger].avatar;
            NSLog(@"输出我的commentId%ld", commityModel.commentId);
            postModel.timeString = @"今天";
            bool firstFlag = NO;
            postModel.commentId = commityModel.commentId;
            postModel.content = commentString;
            if (parentId == 0 && replyId == 0) {
                currentSection = 1;
                postModel.replyToUsername = @"";
                if (self.commentModel.commentList.count == 0) {
                    firstFlag = YES;
                }
                [self.commentModel.commentList insertObject:postModel atIndex:0];
                strongSelf->_parentId = 0; //设置成默认状态
                strongSelf->_replyId = 0;//设置成默认状态
            } else {
                NSLog(@"我截获的一个commentId为%ld", strongSelf->_commentId);
                BJSubCommentsModel* fatherCommentModel = strongSelf.commentModel.commentList[currentSection - 1];
                fatherCommentModel.total += 1;
                BJCommentsModel* currentCommentModel = self.dicty[@(strongSelf->_commentId)];
                if (currentCommentModel == nil) {
                    NSLog(@"当前这条评论还没加载子评论");
                    currentCommentModel = [[BJCommentsModel alloc] init];
                    
                    currentCommentModel.commentList = [NSMutableArray array];
                }
                BJSubCommentsModel* replyModel = self.commentModel.commentList[currentSection - 1];
                postModel.replyId = strongSelf->_replyId;
                
                postModel.userId = [BJNetworkingManger sharedManger].userId;
                NSLog(@"当前回复人的一个id%ld, 自己的一个id%ld", replyModel.replyId, replyModel.userId);
                postModel.replyToUsername = [NSString stringWithFormat:@"%@", replyModel.username];
                NSLog(@"%@", replyModel.username);
                [currentCommentModel.commentList addObject:postModel];
                
               
                self.dicty[@(strongSelf->_commentId)] = currentCommentModel;
                
            }
            
            
            NSLog(@"%@", weakSelf.commentModel.commentList);
            
            NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:strongSelf->_currentSection];
            
            if (currentSection == 1 && parentId == 0 && replyId == 0 && !firstFlag) {
                NSLog(@"该评论是一级评论");
                [strongSelf.iView.mainView performBatchUpdates:^{
                        [strongSelf.iView.mainView insertSections:[NSIndexSet indexSetWithIndex:currentSection]
                                                withRowAnimation:UITableViewRowAnimationAutomatic];
                } completion:^(BOOL finished) {
                    strongSelf->_parentId = 0; //设置成默认状态
                    strongSelf->_replyId = 0;//设置成默认状态
                }];
            } else  if (!firstFlag) {
                NSLog(@"该评论是二级评论");
                [strongSelf.iView.mainView performBatchUpdates:^{
                    NSIndexPath* indexpath = [NSIndexPath indexPathForRow:1 inSection:currentSection];
                    [strongSelf.iView.mainView reloadSections:[NSIndexSet indexSetWithIndex:currentSection] withRowAnimation:UITableViewRowAnimationNone];
//                    [strongSelf.iView.mainView insertRowsAtIndexPaths:@[indexpath] withRowAnimation:UITableViewRowAnimationAutomatic];
                    } completion:^(BOOL finished) {
                        strongSelf->_parentId = 0; //设置成默认状态
                        strongSelf->_replyId = 0;//设置成默认状态
                    }];
            } else {
                
                NSLog(@"该评论是第一次发评论");
                [strongSelf.iView.mainView performBatchUpdates:^{
                    NSIndexPath* indexpath = [NSIndexPath indexPathForRow:0 inSection:currentSection];
                    [strongSelf.iView.mainView reloadRowsAtIndexPaths:@[indexpath] withRowAnimation:UITableViewRowAnimationAutomatic];
                    } completion:^(BOOL finished) {
                        strongSelf->_parentId = 0; //设置成默认状态
                        strongSelf->_replyId = 0;//设置成默认状态
                    }];
            }
            strongSelf.commityModel.commentCount += 1;
            [strongSelf.delegate updateFavourite:strongSelf.commityModel.isFavorite andCommentCount:strongSelf.commityModel.commentCount withWorkId:strongSelf.workId];
            [strongSelf.iView.commentButton setTitle:[NSString stringWithFormat:@"%ld", strongSelf.commityModel.commentCount] forState:UIControlStateNormal];
            //[self.iView.mainView reloadData];
            
            [strongSelf hideKeyborad];
            [strongSelf showUploadCommentSuccess];
        });
    } error:^(NSError * _Nonnull error) {
        NSLog(@"error,发布失败");
    }];
    
    
}
- (void)showUploadCommentSuccess {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"发布评论成功" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}
- (void)deleteCommentWithSection:(NSInteger)section Row:(NSInteger)row{
    NSInteger commentId;
    BJSubCommentsModel* deleteModel;
    if (row != 0) {
        BJSubCommentsModel* commentModel = self.commentModel.commentList[section - 1];
        BJCommentsModel* currentModel = self.dicty[@(commentModel.commentId)];
        BJSubCommentsModel* currentCommentModel = currentModel.commentList[row - 1];
        commentId = currentCommentModel.commentId;
        deleteModel = currentCommentModel;
    } else {
        BJSubCommentsModel* commentModel = self.commentModel.commentList[section - 1];
        commentId = commentModel.commentId;
        deleteModel = commentModel;
    }
    BJSubCommentsModel* commentModel = self.commentModel.commentList[section - 1];
    BJCommentsModel* currentModel = self.dicty[@(commentModel.commentId)];
    
    __weak BJInvitationViewController* weakSelf = self;
    [[BJNetworkingManger sharedManger] deleteCommentId:commentId WithWorkId:_workId WithType:1 loadSuccess:^(BJAttentionDataModel * _Nonnull dataModel) {
        __strong BJInvitationViewController* strongSelf = weakSelf;
        if (dataModel.status == 1000) {
            NSLog(@"删除评论成功");
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [UIView setAnimationsEnabled:NO];
                if (row == 0) {
                    NSLog(@"删除一级评论");
                    [strongSelf.commentModel.commentList removeObject:deleteModel];
                    [strongSelf.iView.mainView performBatchUpdates:^{
                        [strongSelf.iView.mainView deleteSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationAutomatic];
                                    } completion:^(BOOL finished) {
                                        [UIView setAnimationsEnabled:YES];
                                        [strongSelf.delegate updateFavourite:strongSelf.commityModel.isFavorite andCommentCount:strongSelf.commityModel.commentCount - deleteModel.total - 1 withWorkId:strongSelf->_workId];
                                    }];
                } else {
                    NSLog(@"删除二级评论");
                    [currentModel.commentList removeObject:deleteModel];
                    [strongSelf.iView.mainView performBatchUpdates:^{
                        [strongSelf.iView.mainView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:row inSection:section]] withRowAnimation:UITableViewRowAnimationAutomatic];
                                    } completion:^(BOOL finished) {
                                        [UIView setAnimationsEnabled:YES];
                                        [strongSelf.delegate updateFavourite:strongSelf.commityModel.isFavorite andCommentCount:strongSelf.commityModel.commentCount - deleteModel.total withWorkId:strongSelf->_workId];
                                    }];
                }
                
            });
        }
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"error");
    }];
}
- (void)addTapToCommentCell:(UITableViewCell*)cell atIndexPath:(NSIndexPath*)indexPath {
    BOOL flag = NO;
    if (self.commityModel.userId == [BJNetworkingManger sharedManger].userId) {
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pressCommentAlert:)];
        [cell addGestureRecognizer:tap];
        return;
    }
    if ([cell isKindOfClass:[BJInvitationTableViewCell class]]) {
        BJInvitationTableViewCell* currentCell = (BJInvitationTableViewCell*)cell;
        BJSubCommentsModel* commentModel = self.commentModel.commentList[indexPath.section - 1];
        if ([BJNetworkingManger sharedManger].userId == commentModel.userId) {
            UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pressCommentAlert:)];
            [cell addGestureRecognizer:tap];
        } else {
            UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pressNone:)];
            [cell addGestureRecognizer:tap];
        }
    } else if ([cell isKindOfClass:[BJInvitationSubCommentsTableViewCell class]]) {
        BJInvitationSubCommentsTableViewCell* currentCell = (BJInvitationSubCommentsTableViewCell*)cell;
        BJSubCommentsModel* commentModel = self.commentModel.commentList[indexPath.section - 1];
        BJCommentsModel* currentCommentModel = self.dicty[@(commentModel.commentId)];
        BJSubCommentsModel* subCurrentCommentModel = currentCommentModel.commentList[indexPath.row - 1];
        if ([BJNetworkingManger sharedManger].userId == subCurrentCommentModel.userId) {
            UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pressCommentAlert:)];
            [cell addGestureRecognizer:tap];
        } else {
            UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pressNone:)];
            [cell addGestureRecognizer:tap];
        }
    }
}
- (void)pressNone:(UITapGestureRecognizer*)tap {
    UIView* superView = tap.view;
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"暂无删除权限" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}
- (void)pressCommentAlert:(UITapGestureRecognizer*)tap {
    UIView* superView = tap.view;
    NSLog(@"%@", [superView class]);
    NSIndexPath* indexPath;
    NSInteger section;
    NSInteger row;
    if ([superView isKindOfClass:[BJInvitationTableViewCell class]]) {
        BJInvitationTableViewCell* currentCell = (BJInvitationTableViewCell*)superView;
        indexPath = [self.iView.mainView indexPathForCell:currentCell];
        section = indexPath.section;
        row = indexPath.row;
    } else {
        BJInvitationSubCommentsTableViewCell* currentCell = (BJInvitationSubCommentsTableViewCell*)superView;
        indexPath = [self.iView.mainView indexPathForCell:currentCell];
        section = indexPath.section;
        row = indexPath.row;
    }
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"删除评论" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self deleteCommentWithSection:section Row:row];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
