//
//  BJUploadCommentModel.m
//  BJ博鉴乡兴通
//
//  Created by nanxun on 2025/3/25.
//

#import "BJUploadCommentModel.h"

@implementation BJUploadCommentModel
+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper {
    return @{@"commentId":@"data.comment_id"};
}
@end
