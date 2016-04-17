//
//  PinterestLayout.swift
//  Pinterest
//
//  Created by Dominic's Macbook Pro on 15/04/2016.
//  Copyright © 2016 Razeware LLC. All rights reserved.
//

import UIKit

class PinterestLayout: UICollectionViewLayout {

}


// MARK: PinterestLayoutDelegate protocol

protocol PinterestLayoutDelegate {
  func collectionView(collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: NSIndexPath, WithWidth width: CGFloat) -> CGFloat
  func collectionView(collectionView: UICollectionView, heightForAnnotationAtIndexPath indexPath: NSIndexPath, WithWidth width: CGFloat) -> CGFloat
}