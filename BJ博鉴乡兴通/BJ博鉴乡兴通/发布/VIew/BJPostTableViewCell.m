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
        self.titleView.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        self.titleView.leftViewMode = UITextFieldViewModeAlways;
        self.titleView.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 16, 0)];
        [self.contentView addSubview:self.titleView];
        [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.top.left.equalTo(self.contentView);
        }];
    } else if ([reuseIdentifier isEqualToString:@"content"]) {
        self.contentTextView = [[UITextView alloc] init];
        self.contentTextView.font = [UIFont systemFontOfSize:18];
        self.contentTextView.textContainerInset = UIEdgeInsetsMake(16, 16, 0, 16);
        self.contentTextView.backgroundColor = UIColor.clearColor;
        
        self.contentTextView.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:self.contentTextView];
        [self.contentTextView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.top.left.equalTo(self.contentView);
        }];
    } else if ([reuseIdentifier isEqualToString:@"image"]){
        self.buttonScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(10, 15, 393, 100)];
        self.buttonScrollView.contentSize = CGSizeMake(393 * 2, 0);
        self.buttonScrollView.showsVerticalScrollIndicator = NO;
        self.buttonScrollView.showsHorizontalScrollIndicator = NO;
        self.buttonScrollView.scrollEnabled = NO;
        self.btn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.btn.layer.borderWidth = 1;
        self.btn.layer.borderColor = UIColor.lightGrayColor.CGColor;
        self.btn.layer.masksToBounds = YES;
        self.btn.layer.cornerRadius = 10;
        [self.contentView addSubview:self.buttonScrollView];
        [self.buttonScrollView addSubview:self.btn];
        [self.btn setImage:[UIImage imageNamed:@"tianjia-2.png"] forState:UIControlStateNormal];
        self.btn.frame = CGRectMake(10, 5, 90, 90);
    }
    return self;
}
- (void)addPhotosAry:(NSArray<UIImage*>*)imageAry {
    if ([imageAry isEqualToArray:@[]]) {
        return;
    }
    NSArray* buttonAry = [self.buttonScrollView.subviews copy];
    for (UIView* subView in buttonAry) {
        if ([[subView class] isEqual: [UIButton class]] || [[subView class] isEqual: [UIImageView class]]) {
            [subView removeFromSuperview];
        }
    }
    if (imageAry.count < 3) {
        self.buttonScrollView.scrollEnabled = NO;
    } else {
        self.buttonScrollView.scrollEnabled = YES;
    }
    [_buttonScrollView setContentOffset:CGPointMake(0, 0)];
    _buttonScrollView.contentSize = CGSizeMake(imageAry.count * 105 + 100, 100);
    for (int i = 0; i < imageAry.count; i++) {
        UIImageView* iView = [[UIImageView alloc] initWithFrame:CGRectMake( i * 105 + 10, 0, 90, 90)];
        iView.layer.masksToBounds = YES;
        iView.layer.cornerRadius = 10;
        iView.image = imageAry[i];
        
        [self.buttonScrollView addSubview:iView];
    }
    self.btn.frame = CGRectMake(imageAry.count * 105 + 10, 0, 90, 90);
    [self.buttonScrollView addSubview:self.btn];
}
@end
