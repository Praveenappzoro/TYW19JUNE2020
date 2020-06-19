//
//  ConstractServiceProviderVC.swift
//  TruckYourWay
//
//  Created by Anil Choudhary on 20/02/19.
//  Copyright © 2019 Samradh Agarwal. All rights reserved.
//

import UIKit
import QuickLook
import AVFoundation
import PDFKit
import Alamofire

@available(iOS 11.0, *)
class ConstractServiceProviderVC: UIViewController,PDFDocumentDelegate {
    
    @IBOutlet weak var pdfView: PDFView?
    
    @IBOutlet weak var viewPopUpInitial: UIView!
    @IBOutlet weak var subViewPopUpInitial: UIView!
    
    @IBOutlet weak var textFieldInitialName: CustomTxtField!
    
    @IBOutlet weak var viewPopUpSignName: UIView!
    @IBOutlet weak var subViewPopUpSignName: UIView!
    
    @IBOutlet weak var textFieldFullName: CustomTxtField!
    
    @IBOutlet weak var btnSubmitOtlt: CustomButton!
    
    var loginUserData:LoggedInUser!
    var localUrlPDF:URL!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.downloadPDF()
        self.initUI()
        // Do any additional setup after loading the view.
    }    
    
    @IBAction func actionSubmit(_ sender: Any)
    {
        if(self.btnSubmitOtlt.titleLabel?.text == "INITIAL")
        {
            self.viewPopUpInitial.isHidden = false
            self.viewPopUpSignName.isHidden = true
        }
        else if(self.btnSubmitOtlt.titleLabel?.text == "SIGNATURE")
        {
            self.viewPopUpInitial.isHidden = true
            self.viewPopUpSignName.isHidden = false
        }
        else
        {
            self.uploadPdfMediaOnServer()
            //            self.submitPDF()
        }
        
    }
    
    func downloadPDF()
    {
        DispatchQueue.main.async {
            
            let url = URL(string: BSE_URL_PDF_File)
            var urls = URL(string: "")
            let pdfData = try? Data.init(contentsOf: url!)
            let resourceDocPath = (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)).last! as URL
            let pdfNameFromUrl = "\(tywAgreementPdf).pdf"
            let actualPath = resourceDocPath.appendingPathComponent(pdfNameFromUrl)
            do {
                try pdfData?.write(to: actualPath, options: .atomic)
                print("pdf successfully saved!")
                if #available(iOS 10.0, *) {
                    do {
                        let docURL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                        let contents = try FileManager.default.contentsOfDirectory(at: docURL, includingPropertiesForKeys: [.fileResourceTypeKey], options: .skipsHiddenFiles)
                        for url in contents {
                            if url.description.contains("\(tywAgreementPdf).pdf") {
                                
                                self.localUrlPDF = url
                                self.showPDF(localPath:self.localUrlPDF)
                                // its your file! do what you want with it!
                                //                                self.showPDF(url)
                                
                            }
                        }
                    } catch {
                        print("could not locate pdf file !!!!!!!")
                    }
                }
                
            } catch {
                print("Pdf could not be saved")
            }
        }
        
    }
    
    func initUI()
    {
        self.subViewPopUpInitial.layer.cornerRadius = 5
        self.subViewPopUpSignName.layer.cornerRadius = 5
        self.subViewPopUpInitial.layer.masksToBounds = true
        self.subViewPopUpSignName.layer.masksToBounds = true
        
        self.btnSubmitOtlt.setTitle("INITIAL", for: .normal)
        
        USER_DEFAULT.set("", forKey: pdfInitialName)
        USER_DEFAULT.set("", forKey: pdfSignaturelName)
    }
    
    func classForPage() -> AnyClass {
        return SampleWatermark.self
    }
    
    func uploadPdfMediaOnServer()
    {
        var dictData:NSMutableDictionary = NSMutableDictionary()
        self.startAnimating("")
        
        //            let dataImg = UIImagePNGRepresentation(reizedImage)
        let resourceDocPath = (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)).last! as URL
        let pdfNameFromUrl = "\(tywAgreementPdf)Edited.pdf"
        let actualPath = resourceDocPath.appendingPathComponent(pdfNameFromUrl)
        
        let pdfData = try! Data(contentsOf: actualPath.asURL())
        let headers = ["Content-type": "multipart/form-data",
                       "Content-Disposition" : "form-data"]
        Alamofire.upload(multipartFormData: { multipartFormData in
            //Parameter to Upload files
            multipartFormData.append(pdfData, withName: "theFile",fileName: "SignaturePDF.pdf" , mimeType: "application/pdf")
            
            for (key, value) in dictData
            {
                multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key as! String)
            }
            
        }, usingThreshold:UInt64.init(),
           to: BSE_URL_UploadMedia,
           method: .post,
           headers: headers, //pass header dictionary here
            encodingCompletion: { (result) in
                
                switch result {
                case .success(let upload, _, _):
                    print("the status code is :")
                    
                    upload.uploadProgress(closure: { (progress) in
                        
                    })
                    
                    upload.responseJSON { response in
                        DispatchQueue.main.async {
                            self.stopAnimating()
                        }
                        print("the resopnse code is : \(String(describing: response.response?.statusCode))")
                        print("the response is : \(response)")
                        if(response.response != nil)
                        {
                            if let dd = self.convertToDictionary(responseData: response.data!) as NSDictionary?
                            {
                                let fileName = dd.value(forKey: "filename") as? String
                                
                                self.submitPDF(fileName:fileName!)
                                
                            }
                            self.stopAnimating()
                            
                        }
                        
                    }
                    break
                case .failure(let encodingError):
                    print("the error is  : \(encodingError.localizedDescription)")
                    self.stopAnimating()
                    break
                }
        })
        
    }
    
    
    func submitPDF(fileName:String)
    {
        
        if let userData = USER_DEFAULT.object(forKey: "userData") as? Data
        {
            guard let loginUpdate = try? JSONDecoder().decode(LoggedInUser.self, from: userData) else {return}
            self.loginUserData = loginUpdate
        }
        else
        {
            return
        }
        let parameters = [
            "user_id":self.loginUserData.user_id ?? "",
            "isp_contract":fileName,
            "access_token":self.loginUserData.access_token ?? "",
            "refresh_token":self.loginUserData.refresh_token ?? "",
            ] as [String : Any]
        DispatchQueue.main.async(execute: {
            APIManager.sharedInstance.getDataFromAPI(BSE_URL_UPDATE_ISP_CONTRACT, .post, parameters) { (result, data, json, error, msg) in
                
                switch result
                {
                case .Failure:
                    DispatchQueue.main.async(execute: {
                        
                    })
                    break
                case .Success:
                    DispatchQueue.main.async(execute: {
                        
                        AppDelegateVariable.appDelegate.isLogin(isLogin:true)
                        
                    })
                    break
                }
                
            }
        })        
    }
    
    func showPDF(localPath:URL)
    {
        
        if let document = PDFDocument(url: localPath) {
            // Center document on gray background
            pdfView?.autoScales = true
            pdfView?.backgroundColor = UIColor.lightGray
            // 1. Set delegate
            document.delegate = self
            pdfView?.document = document
        }
    }
    
    func convertImageFromString(screenShot: UIImage)
    {
        guard let page = pdfView!.currentPage else { return }
        let pageBounds = page.bounds(for: .cropBox)
        let imageBounds = CGRect(x: pageBounds.maxX-200, y: 50, width: screenShot.size.width, height: screenShot.size.height)
        let imageStamp = ImageStampAnnotation(with:screenShot, forBounds: imageBounds, withProperties: nil)
        page.addAnnotation(imageStamp)
    }
}

@available(iOS 11.0, *)
extension ConstractServiceProviderVC : UITextFieldDelegate
{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if string == "" {
            return true
        }
        
        if(textField == self.textFieldInitialName && (textField.text?.length)! >= 2)
        {
            return false
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if(textField == self.textFieldInitialName)
        {
            if((textField.text?.length)! <= 1 )
            {
//                self.textFieldInitialName.becomeFirstResponder()
                self.view!.makeToast("Please enter minimum 2 characters.", duration: 1.0, position: .center)

                return
            }
            
            USER_DEFAULT.set(self.textFieldInitialName.text, forKey: pdfInitialName)
            self.drawTextOnPDF()
            
            //
            ////            self.convertImageFromString(screenShot: LetterImageGenerator.imageWith(name: self.textFieldInitialName.text)!)
            //            self.showPDF(localPath: self.localUrlPDF)
            self.viewPopUpInitial.isHidden = true
            self.viewPopUpSignName.isHidden = true
            self.btnSubmitOtlt.setTitle("SIGNATURE", for: .normal)
            
            //drawTextOnPDF(self.textFieldInitialName.text ?? "")
        }
        if(textField == self.textFieldFullName)
        {
            
            if((textField.text?.length)! <= 1 )
            {
//                self.textFieldInitialName.becomeFirstResponder()
                self.view!.makeToast("Please add signature", duration: 1.0, position: .center)
                
                return
            }
            USER_DEFAULT.set(self.textFieldFullName.text, forKey: pdfSignaturelName)
            self.drawTextOnPDF()
            
            ////            self.convertImageFromString(screenShot: LetterImageGenerator.imageWith(name: self.textFieldInitialName.text)!)
            //            self.showPDF(localPath: self.localUrlPDF)
            self.viewPopUpInitial.isHidden = true
            self.viewPopUpSignName.isHidden = true
            self.btnSubmitOtlt.setTitle("SUBMIT", for: .normal)
        }
    }
    
    func drawTextOnPDF() {
        
        let resourceDocPath = (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)).last! as URL
        let pdfNameFromUrl = "\(tywAgreementPdf)Edited.pdf"
        let actualPath = resourceDocPath.appendingPathComponent(pdfNameFromUrl)
        
        
        let pdfURL = NSURL(fileURLWithPath: self.localUrlPDF.path); // URL of the existing PDF
        if let pdf:CGPDFDocument = CGPDFDocument(pdfURL as CFURL) { // Create a PDF Document
            
            let _newURL = actualPath.path; // New URL to save editable PDF
            let _url = NSURL(fileURLWithPath: _newURL)
            var _mediaBox:CGRect = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 1000); // mediabox which will set the height and width of page
            let _writeContext = CGContext(_url, mediaBox: &_mediaBox, nil) // get the context
            
            //Run a loop to the number of pages you want
            for i in 0...pdf.numberOfPages
            {
                if let _page = pdf.page(at: i) { // get the page number
                    var _pageRect:CGRect = _page.getBoxRect(CGPDFBox.mediaBox) // get the page rect
                    _writeContext!.beginPage(mediaBox: &_pageRect); // begin new page with given page rect
                    _writeContext!.drawPDFPage(_page); // draw content in page
                    
                    //Draw text
                    //if i == atPage {
                    let strName =  USER_DEFAULT.value(forKey: pdfInitialName) ?? ""
                    let strSignature =  USER_DEFAULT.value(forKey: pdfSignaturelName) ?? ""
                    
                    var string: NSString = ""
                    
                    
                    if i == 5 {
                        string = strName as! NSString
                        let attributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.black, .font: UIFont(name: "Carybe", size: 22) ?? UIFont.boldSystemFont(ofSize: 22)]
                        let stringSize = string.size(withAttributes: attributes)
                        
                        
                        UIGraphicsPushContext(_writeContext!);
                        _writeContext?.setFillColor(UIColor.black.cgColor)
                        _writeContext?.translateBy(x: (_pageRect.size.width - stringSize.width) / 2, y: _pageRect.size.height)
                        _writeContext?.scaleBy(x: 1.0, y: -1.0)
                        
                        string.draw(at: CGPoint(x: _pageRect.midX-95, y: 40), withAttributes: attributes)
                        string.draw(at: CGPoint(x: _pageRect.midX-95, y: 238), withAttributes: attributes)
                        UIGraphicsPopContext();
                        UIGraphicsEndPDFContext();
                    } else if i == 12 {
                        string = strSignature as! NSString
                        
                        let attributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.black, .font: UIFont(name: "KaufmannBT-Regular", size: 40) ?? UIFont.boldSystemFont(ofSize: 30)]
                        let stringSize = string.size(withAttributes: attributes)
                        
                        UIGraphicsPushContext(_writeContext!);
                        _writeContext?.setFillColor(UIColor.black.cgColor)
                        _writeContext?.translateBy(x: (_pageRect.size.width - stringSize.width) / 2, y: _pageRect.size.height)
                        _writeContext?.scaleBy(x: 1.0, y: -1.0)
                        
                        
                        string.draw(at: CGPoint(x: _pageRect.minX-120, y: 250), withAttributes: attributes)
                        UIGraphicsPopContext();
                        UIGraphicsEndPDFContext();
                    }
                    
                    
                    // }
                    
                    _writeContext!.endPage(); // end the current page
                }
            }
            
            
        }
        
        self.showPDF(localPath: actualPath)
    }
    
    func savePdf() {
        let pdfData = try? Data.init(contentsOf: self.localUrlPDF)
        let resourceDocPath = (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)).last! as URL
        let pdfNameFromUrl = "\(tywAgreementPdf).pdf"
        let actualPath = resourceDocPath.appendingPathComponent(pdfNameFromUrl)
        do {
            try pdfData?.write(to: actualPath, options: .atomic)
            print("pdf successfully saved!")
            
            if #available(iOS 10.0, *) {
                do {
                    let docURL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                    let contents = try FileManager.default.contentsOfDirectory(at: docURL, includingPropertiesForKeys: [.fileResourceTypeKey], options: .skipsHiddenFiles)
                    for url in contents {
                        if url.description.contains("\(tywAgreementPdf).pdf") {
                        }
                    }
                } catch {
                    print("could not locate pdf file !!!!!!!")
                }
            }
            
        } catch {
            print("Pdf could not be saved")
        }
        
    }
    
}

class LetterImageGenerator: NSObject {
    class func imageWith(name: String?) -> UIImage? {
        let frame = CGRect(x: 0, y: 0, width: 200, height: 50)
        let nameLabel = UILabel(frame: frame)
        nameLabel.textAlignment = .center
        nameLabel.backgroundColor = .clear
        nameLabel.textColor = .black
        nameLabel.font = UIFont(name: "Carybe", size: 22)
        nameLabel.text = name
        UIGraphicsBeginImageContext(frame.size)
        if let currentContext = UIGraphicsGetCurrentContext() {
            nameLabel.layer.render(in: currentContext)
            let nameImage = UIGraphicsGetImageFromCurrentImageContext()
            return nameImage
        }
        return nil
    }
}

