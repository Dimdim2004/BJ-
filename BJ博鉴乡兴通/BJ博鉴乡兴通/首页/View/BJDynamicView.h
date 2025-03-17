//
//  BJDynamicViewController.h
//  BJ博鉴乡兴通
//
//  Created by wjc on 2025/3/13.
//

#import <UIKit/UIKit.h>
@class BJDynamicModel;
NS_ASSUME_NONNULL_BEGIN
@protocol BJDynamicViewDelegate <NSObject>
- (void)enableMainScrollView:(BOOL)enable;
@end

@interface BJDynamicView : UIView
@property (nonatomic, strong) UITableView *tableView;

@property (weak, nonatomic) id <BJDynamicViewDelegate> delegate;
-(instancetype)initWithDynamicModel:(NSArray<BJDynamicModel *> *)dynamicModel;
@end

NS_ASSUME_NONNULL_END
