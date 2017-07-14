//
//  QbixGroupsRepository.h
//  Groups
//
//  Created by Igor on 7/14/17.
//
//

#import <Foundation/Foundation.h>
#import "StorageGroupModel.h"

@interface QbixGroupsRepository : NSObject
+ (instancetype) instance;

-(void) saveLatestGroups:(NSArray<StorageGroupModel*> *) savedGroups;
-(NSArray<StorageGroupModel*>*) readStorageGroups;
-(void) saveLatestGroups:(NSArray<StorageGroupModel*> *) savedGroups withCallback:(void (^)(BOOL)) callabck;

@end
