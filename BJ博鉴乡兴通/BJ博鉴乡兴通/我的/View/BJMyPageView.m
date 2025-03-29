//
//  BJMyPageView.m
//  BJ博鉴乡兴通
//
//  Created by nanxun on 2025/3/27.
//

#import "BJMyPageView.h"
#import "Masonry/Masonry.h"
#import "BJMyPageFlowLayout.h"
@implementation BJMyPageView
- (void)setUI:(NSArray*)heightAry andSectionCount:(NSInteger)sectionCount itemCount:(NSInteger)itemCount {
    BJMyPageFlowLayout* flowLayout = [[BJMyPageFlowLayout alloc] initWithFlowLayoutWithCount:itemCount andSection:sectionCount andHeightAry:heightAry];
    flowLayout.footerReferenceSize = CGSizeMake(393, 30);
    flowLayout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
    [self addSubview:self.collectionView];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
