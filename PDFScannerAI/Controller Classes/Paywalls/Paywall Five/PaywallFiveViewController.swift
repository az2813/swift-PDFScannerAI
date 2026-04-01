//
//  PaywallFiveViewController.swift
//  PDFScannerAI
//
//  Created by dev on 23.02.2026.
//

import UIKit
import Adapty
import StoreKit

class PaywallFiveViewController: UIViewController {

    @IBOutlet weak var contentsScrollView: UIScrollView!
    @IBOutlet weak var unlimitedLabel: UILabel!
    @IBOutlet weak var descView: UIView!
    @IBOutlet weak var paywallsTableView: UITableView!
    
    @IBOutlet weak var bottomPaywallsConstraint: NSLayoutConstraint!
    
    fileprivate let footerView = GenericPaywallTableFooterView()
    fileprivate var paywalls: [[String: Any]] = [
        ["term": "7-day FREE TRIAL, Auto renewable", "price": "$1.99/week, cancel anytime",],
        ["term": "Billed monthly", "price": "$4.99/month",],
        ["term": "Billed yearly", "price": "$49.99/yearly",],
    ]
    fileprivate var selectedIndex: Int = 0
    
    @objc dynamic var isDismiss: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        initView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        bottomPaywallsConstraint.constant = footerView.bounds.height
    }
    
    fileprivate func initView() {
        //fetchProducts()
        let products = PurchaseManager.shared.products
        for product in products {
            switch product.productIdentifier {
            case UNLOCK_1WEEK_SUBSCRIPTION:
                self.paywalls[0]["price"] = (self.paywalls[0]["price"] as! String).replacingOccurrences(of: "$1.99/week", with: product.localizedPrice!)
                self.paywalls[0]["product"] = product
            case UNLOCK_1MONTH_SUBSCRIPTION:
                self.paywalls[1]["price"] = "\(product.localizedPrice!)/month"
                self.paywalls[1]["product"] = product
            case UNLOCK_1YEAR_SUBSCRIPTION:
                self.paywalls[2]["price"] = "\(product.localizedPrice!)/year"
                self.paywalls[2]["product"] = product
            default:
                break
            }
        }
        setupNavigationButtons()
        unlimitedLabel.font = FontHelper.font(.bold, size: 20)
        for view in descView.subviews {
            for subview in view.subviews {
                if let label = subview as? UILabel {
                    label.font = FontHelper.font(.regular, size: 14.0)
                }
            }
        }
        
        let footerSize = footerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        footerView.frame = CGRect(x: 0, y: paywallsTableView.frame.maxY, width: contentsScrollView.bounds.width, height: footerSize.height)
        footerView.onContinueTapped = {
            guard let product = self.paywalls[self.selectedIndex]["product"] as? SKProduct else {
                return
            }
            LoadingIndicatorManager.shared.show()
            PurchaseManager.shared.didPurchase = { success in
                if success {
                    DispatchQueue.main.async {
                        self.openApp()
                    }
                }
            }
            PurchaseManager.shared.purchase(productId: product.productIdentifier)
            /*self?.purchaseSelectedProduct { [weak self] result in
                DispatchQueue.main.async {
                    LoadingIndicatorManager.shared.hide()
                    switch result {
                    case .success(let result):
                        if case .userCancelled = result {
                            // cancelled
                        } else {
                            self?.openAppIfSubscribed(
                                failureAlertTitle: "Purchase Failed",
                                failureAlertMessage: "Your purchase could not be completed."
                            )
                        }
                    case let .failure(error):
                        let ok = UIAlertAction(title: "OK", style: .default)
                        AlertHelper.showAlert(on: self!, title: "Purchase Error", message: error.localizedDescription, actions: [ok])
                    }
                }
            }*/
        }
        footerView.onRestoreTapped = {
            LoadingIndicatorManager.shared.show()
            PurchaseManager.shared.didRestore = { success in
                if success {
                    DispatchQueue.main.async {
                        self.openApp()
                    }
                }
            }
            PurchaseManager.shared.restore()
            /*self?.restorePurchases { result in
                DispatchQueue.main.async {
                    LoadingIndicatorManager.shared.hide()
                    switch result {
                    case .success:
                        self?.openAppIfSubscribed(
                            failureAlertTitle: "Restore Failed",
                            failureAlertMessage: "No previous purchases found to restore."
                        )
                    case let .failure(error):
                        let ok = UIAlertAction(title: "OK", style: .default)
                        AlertHelper.showAlert(on: self!, title: "Restore Error", message: error.localizedDescription, actions: [ok])
                    }
                }
            }*/
        }
        footerView.onPrivacyTapped = {
            UIApplication.shared.open(Constants.policyURL)
        }
        footerView.onTermsTapped = {
            UIApplication.shared.open(Constants.termsURL)
        }
        footerView.continueButton.setTitle("Become Pro", for: .normal)
        contentsScrollView.addSubview(footerView)
    }
    
    private func openAppIfSubscribed(
        failureAlertTitle: String? = nil,
        failureAlertMessage: String? = nil
    ) {
        SubscriptionManager.shared.checkSubscriptionStatus { [weak self] isSubscribed in
            guard let self else { return }
            if isSubscribed {
                self.dismiss(animated: true)
            } else if let title = failureAlertTitle,
                      let message = failureAlertMessage {
                let ok = UIAlertAction(title: "OK", style: .default)
                AlertHelper.showAlert(on: self,
                                     title: title,
                                     message: message,
                                     actions: [ok])
            }
        }
    }
    
    fileprivate func fetchProducts() {
        Adapty.getPaywall(placementId: "placement_3") { result in
            switch result {
            case let .success(paywall):
                Adapty.getPaywallProducts(paywall: paywall) { productsResult in
                    switch productsResult {
                    case let .success(products):
                        Task { @MainActor in
                            self.handleProducts(products: products)
                        }
                    case let .failure(error):
                        Task { @MainActor in
                            self.handleError(error: error)
                        }
                    }
                }
            case let .failure(error):
                print("Failed to get paywall: \(error)")
                Task { @MainActor in
                    self.handleError(error: error)
                }
            }
        }
    }
    
    fileprivate func handleProducts(products: [AdaptyPaywallProduct]) {
        _ = products.map { product in
            let duration = PaywallThreeTextHelper.shortDurationTitle(for: product)
            let price = PaywallThreeTextHelper.pricePerPeriodString(for: product)
            //let trial = PaywallThreeTextHelper.trialLabelText(for: product)
            //let description = PaywallThreeTextHelper.descriptionText(for: product)
            switch duration {
            case "WEEK":
                self.paywalls[0]["price"] = (self.paywalls[0]["price"] as! String).replacingOccurrences(of: "$1.99/week", with: price)
                self.paywalls[0]["product"] = product
            case "MONTH":
                self.paywalls[1]["price"] = price
                self.paywalls[1]["product"] = product
            case "YEAR":
                self.paywalls[2]["price"] = price
                self.paywalls[2]["product"] = product
            default:
                break
            }
        }
        //self.products = mapped
        paywallsTableView.reloadData()
    }
    
    fileprivate func handleError(error: Error) {
        print("Adapty error: \(error.localizedDescription)")
    }
    
    fileprivate func purchaseSelectedProduct(completion: @escaping (Result<AdaptyPurchaseResult, Error>) -> Void) {
        guard let product = paywalls[selectedIndex]["product"] as? AdaptyPaywallProduct else {
            completion(.failure(NSError(domain: "PaywallFour", code: -1, userInfo: [NSLocalizedDescriptionKey: "Product not found"])))
            return
        }
        Adapty.makePurchase(product: product) { result in
            switch result {
            case .success(let purchaseResult):
                completion(.success(purchaseResult))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }

    fileprivate func restorePurchases(completion: @escaping (Result<Void, Error>) -> Void) {
        Adapty.restorePurchases { result in
            switch result {
            case .success:
                completion(.success(()))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }

    fileprivate func openApp() {
        NavigationManager.shared.transitionToViewController(
            identifier: "DashboardViewController",
            from: self,
            useNavigationController: true,
            push: false,
            presentationStyle: .fullScreen
        )
    }
    
    // MARK: - Navigation Buttons
    fileprivate func setupNavigationButtons() {
        setupCustomButton(
            imageName: "cross_icon",
            isRight: false
        )
    }

    fileprivate func setupCustomButton(imageName: String? = nil, title: String? = nil, isRight: Bool) {
        let button = UIButton(type: .system)
        if let imageName = imageName {
            button.setImage(UIImage(named: imageName)?.withRenderingMode(.alwaysTemplate).resized(to: CGSize(width: 18, height: 18)), for: .normal)
            button.tintColor = Colors.navigationItemsTintColor
        } else if let title = title {
            button.setTitle(title, for: .normal)
            button.titleLabel?.font = FontHelper.font(.regular, size: 12)
            button.setTitleColor(Colors.mainTextColor, for: .normal)
        }
        button.alpha = 0
        button.addTarget(self, action: #selector(customBackButtonTapped), for: .touchUpInside)
        let barButton = UIBarButtonItem(customView: button)
        if isRight {
            navigationItem.rightBarButtonItem = barButton
        } else {
            navigationItem.leftBarButtonItem = barButton
        }
        UIView.animate(withDuration: 0.5, delay: 4.0) {
            button.alpha = 0.6
        }
    }
    
    @objc fileprivate func customBackButtonTapped() {
        //dismiss(animated: true)
        openApp()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

// MARK: - UITableViewDataSource
extension PaywallFiveViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return paywalls.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PaywallTermTableCell", for: indexPath) as! PaywallTermTableCell
        cell.selectionStyle = .none
        let paywall = paywalls[indexPath.row]
        cell.termLabel.text = paywall["term"] as? String
        cell.priceLabel.text = paywall["price"] as? String
        cell.saveLabel.isHidden = indexPath.row != 2
        cell.selection = indexPath.row == selectedIndex
        return cell
    }
}

// MARK: - UITableViewDelegate
extension PaywallFiveViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        selectedIndex = indexPath.row
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 78.0
    }
}
