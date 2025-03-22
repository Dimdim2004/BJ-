//
//  BJCommityModel.m
//  BJ博鉴乡兴通
//
//  Created by nanxun on 2025/3/11.
//

#import "BJCommityModel.h"
#import "BJCommityDataModel.h"
@implementation BJCommityModel
+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{@"data":[BJCommityDataModel class]};
}
@end
