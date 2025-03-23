//
//  BJDisplayView.m
//  BJ博鉴乡兴通
//
//  Created by wjc on 2025/3/14.
//

#import "BJDisplayView.h"
#import "BJDisplayModel.h"
#import <Masonry.h>
@interface BJDisplayView ()
@property (nonatomic, strong) UIImageView *hometownImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *locationLabel;
@property (nonatomic, strong) UILabel *distanceLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@end

@implementation BJDisplayView

- (instancetype)init {
    
    self = [super init];
    if(self) {
        [self setupView];
        [self setupConstraints];
        
    }
    return self;
}

-(void)updateWithModel:(BJDisplayModel *)model {

    self.nameLabel.text = model.name;
    self.locationLabel.text = model.address;
    self.distanceLabel.text = model.distance;
    if (model.image) {
        self.hometownImageView.image = model.image;
    } else {
        self.hometownImageView.image = [UIImage imageNamed:@"placeholderForAddress.png"];
    }
}

-(void)setupView {
    
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.font = [UIFont boldSystemFontOfSize:20];
    self.nameLabel.textColor = [UIColor blackColor];
    self.nameLabel.numberOfLines = 2;
    
    self.locationLabel = [[UILabel alloc] init];
    self.locationLabel.font = [UIFont systemFontOfSize:14];
    self.locationLabel.textColor = [UIColor grayColor];
    self.locationLabel.numberOfLines = 3;
    
    self.distanceLabel = [[UILabel alloc] init];
    self.distanceLabel.font = [UIFont systemFontOfSize:14];
    self.distanceLabel.textColor = [UIColor grayColor];
    self.distanceLabel.numberOfLines = 0;
    
    self.hometownImageView = [[UIImageView alloc] init];
    self.hometownImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.hometownImageView.layer.cornerRadius = 10;
    self.hometownImageView.layer.masksToBounds = YES;
    
    
    [self addSubview:self.nameLabel];
    [self addSubview:self.locationLabel];
    [self addSubview:self.distanceLabel];
    [self addSubview:self.hometownImageView];
    
    
}

-(void)setupConstraints {
    [self.hometownImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.centerY.equalTo(self);
        make.width.equalTo(@100);
        make.height.equalTo(@100);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.hometownImageView.mas_right).offset(10);
        make.right.equalTo(self).offset(-10);
        make.top.equalTo(self).offset(10);
    }];
    
    [self.locationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.hometownImageView.mas_right).offset(10);
        make.right.equalTo(self).offset(-10);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(5);
    }];
    
    [self.distanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.hometownImageView.mas_right).offset(10);
        make.top.equalTo(self.locationLabel.mas_bottom).offset(5);
        make.height.equalTo(@20);
    }];
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
