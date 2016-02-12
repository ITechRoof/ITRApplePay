//
//  ITRDetailViewController.m
//  ITRApplePay
//
//  Created by kiruthika selvavinayagam on 2/1/16.
//  Copyright © 2016 ITechRoof. All rights reserved.
//

#import "ITRDetailViewController.h"
#import <PassKit/PassKit.h>
#import <Stripe/Stripe.h>
#import <Stripe/Stripe+ApplePay.h>

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
    request.requiredShippingAddressFields = PKAddressFieldAll;
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
    
    [Stripe setDefaultPublishableKey:@"pk_test_1Zmxn97Mr21Au6BF1uON6NoE"];
    
    [[STPAPIClient sharedClient] createTokenWithPayment:payment completion:^(STPToken *token, NSError *error) {
        
        if(error) {
            NSLog(@"%@",error);
            completion(PKPaymentAuthorizationStatusFailure);
        }
        
        PKContact *shippingAddress = payment.shippingContact;
        
        NSURL *url = [NSURL URLWithString:@"http://127.0.0.1:5000/myPaymentEngine"];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        request.HTTPMethod = @"POST";
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        
        NSDictionary *param = @{
                                @"stripeToken" : token.tokenId,
                                @"amount"      : [[[NSDecimalNumber alloc] initWithString:[_dataDic objectForKey:@"price"]] decimalNumberByMultiplyingBy:[NSDecimalNumber numberWithInt:100]],
                                @"description" : [_dataDic objectForKey:@"title"],
                                @"shipping": @{
                                             @"city": shippingAddress.postalAddress.city,
                                             @"state": shippingAddress.postalAddress.state,
                                             @"zip": shippingAddress.postalAddress.postalCode,
                                             @"firstName": shippingAddress.name.givenName,
                                             @"lastName": shippingAddress.name.familyName}

                                    };
        [request setHTTPBody:[NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:&error]];
        
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
           
            if (error) {
                completion(PKPaymentAuthorizationStatusFailure);
            } else {
                completion(PKPaymentAuthorizationStatusSuccess);
            }
        }];
        
    }];
    

}

- (void)paymentAuthorizationViewControllerDidFinish:(PKPaymentAuthorizationViewController *)controller {
    [controller dismissViewControllerAnimated:YES completion:nil];
}


@end
