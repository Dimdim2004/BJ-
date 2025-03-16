//
//  BJScrollViewTableViewCell.h
//  BJ博鉴乡兴通
//
//  Created by wjc on 2025/1/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BJScrollViewTableViewCell : UITableViewCell<UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) NSTimer *timer;


- (void)configureWithTopStories:(NSArray *)images;
@end

NS_ASSUME_NONNULL_END
