//
//  DetailMovieViewController.swift
//  MovieViewr
//
//  Created by Cris on 1/11/16.
//  Copyright © 2016 Cristobal Padilla. All rights reserved.
//

import UIKit
import EZLoadingActivity

class DetailMovieViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var webView: UIWebView!
    
    // Instance Variables
    var trailers: [NSDictionary]!
    var movieTitle: String = "No Title Given"
    var overview: String = "No Overview Given"
    var posterImageURL: NSURL = NSURL(fileURLWithPath: " ")
    var trailerURLString: String = "https://www.youtube.com/embed/oAPjTHA19Kw"   // Originally defaulted to "Go", by Valley Lodge
    var movieID: String = " "

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.posterImage.setImageWithURL(posterImageURL)
        self.titleLabel.text = movieTitle
        self.overviewLabel.text = overview
        scrollView.contentSize.height = 1010
        webView.backgroundColor = UIColor.blackColor()
        
        fetchTrailerURLString()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    func fetchTrailerURLString () -> () {
        
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let baseTrailerURL = "https://www.youtube.com/embed/"
        
        let url2 = NSURL(string:"https://api.themoviedb.org/3/movie/\(movieID)/videos?api_key=\(apiKey)")
        let request2 = NSURLRequest(URL: url2!)
        let session2 = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate:nil,
            delegateQueue:NSOperationQueue.mainQueue()
        )
        
        let task1 : NSURLSessionDataTask = session2.dataTaskWithRequest(request2,
            completionHandler: { (dataOrNil, response, error) in
                if let data2 = dataOrNil {
                    if let responseDictionary2 = try! NSJSONSerialization.JSONObjectWithData(
                        data2, options:[]) as? NSDictionary {
                            //NSLog("\n\nresponse2: \(responseDictionary2)")
                            
                            self.trailers = (responseDictionary2["results"] as! [NSDictionary])
                            
                            if self.trailers.count > 0 {
                                let trailer = self.trailers[0]
                            
                                if let key = trailer["key"] as? String {
                                    self.trailerURLString = baseTrailerURL + key
                                    
                                }
                            }
                            
                            EZLoadingActivity.show("Loading...", disableUI: true)
                            let trailerWebFrame = "<iframe width=\"305\" height=\"220\" src=\"\(self.trailerURLString)\" frameborder=\"0\" allowfullscreen></iframe>"
                            self.webView.loadHTMLString(trailerWebFrame, baseURL: nil)
                            self.delay(0.50,closure: {EZLoadingActivity.hide()})
                    }
                }
        });
        task1.resume()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
