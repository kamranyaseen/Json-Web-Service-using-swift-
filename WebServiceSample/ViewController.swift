//
//  ViewController.swift
//  WebServiceSample
//
//  Created by Kamran Yaseen on 3/12/16.
//  Copyright © 2016 Kamran Yaseen. All rights reserved.
//

import UIKit

class ViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource{

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tbl.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tbl.delegate = self
        tbl.dataSource = self
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBOutlet weak var tbl: UITableView!
    @IBOutlet weak var btnWeb: UIButton!
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.TableData.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:UITableViewCell = self.tbl.dequeueReusableCellWithIdentifier("cell")! as UITableViewCell
        
        cell.textLabel?.text = self.TableData[indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("You selected cell #\(indexPath.row)!")
    }
    var TableData:Array< String > = Array < String >()
    @IBAction func CallWebService(sender: AnyObject) {
        let requestURL: NSURL = NSURL(string: "http://www.w3schools.com/angular/customers.php")!
        let urlRequest: NSMutableURLRequest = NSMutableURLRequest(URL: requestURL)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(urlRequest) {
            (data, response, error) -> Void in
            
            let httpResponse = response as! NSHTTPURLResponse
            let statusCode = httpResponse.statusCode
            
            if (statusCode == 200) {
                
                do{
                    
                    let json = try NSJSONSerialization.JSONObjectWithData(data!, options:.AllowFragments)
                    if let stations = json["records"] as? [[String: AnyObject]] {
                        
                        for station in stations {
                            
                            if let name = station["Name"] as? String {
                                
                                if let country = station["Country"] as? String {
                                    dispatch_async(dispatch_get_main_queue(),{
                                        self.TableData.append(name)
                                        self.tbl.reloadData()
                                        });
                                }
                                
                            }
                        }
                        
                    }
                    
                }catch {
                    print("Error with Json: \(error)")
                    
                }
                
            }
            
        }
        
        task.resume()
    }
}

