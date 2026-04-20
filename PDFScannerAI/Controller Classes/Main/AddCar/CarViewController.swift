//
//  CarViewController.swift
//  PDFScannerAI
//
//  Created by dev on 11.03.2026.
//

import UIKit
import PDFKit
import ProgressHUD

class CarViewController: UIViewController {

    @IBOutlet var contentsScrollView: UIScrollView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var carImageView: UIImageView!
    @IBOutlet weak var informationView: UIView!
    @IBOutlet weak var manufacturerLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var makeLabel: UILabel!
    @IBOutlet weak var modelLabel: UILabel!
    @IBOutlet weak var manufacturerTextField: UITextField!
    @IBOutlet weak var typeTextField: UITextField!
    @IBOutlet weak var yearTextField: UITextField!
    @IBOutlet weak var makeTextField: UITextField!
    @IBOutlet weak var modelTextField: UITextField!
    @IBOutlet weak var purchaseLabel: UILabel!
    @IBOutlet weak var purchaseTextField: UITextField!
    @IBOutlet weak var vinNumberLabel: UILabel!
    @IBOutlet weak var vinNumberTextField: UITextField!
    @IBOutlet weak var servicesTableView: UITableView!
    
    @IBOutlet weak var heightCarImageConstraint: NSLayoutConstraint!
    @IBOutlet weak var heightInformationViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var heightServicesTableConstraint: NSLayoutConstraint!
    
    fileprivate var services: [String: Any] = [:]
    fileprivate var serviceKeys: [String] = []
    
    var document: Document? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        initView()
    }
    
    fileprivate func initView() {
        view.backgroundColor = Colors.backgroundColor
        applyBorderCorner(carImageView, borderColor: .clear, cornerRadius: 16.0, borderWidth: 0.0)
        titleLabel.font = FontHelper.font(.bold, size: 16)
        informationView.layer.cornerRadius = 16
        informationView.layer.masksToBounds = true
        manufacturerLabel.font = FontHelper.font(.bold, size: 15)
        typeLabel.font = FontHelper.font(.bold, size: 15)
        yearLabel.font = FontHelper.font(.bold, size: 15)
        makeLabel.font = FontHelper.font(.bold, size: 15)
        modelLabel.font = FontHelper.font(.bold, size: 15)
        purchaseLabel.font = FontHelper.font(.bold, size: 15)
        vinNumberLabel.font = FontHelper.font(.bold, size: 15)
        manufacturerTextField.font = FontHelper.font(.regular, size: 13)
        typeTextField.font = FontHelper.font(.regular, size: 13)
        yearTextField.font = FontHelper.font(.regular, size: 13)
        makeTextField.font = FontHelper.font(.regular, size: 13)
        modelTextField.font = FontHelper.font(.regular, size: 13)
        purchaseTextField.font = FontHelper.font(.regular, size: 13)
        vinNumberTextField.font = FontHelper.font(.regular, size: 13)
        
        if let document = document, let data = document.carData {
            //savedURL = document.fileURL
            manufacturerTextField.text = data["manufacturer"] as? String
            typeTextField.text = data["type"] as? String
            yearTextField.text = data["year"] as? String
            makeTextField.text = data["make"] as? String
            modelTextField.text = data["model"] as? String
            purchaseTextField.text = data["purchase"] as? String
            vinNumberTextField.text = data["vin"] as? String
            services = data["service"] as? [String: Any] ?? [:]
            serviceKeys = Array(services.keys)
            heightServicesTableConstraint.constant = 80 * CGFloat(serviceKeys.count)
            servicesTableView.reloadData()
            if let imageName = data["image"] as? String {
                let documentDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                let path = documentDir.appendingPathComponent(imageName)
                carImageView.image = UIImage(contentsOfFile: path.path())
                if let image = carImageView.image {
                    let width = UIScreen.main.bounds.width - 64
                    let height = (image.size.height / image.size.width) * width
                    heightCarImageConstraint.constant = height
                    heightInformationViewConstraint.constant = 324 + height
                }
            }
        }
        
        createPreviewButton()
    }
    
    fileprivate func applyBorderCorner(_ view: UIView, borderColor: UIColor = .darkGray, cornerRadius: CGFloat = 8.0, borderWidth: CGFloat = 1.0) {
        view.layer.borderColor = borderColor.cgColor
        view.layer.borderWidth = borderWidth
        view.layer.cornerRadius = cornerRadius
        view.layer.masksToBounds = true
    }
    
    fileprivate func applyPadding(_ textField: UITextField, width: CGFloat = 8.0) {
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: textField.frame.height))
        textField.leftView = leftView
        textField.leftViewMode = .always
        
        let rightView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: textField.frame.height))
        textField.rightView = rightView
        textField.rightViewMode = .always
    }
    
    fileprivate func createPreviewButton() {
        let label = PaddedLabel()
        label.text = "Preview"
        label.textColor = Colors.whiteColor
        label.font = FontHelper.font(.semiBold, size: 14)
        label.backgroundColor = Colors.greenColor
        label.textAlignment = .center
        label.clipsToBounds = true
        label.setHorizontalPadding(8)
        label.setVerticalPadding(6)
        label.translatesAutoresizingMaskIntoConstraints = false

        let container = UIView()
        if #available(iOS 26.0, *) {
            container.backgroundColor = .white
        }
        container.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(label)

        // Constraints are REQUIRED in iOS 26
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            label.topAnchor.constraint(equalTo: container.topAnchor),
            label.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])

        // Force layout so size is known
        container.layoutIfNeeded()

        // Rounded pill
        label.layer.cornerRadius = label.intrinsicContentSize.height / 2

        // Tap handling
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handlePreview(_:)))
        container.isUserInteractionEnabled = true
        container.addGestureRecognizer(tapGesture)
        let buttonItem = UIBarButtonItem(customView: container)
        navigationItem.rightBarButtonItem = buttonItem
    }
    
    @objc fileprivate func handlePreview(_ sender: UITapGestureRecognizer) {
        ProgressHUD.animate(interaction: false)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            guard var url = self.generatePDF() else {
                return
            }
            ProgressHUD.dismiss()
            if !FileManager.default.fileExists(atPath: url.path()) {
                let fileName = url.lastPathComponent
                let documentsDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                url = documentsDir.appendingPathComponent(fileName)
            }
            
            NavigationManager.shared.transitionToViewController(
                identifier: "PreviewViewController",
                from: self,
                push: true
            ) { viewController in
                if let previewVC = viewController as? PreviewViewController {
                    previewVC.viewModel.loadPDF(at: url)
                    let fileName = url.deletingPathExtension().lastPathComponent
                    previewVC.viewModel.updateFileName(fileName)
                    previewVC.isFromAddCar = true
                    previewVC.isTitleEditable = false
                }
            }
        }
    }
    
    func generatePDF() -> URL? {
        guard let document else { return nil }
        guard var image = contentsScrollView.headImage(informationView.frame.maxY + 20.0) else { return document.fileURL }
        let pdf = PDFDocument()
        var pageSize = CGSize.zero
        let pdfURL = URL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!).appendingPathComponent("Car.pdf")
        try? FileManager.default.removeItem(at: pdfURL)
        if document.services.count == 0 {
            let pdfPage = PDFPage(image: image)
            pdf.insert(pdfPage!, at: 0)
            pdf.write(to: pdfURL)
        } else {
            if let doc = PDFDocument(url: document.fileURL) {
                var index = 0
                for row in 0 ..< services.count {
                    autoreleasepool {
                        let key = serviceKeys[row]
                        if let service = services[key] as? [String: String], let pages = service["pages"]?.components(separatedBy: "-") {
                            let start = Int(pages[0]) ?? 0
                            let count = Int(pages[1]) ?? 0
                            for i in 0 ..< count {
                                let receipt = doc.page(at: start + i)!
                                if i == 0 {
                                    let pdfPage = createPDFPage(row: row, page: receipt)
                                    pdf.insert(pdfPage.0, at: index)
                                    if pageSize == .zero {
                                        pageSize = pdfPage.1
                                    }
                                } else {
                                    pdf.insert(receipt.resized(), at: index)
                                }
                                index += 1
                            }
                        }
                    }
                }
            }
            if pageSize == .zero {
                if let pdfPage = PDFPage(image: image) {
                    pdf.insert(pdfPage, at: 0)
                }
            } else {
                image = image.resized(to: CGSize(width: pageSize.width, height: image.size.height / image.size.width * pageSize.width))
                if let pdfPage = PDFPage(image: image) {
                    pdf.insert(pdfPage, at: 0)
                }
            }
            pdf.write(to: pdfURL)
        }
        return pdfURL
    }
    
    func createPDFPage(row: Int, page: PDFPage) -> (PDFPage, CGSize) {
        
        guard let pageImage = page.renderImage(scale: 1.0) else {
            AlertHelper.showAlert(on: self, message: "Failed to render pdf page to image", actions: [UIAlertAction(title: "OK", style: .default)])
            return (page, .zero)
        }
        var pageSize = CGSize(width: pageImage.size.width, height: pageImage.size.height)
        guard let cell = servicesTableView.dataSource?.tableView(servicesTableView, cellForRowAt: IndexPath(row: row, section: 0)) else {
            AlertHelper.showAlert(on: self, message: "Failed to get image cell", actions: [UIAlertAction(title: "OK", style: .default)])
            return (page, pageSize)
        }
        let cellImage = imageFromCell(cell)
        guard cellImage.size.width > 0 else {
            return (page, pageSize)
        }
        let cellRatio = pageSize.width / cellImage.size.width
        let cellHeight = cellRatio * cellImage.size.height
        pageSize.height += cellHeight
        
        let renderer = UIGraphicsImageRenderer(size: pageSize)
        
        let pdfImage = renderer.image { context in
            let cgContext = context.cgContext
            
            // White background
            UIColor.white.setFill()
            cgContext.fill(CGRect(origin: .zero, size: pageSize))
            
            // Draw cell at TOP
            let cellRect = CGRect(
                x: 0,
                y: 10 * cellRatio,
                width: pageSize.width,
                height: cellHeight
            )
            
            cellImage.draw(in: cellRect)
            
            let pageHeight = pageImage.size.height
            let pageRect = CGRect(x: 0, y: cellHeight, width: pageSize.width, height: pageHeight)
            pageImage.draw(in: pageRect)
        }
        
        guard let pdfPage = PDFPage(image: pdfImage) else {
            AlertHelper.showAlert(on: self, message: "Failed to make pdf page from image", actions: [UIAlertAction(title: "OK", style: .default)])
            return (page, pageSize)
        }
        
        return (pdfPage, pageSize)
    }
    
    func imageFromCell(_ cell: UITableViewCell) -> UIImage {
        cell.layoutIfNeeded()
        
        let size = cell.contentView.systemLayoutSizeFitting(
            CGSize(width: cell.bounds.width, height: UIView.layoutFittingCompressedSize.height)
        )
        
        cell.frame = CGRect(origin: .zero, size: size)
        //cell.contentView.bounds = cell.bounds
        cell.setNeedsLayout()
        cell.layoutIfNeeded()
        
        let format = UIGraphicsImageRendererFormat.default()
        format.scale = 0.0
        let renderer = UIGraphicsImageRenderer(size: size, format: format)
        
        return renderer.image { context in
            //cell.drawHierarchy(in: cell.bounds, afterScreenUpdates: true)
            cell.layer.render(in: context.cgContext)
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: - IBAction
    @IBAction func handleAddImage(_ sender: UIButton) {
        
    }
}

// MARK: - UITableViewDataSource
extension CarViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return serviceKeys.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VehicleTableCell", for: indexPath) as! VehicleTableCell
        cell.selectionStyle = .none
        let date = serviceKeys[indexPath.row]
        cell.date = date.components(separatedBy: "_")[0]
        cell.service = services[date] as! [String: String]
        cell.didTapReceipt = {
            
        }
        return cell
    }
}

// MARK: - UITableViewDelegate
extension CarViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let url = document?.fileURL else {
            return
        }
        NavigationManager.shared.transitionToViewController(
            identifier: "PreviewViewController",
            from: self,
            push: true
        ) { viewController in
            if let previewVC = viewController as? PreviewViewController {
                let key = self.serviceKeys[indexPath.row]
                let service = self.services[key] as! [String: String]
                let pages = service["pages"]?.components(separatedBy: "-")
                previewVC.viewModel.loadPDF(at: url, start: Int(pages![0]) ?? 0, count: Int(pages![1]) ?? 0)
                let fileName = url.deletingPathExtension().lastPathComponent
                previewVC.viewModel.updateFileName(fileName)
                previewVC.isFromAddCar = true
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}

extension UIScrollView {
    
    func toImage() -> UIImage? {
        UIGraphicsBeginImageContext(contentSize)
        
        let savedContentOffset = contentOffset
        let savedFrame = frame
        let saveVerticalScroll = showsVerticalScrollIndicator
        let saveHorizontalScroll = showsHorizontalScrollIndicator
        
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        contentOffset = CGPoint.zero
        frame = CGRect(x: 0, y: 0, width: contentSize.width, height: contentSize.height)
        
        layer.render(in: UIGraphicsGetCurrentContext()!)
        
        for view in subviews {
            if let tableView = view as? UITableView {
                for row in 0 ..< tableView.numberOfRows(inSection: 0) {
                    let indexPath = IndexPath(row: row, section: 0)
                    
                    guard let cell = tableView.dataSource?.tableView(tableView, cellForRowAt: indexPath) else { continue }
                    
                    cell.bounds = CGRect(x: 0, y: 0, width: bounds.width, height: tableView.delegate!.tableView!(tableView, heightForRowAt: indexPath))
                    cell.layoutIfNeeded()
                    
                    UIGraphicsBeginImageContextWithOptions(cell.bounds.size, false, UIScreen.main.scale)
                    cell.drawHierarchy(in: cell.bounds, afterScreenUpdates: true)
                    let image = UIGraphicsGetImageFromCurrentImageContext()
                    UIGraphicsEndImageContext()
                    
                    var frame = cell.convert(cell.bounds, to: self)
                    frame.origin.x = tableView.frame.minX
                    image?.draw(in: frame)
                }
            }
        }
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        contentOffset = savedContentOffset
        frame = savedFrame
        showsVerticalScrollIndicator = saveVerticalScroll
        showsHorizontalScrollIndicator = saveHorizontalScroll
        
        UIGraphicsEndImageContext()
        
        return image
    }
    
    func headImage(_ height: CGFloat) -> UIImage? {
        let size = CGSize(width: contentSize.width, height: height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        
        let savedContentOffset = contentOffset
        let savedFrame = frame
        let saveVerticalScroll = showsVerticalScrollIndicator
        let saveHorizontalScroll = showsHorizontalScrollIndicator
        
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        contentOffset = CGPoint.zero
        frame = CGRect(x: 0, y: 0, width: contentSize.width, height: contentSize.height)
        
        layer.render(in: UIGraphicsGetCurrentContext()!)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        contentOffset = savedContentOffset
        frame = savedFrame
        showsVerticalScrollIndicator = saveVerticalScroll
        showsHorizontalScrollIndicator = saveHorizontalScroll
        
        UIGraphicsEndImageContext()
        
        return image
    }
}
