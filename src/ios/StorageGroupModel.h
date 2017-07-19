//
//  StorageGroupModel.h
//  Groups
//
//  Created by Igor on 7/14/17.
//
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, StorageSortMethod) {
    StorageSortMethodDefault,
    StorageSortMethodByFirst,
    StorageSortMethodByLast,
    StorageSortMethodByCompany,
    StorageSortMethodByRecentAdd
};


@interface StorageGroupModel : NSObject

@property(nonatomic, strong) NSString *identifier;
@property(nonatomic, strong) NSString *title;
@property(nonatomic, strong) UIImage *icon;
@property(nonatomic, strong) NSArray<NSNumber*> *contactIds;
@property(nonatomic, assign) StorageSortMethod sortMethod;

-(instancetype) initWithDictionary:(NSDictionary*) dict;
-(NSDictionary *)dictionary;

@end
