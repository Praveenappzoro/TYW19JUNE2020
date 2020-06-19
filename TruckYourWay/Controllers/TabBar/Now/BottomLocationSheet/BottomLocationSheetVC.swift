//
//  BottomLocationSheetVC.swift
//  TruckYourWay
//
//  Created by Jitendra Jangir on 10/9/18.
//  Copyright © 2018 Samradh Agarwal. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
class BottomLocationSheetVC: UIViewController,UISearchBarDelegate {
    
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var searchBarLocationOtlt: UISearchBar!
    
    var arrSearchLocation: NSMutableArray  = []
    var searchResults: [String]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.searchResults = Array()
       
        self.searchBarLocationOtlt.layer.borderWidth = 2;
        self.searchBarLocationOtlt.layer.borderColor =  UIColor.init(red: 206.0/255.0, green: 114.0/255.0, blue: 54.0/255.0, alpha: 1.0).cgColor

        self.searchBarLocationOtlt.backgroundColor = UIColor.clear
        self.searchBarLocationOtlt.layer.cornerRadius = 25
        self.searchBarLocationOtlt.layer.masksToBounds = true
        
        self.tblView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        self.searchBarLocationOtlt.setTextFieldColor(color: .lightText)

        
        
        let gesture = UIPanGestureRecognizer.init(target: self, action: #selector(BottomLocationSheetVC.panGesture))
        view.addGestureRecognizer(gesture)
        
        self.navigationController!.interactivePopGestureRecognizer!.isEnabled = false
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       
        definesPresentationContext = true
        UIView.animate(withDuration: 0.3) { [weak self] in
            let frame = self?.view.frame
            let yComponent = UIScreen.main.bounds.height - 200
            
            self?.view.frame = CGRect.init(x: 0, y: yComponent, width: frame!.width, height: frame!.height)
        }
    }
    @objc func panGesture(recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: self.view)
        let y = self.view.frame.minY
        
        let total = y + translation.y;
        let yComponent = UIScreen.main.bounds.height - 200
        if(yComponent < total)
        {
            self.view.frame = CGRect.init(x: 0, y: yComponent, width: self.view.frame.width, height: self.view.frame.height)
            recognizer.setTranslation(CGPoint.zero, in: self.view)
            return
        }
        self.view.frame = CGRect.init(x: 0, y: total > 100 ? y + translation.y : 100, width: view.frame.width, height:  view.frame.height)
        recognizer.setTranslation(CGPoint.zero, in: self.view)
    }
    
    
    // MARK: - Private instance methods

    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        self.searchBarLocationOtlt.resignFirstResponder()
    }
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        return true
    }
    
    func searchBar(_ searchBar: UISearchBar,
                   textDidChange searchText: String){
        
        let placesClient = GMSPlacesClient()
        placesClient.autocompleteQuery(searchText, bounds: nil, filter: nil) { (results, error:Error?) -> Void in
            self.searchResults.removeAll()
            self.arrSearchLocation.removeAllObjects()
            if results == nil {
                return
            }
            for result in results!{
                
                if let result = result as? GMSAutocompletePrediction{
                    self.arrSearchLocation.add(result)
                    self.searchResults.append(result.attributedFullText.string)
                }
            }
            self.tblView.reloadData()
        }
    }
    
    func reloadDataWithArray(array:[String]){
        self.searchResults = array
        self.tblView.reloadData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension BottomLocationSheetVC: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        // TODO
    }
}

//MARK: - UISearchBar EXTENSION
extension UISearchBar {
    
    private func getViewElement<T>(type: T.Type) -> T? {
        
        let svs = subviews.flatMap { $0.subviews }
        guard let element = (svs.filter { $0 is T }).first as? T else { return nil }
        return element
    }
    
    func getSearchBarTextField() -> UITextField? {
        return getViewElement(type: UITextField.self)
    }
    
    func setTextColor(color: UIColor) {
        
        if let textField = getSearchBarTextField() {
            textField.textColor = color
        }
    }
    
    func setTextFieldColor(color: UIColor) {
        
        if let textField = getViewElement(type: UITextField.self) {
            switch searchBarStyle {
            case .minimal:
                textField.layer.backgroundColor = color.cgColor
                textField.layer.cornerRadius = 6
            case .prominent, .default:
                textField.backgroundColor = color
            }
        }
    }
    
    func setPlaceholderTextColor(color: UIColor) {
        
        if let textField = getSearchBarTextField() {
            textField.attributedPlaceholder = NSAttributedString(string: self.placeholder != nil ? self.placeholder! : "", attributes: [NSAttributedStringKey.foregroundColor: color])
        }
    }
    
//    func setTextFieldClearButtonColor(color: UIColor) {
//
//        if let textField = getSearchBarTextField() {
//
//            let button = textField.value(forKey: "clearButton") as! UIButton
//            if let image = button.imageView?.image {
//                button.setImage(image.transform(withNewColor: color), for: .normal)
//            }
//        }
//    }
//
//    func setSearchImageColor(color: UIColor) {
//
//        if let imageView = getSearchBarTextField()?.leftView as? UIImageView {
//            imageView.image = imageView.image?.transform(withNewColor: color)
//        }
//    }
}

