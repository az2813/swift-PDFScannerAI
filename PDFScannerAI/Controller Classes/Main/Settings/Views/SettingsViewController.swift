//
//  © 2025. Brewed with code, ☕, and a sprinkle of innovation. Rights reserved.
//
//  PS: Keep the vibes, respect the rights. 🌟
//

import UIKit

final class SettingsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var viewModel: SettingsViewModel!
    private var tableHandler: SettingsTableViewHandler!
    private var interactionHelper: SettingsInteractionHelper!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        viewModel = SettingsViewModel()
        interactionHelper = SettingsInteractionHelper(viewController: self)
        tableHandler = SettingsTableViewHandler(tableView: tableView, viewModel: viewModel, interactionHelper: interactionHelper)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
}

// MARK: - UI Setup
extension SettingsViewController {
    private func setupUI() {
        view.backgroundColor = Colors.backgroundColor
        SettingsNavigationBarHelper.configureNavigationBar(for: self)
    }
}
