## Overview
OMID SDK is producing lags when loading ads on multiple screens. || https://github.com/appnexus/mobile-sdk-ios/issues/57

 

### Environment Setup 
+ Software
   + Xcode: v12.5.1 
+ SDK used in sample apps
   + Appnexus SDK v7.17.0
   + OMID SDK v1.3.20


### Reproduction steps using Appnexus SDK with OMID SDK
+ Clone the Repo 
+ Go to SimpleIntegration/  folder
+ Open terminal and run pod install 
+ Run[press play button in Xcode] the app click on Banners & scroll till bottom
+ Once ad is loaded, click on Render [Top Right] 
+ Repeat step 5 till you see lags while scrolling.


#### To Test SDK Without OMID
+ Open AppDelegate.swift in Xcode
+ set enableOpenMeasurement to false 
+ ANSDKSettings.sharedInstance().enableOpenMeasurement = false


### Reproduction steps using OMID SDK in Sample Download from https://tools.iabtechlab.com/dashboard

+ Clone Repo Open  omsdk-ios-1.3.24-Appnexus
+ Go to omsdk-ios-1.3.24-Appnexus/ folder
+ Run[press play button in Xcode] the app click on HTML Display & scroll the ad 
+ Once ad is loaded, click on Load Ad on next Page [Top Right] 
+ Repeat step 5 till you see lags while scrolling.



### Note
+ omsdk-ios-1.3.24-Appnexus is downloaded from https://tools.iabtechlab.com/dashboard there is no Appnexus SDK reference, Keyword Appnexus will be there as OMID SDK was build from Appnexus account.

