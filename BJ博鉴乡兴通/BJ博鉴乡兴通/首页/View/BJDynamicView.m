//
//  BJDynamicViewController.m
//  BJ博鉴乡兴通
//
//  Created by wjc on 2025/3/13.
//

#import "BJDynamicView.h"
#import "BJDynamicModel.h"
#import "BJDynamicTableViewCell.h"
#import <Masonry.h>
@interface BJDynamicView ()<UITableViewDelegate,UITableViewDataSource,BJDynamicTableViewCellDelegate,UIGestureRecognizerDelegate>
@property (strong, nonatomic)NSArray<BJDynamicModel *> *dynamicModel;
@end

@implementation BJDynamicView

-(instancetype)initWithDynamicModel:(NSArray<BJDynamicModel *> *)dynamicModel {
    self = [super init];
    if (self) {
        self.dynamicModel = dynamicModel;
        self.backgroundColor = [UIColor whiteColor];
        
        [self setupView];
    }
    return self;
}


-(void)setupView {
    self.tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.bounces = NO;
    self.tableView.scrollEnabled = NO;

    [self addSubview:self.tableView];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[BJDynamicTableViewCell class] forCellReuseIdentifier:@" DynamicTableViewCell"];
    self.tableView.estimatedRowHeight = 200;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    self.tableView.panGestureRecognizer.cancelsTouchesInView = NO;

    UILabel *footerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 30)];
    footerLabel.text = @"已经没有更多内容";
    footerLabel.textAlignment = NSTextAlignmentCenter;
    footerLabel.textColor = [UIColor lightGrayColor];
    
    self.tableView.tableFooterView = footerLabel;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dynamicModel.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BJDynamicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@" DynamicTableViewCell"];
    cell.delegate = self;
    [cell configureWithModel:self.dynamicModel[indexPath.row]];
    return cell;
}

- (void)didTapImageAtIndex:(NSInteger)index onCell:(UITableViewCell *)cell {

    UIWindow *window = [self getCurrentWindow];
    if (!window) return;
    
    UIImageView *originalImageView = [cell.contentView viewWithTag: index];
    if (!originalImageView || !originalImageView.image) {
        NSLog(@"Error: Image view or image not found");
        return;
    }

    UIView *backgroundView = [[UIView alloc] initWithFrame:window.bounds];
    backgroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
    backgroundView.alpha = 0;

    UIImageView *fullImageView = [[UIImageView alloc] initWithImage:originalImageView.image];
    fullImageView.contentMode = UIViewContentModeScaleAspectFit;
    fullImageView.translatesAutoresizingMaskIntoConstraints = NO;

    CGRect startFrame = [originalImageView convertRect:originalImageView.bounds toView:window];
    fullImageView.frame = startFrame;
    

    [backgroundView addSubview:fullImageView];
    [window addSubview:backgroundView];
    
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        backgroundView.alpha = 1;
        fullImageView.frame = window.bounds;
    } completion:nil];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissImageView:)];
    [backgroundView addGestureRecognizer:tap];
}




- (UIWindow *)getCurrentWindow {
    UIWindow *keyWindow = nil;
    for (UIWindowScene *scene in [UIApplication sharedApplication].connectedScenes) {
        if (scene.activationState == UISceneActivationStateForegroundActive) {
            keyWindow = scene.windows.firstObject;
            return keyWindow;
        }
    }
    return nil;
}

- (void)dismissImageView:(UITapGestureRecognizer *)gesture {
    [UIView animateWithDuration:0.3 animations:^{
        gesture.view.alpha = 0;
    } completion:^(BOOL finished) {
        [gesture.view removeFromSuperview];
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

    if (self.tableView.contentOffset.y <= 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ShouldEnableOuterScroll" object:nil];
    }
}
@end
