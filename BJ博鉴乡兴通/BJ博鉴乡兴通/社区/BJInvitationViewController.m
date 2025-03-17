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
#import "Masonry.h"
#import "BJCommentsModel.h"
#import "BJNetworkingManger.h"
#import "BJSubCommentsModel.h"
@interface BJInvitationViewController ()

@end

@implementation BJInvitationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    id manger = [BJNetworkingManger sharedManger];
    [manger loadWithViedoId:1 CommentId:0 WithSuccess:^(BJCommentsModel * _Nonnull commentModel) {
        self.iView = [[BJInvitationView alloc] initWithFrame:self.view.bounds];
        [self.iView.mainView registerClass:[BJInvitationTableViewCell class] forCellReuseIdentifier:@"comments"];
        [self.iView.mainView registerClass:[BJInvitationHeaderTableViewCell class] forCellReuseIdentifier:@"header"];
        [self.iView.mainView registerClass:[BJInvitationSubCommentsTableViewCell class] forCellReuseIdentifier:@"subComments"];
        [self.view addSubview:self.iView];
        self.iView.mainView.delegate = self;
        self.iView.mainView.dataSource = self;
        [self setNavgationBar];
        } failure:^(NSError * _Nonnull error) {
            NSLog(@"error");
        }];
    // Do any additional setup after loading the view.
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 30;
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
    if (indexPath.section == 0) {
        headerCell.titleLabel.text = @"这个是大标题";
        headerCell.contentLabel.text = @"这里我们如果想实现一个管道间的通信的话，其实是通过fork创建一个子进程，创建的子进程会复制父进程的文件描述符，这浪就可以做到两个进程间的一个通信的，这样会做到两个进程各有两个`fd[0]` `fd[1]`,两个进程就可以通过各自的fd写入和读取同一个管道文件实现一个跨进程通信了。这里我们如果想实现一个管道间的通信的话，其实是通过fork创建一个子进程，创建的子进程会复制父进程的文件描述符，这浪就可以做到两个进程间的一个通信的，这样会做到两个进程各有两个`fd[0]` `fd[1]`,两个进程就可以通过各自的fd写入和读取同一个管道文件实现一个跨进程通信了。";
        
        return headerCell;
    } else {
        BJSubCommentsModel* currentModel = self.commentModel.commentList[indexPath.row - 1];
        commentCell.textView.text = currentModel.content;
        commentCell.nameLabel.text = currentModel.username;
        commentCell.timeLabel.text = @"今天";
        commentCell.image.image = [UIImage imageNamed:@"WechatIMG17.jpg"];
        return commentCell;
        
    }
}
-(void) expandSubComment {
   
}

- (void)setNavgationBar {
    UINavigationBarAppearance* apperance = [[UINavigationBarAppearance alloc] init];
    apperance.shadowColor = [UIColor clearColor];
    apperance.shadowImage = [[UIImage alloc] init];
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
    
}
- (void)popViewController {
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
