//
//  BJMyHometownViewController.m
//  BJ博鉴乡兴通
//
//  Created by wjc on 2025/3/8.
//

#import "BJMyHometownViewController.h"
#import <Masonry.h>
#import "BJCountryModel.h"
#import "SDWebImage.h"
#import "BJCountryInfoTableViewCell.h"
#import "BJWatetFlowTableViewCell.h"
@interface BJMyHometownViewController ()<UITableViewDataSource,UIScrollViewDelegate,UIGestureRecognizerDelegate>

{
    BJWatetFlowTableViewCell* _cellRef;
}

@property(strong, nonatomic) UITableView *tableView;
@property(assign, nonatomic) CGFloat imageHeight;
@property(strong, nonatomic) UIButton *leftButton;
@property (nonatomic, assign) CGFloat maxOffsetY;
@property (nonatomic, assign) BOOL mainScrollEnabled;
@property (nonatomic, assign) BOOL subScrollEnabled;
@property (nonatomic, assign) CGFloat currentPanY;


@end

@implementation BJMyHometownViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imageHeight = 250;
    _maxOffsetY = 440;
    [self setupViews];
}

-(void)setupViews {
    self.navigationController.navigationBar.titleTextAttributes = @{
           NSForegroundColorAttributeName: [UIColor whiteColor]
       };
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.scrollEnabled = YES;
    [self.view addSubview:self.tableView];
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    panGesture.delegate = self;
    [self.tableView addGestureRecognizer:panGesture];

    [self.tableView registerClass:[BJCountryInfoTableViewCell class] forCellReuseIdentifier:@"CountryInfoCell"];
    [self.tableView registerClass:[BJWatetFlowTableViewCell class] forCellReuseIdentifier:@"WatetFlowCell"];
    self.headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.imageHeight)];
    self.headerImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.headerImageView.clipsToBounds = YES;
    [self.tableView insertSubview:self.headerImageView atIndex:0];
    

    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, self.imageHeight)];
    headerView.backgroundColor = [UIColor clearColor];
    self.tableView.tableHeaderView = headerView;
    

    self.leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [self.leftButton addTarget:self action:@selector(leftButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.leftButton setImage:[UIImage systemImageNamed:@"chevron.left"] forState:UIControlStateNormal];
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.leftButton];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    self.navigationController.navigationBar.tintColor  = [UIColor colorWithRed:16/255.0 green:89/255.0 blue:45/255.0 alpha:1];
}

-(void)leftButtonClicked:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setCountryModel:(BJCountryModel *)countryModel {
    self.title = countryModel.name;
    _countryModel = countryModel;
    NSLog(@"%@",_countryModel.imageUrl);
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:self->_countryModel.imageUrl] placeholderImage:[UIImage imageNamed:@"placeholderForAddress.png"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            
            [self.tableView reloadData];
        }];
    });
    NSLog(@"%@",self.headerImageView.image);
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        BJCountryInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CountryInfoCell"];
        cell.backgroundColor = [UIColor whiteColor];
        [cell configureWithModel:self.countryModel];
        return cell;
    } else {
        BJWatetFlowTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WatetFlowCell"];
        _cellRef = cell;
        cell.scrollDelegate = self;
        return cell;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 230;
    } else {
        return [UIScreen mainScreen].bounds.size.height - 40;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [scrollView layoutIfNeeded];
    if (scrollView == self.tableView && scrollView.scrollEnabled) {
        CGFloat offsetY = scrollView.contentOffset.y;
        if (offsetY < 0) {
            self.headerImageView.frame = CGRectMake(offsetY, offsetY, scrollView.bounds.size.width - offsetY * 2, self.imageHeight - offsetY);
        } else {
            self.headerImageView.frame = CGRectMake(0, 0, scrollView.bounds.size.width, self.imageHeight);
        }
        if (offsetY >= _maxOffsetY) {
            [scrollView setContentOffset:CGPointMake(0, _maxOffsetY) animated:NO];
            [scrollView.panGestureRecognizer setEnabled:NO];
            [scrollView.panGestureRecognizer setEnabled:YES];
            _cellRef.collectionView.scrollEnabled = YES;
            self.tableView.scrollEnabled = NO;
            _subScrollEnabled = YES;
            _mainScrollEnabled = NO;
        }

        CGFloat threshold = 100.0;
        CGFloat alpha = (offsetY - 50) / threshold;
        alpha = MAX(0, MIN(alpha, 1.0));
        UINavigationBarAppearance *appearance = [self.navigationController.navigationBar.standardAppearance copy];
        appearance.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:alpha];
        if (alpha >= 0.5) {
            appearance.titleTextAttributes = @{ NSForegroundColorAttributeName: [UIColor blackColor] };
            [self.leftButton setTintColor:[UIColor blackColor]];
        } else {
            appearance.titleTextAttributes = @{ NSForegroundColorAttributeName: [UIColor whiteColor] };
            [self.leftButton setTintColor:[UIColor whiteColor]];
        }
        self.navigationController.navigationBar.standardAppearance = appearance;
        self.navigationController.navigationBar.scrollEdgeAppearance = appearance;
        
    } else {
        if (scrollView.contentOffset.y < -3) {
            [scrollView setContentOffset:CGPointZero animated:NO];
            _mainScrollEnabled = YES;
            _subScrollEnabled = NO;
            self.tableView.scrollEnabled = YES;
            _cellRef.collectionView.scrollEnabled = NO;
        }
    }
}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
   
    return YES;
}

-(void)handlePan:(UIPanGestureRecognizer *)recognizer {
    if (recognizer.state != UIGestureRecognizerStateChanged) {
        _currentPanY = 0;
        _mainScrollEnabled = NO;
        _subScrollEnabled = NO;
    } else {
        CGFloat currentY = [recognizer translationInView:self.tableView].y;
        
        if (_mainScrollEnabled || _subScrollEnabled) {
            if (_currentPanY == 0) {
                _currentPanY = currentY; // 记录临界点位置
            }
            CGFloat offsetY = _currentPanY - currentY;
            
            if (_mainScrollEnabled) {
                CGFloat supposeY = _maxOffsetY + offsetY;
                self.tableView.contentOffset = CGPointMake(0, MAX(supposeY, 0));
            } else {
                _cellRef.collectionView.contentOffset = CGPointMake(0, MAX(offsetY, 0));
            }
        }
    }
}


@end

