# cordova-plugin-wkwebview-inject-cookie

When switching to wkWebView in Cordova for iOS some plugins have the known issue that cookies won't be used properly on the very first start of the application, or every time using the iOS Simulator. In particular session cookies. This is due to a [missing proper sync between the underlying WKHTTPCookieStore and the WebView](https://stackoverflow.com/a/49534854/2757879).

While this issue could probably only get fixed by Apple in the first place, there is a simple workaround available to get it working: Once a dummy cookie is placed into the WKHTTPCookieStore manually, the syncronization gets triggered (started) and it won't bug you ever again.

Unfortunately this only works for iOS11 and it's necessary to supply the specific domain. This means the solution does not work out of the box. At least some interaction is necessary.

## Usage

```
document.addEventListener('deviceready', () => {
  wkWebView.injectCookie('mydomain.com', 'mypath');
});
```
You have to replace "mydomain.com" with your domain name and "mypath" with your subpath. If the latter is empty than you don't need to provide it (just leave the trailing slash there to tell the plugin that you don't use any extra path).

Once you have injected a cookie all further (session) cookies are synced properly.

If you want you could also pass a success and and error handler. The success handler will be called if the cookie was injected properly, the error handler if not.
