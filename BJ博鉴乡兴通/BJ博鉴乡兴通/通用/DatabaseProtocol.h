//
//  DatabaseProtocol.h
//  BJ博鉴乡兴通
//
//  Created by nanxun on 2025/3/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol DatabaseProtocol <NSObject>
- (NSString*)tableName;
- (NSString*)primaryKey;
@end

NS_ASSUME_NONNULL_END
