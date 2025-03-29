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
#import "BJImageModel.h"
#import "BJUploadCommentModel.h"
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
    BOOL _isLoading;
}

@end

@implementation BJInvitationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _isLoading = NO;
    _replyId = 0;
    _parentId = 0;
    id manger = [BJNetworkingManger sharedManger];
    _scrollFlag = NO;
    _pageId = 1;
    _pageSize = 2;
    _currentSection = 1;
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
        weakSelf.commentModel = commentModel;
        weakSelf.commentModel.pageId = strongSelf->_pageId;
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
    } else {
        [self.iView.likeButton setTitle:[NSString stringWithFormat:@"%ld", self.commityModel.favoriteCount] forState:UIControlStateNormal];
    }
    
    
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
        return 1;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BJInvitationTableViewCell* commentCell = [self.iView.mainView dequeueReusableCellWithIdentifier:@"comments"];
    BJInvitationHeaderTableViewCell* headerCell = [self.iView.mainView dequeueReusableCellWithIdentifier:@"header"];
    BJInvitationSubCommentsTableViewCell* subCommentCell = [self.iView.mainView dequeueReusableCellWithIdentifier:@"subComments"];
    BJInvitationSubCommentsTableViewCell* noCommentCell = [self.iView.mainView dequeueReusableCellWithIdentifier:@"noComment"];
    headerCell.selectionStyle = UITableViewCellSelectionStyleNone;
    commentCell.selectionStyle = UITableViewCellSelectionStyleNone;
    subCommentCell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section == 0) {
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
            return noCommentCell;
        }
        if (indexPath.row == 0) {
            BJSubCommentsModel* currentModel = self.commentModel.commentList[indexPath.section - 1];
            [commentCell.replyButton addTarget:self action:@selector(showKeyboard:) forControlEvents:UIControlEventTouchUpInside];
            [commentCell.commentButton addTarget:self action:@selector(expandSubComment:) forControlEvents:UIControlEventTouchUpInside];
            commentCell.textView.text = currentModel.content;
            commentCell.nameLabel.text = currentModel.username;
            if ([currentModel.avatar isEqualToString:@""]) {
                NSLog(@"设置默认图片");
                [commentCell.image setImage:[UIImage imageNamed:@"title.jpg"]];
            } else {
                NSLog(@"123");
                [commentCell.image sd_setImageWithURL:[NSURL URLWithString:currentModel.avatar]];
            }
            
            commentCell.timeLabel.text = [currentModel dealWithTime];
        //        commentCell.textView.text = currentModel.content;
        //        commentCell.nameLabel.text = currentModel.username;
            [commentCell.likeButton setTitle:@"0" forState:UIControlStateNormal];
            [commentCell.likeButton addTarget:self action:@selector(selectLike:) forControlEvents:UIControlEventTouchUpInside];
            return commentCell;
        } else {
            BJSubCommentsModel* currentModel = self.commentModel.commentList[indexPath.section - 1];
            NSInteger commentId = currentModel.commentId;
            BJSubCommentsModel* subCommentModel = self.dicty[@(commentId)];
            [subCommentCell.replyButton addTarget:self action:@selector(showKeyboard:) forControlEvents:UIControlEventTouchUpInside];
            [subCommentCell.commentButton addTarget:self action:@selector(expandSubComment:) forControlEvents:UIControlEventTouchUpInside];
            subCommentCell.textView.text = subCommentModel.content;
            subCommentCell.timeLabel.text = [subCommentModel dealWithTime];
        //        commentCell.textView.text = currentModel.content;
        //        commentCell.nameLabel.text = currentModel.username;
            [subCommentCell.likeButton setTitle:@"1233" forState:UIControlStateNormal];
            [subCommentCell.likeButton addTarget:self action:@selector(selectLike:) forControlEvents:UIControlEventTouchUpInside];
            [subCommentCell.image sd_setImageWithURL:[NSURL URLWithString:subCommentModel.avatar]];
            return subCommentCell;
        }
    } else {
        if (indexPath.section == 0) {
            headerCell.titleLabel.text = @"这是一个标题";
            headerCell.contentLabel.text = @"d写入和读取同一个管道文件实现一个跨进程通信了。这里我们如果想实现一个管道间的通信的话，其实是通过fork创建一个子进程，创建的子进程会复制父进程的文件描述符，这浪就可以做到两个进程间的一个通信的，这样会做到两个进程各有两个`fd[0]` `fd[1]`,两个进程就可以通过各自的fd写入d写入和读取同一个管道文件实现一个跨进程通信了。这里我们如果想实现一个管道间的通信的话，其实是通过fork创建一个子进程，创建的子进程会复制父进程的文件描述符，这浪就可以                         做到两个进程间的一个通信的，这样会做到两个进程各有两个`fd[0]` `fd[1]`,两个进程就可以通过各自的fd写入";
            headerCell.headScrollerView.delegate = self;
            [headerCell addImageToScrollerView:@[[UIImage imageNamed:@"1.png"],[UIImage imageNamed:@"1.png"],[UIImage imageNamed:@"1.png"]]];
            self.page = headerCell.mypage;
            return headerCell;
        } else {
            if (self.commentModel.commentList == nil) {
                return noCommentCell;
            }
            if (indexPath.row == 0) {
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
                
                BJSubCommentsModel* currentModel = self.commentModel.commentList[indexPath.section - 1];
                NSInteger commentId = currentModel.commentId;
                NSArray* ary = self.dicty[@(commentId)];
                if (currentModel.total == 0 || self.dicty[@(currentModel.commentId)]) {
                    commentCell.commentButton.hidden = YES;
                } else {
                    commentCell.commentButton.hidden = NO;
                    [commentCell.commentButton addTarget:self action:@selector(expandSubComment:) forControlEvents:UIControlEventTouchUpInside];
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
    NSInteger pageId = self.commentModel.pageId;
    NSInteger currentSection = indexPath.section;
    
    [[BJNetworkingManger sharedManger] loadWithCommentWithWorkId:_workId CommentId:commentId withType:1 withPage:pageId withPageSize:5 WithSuccess:^(BJCommentsModel * _Nonnull commentModel) {
        self->_dicty[@(currentSection)] = commentModel;
        [self.iView.mainView reloadSections:[NSIndexSet indexSetWithIndex:currentSection] withRowAnimation:UITableViewRowAnimationAutomatic];
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"加载二级评论失败error");
        
    }];
}
-(void)selectLike:(UIButton*)btn {
    if (btn == self.iView.likeButton) {
        [[BJNetworkingManger sharedManger] likeWork:self.workId andType:1 attenationSuccess:^(BJAttentionDataModel * _Nonnull dataModel) {
            NSLog(@"点赞操作成果");
        } error:^(NSError * _Nonnull error) {
            NSLog(@"点赞操作失败error");
        }];
    }
    btn.selected = !btn.selected;
    NSString* likeString = btn.titleLabel.text;
    NSString* newlikeString = [NSString stringWithFormat:@"%d", [likeString intValue] + (btn.selected ? 1 : -1)];
    [btn setTitle:newlikeString forState:UIControlStateSelected];
}
- (void)downLoadComment {
    if (self->_isLoading) {
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
        strongSelf->_isLoading = NO;
        dispatch_async(dispatch_get_main_queue(), ^{
            if (strongSelf->_commentModel)
            [strongSelf.iView.mainView reloadData];
            [strongSelf.iView loadActivity:strongSelf->_isLoading];
            strongSelf->_pageId++;
        });
    } failure:^(NSError * _Nonnull error) {
        
    }];
}

-(void)showKeyboard:(UIButton*)btn {
    if ([btn.superview.superview isKindOfClass:[BJInvitationTableViewCell class]]) {
        BJInvitationTableViewCell* cell = (BJInvitationTableViewCell*)btn.superview.superview;
        NSIndexPath* path = [self.iView.mainView indexPathForCell:cell];
        BJSubCommentsModel* iModel = self.commentModel.commentList[path.section - 1];
        _parentId = iModel.commentId; //设置回复的评论的id
        _replyId = iModel.userId; //设置回复的人的id
        self.iView.commentTextView.text = [NSString stringWithFormat:@"回复%@", iModel.username];
    } else {
        BJInvitationSubCommentsTableViewCell* cell = (BJInvitationSubCommentsTableViewCell*)btn.superview.superview;
        NSIndexPath* path = [self.iView.mainView indexPathForCell:cell];
        BJCommentsModel* iModel = _dicty[@(path.section)];
        BJSubCommentsModel* currentModel = iModel.commentList[path.row - 1];
        _parentId = currentModel.commentId;  //设置回复的评论的id
        _replyId = currentModel.userId; //设置回复的人的id
        self.iView.commentTextView.text = [NSString stringWithFormat:@"回复%@", currentModel.username];
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
    
    UIButton* iconButton = [UIButton buttonWithType:UIButtonTypeCustom];
    if (self.commityModel.avatar.length != 0) {
        [iconButton.imageView sd_setImageWithURL:[NSURL URLWithString:self.commityModel.avatar]];
        iconButton.layer.masksToBounds = YES;
        iconButton.layer.cornerRadius = 20;
        NSLog(@"加载头像开始%@", self.commityModel.avatar);
    } else {
        [iconButton setImage:[UIImage imageNamed:@"title.jpg"] forState:UIControlStateNormal];
        iconButton.layer.masksToBounds = YES;
        iconButton.layer.cornerRadius = 20;
    }
    
    
    UIBarButtonItem *space = [[UIBarButtonItem alloc]
        initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
        target:nil action:nil];
    space.width = 8;
    
    UIBarButtonItem* leftButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    UIBarButtonItem* headButton = [[UIBarButtonItem alloc] initWithCustomView:iconButton];
    UILabel* nameLabel = [[UILabel alloc] init];
    nameLabel.text = self.commityModel.username;
    UIBarButtonItem* titleButton = [[UIBarButtonItem alloc] initWithCustomView:nameLabel];
    
    self.navigationItem.leftBarButtonItems = @[leftButton, space, headButton, space, titleButton];
    
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
    UIColor* myColor = [UIColor colorWithRed:98.0 / 255.0 green:184.0 / 255.0 blue:120 / 255.0 alpha:1];
    attentionButton.layer.borderColor = myColor.CGColor;
    [attentionButton setTitleColor:myColor forState:UIControlStateNormal];
    UIBarButtonItem* rightButton = [[UIBarButtonItem alloc] initWithCustomView:attentionButton];
    self.navigationItem.rightBarButtonItems = @[rightButton, space];
    
}
- (void)attention:(UIButton*)btn {
    btn.selected = !btn.selected;
    UIColor* myColor = [UIColor colorWithRed:98.0 / 255.0 green:184.0 / 255.0 blue:120 / 255.0 alpha:1];
    [[BJNetworkingManger sharedManger] attentionSomeone:self.userId follow:btn.selected attenationSuccess:^(BJAttentionDataModel * _Nonnull dataModel) {
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
            BJSubCommentsModel* postModel = [[BJSubCommentsModel alloc] init];
            postModel.username = [BJNetworkingManger sharedManger].username;
            postModel.avatar = [BJNetworkingManger sharedManger].avatar;
            NSLog(@"输出我的commentId%ld", commityModel.commentId);
            postModel.commentId = commityModel.commentId;
            postModel.content = commentString;
            if (parentId == 0 && replyId == 0) {
                currentSection = 1;
                postModel.replyToUsername = @"";
                [self.commentModel.commentList insertObject:postModel atIndex:0];
                _parentId = 0; //设置成默认状态
                _replyId = 0;//设置成默认状态
            } else {
                postModel.replyToUsername = [NSString stringWithFormat:@"%@回复%@", postModel.username, @"当前的人"];
                NSMutableArray* ary = self.dicty[@(parentId)];
                [ary addObject:postModel];
                _parentId = 0; //设置成默认状态
                _replyId = 0;//设置成默认状态
            }
            
            
            NSLog(@"%@", weakSelf.commentModel.commentList);
            __strong BJInvitationViewController* strongSelf = weakSelf;
            NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:_currentSection];
            [strongSelf.iView.mainView performBatchUpdates:^{
                    [strongSelf.iView.mainView insertSections:[NSIndexSet indexSetWithIndex:currentSection]
                                            withRowAnimation:UITableViewRowAnimationAutomatic];
                } completion:nil];
            //[self.iView.mainView reloadData];
            [strongSelf hideKeyborad];
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
