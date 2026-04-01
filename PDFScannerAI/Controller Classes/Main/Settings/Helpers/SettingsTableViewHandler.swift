//
//  © 2025. Brewed with code, ☕, and a sprinkle of innovation. Rights reserved.
//
//  PS: Keep the vibes, respect the rights. 🌟
//

import UIKit

final class SettingsTableViewHandler: NSObject, UITableViewDataSource, UITableViewDelegate {
    private let tableView: UITableView
    private let viewModel: SettingsViewModel
    private let interactionHelper: SettingsInteractionHelper

    init(tableView: UITableView, viewModel: SettingsViewModel, interactionHelper: SettingsInteractionHelper) {
        self.tableView = tableView
        self.viewModel = viewModel
        self.interactionHelper = interactionHelper
        super.init()
        setupTableView()
    }

    private func setupTableView() {
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 8, right: 0)
        tableView.delegate = self
        tableView.dataSource = self
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.settingsSections.count + (PurchaseManager.shared.isPurchased() ? -1 : 1)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (PurchaseManager.shared.isPurchased()) {
            return viewModel.settingsSections[section + 1].options.count
        } else {
            return section == 0 ? 1 : viewModel.settingsSections[section - 1].options.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (PurchaseManager.shared.isPurchased()) {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsTableCell", for: indexPath) as? SettingsTableCell else {
                fatalError("Could not dequeue SettingsTableCell")
            }
            let option = viewModel.settingsSections[indexPath.section + 1].options[indexPath.row]
            cell.configure(with: option)
            cell.optionSwitch.isHidden = !option.isToggle
            cell.arrowImageView.isHidden = option.isToggle
            return cell
        } else {
            if indexPath.section == 0 {
                guard let premiumCell = tableView.dequeueReusableCell(withIdentifier: "PremiumTableCell", for: indexPath) as? PremiumTableCell else {
                    fatalError("Could not dequeue PremiumTableCell")
                }
                return premiumCell
            } else {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsTableCell", for: indexPath) as? SettingsTableCell else {
                    fatalError("Could not dequeue SettingsTableCell")
                }
                let option = viewModel.settingsSections[indexPath.section - 1].options[indexPath.row]
                cell.configure(with: option)
                cell.optionSwitch.isHidden = !option.isToggle
                cell.arrowImageView.isHidden = option.isToggle
                return cell
            }
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if (PurchaseManager.shared.isPurchased()) {
            let option = viewModel.settingsSections[indexPath.section + 1].options[indexPath.row]

            switch option.title {
            case "\(Constants.appName) Premium":
                interactionHelper.presentPaywall()
            case "Privacy Policy":
                interactionHelper.openURL(Constants.policyURL)
            case "Terms of Use":
                interactionHelper.openURL(Constants.termsURL)
            case "Rate the App":
                interactionHelper.rateApp()
            case "Contact Us":
                interactionHelper.sendFeedbackEmail()
            case "Other Apps":
                interactionHelper.openURL(Constants.moreAppsURL)
            default:
                break
            }
            return
        }
        
        if indexPath.section == 0 {
            interactionHelper.presentPremium()
            tableView.deselectRow(at: indexPath, animated: true)
            return
        }

        let option = viewModel.settingsSections[indexPath.section - 1].options[indexPath.row]

        switch option.title {
        case "\(Constants.appName) Premium":
            interactionHelper.presentPaywall()
        case "Privacy Policy":
            interactionHelper.openURL(Constants.policyURL)
        case "Terms of Use":
            interactionHelper.openURL(Constants.termsURL)
        case "Rate the App":
            interactionHelper.rateApp()
        case "Contact Us":
            interactionHelper.sendFeedbackEmail()
        case "Other Apps":
            interactionHelper.openURL(Constants.moreAppsURL)
        default:
            break
        }

        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 ? (PurchaseManager.shared.isPurchased() ? 66 : UITableView.automaticDimension) : 66
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if (PurchaseManager.shared.isPurchased()) {
            let headerView = UIView()
            headerView.backgroundColor = tableView.backgroundColor

            let label = UILabel()
            label.textColor = Colors.mainTextColor
            label.font = FontHelper.font(.semiBold, size: 16)
            label.translatesAutoresizingMaskIntoConstraints = false
            
            let adjustedSection = section + 1
            label.text = viewModel.settingsSections[adjustedSection].title

            headerView.addSubview(label)
            NSLayoutConstraint.activate([
                label.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 8),
                label.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -8),
                label.topAnchor.constraint(equalTo: headerView.topAnchor, constant: section == 0 ? 16 : 0),
                label.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -4)
            ])

            return headerView
        }
        
        guard section != 0 else {
            return nil
        }

        let headerView = UIView()
        headerView.backgroundColor = tableView.backgroundColor

        let label = UILabel()
        label.textColor = Colors.mainTextColor
        label.font = FontHelper.font(.semiBold, size: 16)
        label.translatesAutoresizingMaskIntoConstraints = false

        let adjustedSection = section - 1
        label.text = viewModel.settingsSections[adjustedSection].title

        headerView.addSubview(label)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 8),
            label.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -8),
            label.topAnchor.constraint(equalTo: headerView.topAnchor),
            label.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -4)
        ])

        return headerView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? (PurchaseManager.shared.isPurchased() ? 48 : 0) : 32
    }
}
