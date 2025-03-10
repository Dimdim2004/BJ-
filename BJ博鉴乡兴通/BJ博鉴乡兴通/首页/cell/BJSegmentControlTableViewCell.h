//
//  SegmentControlTableViewCell.h
//  BJ博鉴乡兴通
//
//  Created by wjc on 2025/3/8.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BJSegmentControlTableViewCell : UITableViewCell
@property (strong, nonatomic)UIScrollView *scrollView;

- (void)selectButtonAtIndex:(NSInteger)index animated:(BOOL)animated;
@end

NS_ASSUME_NONNULL_END
