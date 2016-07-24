#import "QbixGroupsCordova.h"

@implementation QbixGroupsCordova

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

-(void) sendSuccessWithCallbackId:(NSString*) callbackId {
    CDVPluginResult* result = [CDVPluginResult
                               resultWithStatus:CDVCommandStatus_OK
                               messageAsString:@""];

    [self.commandDelegate sendPluginResult:result callbackId:callbackId];
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
