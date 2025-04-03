//
//  BJMyPageDraftModel.mm
//  BJ博鉴乡兴通
//
//  Created by nanxun on 2025/4/3.
//

#import "BJMyPageDraftModel+WCTTableCoding.h"
#import "BJMyPageDraftModel.h"
#import <WCDB/WCDBObjc.h>

@implementation BJMyPageDraftModel


WCDB_IMPLEMENTATION(BJMyPageDraftModel)
WCDB_SYNTHESIZE(titleString)
WCDB_SYNTHESIZE(contentString)
WCDB_SYNTHESIZE(email)
WCDB_SYNTHESIZE(noteId)
WCDB_SYNTHESIZE(images)
WCDB_PRIMARY_AUTO_INCREMENT(noteId)
//WCDB_SYNTHESIZE_COLUMN(<#property5#>, "<#column name#>")   // Custom column name
//

//
//WCDB_INDEX(<#_index_subfix#>, <#property#>)
- (NSString *)tableName {
    return @"BJMyPageDraftModel";
}
- (NSString *)primaryKey {
    return @"noteId";
}

@end
