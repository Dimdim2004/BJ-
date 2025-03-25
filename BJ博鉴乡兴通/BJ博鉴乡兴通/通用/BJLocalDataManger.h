//
//  BJLocalDataManger.h
//  BJ博鉴乡兴通
//
//  Created by nanxun on 2025/3/20.
//

#import <Foundation/Foundation.h>
@protocol DatabaseProtocol;
@protocol WCTTableCoding;

NS_ASSUME_NONNULL_BEGIN

@interface BJLocalDataManger : NSObject
- (void)quickTest;
+ (instancetype)sharedManger;
- (void)loadDataManger:(id<DatabaseProtocol, WCTTableCoding>)object;
- (BOOL)insert:(NSObject<DatabaseProtocol, WCTTableCoding>*)object;
- (BOOL)deleteData:(NSObject<DatabaseProtocol, WCTTableCoding>*)object;
//- (BOOL)update:(NSObject<DatabaseProtocol, WCTTableCoding>*)object onProperties:(const WCTProperties&)properties;
- (NSArray*)search:(NSObject<DatabaseProtocol, WCTTableCoding>*)object;
- (void)closeCurrentDatabase;
@end

NS_ASSUME_NONNULL_END
