//
//  SegmentControlTableViewCell.h
//  BJ博鉴乡兴通
//
//  Created by wjc on 2025/3/8.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class BJSegmentControlTableViewCell;
@protocol BJSegmentControlTableViewCellDelegate <NSObject>
- (void)segmentCell:(BJSegmentControlTableViewCell *)cell didScrollToPage:(NSInteger)page;
- (void)segmentCell:(BJSegmentControlTableViewCell *)cell didSelectBtn:(NSString*)text;

@end

@interface BJSegmentControlTableViewCell : UITableViewCell
@property (strong, nonatomic)UIScrollView *scrollView;
@property (nonatomic, assign) NSInteger currentPage;
@property (strong, nonatomic)UIView *stickyView;
@property (strong, nonatomic)UIView *lineView;
@property (weak, nonatomic) id <BJSegmentControlTableViewCellDelegate> delegate; //BJSegmentControlTableViewCellDelegate
- (void)selectButtonAtIndex:(NSInteger)index animated:(BOOL)animated;
- (void) setScrollViewOffsetWithTag:(NSInteger)tag animated:(BOOL)animated;
@end

NS_ASSUME_NONNULL_END
