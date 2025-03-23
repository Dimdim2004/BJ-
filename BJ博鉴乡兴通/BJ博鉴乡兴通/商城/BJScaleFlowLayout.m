//
//  BJScaleFlowLayout.m
//  BJ博鉴乡兴通
//
//  Created by wjc on 2025/3/18.
//

#import "BJScaleFlowLayout.h"

@implementation BJScaleFlowLayout

- (void)prepareLayout {
    [super prepareLayout];
    self.activeDistance = self.itemSize.width * 0.5;
    self.scaleFactor = 0.2;
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray *attributes = [super layoutAttributesForElementsInRect:rect];
    CGRect visibleRect = (CGRect){self.collectionView.contentOffset, self.collectionView.bounds.size};
    
    for (UICollectionViewLayoutAttributes *attr in attributes) {
        CGFloat distance = CGRectGetMidX(visibleRect) - attr.center.x;
        CGFloat normalizedDistance = fabs(distance) / self.activeDistance;
        CGFloat zoom = 1 + self.scaleFactor * (1 - normalizedDistance);
        zoom = MIN(MAX(zoom, 1.0), 1.2);
        
        attr.transform3D = CATransform3DMakeScale(zoom, zoom, 1);
    }
    return attributes;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}


- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedOffset withScrollingVelocity:(CGPoint)velocity {
    CGFloat pageWidth = self.itemSize.width + self.minimumLineSpacing;
    
    CGFloat currentPage = round(self.collectionView.contentOffset.x / pageWidth);
    
    if (velocity.x > 0) {
        currentPage += 1;
    } else if (velocity.x < 0) {
        currentPage -= 1;
    }
    
    return CGPointMake(currentPage * pageWidth, proposedOffset.y);
}

@end
