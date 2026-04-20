//
//  AddCarViewController.swift
//  PDFScannerAI
//
//  Created by dev on 18.02.2026.
//

import UIKit
import PDFKit

enum NavigationStatus: Int {
    case none
    case addImage
    case scan
    case saveCar
    case preview
}

class AddCarViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var addImageButton: UIButton!
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
    @IBOutlet weak var purchaseView: UIView!
    @IBOutlet weak var purchaseTextField: UITextField!
    @IBOutlet weak var vinNumberView: UIView!
    @IBOutlet weak var vinNumberTextField: UITextField!
    @IBOutlet weak var serviceTextField: UITextField!
    @IBOutlet weak var scanButton: UIButton!
    @IBOutlet weak var servicesTableView: UITableView!
    @IBOutlet weak var saveButton: UIButton!
    
    fileprivate var images: [UIImage] = []
    fileprivate var savedURL: URL? = nil
    fileprivate var originURL: URL? = nil
    fileprivate var navigationStatus: NavigationStatus = .none
    fileprivate var services: [String: Any] = [:]
    fileprivate var serviceKeys: [String] = []
    fileprivate var carImage: UIImage? = nil
    
    var document: Document? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        initView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if savedURL != nil || document != nil {
            createPreviewButton()
        }
        
        navigationStatus = .none
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        deleteDocument()
    }
    
    fileprivate func initView() {
        view.backgroundColor = Colors.backgroundColor
        titleLabel.font = FontHelper.font(.bold, size: 16)
        applyBorderCorner(addImageButton, borderColor: .gray)
        addImageButton.titleLabel?.font = FontHelper.font(.regular, size: 14)
        informationView.layer.cornerRadius = 16
        informationView.layer.masksToBounds = true
        manufacturerLabel.font = FontHelper.font(.bold, size: 15)
        typeLabel.font = FontHelper.font(.bold, size: 15)
        yearLabel.font = FontHelper.font(.bold, size: 15)
        makeLabel.font = FontHelper.font(.bold, size: 15)
        modelLabel.font = FontHelper.font(.bold, size: 15)
        manufacturerTextField.font = FontHelper.font(.regular, size: 13)
        typeTextField.font = FontHelper.font(.regular, size: 13)
        yearTextField.font = FontHelper.font(.regular, size: 13)
        makeTextField.font = FontHelper.font(.regular, size: 13)
        modelTextField.font = FontHelper.font(.regular, size: 13)
        applyBorderCorner(manufacturerTextField, cornerRadius: 4.0)
        applyPadding(manufacturerTextField)
        applyBorderCorner(typeTextField, cornerRadius: 4.0)
        applyPadding(typeTextField)
        applyBorderCorner(yearTextField, cornerRadius: 4.0)
        applyPadding(yearTextField)
        applyBorderCorner(makeTextField, cornerRadius: 4.0)
        applyPadding(makeTextField)
        applyBorderCorner(modelTextField, cornerRadius: 4.0)
        applyPadding(modelTextField)
        applyBorderCorner(purchaseView)
        purchaseTextField.font = FontHelper.font(.regular, size: 15)
        applyBorderCorner(vinNumberView)
        vinNumberTextField.font = FontHelper.font(.regular, size: 15)
        serviceTextField.font = FontHelper.font(.regular, size: 13)
        applyBorderCorner(serviceTextField)
        applyPadding(serviceTextField)
        applyBorderCorner(scanButton, borderColor: .gray)
        scanButton.titleLabel?.font = FontHelper.font(.regular, size: 14)
        saveButton.titleLabel?.font = FontHelper.font(.bold, size: 16)
        RoundedStyleUtility.apply(to: saveButton, cornerRadius: 16, backgroundColor: Colors.blueColor)
        
        if let document = document, let data = document.carData {
            manufacturerTextField.text = data["manufacturer"] as? String
            typeTextField.text = data["type"] as? String
            yearTextField.text = data["year"] as? String
            makeTextField.text = data["make"] as? String
            modelTextField.text = data["model"] as? String
            purchaseTextField.text = data["purchase"] as? String
            vinNumberTextField.text = data["vin"] as? String
            services = data["service"] as? [String: Any] ?? [:]
            serviceKeys = Array(services.keys)
            servicesTableView.reloadData()
        }
        
        if let document = document {
            let fileExtension = document.fileURL.pathExtension
            let fileName = "\(document.fileName)0.\(fileExtension)"
            let documentDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            originURL = documentDir.appendingPathComponent(fileName)
            try? FileManager.default.removeItem(at: originURL!)
            try? FileManager.default.copyItem(at: document.fileURL, to: originURL!)
        }
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
    
    fileprivate func deleteDocument() {
        if navigationStatus == .none {
            if let url = savedURL {
                deleteDocument(url)
            }
            if let document = document, let url = originURL {
                try? FileManager.default.removeItem(at: document.fileURL)
                try? FileManager.default.copyItem(at: url, to: document.fileURL)
            }
        }
    }
    
    fileprivate func deleteDocument(_ url: URL) {
        if let document = Document(fileURL: url) {
            FileChatManager.shared.deleteDocument(document) { result in
                print(result)
            }
        }
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
        guard var url = document?.fileURL ?? savedURL else {
            return
        }
        if !FileManager.default.fileExists(atPath: url.path()) {
            let fileName = url.lastPathComponent
            let documentsDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            url = documentsDir.appendingPathComponent(fileName)
        }
        navigationStatus = .preview
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
                previewVC.didRenamePDF = { oldName, newName in
                    let documentDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                    if let url = self.document?.fileURL {
                        let ext = url.pathExtension
                        self.document?.fileURL = documentDir.appendingPathComponent("\(newName).\(ext)")
                    } else if let url = self.savedURL {
                        let ext = url.pathExtension
                        self.savedURL = documentDir.appendingPathComponent("\(newName).\(ext)")
                    }
                }
            }
        }
    }
    
    fileprivate func presentImagePicker(sourceType: UIImagePickerController.SourceType) {
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = self
        picker.allowsEditing = false
        present(picker, animated: true)
    }
    
    fileprivate func pushToEditor(with image: UIImage) {
        NavigationManager.shared.transitionToViewController(
            identifier: "EditorViewController",
            from: self,
            push: true
        ) { [weak self] viewController in
            guard let self = self else { return }
            (viewController as? EditorViewController)?.isFromAddCar = true
            (viewController as? EditorViewController)?.isCarImage = true
            (viewController as? EditorViewController)?.loadImages([image])
            (viewController as? EditorViewController)?.didSavePDF = { url, images in
                self.carImage = images.first!
                if self.document == nil {
                    self.savedURL = url
                }
            }
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
        navigationStatus = .addImage
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let takePhotoAction = UIAlertAction(title: "Take a photo", style: .default) { [weak self] _ in
                self?.presentImagePicker(sourceType: .camera)
            }
            alert.addAction(takePhotoAction)
        }
        
        let pickPhotoAction = UIAlertAction(title: "Pick a photo", style: .default) { [weak self] _ in
            self?.presentImagePicker(sourceType: .photoLibrary)
        }
        alert.addAction(pickPhotoAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    @IBAction func handleScan(_ sender: UIButton) {
        navigationStatus = .scan
        guard let serviceName = serviceTextField.text, serviceName.count > 0 else {
            let okAction = UIAlertAction(title: "OK", style: .destructive)
            AlertHelper.showAlert(on: self, title: Constants.appName, message: "Please input the service name!", actions: [okAction])
            return
        }
        var pages = 0
        if let url = document?.fileURL ?? savedURL, let pdf = PDFDocument(url: url) {
            pages = pdf.pageCount
        }
        if pages == 1, services.count == 0 {
            pages = 0
        }
        let vc = self
        if Constants.isTestMode {
            let imageNames = ["test_1", "test_2", "test_3"]
            let images = imageNames.compactMap { UIImage(named: $0) }
            let resizedImages = images.compactMap{ $0.resized(to: CGSize(width: $0.size.width * 2, height: $0.size.height * 2)) }
            guard !resizedImages.isEmpty else {
                print("Failed to load test images")
                return
            }
            NavigationManager.shared.transitionToViewController(
                identifier: "EditorViewController",
                from: vc,
                push: true
            ) { viewController in
                (viewController as? EditorViewController)?.isFromAddCar = true
                (viewController as? EditorViewController)?.document = self.document
                var _images: [UIImage] = []
                _images.append(contentsOf: self.images)
                _images.append(contentsOf: resizedImages)
                (viewController as? EditorViewController)?.loadImages(_images)
                (viewController as? EditorViewController)?.didSavePDF = { url, images in
                    if let _url = self.savedURL, _url != url {
                        self.deleteDocument(_url)
                    }
                    if self.document == nil {
                        self.savedURL = url
                    }
                    let count = images.count - self.images.count
                    if count > 0 {
                        let date = DateHelper.currentDateTimeKey()
                        self.serviceKeys.append(date)
                        self.services[date] = [
                            "title": serviceName,
                            "pages": "\(pages)-\(count)"
                        ]
                        self.servicesTableView.reloadData()
                    }
                    self.images = images
                }
            }
        } else {
            DocumentScannerManager.shared.presentScanner(from: vc) { images in
                if images.isEmpty {
                    print("Failed to get scanned images")
                    return
                }
                NavigationManager.shared.transitionToViewController(
                    identifier: "EditorViewController",
                    from: vc,
                    push: true
                ) { viewController in
                    (viewController as? EditorViewController)?.isFromAddCar = true
                    (viewController as? EditorViewController)?.document = self.document
                    var _images: [UIImage] = []
                    _images.append(contentsOf: self.images)
                    _images.append(contentsOf: images)
                    (viewController as? EditorViewController)?.loadImages(_images)
                    (viewController as? EditorViewController)?.didSavePDF = { url, images in
                        if let _url = self.savedURL, _url != url {
                            self.deleteDocument(_url)
                        }
                        if self.document == nil {
                            self.savedURL = url
                        }
                        let count = images.count - self.images.count
                        if count > 0 {
                            let date = DateHelper.currentDateTimeKey()
                            self.serviceKeys.append(date)
                            self.services[date] = [
                                "title": serviceName,
                                "pages": "\(pages)-\(count)"
                            ]
                            self.servicesTableView.reloadData()
                        }
                        self.images = images
                    }
                }
            }
        }
    }
    
    @IBAction func handleSave(_ sender: UIButton) {
        navigationStatus = .saveCar
        guard let url = document?.fileURL ?? savedURL else {
            let okAction = UIAlertAction(title: "OK", style: .destructive)
            AlertHelper.showAlert(on: self, title: Constants.appName, message: "Please add images or scan receipt!", actions: [okAction])
            return
        }
        let fileName = url.deletingPathExtension().lastPathComponent
        var pages = 0
        if let pdf = PDFDocument(url: url) {
            pages = pdf.pageCount
        }
        var carData: [String: Any] = [
            "manufacturer": manufacturerTextField.text ?? "",
            "type": typeTextField.text ?? "",
            "year": yearTextField.text ?? "",
            "make": makeTextField.text ?? "",
            "model": modelTextField.text ?? "",
            "purchase": purchaseTextField.text ?? "",
            "vin": vinNumberTextField.text ?? "",
        ]
        if let image = carImage {
            let documentsDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            if !FileManager.default.fileExists(atPath: documentsDir.path) {
                try? FileManager.default.createDirectory(at: documentsDir, withIntermediateDirectories: true)
            }
            if let imageName = document?.carData?["image"] as? String {
                let destURL = documentsDir.appendingPathComponent(imageName)
                try? FileManager.default.removeItem(at: destURL)
                try? image.pngData()!.write(to: destURL)
                carData["image"] = imageName
            } else {
                let imageName = "Image_\(DateHelper.timestampString()).png"
                let destURL = documentsDir.appendingPathComponent(imageName)
                try? FileManager.default.removeItem(at: destURL)
                try? image.pngData()!.write(to: destURL)
                carData["image"] = imageName
            }
        } else if let document = document, let data = document.carData {
            carData["image"] = data["image"] as? String ?? ""
        }
        if !services.isEmpty {
            carData["service"] = services
        }
        if let _ = document {
            FileChatManager.shared.updateDocument(
                at: url,
                fileName: fileName,
                metadata: ["pages": pages],
                carData: carData
            ) { result in
                if case let .failure(error) = result {
                    print("Failed to save file info: \(error.localizedDescription)")
                } else {
                    
                }
            }
        } else {
            FileChatManager.shared.saveDocument(at: url, fileName: fileName, carData: carData, chats: []) { result in
                if case let .failure(error) = result {
                    print("Failed to save file info: \(error.localizedDescription)")
                } else {
                    
                }
            }
        }
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - UITableViewDataSource
extension AddCarViewController: UITableViewDataSource {
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
            if let document = self.document {
                
            }
        }
        return cell
    }
}

// MARK: - UITableViewDelegate
extension AddCarViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let url = document?.fileURL ?? savedURL else {
            return
        }
        navigationStatus = .preview
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
                previewVC.didRenamePDF = { oldName, newName in
                    let documentDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                    if let url = self.document?.fileURL {
                        let ext = url.pathExtension
                        self.document?.fileURL = documentDir.appendingPathComponent("\(newName).\(ext)")
                    } else if let url = self.savedURL {
                        let ext = url.pathExtension
                        self.savedURL = documentDir.appendingPathComponent("\(newName).\(ext)")
                    }
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}

// MARK: - UIImagePickerControllerDelegate & UINavigationControllerDelegate
extension AddCarViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true)
        guard let image = info[.originalImage] as? UIImage else { return }
        pushToEditor(with: image)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}

// MARK: - UITextFieldDelegate
extension AddCarViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
