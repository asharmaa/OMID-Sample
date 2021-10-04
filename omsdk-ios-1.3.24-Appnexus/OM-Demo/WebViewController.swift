//
//  WebViewController.swift
//  OM-TestApp
//
//  Created by Alex Chugunov on 9/17/17.
//

import UIKit
import WebKit
import MediaPlayer

#if canImport(OMSDK_Appnexus)
import OMSDK_Appnexus
#endif

class WebViewController: BaseAdUnitViewController {
    
    @IBAction func nextViewC(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "WebViewController")
        navigationController?.pushViewController(vc, animated: true)
    }
    var webView: WKWebView?
    var webViewInitialNavigation: WKNavigation?
    
    override var creativeURL: URL {
        // URL to the ad creative
        return URL(string: Constants.HTMLAdURL)!
    }

    override func didFinishFetchingCreative(_ fileURL: URL) {
        do {
            let HTML = try String(contentsOf: fileURL)
            NSLog("Did finish fetching creative.")

            // Create webview
            webView = WKWebView(frame: adView.bounds)
            webView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            webView?.navigationDelegate = self

            // Begin loading HTML in the webview
            loadAd(withHTML: HTML)
        } catch {
            self.showErrorMessage(message: "Unable to load creative: \(error)")
        }
    }

    override func destroyAd() {
//        guard let webView = webView else {
//            return
//        }
//
//        // Delay destruction of the webview by at least 1 second, otherwise sessionFinish event will not have enough time to execute.
//        // Temporary workaround for https://github.com/InteractiveAdvertisingBureau/Open-Measurement-SDKiOS/issues/22
//        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1000)) {
//            webView.navigationDelegate = nil
//            webView.scrollView.isScrollEnabled = false
//            webView.stopLoading()
//
//            webView.removeFromSuperview()
//            self.webView = nil
//            NSLog("WebView was destroyed")
//        }
    }

    override func createAdSessionConfiguration() -> OMIDAppnexusAdSessionConfiguration {
        do {
          return try OMIDAppnexusAdSessionConfiguration(creativeType: .htmlDisplay,
                                                impressionType: .beginToRender,
                                                impressionOwner: .javaScriptOwner,
                                                mediaEventsOwner: .noneOwner,
                                                isolateVerificationScripts: false)
        } catch {
          fatalError("Unable to create ad session configuration: \(error)")
        }
    }

    override func createAdSessionContext(withPartner partner: OMIDAppnexusPartner) -> OMIDAppnexusAdSessionContext {
        guard let webView = webView else {
            fatalError("Unable to create ad session context: webView is not initialized")
        }

        do {
            return try OMIDAppnexusAdSessionContext(partner: partner,
                                            webView: webView,
                                            contentUrl: nil,
                                            customReferenceIdentifier: nil)
        } catch {
            fatalError("Unable to create ad session context: \(error)")
        }
    }
    
    override func adLoaded() {
      do {
        NSLog("Firing OMID loaded event.")
        if adSession?.configuration.impressionOwner == .nativeOwner {
          try adEvents?.loaded()
        } else {
          // No need to fire adEvents if if impression owned by js layer as the js script is resposible for it
          return
        }
      } catch let error as NSError {
        fatalError("OMID impression load error: \(error.localizedDescription)")
      }
  }
}

// MARK: - WKScriptMessageHandler
extension WebViewController: WKNavigationDelegate {

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if navigation === webViewInitialNavigation {
            NSLog("WebView did finish loading creative")

            // This is an equivalent of listening to DOMContentLoaded event in JS
            // OMID JS service is not guaranteed to handle any events prior to this point and you
            // should avoid executing native impression event (registered in presentAd()) until DOM
            // is loaded completely. If you're pre-rendering webviews, then waiting for window.onload
            // event is also an option)

            // OMID JS service is now fully operational and it's safe to display the webview and
            // register native impression
            presentAd()
        }
    }
}


// MARK: - WebView lifecycle
extension WebViewController {

    func injectOMID(intoHTML HTML: String) -> String {
        do {
            let creativeWithOMID = try OMIDAppnexusScriptInjector.injectScriptContent(omidJSService, intoHTML:HTML)
            return creativeWithOMID
        } catch {
            fatalError("Unable to inject OMID JS into ad creative: \(error)")
        }
    }

  func insertVerificationScriptUrl(intoHTML HTML:String) -> String {
    return HTML.replacingOccurrences(of: "[INSERT RESOURCE URL]", with: Constants.verificationScriptURL)
  }

    func loadAd(withHTML HTML: String) {
        guard let webView = webView else {
            showErrorMessage(message: "Failed to create webView")
            return
        }

        // Change the place holder of verification script with the actual verification script link
        let htmlWithResourceUrl = insertVerificationScriptUrl(intoHTML: HTML)

        //Inject OMID JS service script into HTML creative
        //This is only necessary if OMID JS is not injected on the server side
        let creative = injectOMID(intoHTML: htmlWithResourceUrl)

        statusLabel.text = "Loading HTML..."

        // Adding the webview to the view hierarchy to allow rendering.
        // Ideally we don't want to display the webview until DOM is loaded.
        adView.addSubview(webView)
        adView.sendSubviewToBack(webView)

        // Start loading HTML, this will trigger webView rendering as well.
        // This implementation uses loadHTMLString() method to load HTML from string,
        // however using load() method here with a remote URL is also an option
        webViewInitialNavigation = webView.loadHTMLString(creative, baseURL: creativeURL.baseURL)
    }
}

