/* 
 * Copyright 2018 Christian-W. Budde
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import "WKWebViewCookieSync.h"
#import <WebKit/WebKit.h>
#import <Cordova/CDV.h>

@implementation WKWebViewCookieSync

- (void)sync:(CDVInvokedUrlCommand *)command {
  self.callbackId = command.callbackId;
  NSLog(@"Cookie sync attempt");

  WKWebView* wkWebView = (WKWebView*) self.webView;
  wkWebView.configuration.processPool = [[WKProcessPool alloc] init];

	CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
	[self.commandDelegate sendPluginResult:pluginResult callbackId:self.callbackId];
}

@end
