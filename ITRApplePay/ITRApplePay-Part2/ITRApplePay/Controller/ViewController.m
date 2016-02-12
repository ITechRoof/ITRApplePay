//
//  ViewController.m
//  ITRApplePay
//
//  Created by kirthi on 30/01/16.
//  Copyright © 2016 ITechRoof. All rights reserved.
//

#import "ViewController.h"
#import "ITRDetailViewController.h"

#define ITRTITLE @"title"
#define ITRPRICE @"price"
#define ITRIMAGE @"image"

@interface ITRPuppyCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *puppyImage;

@end

@implementation ITRPuppyCell

@end

@interface ViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    NSArray *_dataArray;
}
@end

@implementation ViewController

#pragma mark - ViewController life cycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    _dataArray = @[@{ITRTITLE : @"2 Month Old Puppy",
                     ITRPRICE : @"30",
                     ITRIMAGE : @"ic_puppy1"},
                   @{ITRTITLE : @"4 Month Old Puppy",
                     ITRPRICE : @"20",
                     ITRIMAGE : @"ic_puppy2"},
                   @{ITRTITLE : @"3 Month Old Puppy",
                     ITRPRICE : @"25",
                     ITRIMAGE : @"ic_puppy3"},
                   @{ITRTITLE : @"2 Month Old Puppy",
                     ITRPRICE : @"28",
                     ITRIMAGE : @"ic_puppy4"},
                   @{ITRTITLE : @"1 Month Old Puppy",
                     ITRPRICE : @"33",
                     ITRIMAGE : @"ic_puppy5"},
                   @{ITRTITLE : @"2 Month Old Puppy",
                     ITRPRICE : @"36",
                     ITRIMAGE : @"ic_puppy6"}];
}

#pragma mark - UITableViewDatasource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ITRPuppyCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ITRPuppyCell class]) forIndexPath:indexPath];
    
    NSDictionary *dataDic = _dataArray[indexPath.row];
    cell.puppyImage.image = [UIImage imageNamed:[dataDic objectForKey:ITRIMAGE]];
    cell.titleLabel.text = [dataDic objectForKey:ITRTITLE];
    cell.priceLabel.text = [NSString stringWithFormat:@"$%@",[dataDic objectForKey:ITRPRICE]];
    
    if(indexPath.row % 2 == 0) {
        [cell setBackgroundColor:[UIColor whiteColor]];
    }
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   return _dataArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    ITRDetailViewController *detailViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([ITRDetailViewController class])];
    detailViewController.dataDic = _dataArray[indexPath.row];
    [self.navigationController pushViewController:detailViewController animated:YES];
}

@end
