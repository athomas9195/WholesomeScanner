//
//  Scan.m
//  Wholesome
//
//  Created by Anna Thomas on 7/14/21.
//

#import "Scan.h"
#import "Product.h"

@implementation Scan

@dynamic scanID;
@dynamic userID;
@dynamic author;
@dynamic rating;
@dynamic safetyRating;
@dynamic image;
@dynamic allIngred;
@dynamic keyIngred;
@dynamic badIngred;
@dynamic itemID;
@dynamic foodName;
@dynamic brandName;
@dynamic upc;
@dynamic nutriscore;
@dynamic nova;
@dynamic novaGroup;
@dynamic additives;
@dynamic allergens;
@dynamic pieChartSlices;


+ (nonnull NSString *)parseClassName {
    return @"Scan";
}
    
//post new upc and scan info to parse backend
+ (void) postScan: (Product *) product withCompletion: (PFBooleanResultBlock  _Nullable)completion {

    Scan *newScan = [Scan new];

    newScan.author = [PFUser currentUser];
    newScan.upc = product.upc;
    newScan.allIngred = product.allIngred; 
    newScan.keyIngred = product.keyIngred;
    newScan.itemID = product.itemID;
    newScan.foodName = product.foodName; 
    newScan.brandName = product.brandName;
    newScan.nutriscore = product.nutriscore;
    newScan.nova = product.nova;
    newScan.novaGroup = product.novaGroup;
    newScan.additives = product.additives;
    newScan.allergens = product.allergens;
    newScan.pieChartSlices = product.pieChartSlices;
    
    newScan.image = product.image;
   
    [newScan saveInBackgroundWithBlock: completion];
}

//get the pffile from an uimage
+ (PFFileObject *)getPFFileFromImage: (UIImage * _Nullable)image {
 
    // check if image is not nil
    if (!image) {
        return nil;
    }
    
    NSData *imageData = UIImagePNGRepresentation(image);
    // get image data and check if that is not nil
    if (!imageData) {
        return nil;
    }
    
    return [PFFileObject fileObjectWithName:@"image.png" data:imageData];
}
 

@end
