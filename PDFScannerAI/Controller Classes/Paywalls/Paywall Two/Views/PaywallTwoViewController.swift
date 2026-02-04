//
//  © 2025. Brewed with code, ☕, and a sprinkle of innovation. Rights reserved.
//
//  PS: Keep the vibes, respect the rights. 🌟
//

import UIKit

class PaywallTwoViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    private let viewModel = PaywallTwoViewModel()
    private let uiConfigurator = PaywallTwoUIConfigurator()
    private var interactionHelper: PaywallTwoInteractionHelper!
    private var tableViewHelper: PaywallTwoTableViewHelper!
    
    @objc dynamic var isDismiss: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        uiConfigurator.configureUI(for: self)
        setupUI()
        interactionHelper = PaywallTwoInteractionHelper(viewController: self, viewModel: viewModel)
        tableViewHelper = PaywallTwoTableViewHelper(tableView: tableView, viewModel: viewModel, interactionHelper: interactionHelper)
        bindViewModel()
        viewModel.fetchProducts()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        LoadingIndicatorManager.shared.setup(for: view, navigationController: navigationController)
    }
}

// MARK: - Bindings
extension PaywallTwoViewController {
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
extension PaywallTwoViewController {
    private func setupUI() {
        view.backgroundColor = Colors.whiteColor
    }

    @objc func customBackButtonTapped() {
        interactionHelper.customBackButtonTapped()
    }
}
