//
//  Scan.m
//  Wholesome
//
//  Created by Anna Thomas on 7/14/21.
//

#import "Scan.h"

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
@dynamic goodIngred;
@dynamic itemID;
@dynamic foodName;
@dynamic brandName; 


+ (nonnull NSString *)parseClassName {
    return @"Scan";
}
 
//UNCOMMENT LATER 
////post new upc and user info to parse backend
//+ (void) postScan: ( NSNumber * _Nullable )UPC withAllIngred: (NSArray * _Nullable)all withImage:(UIImage * _Nullable)image withCompletion: (PFBooleanResultBlock  _Nullable)completion {
//
//    Scan *newScan = [Scan new];
//    newScan.image = [self getPFFileFromImage:image];
//    newScan.author = [PFUser currentUser];
//    newScan.upc = UPC;
//    newScan.allIngred = all;
//
//    [newScan saveInBackgroundWithBlock: completion];
//}















////post new ingred to parse backend
//+ (void) postIngred: ( UIImage * _Nullable )image withCaption: ( NSString * _Nullable )caption withCompletion: (PFBooleanResultBlock  _Nullable)completion {
//
//    Post *newPost = [Post new];
//    newPost.image = [self getPFFileFromImage:image];
//    newPost.author = [PFUser currentUser];
//    newPost.caption = caption;
//    newPost.likeCount = @(0);
//    newPost.commentCount = @(0);
//
//    [newPost saveInBackgroundWithBlock: completion];
//}

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
