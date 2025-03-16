//
//  BJSearchBarTableViewCell.m
//  BJ博鉴乡兴通
//
//  Created by wjc on 2025/3/13.
//

#import "BJSearchBarTableViewCell.h"
#import "BJSearchBar.h"
#import <Masonry.h>
@implementation BJSearchBarTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

-(void) setupUI {
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    
    _searchBar = [[BJSearchBar alloc] init];
    _searchBar.placeholder = @"搜索乡村/民宿/土货";
    _searchBar.searchBarStyle = UISearchBarStyleMinimal;
    [self.contentView addSubview:_searchBar];
    self.searchBar.frame = CGRectMake(0, -20, [UIScreen mainScreen].bounds.size.width, 44);
    
    
}

@end
