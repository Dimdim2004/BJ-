//
//  BJMainCommunityView.m
//  BJ博鉴乡兴通
//
//  Created by nanxun on 2025/1/22.
//

#import "BJMainCommunityView.h"

@implementation BJMainCommunityView
- (void)setUIWithHeightAry:(NSArray<NSNumber*>*)heightAry andSectionCount:(NSInteger)sectionCount itemCount:(NSInteger)itemCount {
    self.backgroundColor = UIColor.whiteColor;
//    self.contentView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
//    self.contentView.contentSize = CGSizeMake(self.bounds.size.width * 3, 0);
//    self.contentView.backgroundColor = [UIColor colorWithRed:243/255.0 green:245/255.0 blue:247/255.0 alpha:1];;
//    self.contentView.pagingEnabled = YES;
//    self.contentView.showsVerticalScrollIndicator = NO;
//    self.contentView.showsHorizontalScrollIndicator = NO;
//    [self addSubview:_contentView];
   // self.flowViewArray = [NSMutableArray array];
//    for (int i = 0; i < 3; i++) {
    BJCommunityUIColectionViewFlowLayout* layout = [[BJCommunityUIColectionViewFlowLayout alloc] initWithFlowLayoutWithCount:20 andSection:3 andHeightAry:heightAry];
    layout.footerReferenceSize = CGSizeMake(393, 30);
    layout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
    self.mainView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height - 83) collectionViewLayout:layout];
    UIColor* mycolor = [UIColor colorWithRed:250 / 255.0 green:250 / 255.0 blue:250 / 255.0 alpha:1];
    
    self.mainView.backgroundColor = mycolor;
    self.mainView.tag = 101;
    self.mainView.bounces = NO;
    [self addSubview:self.mainView];
    //}
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
