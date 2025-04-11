//
//  BJDetailViewController.h
//  BJ博鉴乡兴通
//
//  Created by wjc on 2025/4/7.
//

#import <UIKit/UIKit.h>
@class BJProductModel;
NS_ASSUME_NONNULL_BEGIN

@interface BJDetailViewController : UIPageViewController
@property (strong, nonatomic)BJProductModel *productModel;

- (instancetype)initWithModel:(BJProductModel *)model;
@end

NS_ASSUME_NONNULL_END
