//
//  BJMymagesInDraftModel.m
//  BJ博鉴乡兴通
//
//  Created by nanxun on 2025/3/22.
//

#import "BJMymagesInDraftModel.h"
#import "WCDB/WCDBObjc.h"
@interface BJMymagesInDraftModel(WCDB)<WCTTableCoding>
WCDB_PROPERTY(noteId)
WCDB_PROPERTY(imageId)
WCDB_PROPERTY(imageFilePath)
@end
@implementation BJMymagesInDraftModel
WCDB_IMPLEMENTATION(BJMymagesInDraftModel)
WCDB_PRIMARY_ASC_AUTO_INCREMENT(imageId)
WCDB_SYNTHESIZE(imageFilePath)
WCDB_SYNTHESIZE(noteId)
WCDB_SYNTHESIZE(imageId)
- (NSString *)tableName {
    return @"BJMymagesInDraftModel";
}
- (NSString *)primaryKey {
    return @"imageId";
}
@end
