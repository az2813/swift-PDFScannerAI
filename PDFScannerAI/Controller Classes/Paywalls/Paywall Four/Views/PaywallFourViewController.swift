//
//  © 2025. Brewed with code, ☕, and a sprinkle of innovation. Rights reserved.
//
//  PS: Keep the vibes, respect the rights. 🌟
//

import UIKit

class PaywallFourViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    private let viewModel = PaywallFourViewModel()
    private let uiConfigurator = PaywallFourUIConfigurator()
    private var interactionHelper: PaywallFourInteractionHelper!
    private var tableViewHelper: PaywallFourTableViewHelper!
    
    @objc dynamic var isDismiss: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        uiConfigurator.configureUI(for: self)
        setupUI()
        interactionHelper = PaywallFourInteractionHelper(viewController: self, viewModel: viewModel)
        tableViewHelper = PaywallFourTableViewHelper(tableView: tableView, viewModel: viewModel, interactionHelper: interactionHelper)
        bindViewModel()
        viewModel.fetchProducts()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        LoadingIndicatorManager.shared.setup(for: view, navigationController: navigationController)
    }
}

// MARK: - Bindings
extension PaywallFourViewController {
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
extension PaywallFourViewController {
    private func setupUI() {
        view.backgroundColor = Colors.whiteColor
    }

    @objc func customBackButtonTapped() {
        interactionHelper.customBackButtonTapped()
    }
}
