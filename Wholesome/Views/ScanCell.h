//
//  ScanCell.h
//  Wholesome
//
//  Created by Anna Thomas on 7/22/21.
//

#import <UIKit/UIKit.h>
#import "Scan.h"

NS_ASSUME_NONNULL_BEGIN

@interface ScanCell : UICollectionViewCell
@property (nonatomic, strong) Product *product;  //stores the product 
@property (weak, nonatomic) IBOutlet UIImageView *imageView; //product image in cell
 
@end

NS_ASSUME_NONNULL_END
