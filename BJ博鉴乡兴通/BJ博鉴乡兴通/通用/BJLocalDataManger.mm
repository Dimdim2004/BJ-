//
//  BJLocalDataManger.m
//  BJ博鉴乡兴通
//
//  Created by nanxun on 2025/3/20.
//

#import "BJLocalDataManger.h"
static id localSharedManger = nil;
#import "BJMyDraftModel.h"
#import "WCDB/WCDBObjc.h"
#import "BJUserModel.h"
#import "DatabaseProtocol.h"

@interface BJLocalDataManger()
@property (nonatomic, strong) WCTDatabase* database;
@end
@implementation BJLocalDataManger
+(instancetype) sharedManger{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        localSharedManger = [[super allocWithZone:NULL] init];
    });
    return localSharedManger;
}
- (void)quickTest {
    if (self.database.canOpen) {
        NSLog(@"可以打开数据库");
    } else {
        NSLog(@"不可以打开数据库");
    }
    if (self.database.isOpened) {
        NSLog(@"数据库正在打开");
    } else {
        NSLog(@"数据库没打开");
    }
}
- (void)closeCurrentDatabase {
    [self.database close];
}
- (void)loadDataManger:(id<DatabaseProtocol, WCTTableCoding>)object {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* string = [paths firstObject];
    NSString* path = [string stringByAppendingPathComponent:[object tableName]];
    NSLog(@"%@", path);
    self.database = [[WCTDatabase alloc] initWithPath:path];
    [self creatTable:object];
}
- (BOOL)creatTable:(id<DatabaseProtocol, WCTTableCoding>)object {
    NSString* string = [object tableName];
    NSLog(@"%@", string);
    NSLog(@"%@", object.class);
    if (![self.database tableExists:string]) {
        BOOL ret = [self.database createTable:string withClass:object.class];
        if (ret) {
            NSLog(@"第一次创建表成功");
        } else {
            NSLog(@"第一次创建数据库失败");
        }
        return ret;
    } else {
        return YES;
    }
    
}

- (BOOL)insert:(NSObject<DatabaseProtocol, WCTTableCoding>*)object {
    NSString* string = [object tableName];
    BOOL ret = [self.database insertObject:object intoTable:string];
    if (ret) {
        NSLog(@"插入成功");
    } else {
        NSLog(@"插入失败");
    }
    return ret;
}
- (BOOL)deleteData:(NSObject<DatabaseProtocol, WCTTableCoding>*)object {
    NSLog(@"%@", [object primaryKey]);
    BOOL ret = [self.database deleteFromTable:[object tableName] where:[object primaryKey]];
    if (ret) {
        NSLog(@"删除成功");
    }
    return ret;
}
- (BOOL)update:(NSObject<DatabaseProtocol, WCTTableCoding>*)object onProperties:(const WCTProperties&)properties {
    BOOL ret = [self.database updateTable:[object tableName] setProperties:properties toObject:object];
    if (ret) {
        NSLog(@"更新成功");
    }
    return ret;
}
- (NSArray*)search:(NSObject<DatabaseProtocol, WCTTableCoding>*)object {
    NSArray* array = [self.database getObjectsOfClass:[object class] fromTable:[object tableName]];
    return array;
}
@end
