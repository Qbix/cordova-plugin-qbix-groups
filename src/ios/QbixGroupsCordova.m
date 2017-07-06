#import "QbixGroupsCordova.h"
#import "TrackingEmailStorage.h"
#import "BatchSenderEmailSms.h"
#import "LocationModel.h"
#import "ContactsService.h"

#define APP_LANGUAGE @"currentAppLanguage"
#define SYSTEM_LANGUAGE @"currentSystemLanguage"
#define TEMPLATE_DATA @"templateData"
#define LOCATION_DATA @"locationData"



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
    NSString* imageUrl = [[command arguments] objectAtIndex:2];

    if(![SMSService isAvailable]) {
        [self sendError:@"Device not configured to sent sms" withCallbackId:command.callbackId];
        return;
    }
    
    if([SMSService isEnableFeature:recipients] || [SMSService isFreeSMS]) {
        [[ApiController controller] loadImageFromUrl:imageUrl withCallback:^(UIImage *image) {
            SMSSenderClient *client = [SMSSenderClient clientWithBlock:^(SMSSenderClientBuilder *builder) {
                builder.body = body;
                builder.recipients = recipients;
                builder.attachment = image;
            }];
            
            [client send:self.viewController andDelegate:self];
        }];
        
    } else {
        [self sendError:@"No free sms to sent" withCallbackId:command.callbackId];
    }
    
//    SmsOperationController *smsOperationController = [[SmsOperationController alloc] init];
//    if(![smsOperationController isAvailable]) {
//        [self sendError:@"Device not configured to sent sms" withCallbackId:command.callbackId];
//        return;
//    }
//    [smsOperationController setDelegateCordova:self];
//    [smsOperationController setRecipientsAsPhoneArray:recipients];
//    [smsOperationController setText:body];
//    [smsOperationController setImageUrl:imageUrl];
//    [smsOperationController setBatch:[recipients count]];
//    [smsOperationController setIsDirect:YES];
//    [smsOperationController showComposeSmsController];
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
    switch (result) {
        case MessageComposeResultSent:
            [self sendSuccessWithCallbackId:smsCallbackId];
            break;
        case MessageComposeResultFailed:
            [self sendError:@"Error" withCallbackId:smsCallbackId];
            break;
        case MessageComposeResultCancelled:
            [self sendError:@"User cancel" withCallbackId:smsCallbackId];
            break;
        default:
            break;
    }
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

-(void) getNativeTemplates:(CDVInvokedUrlCommand *)command {
    [[Recents instance] load];
    
    NSMutableArray *resultArray = [NSMutableArray array];
    
    for(int i=0; i < [[Recents instance] numberOfItems]; i++ ) {
        NSArray *item = [[Recents instance] itemAtIndex:i];
        
        NSString *text = [item objectAtIndex:0];
        id date = [item objectAtIndex:1];
        NSString *imageLink = nil;
        if([item count] > 2) {
            imageLink = [item objectAtIndex:2];
        }
        
        NSString *templateName = nil;
        if([item count] > 3) {
            templateName = [item objectAtIndex:3];
        }
        
        NSString *timeString = @"";
        if([date isKindOfClass:[NSDate class]]) {
            timeString = [date description];
        } else {
            timeString = (NSString*)date;
        }
        
        NSMutableDictionary *itemDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:text, @"text", timeString, @"date", nil];
        if(imageLink != nil) {
            [itemDict setObject:imageLink forKey:@"imageLink"];
        }
        if(templateName != nil) {
            [itemDict setObject:templateName forKey:@"templateName"];
        }
        
        [resultArray addObject:[itemDict mutableCopy]];
    }
    
    CDVPluginResult* result = [CDVPluginResult
                               resultWithStatus:CDVCommandStatus_OK messageAsArray:resultArray];
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

-(void) getSupportLanguages:(CDVInvokedUrlCommand *)command {
    NSArray *supportedLanguages = [[LocalizationSystem sharedLocalSystem] getSupportLanguages];
    
    NSMutableDictionary *resultDict = [[NSMutableDictionary alloc] init];
    for(int i=0; i < [supportedLanguages count]; i++) {
        LanguageModelItem *item = [supportedLanguages objectAtIndex:i];
        
        [resultDict setObject:[item languageFullName] forKey:[item languageShortName]];
    }
    
    CDVPluginResult* result = [CDVPluginResult
                               resultWithStatus:CDVCommandStatus_OK messageAsDictionary:resultDict];
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

-(void) getCurrentLanguage: (CDVInvokedUrlCommand *)command {
    NSString *appLanguage = [[LocalizationSystem sharedLocalSystem] getLanguage];
    NSString *systemLanguage = [[LocalizationSystem sharedLocalSystem] getSystemLanguage];
    
    NSDictionary *resultDict = [NSDictionary dictionaryWithObjectsAndKeys:appLanguage, APP_LANGUAGE, systemLanguage, SYSTEM_LANGUAGE, nil];

    CDVPluginResult* result = [CDVPluginResult
                               resultWithStatus:CDVCommandStatus_OK messageAsDictionary:resultDict];
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

-(void) chooseTemplate:(CDVInvokedUrlCommand *)command {
    NSString *typeString = [[command arguments] objectAtIndex:0];
    NSDictionary *resultDict = nil;
    
    if(typeString == nil) {
        return [self sendError:@"null parameters" withCallbackId:command.callbackId];
    }
    
    if([typeString isEqualToString:@"email"]) {
        NSString *subject = [[command arguments] objectAtIndex:1];
        NSString *body = [[command arguments] objectAtIndex:2];
        NSString *templateName = [[command arguments] objectAtIndex:3];
        EmailTemplateModel *model = [[EmailTemplateModel alloc] init];
        [model setTemplateName:templateName];
        [model setSubject:subject];
        [model setBody:body];
        
        resultDict = [NSDictionary dictionaryWithObjectsAndKeys:model, TEMPLATE_DATA, nil];
    } else {
        NSString *text = [[command arguments] objectAtIndex:1];
        NSString *image = [[command arguments] objectAtIndex:2];
        NSString *templateName = [[command arguments] objectAtIndex:3];
        SmsTemplateModel *model = [[SmsTemplateModel alloc] init];
        [model setTemplateName:templateName];
        [model setImage:image];
        [model setText:text];
        
        resultDict = [NSDictionary dictionaryWithObjectsAndKeys:model, TEMPLATE_DATA, nil];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"chooseTemplate" object:resultDict];
    
    [self sendSuccessWithCallbackId:command.callbackId];
}

-(void) chooseLocation:(CDVInvokedUrlCommand *)command {
    NSDictionary *data = [[command arguments] objectAtIndex:0];
    
    if(data == nil) {
        return [self sendError:@"null parameters" withCallbackId:command.callbackId];
    }
    
    LocationModel *model = [[LocationModel alloc] init];
    [model setLocationUrl:[data objectForKey:@"locationUrl"]];
    [model setMapSrc:[data objectForKey:@"mapSrc"]];
    [model setStreetviewSrc:[data objectForKey:@"streetviewSrc"]];
    
    NSDictionary *resultDict = [NSDictionary dictionaryWithObjectsAndKeys:model, LOCATION_DATA, nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"chooseLocation" object:resultDict];
    
    [self sendSuccessWithCallbackId:command.callbackId];
}

-(void) send:(CDVInvokedUrlCommand *)command {
    NSString *callbackId = command.callbackId;
    NSString *src = [[command arguments] objectAtIndex:0];
    NSString *state = [[command arguments] objectAtIndex:1];
    
    [[ApiController controller] loadBatchesEmailSMS:src callback:^(NSArray<BatchEmailSMS *> *tasks) {
        // run each task in json
        BatchSenderEmailSms *batchSenderEmailSms = [[BatchSenderEmailSms alloc] init:src andState:state];
        [batchSenderEmailSms sentBatches:tasks fromController:self.viewController callback:^{
            [self sendSuccessWithCallbackId:callbackId];
        }];
    }];    
}

- (void) selectedIdentifiers:(CDVInvokedUrlCommand *)command {
    NSArray<QContact*> *selectedContacts = [ContactsService lastSelectedContacts];
    
    if(selectedContacts == nil) {
        [self sendError:@"No selected Identifiers" withCallbackId:command.callbackId];
        return;
    }
    
    NSMutableDictionary *selectedIdentifiers = [NSMutableDictionary dictionary];
    for(QContact *contact in selectedContacts) {
        [selectedIdentifiers setValue:[[contact selectedPhoneNumbers] arrayByAddingObjectsFromArray:[contact selectedEmails]] forKey:[NSString stringWithFormat:@"%ld", (long)[contact identifier]]];
    }
    
    CDVPluginResult* result = [CDVPluginResult
                               resultWithStatus:CDVCommandStatus_OK
                               messageAsDictionary:[selectedIdentifiers copy]];

    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

@end
