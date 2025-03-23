//
//  SegmentControlTableViewCell.h
//  BJ博鉴乡兴通
//
//  Created by wjc on 2025/3/8.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class BJSegmentControlTableViewCell,BJDynamicView;
@protocol BJSegmentControlTableViewCellDelegate <NSObject>
- (void)segmentCell:(BJSegmentControlTableViewCell *)cell didScrollToPage:(NSInteger)page;

- (void)segmentControlDidStartInteraction;
- (void)segmentControlDidEndInteraction;

@end

@interface BJSegmentControlTableViewCell : UITableViewCell
@property (strong, nonatomic)UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray<BJDynamicView *> *dynamicViews;
@property (strong, nonatomic) UIView *stickyView;

@property (weak, nonatomic) id <BJSegmentControlTableViewCellDelegate> delegate;
- (void) setScrollViewOffsetWithTag:(NSInteger)tag animated:(BOOL)animated;
-(BJDynamicView*)currentPageRollwithSet;
-(NSInteger)getCurrentPage;
@end

NS_ASSUME_NONNULL_END
