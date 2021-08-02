//
//  Scan.m
//  Wholesome
//
//  Created by Anna Thomas on 7/14/21.
//

#import "Scan.h"
#import "Product.h"

@implementation Scan

@dynamic scanID; //parse id
@dynamic userID; //user parse id
@dynamic author; //user who scanned the product
@dynamic rating; //the rating of the product
@dynamic safetyRating; //how safe it is to consume
@dynamic image; //the product image
@dynamic allIngred; //the full ingredients list
@dynamic keyIngred; //the key ingredients
@dynamic badIngred; //the ingredients to avoid
@dynamic itemID; //the product id
@dynamic foodName; //the product name
@dynamic brandName; //the brand name
@dynamic upc; //the upc code
@dynamic nutriscore; //the nutriscore value
@dynamic nova; //the nova value
@dynamic novaGroup; //the nova value description
@dynamic additives; //the additives present in the product
@dynamic allergens; //the allergens in the product
@dynamic pieChartSlices; //array used to generate pie chart on report 


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
