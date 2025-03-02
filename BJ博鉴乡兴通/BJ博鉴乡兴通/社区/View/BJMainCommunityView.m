//
//  BJMainCommunityView.m
//  BJ博鉴乡兴通
//
//  Created by nanxun on 2025/1/22.
//

#import "BJMainCommunityView.h"

@implementation BJMainCommunityView
- (void)setUI {
    self.backgroundColor = UIColor.whiteColor;
    BJCommunityUIColectionViewFlowLayout* layout = [[BJCommunityUIColectionViewFlowLayout alloc] initWithFlowLayoutWithCount:20 andSection:3];
    layout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
    self.FlowView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
    
    [self addSubview:self.FlowView];
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUI];
    }
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
