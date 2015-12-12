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
    private var table : UITableView?
    private var table2 : UITableView?
    private var array = [String]()
    let app = UIApplication.sharedApplication().delegate as! AppDelegate
    private var fetchController : NSFetchedResultsController?
    private var textForSearch = ""
    override init(frame: CGRect) {
        super.init(frame: frame)
        fetchController = NSFetchedResultsController(fetchRequest: taskFetchRequest(), managedObjectContext: app.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchController?.delegate = self

        table = UITableView(frame: CGRect.zero)
        table!.registerClass(SFSearchTableCell.self, forCellReuseIdentifier: "search")
        table!.delegate = self
        table!.dataSource = self
        table!.backgroundColor = UIColor(white: 0.9, alpha: 0.6)
        table?.separatorColor = UIColor.clearColor()
        table!.layer.borderColor = UIColor.whiteColor().CGColor
        table!.layer.borderWidth = 1
        table!.layer.cornerRadius = 20
        table2 = UITableView(frame: CGRect.zero)
        table2!.registerClass(SFHistoryCell.self, forCellReuseIdentifier: "search2")
        table2!.delegate = self
        table2!.dataSource = self
        table2!.backgroundColor = UIColor(white: 0.9, alpha: 0.6)
        table2?.separatorColor = UIColor.clearColor()
        table2!.layer.borderColor = UIColor.whiteColor().CGColor
        table2!.layer.borderWidth = 1
        table2!.layer.cornerRadius = 20
        let stackView = UIStackView(arrangedSubviews: [table!, table2!])
        stackView.distribution = .FillEqually
        stackView.spacing = 35
        addSubview(stackView)
        stackView.snp_makeConstraints { (make) -> Void in
            make.top.bottom.right.left.equalTo(0)
        }
        
        
        
    }
    func taskFetchRequest() -> NSFetchRequest {
        
        let request : NSFetchRequest = NSFetchRequest(entityName: "HistoryHit")
        request.sortDescriptors = [NSSortDescriptor(key: "arrangeIndex", ascending: false)]
        
        return request
        
    }

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
                        self.table!.delegate = self

                        self.table!.reloadData()
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
            table2?.reloadData()
        }catch _{
            
        }
        }
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        if tableView == table{
            if array.count > 0{
            NSNotificationCenter.defaultCenter().postNotificationName("OPEN", object: array[indexPath.row])
            }
        }else if tableView == table2{
            let object = fetchController?.objectAtIndexPath(indexPath) as! HistoryHit
             NSNotificationCenter.defaultCenter().postNotificationName("OPEN", object: object.urlOfIt)
        }
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if tableView == self.table{
            let cell = tableView.dequeueReusableCellWithIdentifier("search", forIndexPath: indexPath) as! SFSearchTableCell
            cell.label?.text = array[indexPath.row]
            return cell
        }else if tableView == self.table2{
            let cell = tableView.dequeueReusableCellWithIdentifier("search2", forIndexPath: indexPath) as! SFHistoryCell
            let object = fetchController?.objectAtIndexPath(indexPath) as! HistoryHit
            let title = NSMutableAttributedString(string: object.titleOfIt)
            let rangeT = (object.titleOfIt as NSString).rangeOfString(textForSearch, options: NSStringCompareOptions.CaseInsensitiveSearch)
            title.addAttribute(NSForegroundColorAttributeName, value: UIColor.blackColor(), range: NSMakeRange(0, title.length))
            title.addAttribute(NSForegroundColorAttributeName, value: currentColor!, range: rangeT)
            let url = NSMutableAttributedString(string: object.urlOfIt)
            let rangeU = (object.urlOfIt as NSString).rangeOfString(textForSearch, options: NSStringCompareOptions.CaseInsensitiveSearch)
            url.addAttribute(NSForegroundColorAttributeName, value: UIColor.lightGrayColor(), range: NSMakeRange(0, url.length))
            url.addAttribute(NSForegroundColorAttributeName, value: currentColor!, range: rangeU)
            
            cell.titleLabel?.textColor = nil
            cell.urlLabel?.textColor = nil
            cell.titleLabel?.attributedText = title
            cell.urlLabel?.attributedText = url
            return cell
        }
        return UITableViewCell()
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == table{
        return array.count
        }else if tableView == table2{
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
