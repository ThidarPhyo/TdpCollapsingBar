//
//  ViewController.swift
//  TdpCollapsingBar
//
//  Created by Thidar Phyo on 10/24/20.
//

import UIKit
import Kingfisher

class ViewController: UIViewController, AACarouselDelegate {
 
    @IBOutlet weak var collapsingViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var slideshowView: AACarousel!
    
    
    private var lastContentOffset: CGFloat = 0.0
    private var titleList = ["Myanmar","Japan", "Chinese", "Thai Dramas", "Korean"]
    
    var titleArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let pathArray = ["http://www.gettyimages.ca/gi-resources/images/Embed/new/embed2.jpg",
                                "https://ak.picdn.net/assets/cms/97e1dd3f8a3ecb81356fe754a1a113f31b6dbfd4-stock-photo-photo-of-a-common-kingfisher-alcedo-atthis-adult-male-perched-on-a-lichen-covered-branch-107647640.jpg",
                                "https://imgct2.aeplcdn.com/img/800x600/car-data/big/honda-amaze-image-12749.png",
                                "http://www.conversion-uplift.co.uk/wp-content/uploads/2016/09/Lamborghini-Huracan-Image-672x372.jpg",
                                "ic_cover"]
        self.titleArray = ["picture 1","picture 2","picture 3","picture 4","picture 5"]
        slideshowView.delegate = self
        slideshowView.setCarouselData(paths: pathArray,  describedTitle: titleArray, isAutoScroll: true, timer: 5.0, defaultImage: "ic_1")
                //optional methods
        slideshowView.setCarouselOpaque(layer: false, describedTitle: false, pageIndicator: false)
        slideshowView.setCarouselLayout(displayStyle: 0, pageIndicatorPositon: 5, pageIndicatorColor: nil, describedTitleColor: nil, layerColor: nil)
        self.collectionView.selectItem(at: IndexPath(row: 0, section: 0), animated: false, scrollPosition: .left)
       
    }
    //require method
    func downloadImages(_ url: String, _ index:Int) {
        
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.kf.setImage(with: URL(string: url)!, placeholder: UIImage.init(named: "defaultImage"), options: [.transition(.fade(1))], progressBlock: nil, completionHandler: { (downloadImage, error, cacheType, url) in
            if (downloadImage != nil){
                self.slideshowView.images[index] = downloadImage!
            }
        })
        
    }
    
    //optional method (interaction for touch image)
    func didSelectCarouselView(_ view:AACarousel ,_ index:Int) {
        
        let alert = UIAlertView.init(title:"Alert" , message: titleArray[index], delegate: self, cancelButtonTitle: "OK")
        alert.show()
        
        //startAutoScroll()
        //stopAutoScroll()
    }
    
    //optional method (show first image faster during downloading of all images)
    func callBackFirstDisplayView(_ imageView: UIImageView, _ url: [String], _ index: Int) {
        
        imageView.kf.setImage(with:  URL(string: url[index]), placeholder: UIImage(named: ""), options: [.transition(.fade(1))])
        
    }
    
    func startAutoScroll() {
       //optional method
        slideshowView.startScrollImageView()
        
    }
    
    func stopAutoScroll() {
        //optional method
        slideshowView.stopScrollImageView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension ViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContentCell", for: indexPath) as? ContentTableViewCell
        cell?.lblContent.text = "Bagan-Myo-thu \(indexPath.row)"
        
        return cell ?? ContentTableViewCell()
    }
}

extension ViewController: UITableViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == self.tableView {
            if (scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.frame.size.height)) {
                //Scrolled to bottom
                UIView.animate(withDuration: 0.3) {
                    self.collapsingViewHeightConstraint.constant = 0.0
                    self.view.layoutIfNeeded()
                }
            }
            else if (scrollView.contentOffset.y < self.lastContentOffset || scrollView.contentOffset.y <= 0) && (self.collapsingViewHeightConstraint.constant != 220.0)  {
                //Scrolling up, scrolled to top
                UIView.animate(withDuration: 0.3) {
                    self.collapsingViewHeightConstraint.constant = 220.0
                    self.view.layoutIfNeeded()
                }
            }
            else if (scrollView.contentOffset.y > self.lastContentOffset) && self.collapsingViewHeightConstraint.constant != 0.0 {
                //Scrolling down
                UIView.animate(withDuration: 0.3) {
                    self.collapsingViewHeightConstraint.constant = 0.0
                    self.view.layoutIfNeeded()
                }
            }
            self.lastContentOffset = scrollView.contentOffset.y
        }
    }
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titleList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TitleCell", for: indexPath) as? TitleCollectionViewCell
        cell?.lblTitle.text = titleList[indexPath.row]
        
        return cell ?? TitleCollectionViewCell()
    }
}

