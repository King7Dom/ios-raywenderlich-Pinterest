//
//  PinterestLayout.swift
//  Pinterest
//
//  Created by Dominic's Macbook Pro on 15/04/2016.
//  Copyright © 2016 Razeware LLC. All rights reserved.
//

import UIKit

class PinterestLayout: UICollectionViewLayout {

  var delegate: PinterestLayoutDelegate
  var numberOfColumns = 2
  var cellPadding: CGFloat = 6.0

  private var layoutAttributesCache = [UICollectionViewLayoutAttributes]()
  private var contentHeight: CGFloat = 0.0
  private var contentWidth: CGFloat {
    let insets = collectionView!.contentInset
    return CGRectGetWidth(collectionView!.bounds) - (insets.left + insets.right)
  }
  
  init(delegate: PinterestLayoutDelegate) {
    self.delegate = delegate
    
    super.init()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func prepareLayout() {
  }

  override func collectionViewContentSize() -> CGSize {
    return CGSizeZero
  }

  override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
    return nil
  }
}


// MARK: PinterestLayoutDelegate protocol

protocol PinterestLayoutDelegate {
  func collectionView(collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: NSIndexPath, WithWidth width: CGFloat) -> CGFloat
  func collectionView(collectionView: UICollectionView, heightForAnnotationAtIndexPath indexPath: NSIndexPath, WithWidth width: CGFloat) -> CGFloat
}