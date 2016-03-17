//
//  SFSearchTable.swift
//  Starfly
//
//  Created by Arturs Derkintis on 10/3/15.
//  Copyright © 2015 Starfly. All rights reserved.
//

import UIKit
import CoreData
let querie = "http://suggestqueries.google.com/complete/search?client=toolbar&hl=en&q="
class SFSearchTable: UIView, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate{
    private var googleTable : UITableView?
    private var historyTable : UITableView?
    private var array = [String]()
    let app = UIApplication.sharedApplication().delegate as! AppDelegate
    private var fetchController : NSFetchedResultsController?
    private var textForSearch = ""
    override init(frame: CGRect) {
        super.init(frame: frame)
        fetchController = NSFetchedResultsController(fetchRequest: simpleHistoryRequest, managedObjectContext: SFDataHelper.sharedInstance.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchController?.delegate = self
        
        googleTable = UITableView(frame: CGRect.zero)
        googleTable!.registerClass(SFSearchTableCell.self, forCellReuseIdentifier: "search")
        googleTable!.delegate = self
        googleTable!.dataSource = self
        googleTable!.backgroundColor = UIColor(white: 0.9, alpha: 0.0)
        googleTable?.separatorColor = UIColor.whiteColor().colorWithAlphaComponent(0.6)
        historyTable = UITableView(frame: CGRect.zero)
        historyTable!.registerClass(SFHistoryCell.self, forCellReuseIdentifier: "search2")
        historyTable!.delegate = self
        historyTable!.dataSource = self
        historyTable!.backgroundColor = UIColor(white: 0.9, alpha: 0.0)
        historyTable?.separatorColor = UIColor.whiteColor().colorWithAlphaComponent(0.6)
        let stackView = UIStackView(arrangedSubviews: [googleTable!, historyTable!])
        stackView.distribution = .FillEqually
        stackView.spacing = 20
        addSubview(stackView)
        stackView.snp_makeConstraints { (make) -> Void in
            make.top.bottom.right.left.equalTo(0)
        }
        
    }
    
    lazy var simpleHistoryRequest : NSFetchRequest = {
        let request : NSFetchRequest = NSFetchRequest(entityName: "HistoryHit")
        request.sortDescriptors = [NSSortDescriptor(key: "arrangeIndex", ascending: false)]
        
        return request
    }()
    
    func getSuggestions(forText string : String){
        if string != ""{
            textForSearch = string
            let what : NSString = string.stringByReplacingOccurrencesOfString(" ", withString: "+")
            let set = NSCharacterSet.URLQueryAllowedCharacterSet()
            let formated : String = NSString(format: "%@%@", querie, what).stringByAddingPercentEncodingWithAllowedCharacters(set)!
            
            NSURLSession.sharedSession().dataTaskWithRequest(NSURLRequest(URL: NSURL(string: formated)!)) { (data : NSData?, res, error : NSError?) -> Void in
                if error == nil{
                    
                    do {
                        let xmlDoc = try AEXMLDocument(xmlData: data! as NSData)
                        self.array.removeAll()
                        for chilcd in xmlDoc["toplevel"].children {
                            
                            let string = chilcd["suggestion"].attributes["data"] as String?
                            if let str = string{
                                self.array.append(str)
                            }
                        }
                        
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            self.googleTable!.delegate = self
                            
                            self.googleTable!.reloadData()
                        })
                        
                        
                    } catch _ {
                    }
                    
                }else{
                    print(error?.localizedDescription)
                }
                }.resume()
            let resultPredicate1 : NSPredicate = NSPredicate(format: "titleOfIt CONTAINS[cd] %@", string)
            let resultPredicate2 : NSPredicate = NSPredicate(format: "urlOfIt CONTAINS[cd] %@", string)
            
            let compound = NSCompoundPredicate(orPredicateWithSubpredicates: [resultPredicate1, resultPredicate2])
            fetchController?.fetchRequest.predicate = compound
            do{
                try fetchController?.performFetch()
                historyTable?.reloadData()
            }catch _{
                
            }
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        if tableView == googleTable{
            if array.count > 0{
                if let url = NSURL(string: parseUrl(array[indexPath.row])!){
                    NSNotificationCenter.defaultCenter().postNotificationName("OPEN", object:url)
                }
            }
        }else if tableView == historyTable{
            let object = fetchController?.objectAtIndexPath(indexPath) as! HistoryHit
            NSNotificationCenter.defaultCenter().postNotificationName("OPEN", object: object.getURL())
        }
        UIApplication.sharedApplication().delegate?.window!?.endEditing(true)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if tableView == self.googleTable{
            let cell = tableView.dequeueReusableCellWithIdentifier("search", forIndexPath: indexPath) as! SFSearchTableCell
            
            if array.count > indexPath.row{
                let text = array[indexPath.row]
                cell.label?.text = text
            }
            return cell
        }else if tableView == self.historyTable{
            let cell = tableView.dequeueReusableCellWithIdentifier("search2", forIndexPath: indexPath) as! SFHistoryCell
            let object = fetchController?.objectAtIndexPath(indexPath) as! HistoryHit
            let title = NSMutableAttributedString(string: object.titleOfIt!)
            let rangeT = (object.titleOfIt! as NSString).rangeOfString(textForSearch, options: NSStringCompareOptions.CaseInsensitiveSearch)
            title.addAttribute(NSForegroundColorAttributeName, value: UIColor.whiteColor(), range: NSMakeRange(0, title.length))
            title.addAttribute(NSForegroundColorAttributeName, value: UIColor(white: 0.75, alpha: 1.0), range: rangeT)
            let url = NSMutableAttributedString(string: object.urlOfIt!)
            let rangeU = (object.urlOfIt! as NSString).rangeOfString(textForSearch, options: NSStringCompareOptions.CaseInsensitiveSearch)
            url.addAttribute(NSForegroundColorAttributeName, value: UIColor(white: 0.9, alpha: 1.0), range: NSMakeRange(0, url.length))
            url.addAttribute(NSForegroundColorAttributeName, value: UIColor(white: 0.8, alpha: 1.0), range: rangeU)
            
            cell.titleLabel?.textColor = nil
            
            cell.urlLabel?.textColor = nil
            cell.icon?.hidden = true
            cell.titleLabel?.attributedText = title
            cell.urlLabel?.attributedText = url
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == googleTable{
            return array.count
        }else if tableView == historyTable{
            if self.fetchController!.sections != nil{
                let sectionInfo = self.fetchController!.sections![section] as NSFetchedResultsSectionInfo
                return sectionInfo.numberOfObjects
            }
        }
        return 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
