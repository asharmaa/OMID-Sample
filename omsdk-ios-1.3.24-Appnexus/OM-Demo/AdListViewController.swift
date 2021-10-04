//
//  AdListViewController.swift
//  OM-TestApp
//
//  Created by Alex Chugunov on 9/24/17.
//

import UIKit

/**
 Supported Ad Units
 */
enum AdUnit: CaseIterable {

    /// Standard 300x250 HTML display banner rendered by WKWebView.
    case HTMLDisplay

    /// A video asset rendered by WKWebView
//    case HTMLVideo
//
//    /// A static image rendered by UIImageView
//    case nativeDisplay
//
//    /// A video asset rendered by AVKit
//    case nativeVideo
//
//    /// An audio ad played with AVPlayer
//    case nativeAudio
//
//    case JSDisplay
//
//    case JSVideo

    var title: String {
        switch self {
        case .HTMLDisplay:
            return "HTML Display"
//        case .HTMLVideo:
//            return "HTML Video"
//        case .nativeDisplay:
//            return "Native Display"
//        case .nativeVideo:
//            return "Native Video"
//        case .nativeAudio:
//            return "Native Audio"
//        case .JSDisplay:
//            return "JavaScript Display"
//        case .JSVideo:
//            return "Javascript Video"
        }
    }

    var segue: String {
        switch self {
        case .HTMLDisplay:
            return "showBanner"
//        case .HTMLVideo:
//            return "showHTMLVideo"
//        case .nativeDisplay:
//            return "showNativeBanner"
//        case .nativeVideo:
//            return "showVideo"
//        case .nativeAudio:
//            return "showAudio"
//        case .JSDisplay:
//            return "showJSBanner"
//        case .JSVideo:
//            return "shoowJSVideo"
        }
    }
}

/**
 Presents the user with the list of available ad units in a table view.
 Tapping on a table view cell opens a view controller that handles selected ad unit.
 */
class AdListViewController: UITableViewController {
    var adUnits: [AdUnit] = AdUnit.allCases

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return adUnits.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "listCell", for: indexPath)
        let adUnit = adUnits[indexPath.row]
        cell.textLabel?.text = adUnit.title
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let adUnit = adUnits[indexPath.row]
        performSegue(withIdentifier: adUnit.segue, sender: self)
    }
}
