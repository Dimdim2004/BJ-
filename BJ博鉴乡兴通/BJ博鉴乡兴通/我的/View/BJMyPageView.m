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
    flowLayout.headerReferenceSize = CGSizeMake(393, 40);
    flowLayout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
    UIColor* mycolor = [UIColor colorWithRed:250 / 255.0 green:250 / 255.0 blue:250 / 255.0 alpha:1];
    self.backgroundColor = mycolor;
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height - 110) collectionViewLayout:flowLayout];
    self.collectionView.backgroundColor = mycolor;
    self.collectionView.bounces = NO;
    self.collectionView.tag = 101;
    
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
