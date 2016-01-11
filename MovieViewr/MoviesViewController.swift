//
//  MoviesViewController.swift
//  MovieViewr
//
//  Created by Cris on 1/7/16.
//  Copyright © 2016 Cristobal Padilla. All rights reserved.
//

import UIKit
import AFNetworking
import EZLoadingActivity

class MoviesViewController: UIViewController, UICollectionViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    // Instance Variables
    var movies: [NSDictionary]!
    var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.searchBar.barTintColor = UIColor.blackColor()
        navigationController?.navigationBar.barStyle = UIBarStyle.BlackOpaque
        collectionView.dataSource = self
        
        EZLoadingActivity.show("Loading...", disableUI: true)
        fetchData()
        delay(0.50,closure: {EZLoadingActivity.hide()})
        
        refreshControl = UIRefreshControl()
        self.collectionView.addSubview(self.refreshControl)
        self.refreshControl.addTarget(self, action: "onRefresh", forControlEvents: UIControlEvents.ValueChanged)

    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
         //delay present for demonstration purposes
        
    }
    
    
    func fetchData () {
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = NSURL(string:"https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)")
        let request = NSURLRequest(URL: url!)
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate:nil,
            delegateQueue:NSOperationQueue.mainQueue()
        )
        
        let task : NSURLSessionDataTask = session.dataTaskWithRequest(request,
            completionHandler: { (dataOrNil, response, error) in
                if let data = dataOrNil {
                    if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                        data, options:[]) as? NSDictionary {
                            //NSLog("\n\nresponse: \(responseDictionary)")
                            
                            self.movies = (responseDictionary["results"] as! [NSDictionary])
                            self.collectionView.reloadData()
                            
                    }
                }
        });
        task.resume()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let movies = movies {
            return movies.count
            
        } else {
            return 0
            
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MovieCell", forIndexPath: indexPath) as! MovieCell
        let movie = movies![indexPath.row]
        let title = movie["title"] as! String
        let baseURL = "http://image.tmdb.org/t/p/w500"
        
        if let posterPath = movie["poster_path"] as? String {
            let imageURL = NSURL(string: baseURL + posterPath)
            cell.posterImage.setImageWithURL((imageURL)!)
        }
        cell.titleLabel.text = title
        
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        print("Selected cell number: \(indexPath.row)")
        
        let detailMovieViewController = DetailMovieViewController()
        
        detailMovieViewController.performSegueWithIdentifier("DetailMovie", sender: self)
    }
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    
    func onRefresh() {
        delay(2, closure: {
            self.fetchData()
            self.refreshControl.endRefreshing()
        })
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if let indexPath = getIndexPathOfSelectedCell() {
            let movie = movies![indexPath.row]
            let title = movie["title"] as! String
            let overview = movie["overview"] as! String
            let baseURL = "http://image.tmdb.org/t/p/w500"
            
            if segue.identifier == "DetailMovie" {
                let detailMovieViewController = segue.destinationViewController as! DetailMovieViewController
                detailMovieViewController.movieTitle = title
                detailMovieViewController.overview = overview
                
                if let posterPath = movie["poster_path"] as? String {
                    let imageURL = NSURL(string: baseURL + posterPath)
                    detailMovieViewController.posterImageURL = imageURL!
                }
            }
        }
    }
    
    func getIndexPathOfSelectedCell() -> NSIndexPath? {
        
        var indexPath:NSIndexPath?
        
        if collectionView.indexPathsForSelectedItems()?.count > 0 {
            indexPath = collectionView.indexPathsForSelectedItems()![0]
            
        }
        return indexPath
        
    }
}
