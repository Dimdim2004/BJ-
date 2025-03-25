//
//  BJCountryInfoTableViewCell.m
//  BJ博鉴乡兴通
//
//  Created by wjc on 2025/3/23.
//

#import "BJCountryInfoTableViewCell.h"
#import <Masonry.h>
#import "BJCountryModel.h"
@implementation BJCountryInfoTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _locationButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _locationButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_locationButton setTitleColor:[UIColor colorWithRed:16/255.0 green:89/255.0 blue:45/255.0 alpha:1] forState:UIControlStateNormal];
        [_locationButton addTarget:self action:@selector(navigationStart:) forControlEvents:UIControlEventTouchUpInside];

        _descriptionLabel = [[UILabel alloc] init];
        _descriptionLabel.numberOfLines = 0;
        _descriptionLabel.font = [UIFont systemFontOfSize:18];
        
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont boldSystemFontOfSize:28];
        _nameLabel.textColor = [UIColor blackColor];
        
        UILabel *label = [[UILabel alloc] init];
        label.text = @"乡村简介";
        label.textColor = [UIColor grayColor];
        label.font = [UIFont systemFontOfSize:20];
        [self.contentView addSubview:label];
        
        UIImageView *locationImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"location.png"]];
        locationImageView.contentMode = UIViewContentModeCenter;
        locationImageView.layer.cornerRadius = 10;
        
        [self.contentView addSubview:_locationButton];
        [self.contentView addSubview:_descriptionLabel];
        [self.contentView addSubview:_nameLabel];
        [self.contentView addSubview:locationImageView];
        [self.contentView addSubview:label];
        
        
        [_locationButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(locationImageView.mas_right).offset(10);
            make.centerY.equalTo(locationImageView);
            make.right.equalTo(self.contentView).offset(-10);
            make.height.equalTo(@30);
        }];
        
        
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(10);
            make.left.equalTo(self.contentView).offset(15);
            make.height.equalTo(@30);
        }];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
           make.left.equalTo(_nameLabel);
            make.top.equalTo(_nameLabel.mas_bottom).offset(15);
            make.height.equalTo(@30);
        }];
        
        [_descriptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(label.mas_bottom).offset(10);
            make.left.equalTo(label.mas_left);
            make.right.equalTo(self.contentView).offset(-10);
            make.bottom.equalTo(self.contentView).offset(-40);
        }];
        
        [locationImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
            make.left.equalTo(self.contentView).offset(15);
            make.width.equalTo(@20);
            make.height.equalTo(@20);
        }];
        

    }
    return self;
}

- (void)configureWithModel:(BJCountryModel *)model {
    [_locationButton setTitle: [NSString stringWithFormat:@"位置：%@", model.location] forState:UIControlStateNormal];
    _descriptionLabel.text = model.countryDescription;
    _nameLabel.text = model.name;
}

-(void)navigationStart:(UIButton *)sender {
    
}
@end
