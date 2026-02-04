//
//  © 2025. Brewed with code, ☕, and a sprinkle of innovation. Rights reserved.
//
//  PS: Keep the vibes, respect the rights. 🌟
//

import UIKit

class PaywallTwoTableViewHelper: NSObject {
    private weak var tableView: UITableView?
    private let viewModel: PaywallTwoViewModel
    private let interactionHelper: PaywallTwoInteractionHelper

    private var tableHeaderView: PaywallTwoTableHeaderView!
    var headerView: PaywallTwoTableHeaderView { tableHeaderView }

    init(tableView: UITableView, viewModel: PaywallTwoViewModel, interactionHelper: PaywallTwoInteractionHelper) {
        self.tableView = tableView
        self.viewModel = viewModel
        self.interactionHelper = interactionHelper
        super.init()
        setupTableView()
    }

    private func setupTableView() {
        guard let tableView = tableView else { return }

        tableHeaderView = PaywallTwoTableHeaderView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 60))
        tableHeaderView.onToggleChanged = { [weak self] isOn in
            guard let self else { return }
            viewModel.selectProduct(withTrial: isOn)
            tableView.reloadData()
            if let selected = viewModel.selectedProduct?.product {
                tableHeaderView.trialToggleSwitch.setOn(SubscriptionTrialHelper.hasTrial(selected), animated: true)
                tableHeaderView.trialToggleLabel.text = SubscriptionTrialHelper.hasTrial(selected) ? "Free trial enabled" : "Doubting? Enable free trial"
            }
        }
        tableView.tableHeaderView = tableHeaderView

        let footerView = GenericPaywallTableFooterView()
        let footerSize = footerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        footerView.frame = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: footerSize.height)
        footerView.onContinueTapped = { [weak self] in
            self?.interactionHelper.purchaseSelectedProduct()
        }
        footerView.onRestoreTapped = { [weak self] in
            self?.interactionHelper.restorePurchases()
        }
        footerView.onPrivacyTapped = { [weak self] in
            self?.interactionHelper.openPrivacy()
        }
        footerView.onTermsTapped = { [weak self] in
            self?.interactionHelper.openTerms()
        }
        tableView.tableFooterView = footerView

        tableView.dataSource = self
        tableView.delegate = self

        adjustHeaderSize()
    }

    func adjustHeaderSize() {
        guard let tableView = tableView, let header = tableView.tableHeaderView else { return }
        let targetSize = CGSize(width: tableView.bounds.width, height: UIView.layoutFittingCompressedSize.height)
        let size = header.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
        if header.frame.height != size.height {
            header.frame.size.height = size.height
            tableView.tableHeaderView = header
        }
    }

    func scrollToFooter() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let tableView = self?.tableView, let footer = tableView.tableFooterView else { return }
            tableView.layoutIfNeeded()

            let footerBottomY = footer.frame.maxY
            let visibleHeight = tableView.bounds.height - tableView.adjustedContentInset.bottom
            let offsetY = max(-tableView.adjustedContentInset.top, footerBottomY - visibleHeight)
            let bottomOffset = CGPoint(x: 0, y: offsetY)

            tableView.setContentOffset(bottomOffset, animated: true)
        }
    }

    func updateAfterProductsLoaded() {
        tableView?.reloadData()
        headerView.setBottomMessage("Get access to all our features")
        if let selected = viewModel.selectedProduct?.product {
            headerView.trialToggleSwitch.setOn(SubscriptionTrialHelper.hasTrial(selected), animated: true)
        }
        scrollToFooter()
    }
}

extension PaywallTwoTableViewHelper: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.products.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PaywallTwoTableCell", for: indexPath) as? PaywallTwoTableCell else {
            return UITableViewCell()
        }
        let item = viewModel.products[indexPath.row]
        cell.configure(duration: item.durationTitle, priceTrial: item.priceTrialLabel, weeklyPrice: item.weeklyPriceLabel)
        cell.setSelectedState(isSelected: indexPath.row == viewModel.selectedIndex)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.selectProduct(at: indexPath.row)
        tableView.reloadData()
        headerView.setBottomMessage("Get access to all our features")
        if let selected = viewModel.selectedProduct?.product {
            headerView.trialToggleSwitch.setOn(SubscriptionTrialHelper.hasTrial(selected), animated: true)
            headerView.trialToggleLabel.text = SubscriptionTrialHelper.hasTrial(selected) ? "Free trial enabled" : "Doubting? Enable free trial"
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}
