//
//  BJAnnotation.m
//  BJ博鉴乡兴通
//
//  Created by wjc on 2025/3/3.
//

#import "BJAnnotation.h"

@implementation BJAnnotation

+(instancetype)AnnotationWithType:(BJAnnotationType)type {
    BJAnnotation *annotation = [[BJAnnotation alloc] init];
    
    switch (type) {
        case BJAnnotationTypeScenery:
            annotation.icon = @"annotation.png";
            break;
        case BJAnnotationTypeLiving:
            annotation.icon = @"minsu.png";
            break;
        default:
            break;
    }
    return annotation;
}
@end
