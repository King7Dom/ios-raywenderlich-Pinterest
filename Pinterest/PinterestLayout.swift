//
//  PinterestLayout.swift
//  Pinterest
//
//  Created by Dominic's Macbook Pro on 15/04/2016.
//  Copyright © 2016 Razeware LLC. All rights reserved.
//

import UIKit

class PinterestLayout: UICollectionViewLayout {

  var delegate: PinterestLayoutDelegate!
  var numberOfColumns = 2
  var cellPadding: CGFloat = 6.0

  private var layoutAttributesCache = [PinterestLayoutAttributes]()
  private var contentHeight: CGFloat = 0.0
  private var contentWidth: CGFloat {
    let insets = collectionView!.contentInset
    return CGRectGetWidth(collectionView!.bounds) - (insets.left + insets.right)
  }
  
  override class func layoutAttributesClass() -> AnyClass {
    return PinterestLayoutAttributes.self
  }

  override func prepareLayout() {
    guard let collectionView = collectionView else {
      assert(false, "There is no collectionView to prepare for!")
      return
    }
    // calculate the layout attributes if cache is empty
    if layoutAttributesCache.isEmpty {
      // fills the xOffset array with the x-coordinate for every column based on the column widths
      let columnWidth = contentWidth / CGFloat(numberOfColumns)
      var xOffset = [CGFloat]()
      for column in 0 ..< numberOfColumns {
        xOffset.append(CGFloat(column) * columnWidth)
      }
      // yOffset array tracks the y-position for every column
      // You initialize each value in yOffset to 0, since this is the offset of the first item in each column
      var column = 0
      var yOffset = [CGFloat](count: numberOfColumns, repeatedValue: 0)
      
      for sectionIdx in 0 ..< collectionView.numberOfSections() {
        for itemIdx in 0 ..< collectionView.numberOfItemsInSection(sectionIdx) {
          let indexPath = NSIndexPath(forItem: itemIdx, inSection: sectionIdx)
          // Frame calculation
          let width = columnWidth - cellPadding * 2
          let photoHeight = delegate.collectionView(collectionView, heightForPhotoAtIndexPath: indexPath, WithWidth: width)
          let annotationHeight = delegate.collectionView(collectionView, heightForAnnotationAtIndexPath: indexPath, WithWidth: width)
          let height = (cellPadding * 2) + photoHeight + annotationHeight
          let frame = CGRect(x: xOffset[column], y: yOffset[column], width: columnWidth, height: height)
          let insetFrame = CGRectInset(frame, cellPadding, cellPadding)
          // UICollectionViewLayoutAttribute
          let attributes = PinterestLayoutAttributes(forCellWithIndexPath: indexPath)
          attributes.photoHeight = photoHeight
          attributes.frame = insetFrame
          layoutAttributesCache.append(attributes)
          // expands contentHeight to account for the frame of the newly calculated item
          contentHeight = max(contentHeight, CGRectGetMaxY(frame))
          // advances the yOffset for the current column based on the frame
          yOffset[column] += height
          // advances the column so that the next item will be placed in the next column
          column = column >= (numberOfColumns - 1) ? 0 : column+1
        }
      }
      contentHeight += 100
    }
  }

  override func collectionViewContentSize() -> CGSize {
    return CGSize(width: contentWidth, height: contentHeight)
  }

  override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
    var layoutAttributes = [UICollectionViewLayoutAttributes]()
    
    for attribute in layoutAttributesCache {
      if CGRectIntersectsRect(rect, attribute.frame) {
        layoutAttributes.append(attribute)
      }
    }
    return layoutAttributes
  }
}


// MARK: PinterestLayoutDelegate protocol

protocol PinterestLayoutDelegate {
  func collectionView(collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: NSIndexPath, WithWidth width: CGFloat) -> CGFloat
  func collectionView(collectionView: UICollectionView, heightForAnnotationAtIndexPath indexPath: NSIndexPath, WithWidth width: CGFloat) -> CGFloat
}


// MARK: UICollectionViewLayoutAttributes Subclass

class PinterestLayoutAttributes: UICollectionViewLayoutAttributes {
  
    /// cell will use this to resize its image view
  var photoHeight: CGFloat = 0.0
  
  // Subclasses of UICollectionViewLayoutAttributes need to conform to the NSCopying protocol because the attribute’s objects can be copied internally. Overriding this method to guarantee that the photoHeight property is set when the object is copied.
  override func copyWithZone(zone: NSZone) -> AnyObject {
    let copy = super.copyWithZone(zone) as! PinterestLayoutAttributes
    copy.photoHeight = photoHeight
    return copy
  }
  
  // The collection view determines whether the attributes have changed by comparing the old and new attribute objects using isEqual(_:). You must implement it to compare the custom properties of your subclass. The code compares the photoHeight of both instances, and if they are equal, calls super to determine if the inherited attributes are the same. If the photo heights are different, it returns false.
  override func isEqual(object: AnyObject?) -> Bool {
    if let attributes = object as? PinterestLayoutAttributes where attributes.photoHeight == photoHeight {
      return super.isEqual(object)
    } else {
      return false
    }
  }
}