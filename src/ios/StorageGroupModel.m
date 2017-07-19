//
//  StorageGroupModel.m
//  Groups
//
//  Created by Igor on 7/14/17.
//
//

#import "StorageGroupModel.h"

#define ID @"id"
#define TITLE @"title"
#define ICON @"icon"
#define CONTACTIDS @"contactIds"
#define SORTMETHOD @"sortMethod"

@implementation StorageGroupModel

-(instancetype) initWithDictionary:(NSDictionary*) dict {
    if(self = [super init]) {
        [self setIdentifier:[dict objectForKey:ID]];
        [self setTitle:[dict objectForKey:TITLE]];
        
        NSString *iconBase64 = [dict objectForKey:ICON];
        if(iconBase64 != nil && ![iconBase64 isEqualToString:@""]) {
            NSData *data = [[NSData alloc]initWithBase64EncodedString:iconBase64 options:NSDataBase64DecodingIgnoreUnknownCharacters];
            [self setIcon:[UIImage imageWithData:data]];
        } else {
            [self setIcon:nil];
        }
        [self setContactIds:[dict objectForKey:CONTACTIDS]];
        [self setSortMethod:[[dict objectForKey:SORTMETHOD] integerValue]];
    }
    
    return self;
}

-(NSDictionary *)dictionary {
    return @{ID:_identifier,
             TITLE:_title,
             ICON:_icon ? [_icon base64] : @"",
             CONTACTIDS:_contactIds,
             SORTMETHOD: [NSNumber numberWithInteger:_sortMethod]};
}

@end
