//
//  BJDynamicTableViewCell.h
//  BJ博鉴乡兴通
//
//  Created by wjc on 2025/3/11.
//

#import <UIKit/UIKit.h>
@class BJDynamicModel,BJDynamicTableViewCell;
NS_ASSUME_NONNULL_BEGIN
@protocol BJDynamicTableViewCellDelegate <NSObject>
- (void)didTapLikeButtonOnCell:(BJDynamicTableViewCell *)cell;
- (void)didTapCommentButtonOnCell:(BJDynamicTableViewCell *)cell;
- (void)didTapShareButtonOnCell:(BJDynamicTableViewCell *)cell;
- (void)didTapImageAtIndex:(NSInteger)index onCell:(UITableViewCell *)cell;
@end


@interface BJDynamicTableViewCell : UITableViewCell

@property (nonatomic, weak) id<BJDynamicTableViewCellDelegate> delegate;


- (void)configureWithModel:(BJDynamicModel *)model;
+ (CGFloat)cellHeightForModel:(BJDynamicModel *)model tableViewWidth:(CGFloat)width;
@end

NS_ASSUME_NONNULL_END
