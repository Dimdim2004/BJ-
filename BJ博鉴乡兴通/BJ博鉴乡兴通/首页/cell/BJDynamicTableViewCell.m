//
//  BJDynamicTableViewCell.m
//  BJ博鉴乡兴通
//
//  Created by wjc on 2025/3/11.
//

#import "BJDynamicTableViewCell.h"
#import "BJDynamicModel.h"
#import <Masonry.h>
#import <SDWebImage.h>


@interface BJDynamicTableViewCell ()
@property (strong, nonatomic) UIImageView *avatarImageView;
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UILabel *timeLabel;
@property (strong, nonatomic) UILabel *contentLabel;
@property (strong, nonatomic) UIView *imageContainer;
@property (strong, nonatomic) UIButton *likeButton;
@property (strong, nonatomic) UIButton *commentButton;
@property (strong, nonatomic) UIButton *shareButton;
@property (strong, nonatomic) UIView *interactionView;
@property (strong, nonatomic) UIView *lineView;
@property (assign, nonatomic) BOOL isLoad;
@end

@implementation BJDynamicTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupUI];
        self.isLoad = NO;
        self.backgroundColor = [UIColor whiteColor];
        [self setupConstraints];
    }
    return self;
}

- (void)setupUI {
    // 头像
    _avatarImageView = [UIImageView new];
    _avatarImageView.contentMode = UIViewContentModeScaleAspectFill;
    _avatarImageView.layer.cornerRadius = 5;
    _avatarImageView.clipsToBounds = YES;
    [self.contentView addSubview:_avatarImageView];
    
    // 用户名
    _nameLabel = [UILabel new];
    _nameLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightSemibold];
    _nameLabel.textColor = [UIColor darkTextColor];
    [self.contentView addSubview:_nameLabel];
    
    // 时间
    _timeLabel = [UILabel new];
    _timeLabel.font = [UIFont systemFontOfSize:12];
    _timeLabel.textColor = [UIColor grayColor];
    [self.contentView addSubview:_timeLabel];
    
    // 正文
    _contentLabel = [UILabel new];
    _contentLabel.font = [UIFont systemFontOfSize:15];
    _contentLabel.textColor = [UIColor darkTextColor];
    _contentLabel.numberOfLines = 0;
    [self.contentView addSubview:_contentLabel];
    
    _imageContainer = [UIView new];
    [self.contentView addSubview:_imageContainer];
    
    _interactionView = [UIView new];
    _interactionView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:_interactionView];
    
    _likeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_likeButton setImage:[UIImage imageNamed:@"likes.png"] forState:UIControlStateNormal];
    [_likeButton setImage:[UIImage imageNamed:@"likes_selected.png"] forState:UIControlStateSelected];
    [_likeButton addTarget:self action:@selector(likeButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    [_likeButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    _likeButton.titleLabel.font = [UIFont systemFontOfSize:12];

    
    _commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_commentButton setImage:[UIImage imageNamed:@"comment.png"] forState:UIControlStateNormal];
    [_commentButton addTarget:self action:@selector(commentButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    _commentButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
    _commentButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [_commentButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];

    _shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_shareButton setImage:[UIImage imageNamed:@"share.png"] forState:UIControlStateNormal];
    [_shareButton addTarget:self action:@selector(shareButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    _shareButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 7);
    _shareButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 15);
    [_shareButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    _shareButton.titleLabel.font = [UIFont systemFontOfSize:12];

    
    [_interactionView addSubview:_likeButton];
    [_interactionView addSubview:_commentButton];
    [_interactionView addSubview:_shareButton];
}

- (void)setupConstraints {
    [_avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.contentView).offset(15);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_avatarImageView);
        make.left.equalTo(_avatarImageView.mas_right).offset(10);
        make.right.lessThanOrEqualTo(self.contentView).offset(-15);
    }];
    
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_avatarImageView);
        make.left.equalTo(_nameLabel);
    }];
    
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_avatarImageView.mas_bottom).offset(10);
        make.left.equalTo(_nameLabel);
        make.right.equalTo(self.contentView).offset(-25);
        make.bottom.equalTo(_imageContainer.mas_top).offset(-25);

    }];
    
    [_imageContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_contentLabel.mas_bottom).offset(25);
        make.left.equalTo(_nameLabel);
        make.right.lessThanOrEqualTo(self.contentView).offset(-15);
    }];
    
    [_interactionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_imageContainer.mas_bottom).offset(10);
        make.left.right.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView);
        make.height.mas_equalTo(30);
    }];
    
    NSArray *buttons = @[_likeButton, _commentButton, _shareButton];
    [buttons mas_distributeViewsAlongAxis:MASAxisTypeHorizontal
                       withFixedSpacing:0
                            leadSpacing:0
                            tailSpacing:0];
    [buttons mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(_interactionView);
        make.width.equalTo(_interactionView.mas_width).dividedBy(3);
    }];
}

#pragma mark - Public Methods
- (void)configureWithModel:(BJDynamicModel *)model {
    // 配置头像
    [_avatarImageView sd_setImageWithURL:[NSURL URLWithString:model.avatarUrl]
                        placeholderImage:[UIImage imageNamed:@"default_avatar"]];
    
    _nameLabel.text = model.userName;
    _timeLabel.text = model.timeText;
    _contentLabel.text = model.content;
    _likeButton.selected = model.isLiked;
    [_likeButton setTitle:model.numofLikes forState:UIControlStateNormal];
    NSInteger likes = [model.numofLikes integerValue];
    [_likeButton setTitle:[NSString stringWithFormat:@"%ld",likes + 1] forState:UIControlStateSelected];
    
    [_commentButton setTitle:model.numofComment forState:UIControlStateNormal];
    [_shareButton setTitle:model.numofShare forState:UIControlStateNormal];
    if(!self.isLoad) {
        [self setupImages:model.images];
        self.isLoad = YES;

    }
    

}

#pragma mark - Private Methods
- (void)setupImages:(NSArray *)images {
    [_imageContainer.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    CGFloat itemSize = [self imageItemSizeForCount:images.count];
    CGFloat spacing = 5;
    
    for (NSInteger i = 0; i < images.count; i++) {
        UIImageView *imageView = [UIImageView new];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        imageView.userInteractionEnabled = YES;
        imageView.tag = i + 1000;
        [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc]
                                        initWithTarget:self
                                        action:@selector(imageTapped:)]];
        [_imageContainer addSubview:imageView];
        
        imageView.image = [UIImage imageNamed:images[i]];
//        [imageView sd_setImageWithURL:[NSURL URLWithString:images[i]]
//                     placeholderImage:[UIImage imageNamed:@"image_placeholder"]];
        
        // 计算布局
        NSInteger row = i / 3;
        NSInteger col = i % 3;
        
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(itemSize, itemSize));
            make.left.equalTo(_imageContainer).offset(col * (itemSize + spacing));
            make.top.equalTo(_imageContainer).offset(row * (itemSize + spacing));
            if (i == images.count - 1) {
                make.bottom.equalTo(_imageContainer);
            }
        }];
    }
}

- (CGFloat)imageItemSizeForCount:(NSInteger)count {
    if (count == 0) return 0;
    if (count == 1) return 150; // 大图尺寸
    CGFloat containerWidth = CGRectGetWidth(self.contentView.frame) - 70; // 根据实际布局计算
    return (containerWidth - 2 * 5) / 3; // 3列布局
}

- (void)setupInteractionWithLikes:(NSArray *)likes {
    [_interactionView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    // 添加点赞
    __block UIView *lastView = nil;
    if (likes.count > 0) {
        UILabel *likeLabel = [UILabel new];
        likeLabel.font = [UIFont systemFontOfSize:14];
        likeLabel.textColor = [UIColor darkGrayColor];
        likeLabel.attributedText = [self formattedLikesText:likes];
        [_interactionView addSubview:likeLabel];
        
        [likeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.equalTo(_interactionView).offset(8);
            make.right.equalTo(_interactionView).offset(-8);
        }];
        lastView = likeLabel;
    }
}

- (NSAttributedString *)formattedLikesText:(NSArray *)likes {
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:@"❤️ "];
    for (NSString *name in likes) {
        NSAttributedString *nameStr = [[NSAttributedString alloc]
                                      initWithString:[NSString stringWithFormat:@"%@ ", name]
                                      attributes:@{NSForegroundColorAttributeName: [UIColor blueColor]}];
        [text appendAttributedString:nameStr];
    }
    return text;
}
#pragma mark - Actions
- (void)likeButtonClicked {
    _likeButton.selected = !_likeButton.selected;
//    if ([self.delegate respondsToSelector:@selector(didTapLikeButtonOnCell:)]) {
//        [self.delegate didTapLikeButtonOnCell:self];
//    }
}

- (void)commentButtonClicked {
//    if ([self.delegate respondsToSelector:@selector(didTapCommentButtonOnCell:)]) {
//        [self.delegate didTapCommentButtonOnCell:self];
//    }
}

- (void)imageTapped:(UITapGestureRecognizer *)gesture {
    if ([self.delegate respondsToSelector:@selector(didTapImageAtIndex:onCell:)]) {
        [self.delegate didTapImageAtIndex:gesture.view.tag onCell:self];
    }
}

- (void)shareButtonClicked {
//    if ([self.delegate respondsToSelector:@selector(didTapShareButtonOnCell:)]) {
//        [self.delegate didTapShareButtonOnCell:self];
//    }
}

#pragma mark - Height Calculation
+ (CGFloat)cellHeightForModel:(BJDynamicModel *)model tableViewWidth:(CGFloat)width {
    static BJDynamicTableViewCell *dummyCell;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dummyCell = [[BJDynamicTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"dummy"];
    });
    
    [dummyCell configureWithModel:model];
    
    [dummyCell setNeedsLayout];
    [dummyCell layoutIfNeeded];
    
    CGFloat height = [dummyCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    return MAX(height, 100); // 最小高度
}

@end
