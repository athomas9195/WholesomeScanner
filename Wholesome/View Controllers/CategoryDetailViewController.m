//
//  CategoryDetailViewController.m
//  Wholesome
//
//  Created by Anna Thomas on 7/24/21.
//

#import "CategoryDetailViewController.h"
#import "FoodCell.h"
#import <Parse/Parse.h>

@interface CategoryDetailViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
 
@property (strong, nonatomic) NSString *category; 
  
@end

@implementation CategoryDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //table view delegate
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
  
}  
//set how many rows in timeline display
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.selectedArray count];
} 
 
//enables custom cell displays
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
     
    NSString *item = self.selectedArray[indexPath.row];
    FoodCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FoodCell" forIndexPath:indexPath];
    cell.foodLabel.text = item;
      
    return cell;
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
