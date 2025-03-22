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
@interface BJInvitationViewController () {
    NSInteger _pageId;
    NSInteger _pageSize;
}

@end

@implementation BJInvitationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    id manger = [BJNetworkingManger sharedManger];
    _pageId = 1;
    _pageSize = 2;
    self.view.backgroundColor = UIColor.whiteColor;
    self.iView = [[BJInvitationView alloc] initWithFrame:self.view.bounds];
    [self.iView setToolBar];
    [self.iView.mainView registerClass:[BJInvitationTableViewCell class] forCellReuseIdentifier:@"comments"];
    [self.iView.mainView registerClass:[BJInvitationHeaderTableViewCell class] forCellReuseIdentifier:@"header"];
    [self.iView.mainView registerClass:[BJInvitationSubCommentsTableViewCell class] forCellReuseIdentifier:@"subComments"];
    [self.view addSubview:self.iView];
    self.iView.mainView.delegate = self;
    self.iView.mainView.dataSource = self;
    
    self.iView.commentTextView.delegate = self;
    [manger loadWithCommentWithWorkId:_workId CommentId:0 withType:1 withPage:_pageId withPageSize:_pageSize WithSuccess:^(BJCommentsModel * _Nonnull commentModel) {
        self.commentModel = commentModel;
        [self.iView.mainView reloadData];
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"load loacl View");

    }];
    [self setNavgationBar];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification  object:nil];
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification  object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification  object:nil];
    // Do any additional setup after loading the view.
}
- (void)textViewDidBeginEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:@"说点什么"]) {
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
    //[self.iView.commentTextView removeFromSuperview];
    if (!self.iView.backView) {
        self.iView.backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 393, height - 50)];
        self.iView.backView.backgroundColor = UIColor.blackColor;
        self.iView.backView.alpha = 0.5;
        [self.iView addSubview:self.iView.backView];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyborad)];
        tapGesture.numberOfTapsRequired = 1;
        tapGesture.numberOfTouchesRequired = 1;
        [self.iView.backView addGestureRecognizer:tapGesture];
    } else {
        self.iView.backView.hidden = NO;
    }
    [self.iView.commentTextView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iView.backView.mas_bottom);
        make.left.right.equalTo(self.iView);
        make.height.equalTo(@50);
    }];
    
}
-(void)hideKeyborad {
    [self.iView.commentTextView resignFirstResponder];
}
-(void)keyboardWillHide:(NSNotification*)notification {
    [self.iView.commentTextView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iView.toolBar).offset(10);
        make.width.equalTo(@165);
        make.top.equalTo(self.iView.toolBar).offset(15);
        make.height.equalTo(@40);
    }];
    self.iView.backView.hidden = YES;
    NSLog(@"hide");
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.commentModel !=  nil) {
        return self.commentModel.commentList.count + 1;
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
    headerCell.selectionStyle = UITableViewCellSelectionStyleNone;
    commentCell.selectionStyle = UITableViewCellSelectionStyleNone;
    subCommentCell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.commentModel != nil) {
        if (indexPath.section == 0) {
            headerCell.titleLabel.text = self.commityModel.title;
            headerCell.contentLabel.text = self.commityModel.content;
            headerCell.headScrollerView.delegate = self;
            
            NSMutableArray<NSString*>* mutableAry = [NSMutableArray array];
            for (int i = 0; i < self.commityModel.images.count; i++) {
                BJImageModel* model = self.commityModel.images[i];
                [mutableAry addObject:model.url];
            }
            
            NSArray* ary = [NSArray arrayWithArray:mutableAry];
            [headerCell addUrlImageToScrollerView:ary];
            self.page = headerCell.mypage;
            return headerCell;
        } else {
            BJSubCommentsModel* currentModel = self.commentModel.commentList[indexPath.row - 1];
            
            [commentCell.replyButton addTarget:self action:@selector(showKeyboard) forControlEvents:UIControlEventTouchUpInside];
            commentCell.textView.text = currentModel.content;
            commentCell.timeLabel.text = [currentModel dealWithTime];
    //        commentCell.textView.text = currentModel.content;
    //        commentCell.nameLabel.text = currentModel.username;
            [commentCell.likeButton setTitle:@"1233" forState:UIControlStateNormal];
            [commentCell.likeButton addTarget:self action:@selector(selectLike:) forControlEvents:UIControlEventTouchUpInside];
            [commentCell.image sd_setImageWithURL:[NSURL URLWithString:currentModel.advator]];
            return commentCell;
            
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
            BJSubCommentsModel* currentModel = self.commentModel.commentList[indexPath.row - 1];
            [commentCell.replyButton addTarget:self action:@selector(showKeyboard) forControlEvents:UIControlEventTouchUpInside];
            commentCell.textView.text = @"d写入和读取同一个管道文件实现一个跨进程通信了。这里我们如果想实现一个管道间的通信的话，其实是通过fork创建一个子进程，创建的子进程会复制父进程的文件描述符，这浪就可以做到两个进程间的一个通信的，这样会做到两个进程各有两个`fd[0]` `fd[1]`,两个进程就可以通过各自的fd写入";
            //        commentCell.textView.text = currentModel.content;
            //        commentCell.nameLabel.text = currentModel.username;
            [commentCell.likeButton setTitle:@"1233" forState:UIControlStateNormal];
            [commentCell.likeButton addTarget:self action:@selector(selectLike:) forControlEvents:UIControlEventTouchUpInside];
            commentCell.timeLabel.text = @"今天";
            commentCell.image.image = [UIImage imageNamed:@"WechatIMG17.jpg"];
            return commentCell;
        }
    }
}
-(void)expandSubComment {
   
}
-(void)selectLike:(UIButton*)btn {
    btn.selected = !btn.selected;
    NSString* likeString = btn.titleLabel.text;
    NSString* newlikeString = [NSString stringWithFormat:@"%d", [likeString intValue] + btn.selected ? 1 : -1];
    [btn setTitle:newlikeString forState:UIControlStateSelected];
}
-(void)showKeyboard {
    [self.iView.commentTextView becomeFirstResponder];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.tag == 100) {
        CGFloat offsetX = scrollView.contentOffset.x;
        CGFloat pageWidth = scrollView.frame.size.width;
        NSInteger currentPage = scrollView.contentOffset.x / pageWidth;
        self.page.currentPage = currentPage;
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
    [iconButton setImage:[UIImage imageNamed:@"title.jpg"] forState:UIControlStateNormal];
    iconButton.layer.masksToBounds = YES;
    iconButton.layer.cornerRadius = 20;
    
    UIBarButtonItem *space = [[UIBarButtonItem alloc]
        initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
        target:nil action:nil];
    space.width = 8;
    
    UIBarButtonItem* leftButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    UIBarButtonItem* headButton = [[UIBarButtonItem alloc] initWithCustomView:iconButton];
    UILabel* nameLabel = [[UILabel alloc] init];
    nameLabel.text = @"名字";
    UIBarButtonItem* titleButton = [[UIBarButtonItem alloc] initWithCustomView:nameLabel];
    
    self.navigationItem.leftBarButtonItems = @[leftButton, space, headButton, space, titleButton];
    
    UIButton* attentionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    attentionButton.backgroundColor = UIColor.whiteColor;
    
    [attentionButton setTitle:@"关注" forState:UIControlStateNormal];
    attentionButton.layer.masksToBounds = YES;
    attentionButton.layer.cornerRadius = 10;
    attentionButton.frame = CGRectMake(0, 0, 80, 30);
    attentionButton.layer.borderWidth = 1;
    
    attentionButton.layer.masksToBounds = YES;
    attentionButton.layer.cornerRadius = 13;
    UIColor* myColor = [UIColor colorWithRed:98.0 / 255.0 green:184.0 / 255.0 blue:120 / 255.0 alpha:1];\
    attentionButton.layer.borderColor = myColor.CGColor;
    [attentionButton setTitleColor:myColor forState:UIControlStateNormal];
    UIBarButtonItem* rightButton = [[UIBarButtonItem alloc] initWithCustomView:attentionButton];
    self.navigationItem.rightBarButtonItems = @[rightButton, space];
    
}
- (void)popViewController {
    self.tabBarController.hidesBottomBarWhenPushed = NO;
    [self.navigationController popViewControllerAnimated:YES];
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
