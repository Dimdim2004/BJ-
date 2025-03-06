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
@interface BJInvitationViewController ()

@end

@implementation BJInvitationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.iView = [[BJInvitationView alloc] initWithFrame:self.view.bounds];
    [self.iView.mainView registerClass:[BJInvitationTableViewCell class] forCellReuseIdentifier:@"comments"];
    [self.iView.mainView registerClass:[BJInvitationHeaderTableViewCell class] forCellReuseIdentifier:@"header"];
    [self.iView.mainView registerClass:[BJInvitationSubCommentsTableViewCell class] forCellReuseIdentifier:@"subComments"];
    [self.view addSubview:self.iView];
    self.iView.mainView.delegate = self;
    self.iView.mainView.dataSource = self;
    // Do any additional setup after loading the view.
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 30;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else {
        return 3;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
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
        if (indexPath.row == 0) {
            commentCell.textView.text = @"这个是主评论";
            commentCell.nameLabel.text = @"名字";
            commentCell.timeLabel.text = @"今天";
            commentCell.image.image = [UIImage imageNamed:@"WechatIMG17.jpg"];
            return commentCell;
        } else {
            subCommentCell.textView.text = @"这个是二级评论第一层,这个是二级评论第一层,这个是二级评论第一层,这个是二级评论第一层,这个是二级评论第一层,这个是二级评论第一层,这个是二级评论第一层,这个是二级评论第一层,这个是二级评论第一层";
            subCommentCell.nameLabel.text = @"名字";
            subCommentCell.timeLabel.text = @"今天";
            subCommentCell.image.image = [UIImage imageNamed:@"WechatIMG17.jpg"];
            return subCommentCell;
        }
    }
}
-(void) expandSubComment {
   
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
