//
//  QbixGroupsRepository.m
//  Groups
//
//  Created by Igor on 7/14/17.
//
//

#import "QbixGroupsRepository.h"

@interface QbixGroupsRepository()
@property(nonatomic, strong) NSURL *path;
@property(nonatomic, strong) NSURL *tempPath;
@property(nonatomic, strong) NSOperationQueue *operationQueue;
@end

@implementation QbixGroupsRepository

+(NSURL*) getFilePath {
    NSURL *directoryAppGroupPath = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:SHARE_APP_GROUP];
    
    return [directoryAppGroupPath URLByAppendingPathComponent:@"groups.json"];
}

+(NSURL*) getTempFilePath {
    NSURL *directoryAppGroupPath = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:SHARE_APP_GROUP];
    
    return [directoryAppGroupPath URLByAppendingPathComponent:@"tempgroups.json"];
}

+ (instancetype) instance {
    static QbixGroupsRepository *inst = nil;
    if (!inst) {
        NSURL *directoryAppGroupPath = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:SHARE_APP_GROUP];
        
        //NSURL *directoryPath = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
        
        //NSURL *cachePath = [[[NSFileManager defaultManager] URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask] lastObject];
        
        inst = [[self alloc] initWithFile:[QbixGroupsRepository getFilePath] andTempFile:[QbixGroupsRepository getTempFilePath]];
    }
    return inst;
}

- (instancetype)initWithFile:(NSURL*) path andTempFile:(NSURL*) tempPath {
    if(self = [super init]) {
        _path = [path retain];
        _tempPath = [tempPath retain];
        _operationQueue = [[NSOperationQueue alloc] init];
        [_operationQueue setMaxConcurrentOperationCount:1];
    }
    return self;
}

-(void) saveLatestGroups:(NSArray<StorageGroupModel*> *) savedGroups {
    [self saveLatestGroups:savedGroups withCallback:nil];
}

-(void) saveLatestGroups:(NSArray<StorageGroupModel*> *) savedGroups withCallback:(void (^)(BOOL)) callabck {
//    NSOperation *operation = [[NSOperation alloc] init];
//    [operation setQueuePriority:NSOperationQueuePriorityHigh];
//    [operation setQualityOfService:NSQualityOfServiceBackground];
//    [operation setCompletionBlock:^{
        NSMutableArray *jsonArray = [NSMutableArray array];
        for(StorageGroupModel* model in savedGroups) {
            [jsonArray addObject:[model dictionary]];
        }
        
        NSError *writeError = nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:[jsonArray copy] options:NSJSONWritingPrettyPrinted error:&writeError];
        
        [jsonData writeToURL:_tempPath atomically:YES];
        
        if(writeError) {
            callabck(NO);
            return;
        }
        
        [[NSFileManager defaultManager] replaceItemAtURL:_path withItemAtURL:_tempPath backupItemName:@"backupGroups" options:0 resultingItemURL:nil error:&writeError];
        
        if(callabck != nil) {
            callabck(YES);
        }
//    }];
    
//    [_operationQueue addOperation:operation];
//    [_operationQueue ]
//    [_operationQueue waitUntilAllOperationsAreFinished];
}

-(NSArray<StorageGroupModel*>*) readStorageGroups {
    NSData *data = [NSData dataWithContentsOfURL:_path];
    
    NSError *error = nil;
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    
    if (error != nil) {
        return nil;
    }
    
    NSMutableArray *groups = [NSMutableArray array];
    for(NSDictionary* items in jsonArray) {
        [groups addObject:[[StorageGroupModel alloc] initWithDictionary:items]];
    }
    
    return [groups copy];
}

@end
