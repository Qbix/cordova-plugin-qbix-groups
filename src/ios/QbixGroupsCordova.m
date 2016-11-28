#import "QbixGroupsCordova.h"
#import "TrackingEmailStorage.h"

@implementation QbixGroupsCordova {
    NSString *smsCallbackId;
    NSString *emailCallbackId;
}

- (void)hello:(CDVInvokedUrlCommand*)command
{

    NSString* callbackId = [command callbackId];
    NSString* name = [[command arguments] objectAtIndex:0];
    NSString* msg = [NSString stringWithFormat: @"Hello, %@", name];

    CDVPluginResult* result = [CDVPluginResult
                               resultWithStatus:CDVCommandStatus_OK
                               messageAsString:msg];

    [self.commandDelegate sendPluginResult:result callbackId:callbackId];
}


- (void)getEmailInfo:(CDVInvokedUrlCommand*)command
{
    NSString* callbackId = [command callbackId];
    NSArray* cuids = [[command arguments] objectAtIndex:0];
    
    CDVPluginResult* result = nil;
    if(cuids != nil) {
        TrackingEmailStorage *trackingEmailStorage = [[TrackingEmailStorage alloc] init];
        NSArray* trackingEmailsDTOs = [trackingEmailStorage getTrackingEmailDTOs];
        NSMutableArray* trackingEmailsDTOsFiltered = [NSMutableArray array];
        for(int i=0; i < [cuids count]; i++) {
            for(int j=0; j < [trackingEmailsDTOs count]; j++) {
                TrackingEmailDTO *trackingEmailDTO = [trackingEmailsDTOs objectAtIndex:j];
                if([[trackingEmailDTO cuid] isEqualToString:[cuids objectAtIndex:i]])
                    [trackingEmailsDTOsFiltered addObject:trackingEmailDTO];
            }
        }
        
        result = [CDVPluginResult
                  resultWithStatus:CDVCommandStatus_OK
                  messageAsArray:[JSONModel arrayOfDictionariesFromModels:trackingEmailsDTOsFiltered]];
    } else {
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Please provide array of cuids"];
    }

    [self.commandDelegate sendPluginResult:result callbackId:callbackId];
}

-(void) sendSuccessWithCallbackId:(NSString*) callbackId {
    CDVPluginResult* result = [CDVPluginResult
                               resultWithStatus:CDVCommandStatus_OK
                               messageAsString:@""];

    [self.commandDelegate sendPluginResult:result callbackId:callbackId];
}

-(void) sendError:(NSString*) error withCallbackId:(NSString*)callbackId {
    CDVPluginResult* result = [CDVPluginResult
                               resultWithStatus:CDVCommandStatus_ERROR
                               messageAsString:@""];

    [self.commandDelegate sendPluginResult:result callbackId:callbackId];
}

-(void) didError:(NSString*) error withType:(ActionOperation) type {
    switch (type) {
        case SMSOperation:
            if(smsCallbackId != nil) {
                [self sendError:error withCallbackId:smsCallbackId];
            }
            break;
        case EMAILOperation:
            if(emailCallbackId != nil) {
                [self sendError:error withCallbackId:emailCallbackId];
            }
            break;
        default:
            break;
    }
}
-(void) didFinishSuccessWithType:(ActionOperation) type {
    switch (type) {
        case SMSOperation:
            if(smsCallbackId != nil) {
                [self sendSuccessWithCallbackId:smsCallbackId];
            }
            break;
        case EMAILOperation:
            if(emailCallbackId != nil) {
                [self sendSuccessWithCallbackId:emailCallbackId];
            }
            break;
        default:
            break;
    }

}

- (void) sendSms:(CDVInvokedUrlCommand*)command {
    smsCallbackId = [command.callbackId copy];
    NSArray* recipients = [[command arguments] objectAtIndex:0];
    NSString* body = [[command arguments] objectAtIndex:1];
    //NSInteger batch = [[[command arguments] objectAtIndex:2] integerValue];

    SmsOperationController *smsOperationController = [[SmsOperationController alloc] init];
    if(![smsOperationController isAvailable]) {
        [self sendError:@"Device not configured to sent sms" withCallbackId:command.callbackId];
        return;
    }
    [smsOperationController setDelegateCordova:self];
    [smsOperationController setRecipientsAsPhoneArray:recipients];
    [smsOperationController setText:body];
    [smsOperationController setBatch:[recipients count]];
    [smsOperationController setIsDirect:YES];
    [smsOperationController showComposeSmsController];
}

- (void) sendEmail:(CDVInvokedUrlCommand*)command {
    emailCallbackId = [command.callbackId copy];
    NSArray* recipients = [[command arguments] objectAtIndex:0];
    NSString* subject = [[command arguments] objectAtIndex:1];
    NSString* body = [[command arguments] objectAtIndex:2];

    EmailOperationController *emailOperationController = [[EmailOperationController alloc] init];
    if(![emailOperationController isAvailable]) {
        [self sendError:@"Device not configured to sent mail" withCallbackId:command.callbackId];
        return;
    }
    [emailOperationController setDelegateCordova:self];
    [emailOperationController setRecipients:recipients];
    [emailOperationController setSubject:subject];
    [emailOperationController setText:body];
    [emailOperationController showComposeEmail];
}

- (void) setList:(CDVInvokedUrlCommand*)command {
	NSArray* sectionItems = [[command arguments] objectAtIndex:0];

	NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
   [dict setValue:sectionItems forKey:@"sections"];

	[[NSNotificationCenter defaultCenter] postNotificationName:@"cordovaSetList" object:nil userInfo:dict];
	[self sendSuccessWithCallbackId:command.callbackId];
}

- (void) setActions:(CDVInvokedUrlCommand*)command {
	NSArray* sectionItems = [[command arguments] objectAtIndex:0];

	NSDictionary* dict = [[NSDictionary alloc] init];
  [dict setValue:sectionItems forKey:@"items"];

  [[NSNotificationCenter defaultCenter] postNotificationName:@"cordovaSetActions" object:nil userInfo:dict];
	[self sendSuccessWithCallbackId:command.callbackId];
}

- (void)hideFullscreen:(CDVInvokedUrlCommand*)command
{
    NSString *height = @"62";
    @try {
        height = [[command arguments] objectAtIndex:0];
    } @catch(NSException *e) {};

    NSDictionary* dict = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:[height intValue]] forKey:@"height"];

    [[NSNotificationCenter defaultCenter] postNotificationName:@"cordovaHideFullscreen" object:nil userInfo:dict];

    [self sendSuccessWithCallbackId:command.callbackId];
}

- (void)showFullscreen:(CDVInvokedUrlCommand*)command
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"cordovaShowFullscreen" object:nil];

    [self sendSuccessWithCallbackId:command.callbackId];
}

- (void)showOptions:(CDVInvokedUrlCommand*)command
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"cordovaShowOptions" object:nil];

    [self sendSuccessWithCallbackId:command.callbackId];
}

- (void)showEnhance:(CDVInvokedUrlCommand*)command
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"cordovaShowEnhance" object:nil];

    [self sendSuccessWithCallbackId:command.callbackId];
}

- (void)showSupport:(CDVInvokedUrlCommand*)command
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"cordovaShowSupport" object:nil];

    [self sendSuccessWithCallbackId:command.callbackId];
}

- (void)showEdit:(CDVInvokedUrlCommand*)command
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"cordovaShowEdit" object:nil];

    [self sendSuccessWithCallbackId:command.callbackId];
}

-(void)deleteStickyAds:(CDVInvokedUrlCommand *)command
{
    NSDictionary* dict = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:YES] forKey:@"removeAdsData"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"cordovaDeleteStickyAds" object:dict];

    [self sendSuccessWithCallbackId:command.callbackId];
}

//-(void)cordovaShowNotificationEnable:(CDVInvokedUrlCommand *)command
//{
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"cordovaShowNotificationEnable" object:nil];
//
//    CDVPluginResult* result = [CDVPluginResult
//                               resultWithStatus:CDVCommandStatus_OK
//                               messageAsString:@"true"];
//
//    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
//}

-(void) closeModalWebView:(CDVInvokedUrlCommand *)command {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"cordovaCloseModalWebView" object:nil];

    [self sendSuccessWithCallbackId:command.callbackId];
}



@end
