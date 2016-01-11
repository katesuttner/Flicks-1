//
//  DetailMovieViewController.swift
//  MovieViewr
//
//  Created by Cris on 1/11/16.
//  Copyright © 2016 Cristobal Padilla. All rights reserved.
//

import UIKit

class DetailMovieViewController: UIViewController {
    
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    
    var movieTitle: String = "No Title Given"
    var overview: String = "No Overview Given"
    var posterImageURL: NSURL = NSURL(fileURLWithPath: " ")
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.posterImage.setImageWithURL(posterImageURL)
        self.titleLabel.text = movieTitle
        self.overviewLabel.text = overview

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
