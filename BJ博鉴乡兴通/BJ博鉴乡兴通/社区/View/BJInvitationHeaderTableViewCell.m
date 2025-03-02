//
//  BJInvitationHeaderTableViewCell.m
//  BJ博鉴乡兴通
//
//  Created by nanxun on 2025/2/6.
//

#import "BJInvitationHeaderTableViewCell.h"
#import "BJInvitationTopContentView.h"
@implementation BJInvitationHeaderTableViewCell

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
    if ([reuseIdentifier isEqualToString:@"header"]) {
        self.titleLabel = [[UILabel alloc] init];
        self.contentLabel = [[UILabel alloc] init];
        self.headImageView = [[UIImageView alloc] init];
        self.contentLabel.textColor = UIColor.blackColor;
        self.titleLabel.textColor = UIColor.blackColor;
        self.contentLabel.font = [UIFont systemFontOfSize:16];
        self.titleLabel.numberOfLines = 2;
        self.contentLabel.numberOfLines = 0;
        self.titleLabel.font = [UIFont boldSystemFontOfSize:23];
        [self.contentView addSubview:_headImageView];
        [self.contentView addSubview:_titleLabel];
        [self.contentView addSubview:_contentLabel];
        [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView);
            make.left.equalTo(self.contentView);
            make.right.equalTo(self.contentView);
            make.height.equalTo(@(363));
        }];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(10);
            make.right.equalTo(self.contentView).offset(10);
            make.top.equalTo(self.headImageView.mas_bottom).offset(-10);
            make.height.equalTo(@80);
        }];
        [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLabel.mas_bottom);
            make.left.right.equalTo(self.titleLabel);
            make.bottom.equalTo(self.contentView);
        }];
    }
    return self;
}
@end
