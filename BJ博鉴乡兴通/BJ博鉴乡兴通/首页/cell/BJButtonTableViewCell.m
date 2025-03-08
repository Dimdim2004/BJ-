//
//  BJButtonTableViewCell.m
//  BJ博鉴乡兴通
//
//  Created by wjc on 2025/3/6.
//

#import "BJButtonTableViewCell.h"
#import <Masonry.h>


@implementation BJButtonTableViewCell

-(instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupViews];
    }
    return self;
}

-(void)setupViews {
    self.contentView.backgroundColor = [UIColor clearColor];

    UIView *buttonContainer = [UIView new];
    [self.contentView addSubview:buttonContainer];
    
    // 创建按钮公共配置
    void (^buttonConfig)(UIButton *) = ^(UIButton *btn) {
        
        btn.backgroundColor = [UIColor whiteColor];
        btn.layer.cornerRadius = 20; // 圆角半径
        btn.layer.masksToBounds = YES;
        btn.layer.borderWidth = 0.5;
        btn.layer.borderColor = [UIColor colorWithWhite:0.9 alpha:1].CGColor;
        
        btn.layer.shadowRadius = 5;
        btn.layer.shadowOffset =  CGSizeMake(1, 1);
        btn.layer.shadowOpacity = 0.8;
        btn.layer.shadowColor =  [UIColor grayColor].CGColor;


        btn.titleLabel.font = [UIFont fontWithName:@"Joyfonts-QinglongGB-Flash-Black" size:26];
        btn.titleLabel.numberOfLines = 2;
        [btn setTitleColor:[UIColor colorWithRed:16/255.0 green:89/255.0 blue:45/255.0 alpha:1]
                 forState:UIControlStateNormal];
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        btn.titleEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);  // 文字右移
        btn.imageEdgeInsets = UIEdgeInsetsMake(0, 10, 0, -10); // 图片左移
    };
    
    // 配置"我的家乡"按钮
    _btnToMyHometown = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btnToMyHometown setImage:[UIImage imageNamed:@"toMyHometown.png"] forState:UIControlStateNormal];
    [_btnToMyHometown setTitle:@"我的家乡" forState:UIControlStateNormal];
    buttonConfig(_btnToMyHometown);
    
    // 配置"地图导航"按钮
    _btnToMap = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btnToMap setImage:[UIImage imageNamed:@"toMap.png"] forState:UIControlStateNormal];
    [_btnToMap setTitle:@"地图导航" forState:UIControlStateNormal];
    buttonConfig(_btnToMap);
    
    [buttonContainer addSubview:_btnToMyHometown];
    [buttonContainer addSubview:_btnToMap];
    
    [buttonContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(120); // 按钮高度
        make.left.right.equalTo(self.contentView).inset(15);
        make.centerY.equalTo(self.contentView);
    }];
    
    [_btnToMyHometown mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(buttonContainer);
        make.right.equalTo(_btnToMap.mas_left).offset(-10);
        make.width.equalTo(_btnToMap);
    }];
    
    [_btnToMap mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.equalTo(buttonContainer);
    }];
    

    [_btnToMyHometown addTarget:self action:@selector(buttonTouchDown:)
               forControlEvents:UIControlEventTouchDown];
    [_btnToMyHometown addTarget:self action:@selector(buttonTouchUp:)
               forControlEvents:UIControlEventTouchUpOutside|UIControlEventTouchUpInside];
    [_btnToMap addTarget:self action:@selector(buttonTouchDown:)
       forControlEvents:UIControlEventTouchDown];
    [_btnToMap addTarget:self action:@selector(buttonTouchUp:)
       forControlEvents:UIControlEventTouchUpOutside|UIControlEventTouchUpInside];
}

// 按钮点击动画（增强质感）
- (void)buttonTouchDown:(UIButton *)btn {
    [UIView animateWithDuration:0.1 animations:^{
        btn.alpha = 0.8;
        btn.transform = CGAffineTransformMakeScale(0.98, 0.98);
    }];
}

- (void)buttonTouchUp:(UIButton *)btn {
    [UIView animateWithDuration:0.2 animations:^{
        btn.alpha = 1;
        btn.transform = CGAffineTransformIdentity;
    }];
}

@end
