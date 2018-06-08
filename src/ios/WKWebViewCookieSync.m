#import "WKWebViewCookieSync.h"
#import <Cordova/CDV.h>

@implementation WKWebViewCookieSync

- (void)sync:(CDVInvokedUrlCommand *)command {
  self.callbackId = command.callbackId;
  NSLog(@"Test");

  self.webView.configuration.processPool = [[WKProcessPool alloc] init];

	[self.commandDelegate sendPluginResult:pluginResult callbackId:self.callbackId];
}

@end
