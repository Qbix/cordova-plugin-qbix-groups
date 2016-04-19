#import <Cordova/CDV.h>

@interface QbixGroupsCordova : CDVPlugin

- (void) hello:(CDVInvokedUrlCommand*)command;

- (void) setList:(CDVInvokedUrlCommand*)command;
- (void) setActions:(CDVInvokedUrlCommand*)command;

- (void)hideFullscreen:(CDVInvokedUrlCommand*)command;
- (void)showFullscreen:(CDVInvokedUrlCommand*)command;
- (void)showOptions:(CDVInvokedUrlCommand*)command;
- (void)showEnhance:(CDVInvokedUrlCommand*)command;
- (void)showSupport:(CDVInvokedUrlCommand*)command;
- (void)showEdit:(CDVInvokedUrlCommand*)command;
- (void)deleteStickyAds:(CDVInvokedUrlCommand *)command;
//- (void)cordovaRevertWebMode:(CDVInvokedUrlCommand *)command;
- (void)closeModalWebView:(CDVInvokedUrlCommand *)command;

@end