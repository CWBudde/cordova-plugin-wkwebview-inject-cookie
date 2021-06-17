/* 
 * Copyright 2018-2021 Christian-W. Budde
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

#import "WKWebViewInjectCookie.h"
#import <WebKit/WebKit.h>
#import <Cordova/CDV.h>

@implementation WKWebViewInjectCookie

- (void)setCookie:(CDVInvokedUrlCommand *)command {
    self.callbackId = command.callbackId;

    NSString *domain = command.arguments[0];
    NSString *path = command.arguments[1];
    NSString *name = command.arguments[2];
    NSString *value = command.arguments[3];
    NSString *expire = command.arguments[4];
    NSString *secure = command.arguments[5];
    NSString *maxAge = command.arguments[6];

    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];

    WKWebView* wkWebView = (WKWebView*) self.webView;

    if (@available(iOS 2.0, *)) {
        NSMutableDictionary *cookieProperties = [NSMutableDictionary dictionary];
        [cookieProperties setObject:name forKey:NSHTTPCookieName];
        [cookieProperties setObject:value forKey:NSHTTPCookieValue];
        [cookieProperties setObject:domain forKey:NSHTTPCookieDomain];
        [cookieProperties setObject:domain forKey:NSHTTPCookieOriginURL];
        [cookieProperties setObject:path forKey:NSHTTPCookiePath];
        [cookieProperties setObject:secure forKey:NSHTTPCookieSecure];
        [cookieProperties setObject:maxAge forKey:NSHTTPCookieMaximumAge];

        @try {
            if (![expire isEqual: [NSNull null]]) {
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
                NSLocale *posix = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
                [formatter setLocale:posix];
                NSDate *date = [formatter dateFromString:expire];
                [cookieProperties setObject:date forKey:NSHTTPCookieExpires];
            }

            NSHTTPCookie * cookie = [NSHTTPCookie cookieWithProperties:cookieProperties];

            [wkWebView.configuration.websiteDataStore.httpCookieStore setCookie:cookie completionHandler:^{NSLog(@"Cookies synced");}];
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
        } @catch(NSException *e) {
            CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Unknown exception"];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:self.callbackId];
            return;
        }

        CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:self.callbackId];
    } else {
        CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:self.callbackId];
    };
}

- (void)getCookies:(CDVInvokedUrlCommand *)command {
    self.callbackId = command.callbackId;

    NSString* url = [command.arguments objectAtIndex:0];

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSLocale *enUSPOSIXLocale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
    [dateFormatter setLocale:enUSPOSIXLocale];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZZ"];
    [dateFormatter setCalendar:[NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian]];
    
    WKHTTPCookieStore* cookies = [WKWebsiteDataStore defaultDataStore].httpCookieStore;

    [cookies getAllCookies:^(NSArray<NSHTTPCookie *> * _Nonnull allCookies) {
        NSMutableArray<NSDictionary*> *array = [NSMutableArray array];
 
        for (NSHTTPCookie *cookie in allCookies) {
            if (url == nil || [url length] == 0 || [url rangeOfString:cookie.domain].location != NSNotFound) {
   
                NSDictionary* item = @{
                    @"domain": cookie.domain,
                    @"expireDate": (cookie.expiresDate ? [dateFormatter stringFromDate:cookie.expiresDate]: [NSNull null]),
                    @"name": cookie.name,
                    @"path": cookie.path,
                    @"HTTPOnly": [NSNumber numberWithBool:cookie.HTTPOnly],
                    @"sessionOnly": [NSNumber numberWithBool:cookie.sessionOnly],
                    @"value": cookie.value
                };
                [array addObject:item];
            }

        }

        [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsArray:array] callbackId:command.callbackId];
    }];
}

@end