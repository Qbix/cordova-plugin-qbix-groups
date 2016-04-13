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
	NSString* after = [[command arguments] objectAtIndex:1];
	NSString* title = [[command arguments] objectAtIndex:2];

	NSDictionary* dict = [[NSDictionary alloc] init];
  [dict setValue:title forKey:@"title"];
  [dict setValue:after forKey:@"after"];
  [dict setValue:sectionItems forKey:@"items"];

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

- (void)cordovaHideFullscreen:(CDVInvokedUrlCommand*)command
{
    NSString *height = @"62";
    @try {
        height = [[command arguments] objectAtIndex:0];
    } @catch(NSException *e) {};
    
    NSDictionary* dict = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:[height intValue]] forKey:@"height"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"cordovaHideFullscreen" object:nil userInfo:dict];
    
    [self sendSuccessWithCallbackId:command.callbackId];
}

- (void)cordovaShowFullscreen:(CDVInvokedUrlCommand*)command
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"cordovaShowFullscreen" object:nil];

    [self sendSuccessWithCallbackId:command.callbackId];  
}

- (void)cordovaShowOptions:(CDVInvokedUrlCommand*)command
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"cordovaShowOptions" object:nil];

    [self sendSuccessWithCallbackId:command.callbackId];  
}

- (void)cordovaShowEnhance:(CDVInvokedUrlCommand*)command
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"cordovaShowEnhance" object:nil];

    [self sendSuccessWithCallbackId:command.callbackId];  
}

- (void)cordovaShowSupport:(CDVInvokedUrlCommand*)command
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"cordovaShowSupport" object:nil];

    [self sendSuccessWithCallbackId:command.callbackId];  
}

- (void)cordovaShowEdit:(CDVInvokedUrlCommand*)command
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"cordovaShowEdit" object:nil];

    [self sendSuccessWithCallbackId:command.callbackId];  
}

-(void)cordovaDeleteStickyAds:(CDVInvokedUrlCommand *)command
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

-(void) cordovaСloseModalWebView:(CDVInvokedUrlCommand *)command {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"cordovaCloseModalWebView" object:nil];
    
    [self sendSuccessWithCallbackId:command.callbackId];  
}



@end