//
//  © 2025. Brewed with code, ☕, and a sprinkle of innovation. Rights reserved.
//
//  PS: Keep the vibes, respect the rights. 🌟
//

import UIKit
import PDFKit
import ProgressHUD

class DashboardTableViewHelper: NSObject {
    private weak var tableView: UITableView?
    private weak var viewController: DashboardViewController?
    private let viewModel: DashboardViewModel
    private var animatedIndexPaths: Set<IndexPath> = []

    init(tableView: UITableView, viewModel: DashboardViewModel, viewController: DashboardViewController) {
        self.tableView = tableView
        self.viewModel = viewModel
        self.viewController = viewController
        super.init()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.contentInset = UIEdgeInsets(top: 24, left: 0, bottom: 16, right: 0)
    }
}

extension DashboardTableViewHelper: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItems(in: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DocumentTableCell", for: indexPath) as? DocumentTableCell else {
            return UITableViewCell()
        }
        if let document = viewModel.item(at: indexPath) {
            let meta = viewModel.metaInfo(for: document)
            cell.configure(with: document, metaInfo: meta)
            cell.delegate = self
        }
        return cell
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .clear
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = viewModel.title(for: section)
        label.font = FontHelper.font(.semiBold, size: 16)
        label.textColor = Colors.mainTextColor
        headerView.addSubview(label)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 24),
            label.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -24),
            label.topAnchor.constraint(equalTo: headerView.topAnchor),
            label.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -4)
        ])
        return headerView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 32
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let vc = viewController else { return }
        SubscriptionManager.shared.checkSubscriptionStatus { isSubscribed in
            DispatchQueue.main.async {
                guard isSubscribed else {
                    vc.handlePremiumTapped()
                    return
                }
                if let document = self.viewModel.item(at: indexPath) {
                    if let _ = document.carData {
                        NavigationManager.shared.transitionToViewController(
                            identifier: "AddCarViewController",
                            from: vc,
                            push: true
                        ) { viewController in
                            if let controller = viewController as? AddCarViewController {
                                controller.document = document
                            }
                        }
                    } else {
                        NavigationManager.shared.transitionToViewController(
                            identifier: "PreviewViewController",
                            from: vc,
                            push: true
                        ) { viewController in
                            if let preview = viewController as? PreviewViewController {
                                preview.viewModel.loadPDF(at: document.fileURL)
                                preview.viewModel.updateFileName(document.fileName)
                            }
                        }
                    }
                }
            }
        }
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.alpha = 0
        cell.transform = CGAffineTransform(translationX: 0, y: 60).scaledBy(x: 0.92, y: 0.92)
        UIView.animate(
            withDuration: 1.0,
            delay: 0.06 * Double(indexPath.row),
            usingSpringWithDamping: 0.75,
            initialSpringVelocity: 0.4,
            options: [.curveEaseInOut],
            animations: {
                cell.alpha = 1
                cell.transform = .identity
            },
            completion: nil
        )
        animatedIndexPaths.insert(indexPath)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 94
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 8
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let spacer = UIView()
        spacer.backgroundColor = .clear
        return spacer
    }
}

extension DashboardTableViewHelper: DocumentTableCellDelegate {
    func documentTableCell(_ cell: DocumentTableCell, didTapMoreFor document: Document) {
        showActionSheet(for: document)
    }
}

private extension DashboardTableViewHelper {
    func showActionSheet(for document: Document) {
        guard let vc = viewController else { return }
        SubscriptionManager.shared.checkSubscriptionStatus { [weak self] isSubscribed in
            DispatchQueue.main.async {
                guard let self = self else { return }
                guard isSubscribed else {
                    vc.handlePremiumTapped()
                    return
                }

                let download = UIAlertAction(title: "Download", style: .default) { [weak self] _ in
                    self?.download(document)
                }

                let share = UIAlertAction(title: "Share", style: .default) { [weak self] _ in
                    self?.share(document)
                }

                let delete = UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
                    self?.delete(document)
                }

                let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

                if let _ = document.carData {
                    let view = UIAlertAction(title: "View", style: .default) { [weak self] _ in
                        self?.view(document)
                    }
                    AlertHelper.showAlert(on: vc, actions: [view, download, share, delete, cancel], preferredStyle: .actionSheet)
                } else {
                    AlertHelper.showAlert(on: vc, actions: [download, share, delete, cancel], preferredStyle: .actionSheet)
                }
            }
        }
    }
    
    func view(_ document: Document) {
        guard let vc = viewController else { return }
        NavigationManager.shared.transitionToViewController(
            identifier: "CarViewController",
            from: vc,
            push: true
        ) { viewController in
            if let carVC = viewController as? CarViewController {
                carVC.document = document
            }
        }
    }

    func download(_ document: Document) {
        guard let vc = viewController else { return }
        let activity: UIActivityViewController
        if let data = document.carData, let imageName = data["image"] as? String {
            let documentDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let path = documentDir.appendingPathComponent(imageName)
            activity = UIActivityViewController(activityItems: [path, data, document.fileURL], applicationActivities: nil)
        } else {
            activity = UIActivityViewController(activityItems: [document.fileURL], applicationActivities: nil)
        }
        vc.present(activity, animated: true)
    }

    func share(_ document: Document) {
        guard let vc = viewController else { return }
        ProgressHUD.animate(interaction: false)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            let activity: UIActivityViewController
            if var _ = document.carData {
                let controller = vc.storyboard!.instantiateViewController(withIdentifier: "CarViewController") as! CarViewController
                controller.document = document
                controller.loadViewIfNeeded()
                controller.view.setNeedsLayout()
                controller.view.layoutIfNeeded()
                if let fileURL = controller.generatePDF() {
                    activity = UIActivityViewController(activityItems: [fileURL], applicationActivities: nil)
                } else {
                    activity = UIActivityViewController(activityItems: [document.fileURL], applicationActivities: nil)
                }
                ProgressHUD.dismiss()
            } else {
                activity = UIActivityViewController(activityItems: [document.fileURL], applicationActivities: nil)
            }
            vc.present(activity, animated: true)
        }
    }

    func delete(_ document: Document) {
        viewModel.deleteDocument(document) { [weak self] in
            self?.tableView?.reloadData()
        }
    }
}
