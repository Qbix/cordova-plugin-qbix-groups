#import <Cordova/CDV.h>

#import "QbixGroupsCordovaDelegate.h"
#import "SMSSenderClient.h"
#import "Recents.h"
#import "EmailTemplateModel.h"
#import "SmsTemplateModel.h"
#import "QbixGroupsRepository.h"

@interface QbixGroupsCordova : CDVPlugin<QbixGroupsCordovaDelegate>

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
-(void) didFinishWithResult:(BOOL) isSuccess;
-(void) showError:(NSString*) error;
- (void) getEmailInfo:(CDVInvokedUrlCommand *)command;

-(void) getNativeTemplates:(CDVInvokedUrlCommand *)command;
-(void) getSupportLanguages:(CDVInvokedUrlCommand *)command;
-(void) getCurrentLanguage: (CDVInvokedUrlCommand *)command;
-(void) chooseTemplate:(CDVInvokedUrlCommand *)command;
-(void) chooseLocation:(CDVInvokedUrlCommand *)command;

@end
