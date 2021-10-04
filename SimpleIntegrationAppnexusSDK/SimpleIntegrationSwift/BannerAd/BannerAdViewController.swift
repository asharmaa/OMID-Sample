/*   Copyright 2020 APPNEXUS INC

 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at

 http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */

import UIKit
import AppNexusSDK

class BannerAdViewController: UIViewController , ANBannerAdViewDelegate{

    private let numberOfAds = 5
    private let numberOfText = 2
    var adContainerViews = [UIView]()

    private var scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: .zero)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    private let mainStackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.spacing = 20
        return view
    }()

    private func adContainerView() -> UIView {
        let container = UIView(frame: .zero)
        container.translatesAutoresizingMaskIntoConstraints = false
        container.backgroundColor = .lightGray
        return container
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Banner Ad"

        let renderButton = UIBarButtonItem(title: "Render",
                                           style: .plain,
                                           target: self,
                                           action: #selector(didTapRender))
        renderButton.accessibilityIdentifier = "Render"
        self.navigationItem.setRightBarButtonItems([renderButton].compactMap { $0 },
                                                   animated: true)

        self.setupView()
        self.loadAd()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        for adContainer in adContainerViews {
            adContainer.removeFromSuperview()
        }
    }

    @objc func didTapRender() {
        let storyboard = UIStoryboard(name: "BannerAd", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "BannerAdViewController")
        navigationController?.pushViewController(vc, animated: true)
    }

    private func setupView() {
        for _ in 0..<numberOfAds {
            for _ in 0..<numberOfText {
                mainStackView.addArrangedSubview(self.createMockTextView())
            }
            let containerView = self.adContainerView()
            self.adContainerViews.append(containerView)
            mainStackView.addArrangedSubview(containerView)
        }

        self.scrollView.addSubview(mainStackView)
        mainStackView.leftAnchor.constraint(equalTo: self.scrollView.leftAnchor).isActive = true
        mainStackView.rightAnchor.constraint(equalTo: self.scrollView.rightAnchor).isActive = true
        mainStackView.topAnchor.constraint(equalTo: self.scrollView.topAnchor).isActive = true
        mainStackView.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor).isActive = true
        mainStackView.widthAnchor.constraint(equalToConstant: self.view.bounds.width).isActive = true

        self.view.addSubview(scrollView)
        scrollView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }

    private func createMockTextView() -> UIView {
        let textView = UILabel(frame: .zero)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.numberOfLines = 0
        textView.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
        return textView
    }

    private func loadAd() {
        for adContainerView in self.adContainerViews {
            let adWidth: Int = 300
            let adHeight: Int = 250
            let adID = "17058950"

            // Needed for when we create our ad view.

            let rect = CGRect(origin: .zero,
                              size: CGSize(width: adWidth, height: adHeight))

            let size = CGSize(width: adWidth, height: adHeight)

            // Make a banner ad view.
            let banner = ANBannerAdView(frame: rect, placementId: adID, adSize: size)
            banner.translatesAutoresizingMaskIntoConstraints = false
            banner.rootViewController = self
            banner.delegate = self
            banner.autoRefreshInterval = 0

            adContainerView.addSubview(banner)
            banner.leftAnchor.constraint(equalTo: adContainerView.leftAnchor).isActive = true
            banner.rightAnchor.constraint(equalTo: adContainerView.rightAnchor).isActive = true
            banner.topAnchor.constraint(equalTo: adContainerView.topAnchor).isActive = true
            banner.bottomAnchor.constraint(equalTo: adContainerView.bottomAnchor).isActive = true

            banner.leftAnchor.constraint(equalTo: adContainerView.leftAnchor).isActive = true
            banner.rightAnchor.constraint(equalTo: adContainerView.rightAnchor).isActive = true

            // Load an ad.
            banner.loadAd()
        }
    }

    func adDidReceiveAd(_ ad: Any) {
        guard let adView = ad as? ANBannerAdView else { return }
        (adView.heightAnchor.constraint(equalToConstant: adView.adSize.height)).isActive = true
        print("Ad did receive ad")
    }

    func ad(_ ad: Any, requestFailedWithError error: Error) {
        print("Ad request Failed With Error")
    }
}

