//
//  BJCountryDynamicTableViewCell.m
//  BJ博鉴乡兴通
//
//  Created by wjc on 2025/3/24.
//

#import "BJCountryDynamicTableViewCell.h"
#import "BJCommityCollectionViewCell.h"
#import "BJCommityModel.h"

@implementation BJCountryDynamicTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
    }
    return self;
}
-(void)setupUI {
    
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self addSubview:self.collectionView];
    
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


@end
