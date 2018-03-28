### What is this?

This application starts in 1.3 seconds and then loads 34 frameworks *at runtime*.

Click below to see the video in youtube.

[![Watch the video](https://raw.githubusercontent.com/j4n0/dlopen/master/thumbnail.png)](https://youtu.be/zJ0CKdZREWI)

It takes 1.3s to load because the app contains 34 fat frameworks that weight 167Mb. Then it starts loading frameworks one by one. Loading a framework is a costly operation that slows down the application (I don’t know the specifics), however:

- Core Animation keeps running smoothly.
- I’m still able to type.

To allow typing I only load frameworks during 1/3 of every second. This keeps the application more or less responsive.

### How I did it?

To load the frameworks I used dlopen:
```
dlopen("MyFramework.framework/MyFramework", RTLD_LAZY)
```

Is this legal? Yes, Apple only demands that the application reviewed is the same your users will see. For instance, the app will fail review if you pass a dynamic parameter to dlopen.

To use this technique you should be using dependency injection, which you should be doing anyway because it facilitates testing, understanding, splitting the work between teams, and speeds up developer iterations. Productivity is way higher when you are able to work on sets of screens disconnected from the main app. 

To load classes you have to use `NSClassFromString` then force cast it to an implementation of an interface. This is because if you import or reference a class anywhere, the framework will be automatically loaded. 
```
print("\(NSClassFromString("MyFramework.AccountVC"))")
```

### Why is this interesting?

The use case for this technique is applications where features are presented linearly, like levels of a game, or those requiring signup –like bank applications. If the user is already logged, you can programmatically load all frameworks in advance while running a smooth animation to distract the user. Twitter animates their logo after startup time, you could be doing this while loading frameworks. I currently don’t know if loading at runtime is slower, or if loading more than one at once speeds up the process

If you run the application until it finishes loading, then kill it, then run it again, it will load all frameworks within a second. This happens because the application contents remains cached in memory.

Whether this is useful or not, it depends on its use case. Also keep in mind that this is an insane example with 34 fat frameworks.

### How do I test this example?
```
brew install carthage
./carthage.sh
```
Carthage will take half an hour to build all frameworks. 

On my iPhone 6 plus the console looks like this:
```
Animating circle
Loading frameworks
Frameworks loading ---------
1038ms  01/34 AirshipKit
wait 700ms
117ms  02/34 Bolts
wait 700ms
132ms  03/34 BoltsSwift
360ms  04/34 Braintree3DSecure
wait 700ms
131ms  05/34 BraintreeAmericanExpress
133ms  06/34 BraintreeApplePay
wait 700ms
00ms  07/34 BraintreeCard
00ms  08/34 BraintreeCore
129ms  09/34 BraintreeDataCollector
556ms  10/34 BraintreePayPal
wait 700ms
209ms  11/34 BraintreePaymentFlow
wait 700ms
161ms  12/34 BraintreeUI
143ms  13/34 BraintreeUnionPay
wait 700ms
132ms  14/34 BraintreeVenmo
150ms  15/34 FBSDKCoreKit
wait 700ms
157ms  16/34 FBSDKLoginKit
134ms  17/34 FBSDKPlacesKit
wait 700ms
149ms  18/34 FBSDKShareKit
150ms  19/34 FacebookCore
wait 700ms
138ms  20/34 FacebookLogin
154ms  21/34 FacebookShare
wait 700ms
232ms  22/34 Koloda
wait 700ms
153ms  23/34 Locksmith
120ms  24/34 MMMaterialDesignSpinner
wait 700ms
114ms  25/34 NVActivityIndicatorView
131ms  26/34 ObjectMapper
wait 700ms
00ms  27/34 PayPalDataCollector
00ms  28/34 PayPalOneTouch
00ms  29/34 PayPalUtils
167ms  30/34 Realm
120ms  31/34 RealmSwift
wait 700ms
119ms  32/34 SVProgressHUD
130ms  33/34 Stripe
wait 700ms
01ms  34/34 pop
Loading time: 5560
Loading time plus pauses: 16760
```
