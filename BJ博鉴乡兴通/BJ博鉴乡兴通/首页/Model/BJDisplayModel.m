//
//  BJDisplayModel.m
//  BJ博鉴乡兴通
//
//  Created by wjc on 2025/3/14.
//

#import "BJDisplayModel.h"
#import <SDWebImage.h>
@implementation BJDisplayModel

- (instancetype)initWithName:(NSString *)name distance:(NSString *)distance imageUrl:(NSString *)urlString {
    self = [super init];
    if (self) {
        _name = [name copy];
        _distance = distance;
        _urlString = urlString;
    }
    return self;
}

- (void)loadImageWithCompletion:(void (^)(UIImage * _Nullable))completion {
    if (!self.urlString) {
        if (completion) completion(nil);
        return;
    }
    
    NSURL *url = [NSURL URLWithString:self.urlString];
    if (!url) {
        if (completion) completion(nil);
        return;
    }
    
    [[SDWebImageManager sharedManager] loadImageWithURL:url options:SDWebImageRetryFailed progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
            if (image) {
                self.image = image;
            } else {
                NSLog(@"加载不成功");
            }
            if (completion) {
                completion(image);
            }
    }];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"name: %@, distance: %@, urlString: %@", self.name, self.distance, self.urlString];
}
@end
