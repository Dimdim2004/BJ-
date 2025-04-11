//
//  ScrollViewViewModel.h
//  BJ博鉴乡兴通
//
//  Created by wjc on 2025/4/5.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ScrollViewViewModel : NSObject
@property (weak, nonatomic) UIViewController<UIScrollViewDelegate> *targetVC;

@end

NS_ASSUME_NONNULL_END
