//
//  BJCommityCollectionViewCell.h
//  BJ博鉴乡兴通
//
//  Created by nanxun on 2025/1/29.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BJCommityCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) UIImageView* imageView;
@property (nonatomic, strong) UILabel* label;
@property (nonatomic, strong) UIImageView* profileView;
@property (nonatomic, strong) UILabel* nameLabel;
@property (nonatomic, strong) UIButton* likeButton;
@end

NS_ASSUME_NONNULL_END
