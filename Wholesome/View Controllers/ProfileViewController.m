//
//  ProfileViewController.m
//  Wholesome
//
//  Created by Anna Thomas on 7/13/21.
//

#import "ProfileViewController.h"

@interface ProfileViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *contentView;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
  
    [self.scrollView addSubview:self.contentView];//if the contentView is not already inside your scrollview in your xib/StoryBoard doc

    self.scrollView.contentSize = self.contentView.frame.size; //sets ScrollView content size
    
    self.scrollView.delegate = self;
    // Do any additional setup after loading the view.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
