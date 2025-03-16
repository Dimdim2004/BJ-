//
//  SegmentControlTableViewCell.m
//  BJ博鉴乡兴通
//
//  Created by wjc on 2025/3/8.
//


#import "BJSegmentControlTableViewCell.h"
#import <Masonry.h>
#import "BJDynamicModel.h"
#import "BJDynamicTableViewCell.h"
#import "BJDynamicView.h"



@interface BJSegmentControlTableViewCell ()<UIScrollViewDelegate,BJDynamicTableViewCellDelegate,UIGestureRecognizerDelegate>

@property (assign, nonatomic)BOOL isLocked;
@property (strong, nonatomic)NSArray *array;
@property (strong, nonatomic)NSArray<BJDynamicModel *> *dynamicModel;
@end


@implementation BJSegmentControlTableViewCell

-(instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.isLocked = NO;
        self.dynamicViews = [[NSMutableArray alloc] init];
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self setupModel];
        [self setupScrollView];

        
    }
    return self;
}



-(void)setupModel {
    BJDynamicModel *model = [[BJDynamicModel alloc] init];
    model.userName = @"旅行日记";
    model.avatarUrl = @"https://example.com/avatars/travel_diary.jpg";
    model.content = @"刚完成环青海湖骑行，全程360公里，蓝天白云和油菜花海交织的美景让人忘却疲惫🚴♀️！";
    model.images = @[
        @"1.png",
        @"2.png",
        @"3.png"
    ];
    model.numofLikes = @"12";
    model.numofComment = @"5";
    model.numofShare = @"3";
    model.timeText = @"3小时前";
    model.isLiked = NO;
    self.dynamicModel = @[model, model, model,model,model];
}

- (void) setScrollViewOffsetWithTag:(NSInteger)tag animated:(BOOL)animated {
    [self.scrollView setContentOffset:CGPointMake(tag  * self.scrollView.frame.size.width, 0) animated:animated];
}
-(void)setupScrollView {
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.scrollView];
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView);
        make.left.right.equalTo(self.contentView);
    }];
    
    UIView *containerView = [UIView new];
    [self.scrollView addSubview:containerView];
    [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.scrollView);
        make.top.equalTo(self.scrollView);
        make.height.equalTo(self.scrollView);
    }];
    

    UIView *previousView = nil;
    for (int i = 0; i < 4; i++) {;
        BJDynamicView *dynamicView = [[BJDynamicView alloc] initWithDynamicModel:self.dynamicModel];
        
        dynamicView.tag = 100 + i;
        dynamicView.backgroundColor = [UIColor whiteColor];
        [self.dynamicViews addObject:dynamicView];
        [containerView addSubview:dynamicView];
        [dynamicView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(containerView);
            make.width.equalTo(self.scrollView);
            
            if (previousView) {
                make.left.equalTo(previousView.mas_right);
            } else {
                make.left.equalTo(containerView);
            }
        }];
        
        previousView = dynamicView;
    }
    

    [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(previousView);
    }];

    // 设置内容区域右边界
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(previousView.mas_right);
    }];
    

    self.scrollView.delegate = self;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.bounces = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
}


#pragma mark - ScrollView联动处理
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat pageWidth = scrollView.frame.size.width;
    NSInteger currentPage = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    if ([self.delegate respondsToSelector:@selector(segmentCell:didScrollToPage:)]) {
        [self.delegate segmentCell:self didScrollToPage:currentPage];
    }
}

-(BJDynamicView*)currentPageRollwithSet {
    CGFloat pageWidth = self.scrollView.frame.size.width;
    NSInteger currentPage = (NSInteger)(self.scrollView.contentOffset.x / pageWidth);
    BJDynamicView* view = self.dynamicViews[currentPage];
    return view;
}





@end
