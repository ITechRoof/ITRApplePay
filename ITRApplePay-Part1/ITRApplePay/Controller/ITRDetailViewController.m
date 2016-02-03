//
//  ITRDetailViewController.m
//  ITRApplePay
//
//  Created by kiruthika selvavinayagam on 2/1/16.
//  Copyright © 2016 ITechRoof. All rights reserved.
//

#import "ITRDetailViewController.h"
#import <PassKit/PassKit.h>

@interface ITRDetailViewController ()<PKPaymentAuthorizationViewControllerDelegate>
{
    NSMutableArray *_supportedNetwork;
}

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *puppyImage;
@property (weak, nonatomic) IBOutlet UIButton *applePayButton;

@end

@implementation ITRDetailViewController

#pragma mark - ViewController life cycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.puppyImage.image = [UIImage imageNamed:[_dataDic objectForKey:@"image"]];
    self.titleLabel.text = [_dataDic objectForKey:@"title"];
    self.priceLabel.text = [NSString stringWithFormat:@"$%@",[_dataDic objectForKey:@"price"]];
    
    _supportedNetwork = [[NSMutableArray alloc] initWithArray:@[PKPaymentNetworkAmex, PKPaymentNetworkMasterCard, PKPaymentNetworkVisa]];
    
    self.applePayButton.hidden = ![PKPaymentAuthorizationViewController canMakePaymentsUsingNetworks:_supportedNetwork];
}

#pragma mark - selector

- (IBAction)payClicked:(id)sender {
    
    PKPaymentRequest *request = [[PKPaymentRequest alloc] init];
    request.merchantIdentifier = @"merchant.ITR.ApplePay";
    request.supportedNetworks = _supportedNetwork;
    request.merchantCapabilities = PKMerchantCapability3DS;
    request.countryCode = @"US";
    request.currencyCode = @"USD";
    request.paymentSummaryItems = @[[PKPaymentSummaryItem summaryItemWithLabel:[_dataDic objectForKey:@"title"] amount:[[NSDecimalNumber alloc] initWithString:[_dataDic objectForKey:@"price"]]],
                                    [PKPaymentSummaryItem summaryItemWithLabel:@"ITechRoof" amount:[[NSDecimalNumber alloc] initWithString:[_dataDic objectForKey:@"price"]]]
                                   ];
    PKPaymentAuthorizationViewController *applePayController = [[PKPaymentAuthorizationViewController alloc] initWithPaymentRequest:request];
    applePayController.delegate = self;
    [self presentViewController:applePayController animated:YES completion:nil];

}

#pragma mark - 

- (void)paymentAuthorizationViewController:(PKPaymentAuthorizationViewController *)controller
                       didAuthorizePayment:(PKPayment *)payment
                                completion:(void (^)(PKPaymentAuthorizationStatus status))completion {
    completion(PKPaymentAuthorizationStatusSuccess);
}

- (void)paymentAuthorizationViewControllerDidFinish:(PKPaymentAuthorizationViewController *)controller {
    [controller dismissViewControllerAnimated:YES completion:nil];
}


@end
