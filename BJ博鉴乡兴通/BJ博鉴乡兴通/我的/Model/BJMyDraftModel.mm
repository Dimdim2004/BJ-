//
//  BJMyDraftModel.m
//  BJ博鉴乡兴通
//
//  Created by nanxun on 2025/3/22.
//

#import "BJMyDraftModel.h"
#import "WCDB/WCDBObjc.h"

@interface BJMyDraftModel (WCTTableCoding) 
WCDB_PROPERTY(titleString)
WCDB_PROPERTY(contentString)
WCDB_PROPERTY(noteId)
WCDB_PROPERTY(email)

@end
@implementation BJMyDraftModel

WCDB_IMPLEMENTATION(BJMyDraftModel)
WCDB_PRIMARY_ASC_AUTO_INCREMENT(noteId)
WCDB_SYNTHESIZE(titleString)
WCDB_SYNTHESIZE(contentString)
WCDB_SYNTHESIZE(noteId)
WCDB_SYNTHESIZE(email)
- (NSString *)tableName {
    return @"BJMyDraftModel";
}
- (NSString *)primaryKey {
    return @"noteId";
}
@end


