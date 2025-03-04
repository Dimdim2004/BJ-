//
//  BJAnnotation.h
//  BJ博鉴乡兴通
//
//  Created by wjc on 2025/3/3.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
NS_ASSUME_NONNULL_BEGIN


typedef enum BJAnnotationType {
    BJAnnotationTypeScenery = 0,
    BJAnnotationTypeLiving = 1
} BJAnnotationType;


@interface BJAnnotation : NSObject<MKAnnotation>
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
//自定义大头针图片
@property(nonatomic,copy) NSString *icon;

+(instancetype)AnnotationWithType:(BJAnnotationType)type;
@end

NS_ASSUME_NONNULL_END
