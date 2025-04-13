//
//  BJInvitationHeaderTableViewCell.m
//  BJ博鉴乡兴通
//
//  Created by nanxun on 2025/2/6.
//

#import "BJInvitationHeaderTableViewCell.h"
#import "BJInvitationTopContentView.h"
#import "SDWebImage/SDWebImage.h"
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
        self.headScrollerView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 393, 393)];
        self.headScrollerView.bounces = NO;
        self.headScrollerView.contentSize = CGSizeMake(393, 0);
        self.headScrollerView.showsHorizontalScrollIndicator = NO;
        self.headScrollerView.showsVerticalScrollIndicator = NO;
        self.contentLabel.textColor = UIColor.blackColor;
        self.titleLabel.textColor = UIColor.blackColor;
        
        self.contentLabel.font = [UIFont systemFontOfSize:16];
        self.titleLabel.numberOfLines = 2;
        self.contentLabel.numberOfLines = 0;
        self.titleLabel.font = [UIFont boldSystemFontOfSize:23];
        self.mypage = [[UIPageControl alloc] init];
        self.mypage.userInteractionEnabled = NO;
        self.mypage.tintColor = UIColor.blackColor;
        self.mypage.pageIndicatorTintColor = UIColor.lightGrayColor;
        self.mypage.numberOfPages = 3;
        self.headScrollerView.pagingEnabled = YES;
        self.headScrollerView.tag = 100;
        [self.contentView addSubview:_headScrollerView];
        [self.contentView addSubview:_titleLabel];
        [self.contentView addSubview:_contentLabel];
        [self.contentView addSubview:_mypage];
        [_mypage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView);
            make.width.equalTo(@200);
            make.height.equalTo(@30);
            make.bottom.equalTo(self.headScrollerView).offset(-5);
        }];
        [self.headScrollerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView);
            make.left.equalTo(self.contentView);
            make.right.equalTo(self.contentView);
            make.height.equalTo(@(363));
        }];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(10);
            make.right.equalTo(self.contentView).offset(10);
            make.top.equalTo(self.headScrollerView.mas_bottom).offset(-10);
            make.height.equalTo(@80);
        }];
        [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLabel.mas_bottom);
            make.left.equalTo(self.contentView).offset(10);
            make.right.equalTo(self.contentView).offset(-10);
            make.bottom.equalTo(self.contentView).offset(-10);
        }];
    }
    return self;
}
- (void)addImageToScrollerView:(NSArray<UIImage*>*)imageAry {

    if ([imageAry isEqualToArray:@[]]) {
        
        return;
    }
    self.mypage.currentPage = 0;
    self.mypage.numberOfPages = imageAry.count;
    
    NSArray* buttonAry = [self.headScrollerView.subviews copy];
    for (UIView* subView in buttonAry) {
        if ([[subView class] isEqual: [UIButton class]] || [[subView class] isEqual: [UIImageView class]]) {
            [subView removeFromSuperview];
        }
    }
    self.headScrollerView.contentSize = CGSizeMake(393 * imageAry.count, 0);
    for (int i = 0; i < imageAry.count; i++) {
        UIImageView* iView = [[UIImageView alloc] initWithFrame:CGRectMake(i * 393, 0, 393, 393)];
        
        iView.layer.masksToBounds = YES;
        iView.layer.cornerRadius = 10;
        iView.image = imageAry[i];
        [self.headScrollerView addSubview:iView];
        
    }
}
- (void)addUrlImageToScrollerView:(NSArray<NSString *> *)imageAry {
    if (imageAry.count == 0) return;

    self.mypage.currentPage = 0;
    self.mypage.numberOfPages = imageAry.count;

    // 清除旧视图
    for (UIView *subView in [self.headScrollerView.subviews copy]) {
        if ([subView isKindOfClass:[UIImageView class]]) {
            [subView removeFromSuperview];
        }
    }

    CGFloat viewWidth = 393;
    CGFloat defaultHeight = 393;
    __block CGFloat maxImageHeight = defaultHeight;

    self.headScrollerView.contentSize = CGSizeMake(viewWidth * imageAry.count, 0);

    __weak typeof(self) weakSelf = self;

    for (int i = 0; i < imageAry.count; i++) {
        NSString *urlString = imageAry[i];
        CGRect initialFrame = CGRectMake(i * viewWidth, 0, viewWidth, defaultHeight);
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:initialFrame];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.backgroundColor = UIColor.lightGrayColor;
        [self.headScrollerView addSubview:imageView];

        __weak typeof(imageView) weakImageView = imageView;

        [imageView sd_setImageWithURL:[NSURL URLWithString:urlString]
                     completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            if (image) {
                CGFloat imageHeight = image.size.height * viewWidth / image.size.width;

                dispatch_async(dispatch_get_main_queue(), ^{
                    // 更新最大高度
                    if (imageHeight > maxImageHeight) {
                        maxImageHeight = imageHeight;

                        // 更新 scrollView 高度约束
                        __strong typeof(weakSelf) strongSelf = weakSelf;
                        [strongSelf.headScrollerView mas_updateConstraints:^(MASConstraintMaker *make) {
                            make.height.mas_equalTo(maxImageHeight);
                        }];

                        // 更新 scrollView contentSize
                        strongSelf.headScrollerView.contentSize = CGSizeMake(viewWidth * imageAry.count, 0);
                    }

                    // 垂直居中显示
                    CGFloat yOffset = imageHeight < maxImageHeight ? (maxImageHeight - imageHeight) / 2.0 : 0;
                    weakImageView.frame = CGRectMake(i * viewWidth, yOffset, viewWidth, imageHeight);
                });
            }
        }];
    }
}


@end
