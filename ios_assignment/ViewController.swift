//
//  ViewController.swift
//  ios_assignment
//
//  Created by Sai Naveen Katla on 16/02/21.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    let labels = ["Users", "Enroll"]
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.selectItem(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .bottom)
        
    }

}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! Segmented_CollectionViewCell
        
        cell.name.text = labels[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (UIScreen.main.bounds.width - 5)/2, height: 45)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.3) {
            if indexPath.row == 0 {
                self.scrollView.contentOffset.x = 0
            }
            else {
                self.scrollView.contentOffset.x = UIScreen.main.bounds.width
            }
        }
    }
    
}

extension ViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let x = scrollView.contentOffset.x / UIScreen.main.bounds.width
        
        UIView.animate(withDuration: 0.1) {
            if x > 0.5 {
                self.collectionView.selectItem(at: IndexPath(row: 1, section: 0), animated: true, scrollPosition: .bottom)
            }
            else {
                self.collectionView.selectItem(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .bottom)
            }
        }
    }
}

