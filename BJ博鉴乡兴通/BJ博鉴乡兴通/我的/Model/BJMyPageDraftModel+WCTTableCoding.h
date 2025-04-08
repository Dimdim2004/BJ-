//
//  BJMyPageDraftModel+WCTTableCoding.h
//  BJ博鉴乡兴通
//
//  Created by nanxun on 2025/4/3.
//

#import "BJMyPageDraftModel.h"
#import <WCDB/WCDBObjc.h>

@interface BJMyPageDraftModel (WCTTableCoding) <WCTTableCoding>

WCDB_PROPERTY(titleString)
WCDB_PROPERTY(contentString)
WCDB_PROPERTY(noteId)
WCDB_PROPERTY(email)
WCDB_PROPERTY(images)
@end
