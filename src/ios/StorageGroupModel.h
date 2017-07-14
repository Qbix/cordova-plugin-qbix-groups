//
//  StorageGroupModel.h
//  Groups
//
//  Created by Igor on 7/14/17.
//
//

#import <Foundation/Foundation.h>

@interface StorageGroupModel : NSObject

@property(nonatomic, strong) NSNumber *identifier;
@property(nonatomic, strong) NSString *title;
@property(nonatomic, strong) UIImage *icon;
@property(nonatomic, strong) NSArray<NSNumber*> *contactIds;

-(instancetype) initWithDictionary:(NSDictionary*) dict;
-(NSDictionary *)dictionary;

@end
