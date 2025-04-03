//
//  BJCommityFootReusableView.h
//  BJ博鉴乡兴通
//
//  Created by nanxun on 2025/3/28.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BJCommityFootReusableView : UICollectionReusableView
@property (nonatomic, strong) UIActivityIndicatorView* activity;
- (void)startLoading:(BOOL)isLoading;
- (void)endLoading;
@end

NS_ASSUME_NONNULL_END
