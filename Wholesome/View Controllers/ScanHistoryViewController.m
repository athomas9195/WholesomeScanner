//
//  ScanHistoryViewController.m
//  Wholesome
//
//  Created by Anna Thomas on 7/22/21.
//

#import "ScanHistoryViewController.h"
#import <Parse/Parse.h>
#import <Parse/ParseUIConstants.h>
#import <Parse/PFInstallation.h>
#import <Parse/PFImageView.h>
#import "Scan.h"
#import "ScanCell.h"
#import "ReportViewController.h"

@interface ScanHistoryViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollisionBehaviorDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
 
@property (nonatomic, strong) NSMutableArray *scans; //stores scans
@property (weak, nonatomic) IBOutlet PFImageView *profileImage;
@property (nonatomic, strong) Product *product; //stores scans

     
@end
 
@implementation ScanHistoryViewController
- (IBAction)didTapProduct:(id)sender {
    [self performSegueWithIdentifier:@"toReportHistory" sender:self];
} 

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.profileImage.layer.cornerRadius = 38.0; 
    
    [self getData:30];

    //set the layout of the collection view
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *) self.collectionView.collectionViewLayout;
     
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing =0;
    
 
}

//resizes the given image
- (UIImage *)resizeImage:(UIImage *)image withSize:(CGSize)size {
    UIImageView *resizeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    
    resizeImageView.contentMode = UIViewContentModeScaleAspectFill;
    resizeImageView.image = image;
    
    UIGraphicsBeginImageContext(size);
    [resizeImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}
 
 
//gets the data from parse backend
- (void)getData: (int) postLimit {
 
    // construct PFQuery
    PFQuery *scanQuery = [Scan query];
    [scanQuery orderByDescending:@"createdAt"];
    [scanQuery includeKey:@"author"];
    [scanQuery whereKey:@"author" equalTo: [PFUser currentUser]];
    scanQuery.limit = postLimit;

    // fetch data asynchronously
    [scanQuery findObjectsInBackgroundWithBlock:^(NSArray<Scan *> * _Nullable scans, NSError * _Nullable error) {
        if (scans) {
            NSMutableArray* scansMutableArray = [scans mutableCopy];
            self.scans = scansMutableArray;
            [self.collectionView reloadData];  
        }
        else {
            NSLog(@"%@", error.localizedDescription);
            NSLog(@"%@", @"CANNOT GET STUFF");
        }
    }];
}

//sets up the collection view
- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
     
    ScanCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ScanCell" forIndexPath:indexPath];
    
    Scan *scan = self.scans[indexPath.row];
    self.product =[[Product alloc] initWithScan: scan];
    cell.product = self.product;
    
    
    PFFileObject *file = cell.product.image;
    [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {

        UIImage *newImage =[UIImage imageWithData:data];
        UIImage *resized = [self resizeImage:newImage withSize:CGSizeMake(300, 300)];
        cell.imageView.image = resized;
   }];
      
    return cell;
}

//layout for collection view
-(CGSize) collectionView:(UICollectionView *) collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(nonnull NSIndexPath *)indexPath{
  
    return CGSizeMake((CGRectGetWidth(collectionView.frame))/2.0,
                      (CGRectGetWidth(collectionView.frame))/2.0);
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.scans.count; 
} 


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([[segue identifier] isEqualToString:@"toReportHistory"]){
        //report details segue
         
        UICollectionViewCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.collectionView indexPathForCell:tappedCell];
         
        Product *product = [[Product alloc] initWithScan: self.scans[indexPath.row]];
        
        ReportViewController *reportView = [segue destinationViewController];
        
        reportView.product = product;
        
    }
}


@end
