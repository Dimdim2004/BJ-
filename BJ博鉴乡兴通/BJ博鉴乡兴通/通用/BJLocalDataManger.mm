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
#import "BJMymagesInDraftModel.h"
#import "BJUserModel.h"
#import "DatabaseProtocol.h"
#import "BJMyPageDraftModel+WCTTableCoding.h"
#import "BJMyPageDraftModel.h"
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
            NSLog(@"第一次创建表失败");
        }
        return ret;
    } else {
        return YES;
    }
    
}

- (BOOL)insert:(NSObject<DatabaseProtocol, WCTTableCoding>*)object {
    NSString* string = [object tableName];
    NSLog(@"当前插入的一个表%@", string);
    BOOL ret = [self.database insertObject:object intoTable:string];
    if (ret) {
        NSLog(@"插入成功");
    } else {
        NSLog(@"插入失败");
    }
    return ret;
}
- (BOOL)deleteData:(NSObject<DatabaseProtocol, WCTTableCoding>*)object withPrimaryKey:(NSInteger) keyValue {
    NSLog(@"%@", [object primaryKey]);
    NSLog(@"%@", [object tableName]);
    BOOL ret = 1;
    

    if (ret) {
        NSLog(@"删除成功");
    } else {
        NSLog(@"删除失败");
    }
    return ret;
}
- (BOOL)deleteDarftData:(BJMyPageDraftModel*)draftModel withKeyValue:(NSInteger)keyValue {
    BOOL ret = [self.database deleteFromTable:[draftModel tableName] where:BJMyPageDraftModel.noteId == keyValue];
    if (ret) {
        NSLog(@"删除成功");
    } else {
        NSLog(@"删除失败");
    }
    return ret;
}
- (BOOL)updateDraft:(BJMyPageDraftModel*)draftModel withKeyValue:(NSInteger)keyValue {
    BOOL ret = [self.database updateTable:[draftModel tableName] setProperties:BJMyPageDraftModel.allProperties toObject:draftModel where:BJMyPageDraftModel.noteId == keyValue];
    if (ret) {
        NSLog(@"更新成功");
    } else {
        NSLog(@"更新失败");
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
- (NSArray*)search:(BJMyPageDraftModel*)object WithEmail:(NSString*)email {
    NSArray* array = [self.database getObjectsOfClass:[object class] fromTable:[object tableName] where:BJMyPageDraftModel.email == email];
    return array;
}
@end
