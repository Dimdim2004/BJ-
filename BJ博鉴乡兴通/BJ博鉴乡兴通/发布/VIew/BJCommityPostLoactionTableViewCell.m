//
//  BJCommityPostLoactionTableViewCell.m
//  BJ博鉴乡兴通
//
//  Created by nanxun on 2025/3/11.
//

#import "BJCommityPostLoactionTableViewCell.h"

@implementation BJCommityPostLoactionTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if ([self.reuseIdentifier isEqualToString:@"loaction"]) {
        self.titleView = [[UITextField alloc] init];
        self.titleView.text = @"关联到村";
        self.titleView.frame = CGRectMake(40, 5, 100, 30);
        [self.contentView addSubview:self.titleView];
        self.iconView = [[UIImageView alloc] init];
        self.iconView.image = [UIImage imageNamed:@"didian.png"];
        self.iconView.frame = CGRectMake(10, 7.5, 25, 25);
        
        [self.contentView addSubview:self.iconView];
        
    }
    return self;
}
@end
