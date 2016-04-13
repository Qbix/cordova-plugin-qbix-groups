#import <Cordova/CDV.h>

@interface QbixGroupsCordova : CDVPlugin

- (void) hello:(CDVInvokedUrlCommand*)command;

- (void) setList:(CDVInvokedUrlCommand*)command;
- (void) setActions:(CDVInvokedUrlCommand*)command;

- (void)cordovaHideFullscreen:(CDVInvokedUrlCommand*)command;
- (void)cordovaShowFullscreen:(CDVInvokedUrlCommand*)command;
- (void)cordovaShowOptions:(CDVInvokedUrlCommand*)command;
- (void)cordovaShowEnhance:(CDVInvokedUrlCommand*)command;
- (void)cordovaShowSupport:(CDVInvokedUrlCommand*)command;
- (void)cordovaShowEdit:(CDVInvokedUrlCommand*)command;
- (void)cordovaDeleteStickyAds:(CDVInvokedUrlCommand *)command;
//- (void)cordovaRevertWebMode:(CDVInvokedUrlCommand *)command;
- (void)cordovaСloseModalWebView:(CDVInvokedUrlCommand *)command;

@end