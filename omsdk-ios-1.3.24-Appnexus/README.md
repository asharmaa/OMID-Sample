# Open Measurement Reference App for iOS

## Overview

A sample iOS application in Swift built to showcase OM SDK integration.

Included are 5 sample integrations:

* HTML display ad
* HTML video ad 
* Native display ad
* Native video ad
* Native audio ad

## Getting Started

1. Download the latest `omsdk-v1.js` release from the [IAB portal](https://tools.iabtechlab.com/omsdk) and copy it into `OMSDK/Service/`.
2. Open `OM-Demo.xcodeproj` in Xcode
3. Build and run `OM-Demo` target in Simulator
4. Use Charles proxy or Safari Web Inspector to see what events OM SDK is receiving
5. Choose one of the sample implementations from the table
6. Wait for the ad to load
7. Observe network calls to `http://complianceomsdk.iabtechlab.com` (the query string will include OM SDK event parameters)

## Clarifications

1. The code provided in this sample project is for education purposes only.
2. For production integration, please refer to the *"Onboarding Guide"* that is published on [IAB Tech Lab](https://iabtechlab.com/standards/open-measurement-sdk/) and follow the instructions.
2. For simplicity, this Demo app does not implement parsing of VAST or any other ad response formats. Asset URLs, verification script URLs and parameters are specified as constants instead. Please refer to [IAB Tech Lab](https://iabtechlab.com/standards/open-measurement-sdk/) for details regarding how verification resources are represented in various ad formats.

## Additional Information

* [Open Measurement SDK on IAB Tech Lab](https://iabtechlab.com/standards/open-measurement-sdk/)
