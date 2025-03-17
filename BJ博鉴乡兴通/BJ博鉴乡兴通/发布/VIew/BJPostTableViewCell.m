//
//  BJPostTableViewCell.m
//  BJ博鉴乡兴通
//
//  Created by nanxun on 2025/2/27.
//

#import "BJPostTableViewCell.h"
#import "Masonry/Masonry.h"

@implementation BJPostTableViewCell

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
    if ([reuseIdentifier isEqualToString:@"title"]) {
        self.titleView = [[UITextField alloc] init];
        self.titleView.font = [UIFont systemFontOfSize:23];
        self.titleView.placeholder = @"请输入标题";
        self.titleView.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
        self.titleView.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 0)];
        [self.contentView addSubview:self.titleView];
        [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.top.left.equalTo(self.contentView);
        }];
    } else if ([reuseIdentifier isEqualToString:@"content"]) {
        self.contentTextView = [[UITextField alloc] init];
        self.contentTextView.font = [UIFont systemFontOfSize:18];
        self.contentTextView.placeholder = @"请输入内容";
        self.contentTextView.textAlignment = NSTextAlignmentLeft;
        self.contentTextView.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 0)];
        self.contentTextView.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
        [self.contentView addSubview:self.contentTextView];
        [self.contentTextView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.top.left.equalTo(self.contentView);
        }];
    } else if ([reuseIdentifier isEqualToString:@"image"]){
        self.buttonScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(10, 15, 393, 50)];
        self.buttonScrollView.contentSize = CGSizeMake(393 * 2, 0);
        self.buttonScrollView.showsVerticalScrollIndicator = NO;
        self.buttonScrollView.showsHorizontalScrollIndicator = NO;
        self.btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.contentView addSubview:self.buttonScrollView];
        [self.buttonScrollView addSubview:self.btn];
        [self.btn setImage:[UIImage imageNamed:@"tianjia.png"] forState:UIControlStateNormal];
        self.btn.frame = CGRectMake(10, 0, 50, 50);
    }
    return self;
}
@end
