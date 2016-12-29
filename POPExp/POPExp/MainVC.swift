//
//  MainVC.swift
//  POPExp
//
//  Created by Joseph Park on 12/28/16.
//  Copyright © 2016 Joseph Park. All rights reserved.
//

import UIKit

class MainVC: UIViewController, DataServiceDelegate {
    @IBOutlet weak var headerView: HeaderView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var ds: DataService = DataService.instance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        headerView.addDropShadow()
        
        ds.delegate = self
        ds.loadTacoData()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(TacoCell.self)
//        let nib = UINib(nibName: "TacoCell", bundle: nil)
//        collectionView.register(nib, forCellWithReuseIdentifier: "TacoCell")
    }
    
    func tacoDataLoaded() {
        print("data loaded")
    }
  

}

extension MainVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ds.tacoArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as TacoCell
        cell.configureCell(taco: ds.tacoArray[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("collectionView didselectItemAt")
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width:95, height: 95)
    }
    
}
