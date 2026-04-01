//
//  © 2025. Brewed with code, ☕, and a sprinkle of innovation. Rights reserved.
//
//  PS: Keep the vibes, respect the rights. 🌟
//

import UIKit

class DashboardViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var newScanButton: UIButton!
    @IBOutlet weak var aiButton: UIButton!
    @IBOutlet weak var carScanButton: UIButton!
    
    private var interactionHelper: DashboardInteractionHelper!
    private var tableViewHelper: DashboardTableViewHelper!
    private let viewModel = DashboardViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        interactionHelper = DashboardInteractionHelper(viewController: self, viewModel: viewModel) { [weak self] in
            self?.configureNavigationBar()
        }
        tableViewHelper = DashboardTableViewHelper(tableView: tableView, viewModel: viewModel, viewController: self)
        viewModel.startObservingDocuments { [weak self] in
            self?.tableView.reloadData()
        }
        aiButton.addTarget(interactionHelper, action: #selector(DashboardInteractionHelper.handleAIButton(_:)), for: .touchUpInside)
        newScanButton.addTarget(interactionHelper, action: #selector(DashboardInteractionHelper.handleNewScanButton(_:)), for: .touchUpInside)
        carScanButton.addTarget(interactionHelper, action: #selector(DashboardInteractionHelper.handleCarScanButton(_:)), for: .touchUpInside)
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavigationBar()
        LoadingIndicatorManager.shared.setup(for: view, navigationController: navigationController)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.stopObserving()
    }
    
    @objc func handleMenu() {
        hapticFeedback()
        interactionHelper.handleMenu()
    }
    
    @objc func handlePremiumTapped() {
        hapticFeedback()
        interactionHelper.handlePremiumTapped()
    }
}

// MARK: - UI Setup
extension DashboardViewController {
    private func setupUI() {
        DashboardUIConfigurator().configureUI(for: self)
    }
    
    private func configureNavigationBar() {
        SubscriptionManager.shared.checkSubscriptionStatus { [weak self] isSubscribed in
            guard let self = self else { return }
            DispatchQueue.main.async {
                NavigationBarHelper.configureNavigationBar(
                    for: self,
                    isSubscribed: isSubscribed,
                    onPremiumTap: #selector(self.handlePremiumTapped),
                    onMenuTap: #selector(self.handleMenu)
                )
                // Reflect access state in UI elements
                DashboardUIConfigurator().applyAccessState(for: self, isSubscribed: isSubscribed)
            }
        }
    }
}
