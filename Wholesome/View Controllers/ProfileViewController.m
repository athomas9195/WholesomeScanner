//
//  ProfileViewController.m
//  Wholesome
//
//  Created by Anna Thomas on 7/13/21.
//

#import "ProfileViewController.h"
#import <Parse/Parse.h>
#import "LoginViewController.h"
#import "SceneDelegate.h"
#import "CategoryDetailViewController.h"
#import <Parse/PFImageView.h> 

@interface ProfileViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;  //the container for the categories
@property (weak, nonatomic) IBOutlet UIView *contentView;   //the stack view 
@property (weak, nonatomic) IBOutlet UIImageView *allergies;
@property (weak, nonatomic) IBOutlet UIImageView *health;
@property (weak, nonatomic) IBOutlet UIImageView *additives;
@property (weak, nonatomic) IBOutlet UIImageView *sweeteners;
@property (weak, nonatomic) IBOutlet PFImageView *profileImage;


@property (strong, nonatomic) NSArray *allergyArray; //array of items in the categories
@property (strong, nonatomic) NSArray *healthArray; //array of items in the categories
@property (strong, nonatomic) NSArray *additiveArray; //array of items in the categories
@property (strong, nonatomic) NSArray *sweetenerArray; //array of items in the categories  

@end

@implementation ProfileViewController
- (IBAction)didTapAllergies:(id)sender {
    [self performSegueWithIdentifier:@"toAllergies" sender:self];
}
- (IBAction)didTapHealth:(id)sender {
    [self performSegueWithIdentifier:@"toHealth" sender:self];
}
- (IBAction)didTapAdditives:(id)sender {
    [self performSegueWithIdentifier:@"toAdditives" sender:self];
}
- (IBAction)didTapSweeteners:(id)sender {
    [self performSegueWithIdentifier:@"toSweeteners" sender:self];   
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.allergies.userInteractionEnabled = YES;
    self.additives.userInteractionEnabled = YES;
    self.health.userInteractionEnabled = YES;
    self.sweeteners.userInteractionEnabled = YES;
    self.profileImage.layer.cornerRadius = 38.0;
       
    // Do any additional setup after loading the view.
    
    self.allergyArray = [NSArray arrayWithObjects: @"Dairy", @"Egg",@"Fish and Shellfish",@"Soybean", @"Tree Nuts", @"Wheat",@"Sesame",@"Peanut",@"Celery",@"Gluten",@"Lupin",@"Mustard",@"Sulphites", nil];
    self.healthArray = [NSArray arrayWithObjects: @"Vegan", @"Vegetarian",@"Pescatarian",@"Pregnancy", @"Omega 3", @"Plant-based" , @"Protein-rich", @"Reduced fat", @"Reduced sugar", @"Healthy", @"No saturated fats",  nil];
    self.additiveArray = [NSArray arrayWithObjects: @"MSG", @"Azo-Colours",@"Banzote",@"Benzoic Acid", @"Food Coloring", @"Glutamate",@"Preservative", @"Nitrates", @"BHA", @"BHT", @"Potassium Benzote", @"Benzene", @"Sorbates", @"Trans fats", @"Salt", @"High fructcose corn syrup", nil];
    self.sweetenerArray = [NSArray arrayWithObjects: @"Stevia", @"Splenda",@"Maple Syrup",@"Agave Syrup", @"Xylitol", @"Erythritol",@"Yacon Syrup", @"Acesulfame", @"Advantame", @"Aspartame", @"Neotame", @"Saccharin", @"Sucralose", @"Splenda", @"Sunett", @"Newtame", @"Sweet Twin", nil]; 
          
}
 

- (IBAction)didTapLogout:(id)sender {
    [self didLogOut];
}

//allows user to log out
-(void)didLogOut {
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        // PFUser.current() will now be nil
        if (error != nil) {
            NSLog(@"User log out failed: %@", error.localizedDescription);
        } else {
            NSLog(@"User logged out successfully"); 
     
        }
    }];
    SceneDelegate *myDelegate = (SceneDelegate *)self.view.window.windowScene.delegate;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    myDelegate.window.rootViewController = loginViewController;
     
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    //set up the segues for each corresponding category 
    if ([[segue identifier] isEqualToString:@"toAllergies"]) {
        CategoryDetailViewController *detail = segue.destinationViewController;
        detail.selectedArray = self.allergyArray;
    }
    
    if ([[segue identifier] isEqualToString:@"toHealth"]) {
        CategoryDetailViewController *detail = segue.destinationViewController;
        detail.selectedArray = self.healthArray;
    }
    
    if ([[segue identifier] isEqualToString:@"toAdditives"]) {
        CategoryDetailViewController *detail = segue.destinationViewController;
        detail.selectedArray = self.additiveArray;
    } 
     
    if ([[segue identifier] isEqualToString:@"toSweeteners"]) {
        CategoryDetailViewController *detail = segue.destinationViewController;
        detail.selectedArray = self.sweetenerArray;
    }
}


@end
