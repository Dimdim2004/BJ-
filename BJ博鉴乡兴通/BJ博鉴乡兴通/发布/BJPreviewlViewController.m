//
//  BJPreviewlViewController.m
//  BJ博鉴乡兴通
//
//  Created by nanxun on 2025/3/18.
//

#import "BJPreviewlViewController.h"
#import "BJCommityPostLoactionTableViewCell.h"
#import "BJInvitationHeaderTableViewCell.h"
#import "BJPostCommityView.h"
#import "Masonry.h"
#import "BJPreviewModel.h"

@interface BJPreviewlViewController ()

@end

@implementation BJPreviewlViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    self.mainView = [[UITableView alloc] initWithFrame:CGRectMake(0, 100, 393, 800)];
    [self.mainView registerClass:[BJCommityPostLoactionTableViewCell class] forCellReuseIdentifier:@"preView"];
    [self.mainView registerClass:[BJInvitationHeaderTableViewCell class] forCellReuseIdentifier:@"header"];
    [self.view addSubview:self.mainView];
    self.mainView.delegate = self;
    self.mainView.dataSource = self;
    self.mainView.estimatedRowHeight = 100;
    self.mainView.rowHeight = UITableViewAutomaticDimension;
    self.postButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:self.postButton];
    [self.postButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(-10);
        make.left.equalTo(self.view.mas_left).offset(10);
        make.bottom.equalTo(self.view.mas_bottom).offset(-30);
        make.height.equalTo(@60);
    }];
    [self.postButton setTitle:@"发布动态" forState:UIControlStateNormal];
    [self.postButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    UIColor* buttonColor = [UIColor colorWithRed:43.0 / 255.0 green:95.0 / 255.0 blue:51 / 255.0 alpha:1];
    self.postButton.backgroundColor = buttonColor;
    self.postButton.layer.masksToBounds = YES;
    self.postButton.layer.cornerRadius = 30;
    [self.postButton addTarget:self action:@selector(post) forControlEvents:UIControlEventTouchUpInside];
    NSString* string = @"back2.png";
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:button];
    [button addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [button setImage:[UIImage imageNamed:string] forState:UIControlStateNormal];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.width.height.equalTo(@45);
        make.top.equalTo(@60);
    }];

}

-(void)dismiss {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BJInvitationHeaderTableViewCell* headerCell = [tableView dequeueReusableCellWithIdentifier:@"header"];
    BJCommityPostLoactionTableViewCell* sceondCell = [tableView dequeueReusableCellWithIdentifier:@"preView"];
    if (indexPath.section == 0) {
        headerCell.headScrollerView.delegate = self;
        headerCell.contentLabel.text = self.model.contetnString.length == 0 ? @"" : self.model.contetnString;
        headerCell.titleLabel.text = self.model.titleString.length == 0 ? @"" : self.model.titleString;
        self.page = headerCell.mypage;
        [headerCell addImageToScrollerView:self.photos];
        return headerCell;
    } else {
        return sceondCell;
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.tag == 100) {
        CGFloat offsetX = scrollView.contentOffset.x;
        CGFloat pageWidth = scrollView.frame.size.width;
        NSInteger currentPage = scrollView.contentOffset.x / pageWidth;
        self.page.currentPage = currentPage;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (void)post {
    return;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return UITableViewAutomaticDimension;
    } else {
        return 70;
    }
}

@end
