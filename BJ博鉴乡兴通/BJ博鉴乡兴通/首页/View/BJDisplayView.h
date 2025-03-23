//
//  BJDisplayView.h
//  BJ博鉴乡兴通
//
//  Created by wjc on 2025/3/14.
//

#import <UIKit/UIKit.h>
@class BJDisplayModel;
NS_ASSUME_NONNULL_BEGIN

@interface BJDisplayView : UIView
-(void)updateWithModel:(BJDisplayModel *)model;
@end

NS_ASSUME_NONNULL_END
