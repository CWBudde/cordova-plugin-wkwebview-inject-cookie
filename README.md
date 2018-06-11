# cordova-plugin-wkwebview-cookie-sync

While this plugin has not been tested properly so far it should provide an alternative way to sync cookies in a wkWebView implemantation.

This is necessary as cookies may not get synced properly on the very first start of the app. 

## Usage

```
document.addEventListener('deviceready', () => {
  wkwebview.injectCookie('mydomain.com/mypath');
});
```
