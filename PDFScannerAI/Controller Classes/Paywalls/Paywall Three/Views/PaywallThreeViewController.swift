//
//  © 2025. Brewed with code, ☕, and a sprinkle of innovation. Rights reserved.
//
//  PS: Keep the vibes, respect the rights. 🌟
//

import UIKit

class PaywallThreeViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    private let viewModel = PaywallThreeViewModel()
    private let uiConfigurator = PaywallThreeUIConfigurator()
    private var interactionHelper: PaywallThreeInteractionHelper!
    private var tableViewHelper: PaywallThreeTableViewHelper!

    @objc dynamic var isDismiss: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        uiConfigurator.configureUI(for: self)
        interactionHelper = PaywallThreeInteractionHelper(viewController: self, viewModel: viewModel)
        tableViewHelper = PaywallThreeTableViewHelper(tableView: tableView, viewModel: viewModel, interactionHelper: interactionHelper)
        bindViewModel()
        viewModel.fetchProducts()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        LoadingIndicatorManager.shared.setup(for: view, navigationController: navigationController)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableViewHelper.adjustHeaderSize()
    }
}

// MARK: - Bindings
extension PaywallThreeViewController {
    private func bindViewModel() {
        viewModel.onProductsUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.tableViewHelper.updateAfterProductsLoaded()
            }
        }

        viewModel.onError = { error in
            print("Adapty error: \(error.localizedDescription)")
        }
    }
}

// MARK: - UI Setup
extension PaywallThreeViewController {
    @objc func customBackButtonTapped() {
        interactionHelper.customBackButtonTapped()
    }
}
