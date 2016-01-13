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
    
//    @IBDesignable class TopAlignedLabel: UILabel {
//        override func drawTextInRect(rect: CGRect) {
//            if let stringText = text {
//                let stringTextAsNSString = stringText as NSString
//                var labelStringSize = stringTextAsNSString.boundingRectWithSize(CGSizeMake(CGRectGetWidth(self.frame), CGFloat.max),
//                    options: NSStringDrawingOptions.UsesLineFragmentOrigin,
//                    attributes: [NSFontAttributeName: font],
//                    context: nil).size
//                super.drawTextInRect(CGRectMake(0, 0, CGRectGetWidth(self.frame), ceil(labelStringSize.height)))
//            } else {
//                super.drawTextInRect(rect)
//            }
//    }
//        
//        override func prepareForInterfaceBuilder() {
//            super.prepareForInterfaceBuilder()
//            layer.borderWidth = 1
//            layer.borderColor = UIColor.blackColor().CGColor
//        }
//    }
//
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.posterImage.setImageWithURL(posterImageURL)
        self.titleLabel.text = movieTitle
        self.overviewLabel.text = overview
        scrollView.contentSize.height = 1000
        webView.backgroundColor = UIColor.blackColor()
        //scrollView.sizeToFit()
        overviewLabel.sizeToFit()
        
        fetchTrailerURLString()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    func fetchTrailerURLString () -> () {
        
        EZLoadingActivity.show("Loading...", disableUI: true)
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
                            
                            self.delay(0.50,closure: {EZLoadingActivity.hide(success: true, animated: true)})
                            
                            self.trailers = (responseDictionary2["results"] as! [NSDictionary])
                            
                            if self.trailers.count > 0 {
                                let trailer = self.trailers[0]
                            
                                if let key = trailer["key"] as? String {
                                    self.trailerURLString = baseTrailerURL + key
                                    
                                }
                            }
                            
                            
                            let trailerWebFrame = "<iframe width=\"323\" height=\"245\" src=\"\(self.trailerURLString)\" marginheight=\"0\" marginwidth=\"0\" frameborder=\"0\" allowfullscreen></iframe>"
                            self.webView.loadHTMLString(trailerWebFrame, baseURL: nil)
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
