//
//  QbixGroupsCordovaDelegate.h
//  Groups
//
//  Created by Igor on 8/4/16.
//
//

#ifndef QbixGroupsCordovaDelegate_h
#define QbixGroupsCordovaDelegate_h

typedef enum {
    SMSOperation,
    EMAILOperation
} ActionOperation;

@protocol QbixGroupsCordovaDelegate
@required
-(void) didError:(NSString*) error withType:(ActionOperation) type;
-(void) didFinishSuccessWithType:(ActionOperation) type;
@end



#endif /* QbixGroupsCordovaDelegate_h */
