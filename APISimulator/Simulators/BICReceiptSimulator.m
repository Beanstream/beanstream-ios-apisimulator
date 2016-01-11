//
//  BICReceiptSimulator.m
//  BeanstreamAPISimulator
//
//  Created by DLight on 2015-10-26.
//  Copyright © 2015 Beanstream. All rights reserved.
//

#import "BICReceiptSimulator.h"
#import "BICReceiptResponse.h"

@implementation BICReceiptSimulator

static NSString *const BICCustomerReceipt =
@"<!DOCTYPE html><head><title>Mobile Transaction Receipt</title></head><body style=\"font-family: "
"Helvetica, Arial, sans-serif; font-size: medium;\"><table style=\"border-spacing: 1px; padding: 0 "
"0 10px 0\" ><tr><td style=\"border-bottom-color: black; border-bottom-style: solid; "
"border-bottom-width: 2px;\"><table style=\"border-bottom-color: black; border-bottom-style: "
"solid; border-bottom-width: 2px; width: 100%; padding: 1px; border-spacing: 1px;\" ><tr><td "
"style=\"border-bottom-color: black; border-bottom-style: solid; border-bottom-width: 2px; "
"font-size: x-large; padding: 10px 0 0 10px;\" colspan=\"2\"> Mobile Transaction Receipt "
"</td></tr><tr><td style=\"padding: 5px 0 5px 10px; width: 50%; vertical-align: top;\"><b>Magic "
"Happens</b></td><td style=\"padding: 5px 0 5px 10px; width: 50%; vertical-align: top;\">Victoria, "
"CA</td></tr></table><table style=\"width: 100%; padding: 1px; border-spacing: 1px;\" ><tr><td "
"style=\"padding: 5px 0 0 10px; width: 50%; vertical-align: top;\"><b>Order Date:</b></td><td "
"style=\"padding: 5px 0 0 10px; width: 50%; vertical-align: top;\">2015-09-22 5:55:43 "
"PM</td></tr><tr><td style=\"padding: 5px 0 0 10px; width: 50%; vertical-align: top;\"><b>Bank "
"Auth Number:</b></td><td style=\"padding: 5px 0 0 10px; width: 50%; vertical-align: "
"top;\">076879</td></tr><tr><td style=\"padding: 5px 0 0 10px; width: 50%; vertical-align: "
"top;\"><b>Order Total:</b></td><td style=\"padding: 5px 0 0 10px; width: 50%; vertical-align: "
"top;\">31.38</td></tr><tr><td style=\"padding: 5px 0 0 10px; width: 50%; vertical-align: "
"top;\"><b>Card Type:</b></td><td style=\"padding: 5px 0 0 10px; width: 50%; vertical-align: "
"top;\">VI</td></tr><tr><td style=\"padding: 5px 0 0 10px; width: 50%; vertical-align: "
"top;\"><b>Transaction Type:</b></td><td style=\"padding: 5px 0 0 10px; width: 50%; "
"vertical-align: top;\">Purchase</td></tr><tr><td style=\"padding: 5px 0 0 10px; width: 50%; "
"vertical-align: top;\"><b>Last Four Digits:</b></td><td style=\"padding: 5px 0 0 10px; width: "
"50%; vertical-align: top;\">0019</td></tr><tr><td colspan=\"2\"></td></tr></table><table "
"style=\"border-top-color: black; border-top-style: solid; border-top-width: 2px; width: "
"100%;\"><tr><td style=\"padding: 5px 0 5px 10px;\"></td></tr><tr><td style=\"padding: 5px 0 5px "
"10px;\"><img alt=\"location\" "
"src=\"https://maps.googleapis.com/maps/api/"
"staticmap?&markers=48.438127,-123.366941&size=300x250&zoom=16&key=AIzaSyAFnt_"
"2NlyxQb43C7Ik6adauLjrLloRvWM\"></td></tr></table></td></tr></table><table style=\"font-size:10px; "
"border:0; width: 200px;\"><tr><td colspan=\"2\" style=\"text-align: center;\">Magic "
"Happens</td></tr><tr><td colspan=\"2\" style=\"text-align: center;\">123 Street</td></tr><tr><td "
"colspan=\"2\" style=\"text-align: center;\">Victoria</td></tr><tr><td "
"colspan=\"2\">&nbsp;</td></tr><tr><td>Term Id: 01260906</td></tr><tr><td>Merchant "
"#:</td></tr><tr><td>&nbsp;&nbsp;&nbsp;1143152</td></tr><tr><td>Invoice #: "
"10011448</td></tr><tr><td></td></tr><tr><td>VISA Purchase </td></tr><tr><td>Card "
"#:</td></tr><tr><td>&nbsp; &nbsp; &nbsp; XXXXXXXXXXXX0019</td></tr><tr><td>AID: </td></tr><tr><td "
"colspan=\"2\">&nbsp;</td></tr><tr><td>00APPROVED-THANK YOU</td></tr><tr><td "
"colspan=\"2\">&nbsp;</td></tr><tr><td>AMOUNT&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;31.38 "
"CAD</td></tr><tr><td colspan=\"2\">&nbsp;</td></tr><tr><td "
"colspan=\"2\">&nbsp;</td></tr><tr><td>Ref.#: RRN 000000710475 S</td></tr><tr><td>Auth.#: "
"076879</td></tr><tr><td>Date: 2015-09-22</td></tr><tr><td>Time: 5:55:43 PM</td></tr><tr><td "
"colspan=\"2\">&nbsp;</td></tr><tr><td colspan=\"2\">&nbsp;</td></tr><tr><td colspan=\"2\" "
"style=\"text-align: center;\">***CUSTOMER COPY***</td></tr></table></body></html>";

static NSString *const BICMerchantReceipt =
@"<!DOCTYPE html><head><title>Mobile Transaction Receipt</title></head><body style=\"font-family: "
"Helvetica, Arial, sans-serif; font-size: medium;\"><table style=\"border-spacing: 1px; padding: 0 "
"0 10px 0\" ><tr><td style=\"border-bottom-color: black; border-bottom-style: solid; "
"border-bottom-width: 2px;\"><table style=\"border-bottom-color: black; border-bottom-style: "
"solid; border-bottom-width: 2px; width: 100%; padding: 1px; border-spacing: 1px;\" ><tr><td "
"style=\"border-bottom-color: black; border-bottom-style: solid; border-bottom-width: 2px; "
"font-size: x-large; padding: 10px 0 0 10px;\" colspan=\"2\"> Mobile Transaction Receipt "
"</td></tr><tr><td style=\"padding: 5px 0 5px 10px; width: 50%; vertical-align: top;\"><b>Magic "
"Happens</b></td><td style=\"padding: 5px 0 5px 10px; width: 50%; vertical-align: top;\">Victoria, "
"CA</td></tr></table><table style=\"width: 100%; padding: 1px; border-spacing: 1px;\" ><tr><td "
"style=\"padding: 5px 0 0 10px; width: 50%; vertical-align: top;\"><b>Order Date:</b></td><td "
"style=\"padding: 5px 0 0 10px; width: 50%; vertical-align: top;\">2015-09-22 5:55:43 "
"PM</td></tr><tr><td style=\"padding: 5px 0 0 10px; width: 50%; vertical-align: top;\"><b>Bank "
"Auth Number:</b></td><td style=\"padding: 5px 0 0 10px; width: 50%; vertical-align: "
"top;\">076879</td></tr><tr><td style=\"padding: 5px 0 0 10px; width: 50%; vertical-align: "
"top;\"><b>Order Total:</b></td><td style=\"padding: 5px 0 0 10px; width: 50%; vertical-align: "
"top;\">31.38</td></tr><tr><td style=\"padding: 5px 0 0 10px; width: 50%; vertical-align: "
"top;\"><b>Card Type:</b></td><td style=\"padding: 5px 0 0 10px; width: 50%; vertical-align: "
"top;\">VI</td></tr><tr><td style=\"padding: 5px 0 0 10px; width: 50%; vertical-align: "
"top;\"><b>Transaction Type:</b></td><td style=\"padding: 5px 0 0 10px; width: 50%; "
"vertical-align: top;\">Purchase</td></tr><tr><td style=\"padding: 5px 0 0 10px; width: 50%; "
"vertical-align: top;\"><b>Last Four Digits:</b></td><td style=\"padding: 5px 0 0 10px; width: "
"50%; vertical-align: top;\">0019</td></tr><tr><td colspan=\"2\"></td></tr></table><table "
"style=\"border-top-color: black; border-top-style: solid; border-top-width: 2px; width: "
"100%;\"><tr><td style=\"padding: 5px 0 5px 10px;\"></td></tr><tr><td style=\"padding: 5px 0 5px "
"10px;\"><img alt=\"location\" "
"src=\"https://maps.googleapis.com/maps/api/"
"staticmap?&markers=48.438127,-123.366941&size=300x250&zoom=16&key=AIzaSyAFnt_"
"2NlyxQb43C7Ik6adauLjrLloRvWM\"></td></tr></table></td></tr></table><table style=\"font-size:10px; "
"border:0; width: 200px;\"><tr><td colspan=\"2\" style=\"text-align: center;\">Magic "
"Happens</td></tr><tr><td colspan=\"2\" style=\"text-align: center;\">123 Street</td></tr><tr><td "
"colspan=\"2\" style=\"text-align: center;\">Victoria</td></tr><tr><td "
"colspan=\"2\">&nbsp;</td></tr><tr><td>Term Id: 01260906</td></tr><tr><td>Merchant "
"#:</td></tr><tr><td>&nbsp;&nbsp;&nbsp;1143152</td></tr><tr><td>Invoice #: "
"10011448</td></tr><tr><td></td></tr><tr><td>VISA Purchase </td></tr><tr><td>Card "
"#:</td></tr><tr><td>&nbsp; &nbsp; &nbsp; XXXXXXXXXXXX0019</td></tr><tr><td>AID: </td></tr><tr><td "
"colspan=\"2\">&nbsp;</td></tr><tr><td>00APPROVED-THANK YOU</td></tr><tr><td "
"colspan=\"2\">&nbsp;</td></tr><tr><td>AMOUNT&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;31.38 "
"CAD</td></tr><tr><td colspan=\"2\">&nbsp;</td></tr><tr><td colspan=\"2\">&nbsp;</td></tr><tr><td "
"colspan=\"2\"></td></tr><tr><td colspan=\"2\"><img width=200px alt=\"Signature\" "
"src=\"data:image/jpg;base64,/9j/4AAQSkZJRgABAQEAYABgAAD/"
"2wBDAAgGBgcGBQgHBwcJCQgKDBQNDAsLDBkSEw8UHRofHh0a "
"HBwgJC4nICIsIxwcKDcpLDAxNDQ0Hyc5PTgyPC4zNDL/2wBDAQkJCQwLDBgNDRgyIRwhMjIyMjIy "
"MjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjL/wAARCABXAMgDASIA "
"AhEBAxEB/8QAHwAAAQUBAQEBAQEAAAAAAAAAAAECAwQFBgcICQoL/8QAtRAAAgEDAwIEAwUFBAQA "
"AAF9AQIDAAQRBRIhMUEGE1FhByJxFDKBkaEII0KxwRVS0fAkM2JyggkKFhcYGRolJicoKSo0NTY3 "
"ODk6Q0RFRkdISUpTVFVWV1hZWmNkZWZnaGlqc3R1dnd4eXqDhIWGh4iJipKTlJWWl5iZmqKjpKWm "
"p6ipqrKztLW2t7i5usLDxMXGx8jJytLT1NXW19jZ2uHi4+Tl5ufo6erx8vP09fb3+Pn6/8QAHwEA "
"AwEBAQEBAQEBAQAAAAAAAAECAwQFBgcICQoL/8QAtREAAgECBAQDBAcFBAQAAQJ3AAECAxEEBSEx "
"BhJBUQdhcRMiMoEIFEKRobHBCSMzUvAVYnLRChYkNOEl8RcYGRomJygpKjU2Nzg5OkNERUZHSElK "
"U1RVVldYWVpjZGVmZ2hpanN0dXZ3eHl6goOEhYaHiImKkpOUlZaXmJmaoqOkpaanqKmqsrO0tba3 "
"uLm6wsPExcbHyMnK0tPU1dbX2Nna4uPk5ebn6Onq8vP09fb3+Pn6/9oADAMBAAIRAxEAPwD3+iii "
"gAooooAKKKKACiiigAooooAKKKKACiiigAoopCyhgCwBPQE9aAFooooAKKKKACiiigAooooAKKKK "
"ACiiigAooooAKKKKACiiigAooooAKKKiubmCzt3uLmaOGCMbnkkYKqj1JPAoAlrM1zxDpPhuwN5q "
"17HbRZwu7lpG/uqo5Y+wFcxJ4z1LxLK1r4IsVniztk1m8Urax9j5Y+9Kw9uPetHQ/A9lpt8NW1G4 "
"m1jWyPmv7zBKe0SfdjHsv50AZou/F/jE5sI38MaO3S5uYw97MP8AZjPyxA+rZPtWZ4r+HOgab4O1 "
"nVVF3PrFraSXMWp3V3JJOsiKWVgxOByB0AFenVx/xRuGg+G+sxx8y3Ua2ka/3mldYwP/AB6gDotF "
"upL3QtPu5v8AWz20cr/VlBP86vVDaW62tnBbp92KNYx9AMVNQAUUVHNNFbQSTzyJFFGpZ3dgqqB1 "
"JJ6CgCSoobm3uGlWCeKVon8uQI4Yo3XacdDyOK4V9W1rx872/h+WbSvDudsmsbcTXQ7i3U/dX/po "
"fw6V1uhaDpvhzTVsNLtlggB3N3aRj1ZmPLMfU0AaVFFFABRRRQAUUUUAFFFFABRRRQBl674h0zw3 "
"ZpearO8Fu8gjDrC8mCQTztBwODyeKwP+Fs+Bf+hhgB9DFID/AOg12dJtUnO0flQBxn/C2PBR+5rD "
"SH0jtJ2/klJ/ws7SZuNO0rX9RY9BbaVL/NwoH512tFAHEnWvHWs/Lpnhu10eE9LnV7gO+PURRZ5+ "
"rCnW/wAPIb24S78Wanc+IblDuWK4AjtYz/swL8v/AH1mu0ooAbHGkUaxxoqIowqqMAD0Ap1FFABX "
"E+NP+Jp4p8J+H15V706jcAdo7dcjPsXZB+FdtXEeF/8Aid+PPEniFvmhtWXR7M+0fzTEfWRsf8Bo "
"A7eiiqmp6nZaPp0+oahcx21pAu6SWQ4Cj+p9u9AD76/tdMsZ729uI7e1gQvLLIcKoHeuFgsL34kX "
"Ed/q8Utp4VRg9ppr/K9/jkSzjsndU79TUljp174+voNY122kttAgYSafpUow05HSacfqqdup9++o "
"AaiJFGscaqiKAqqowAB0AFOoooAKKKKACiiigArH8UXuoaZ4eutR01YZJ7RfPaKXpLGvLqD/AAkq "
"Dg+uK2K5bxbpWpa5e6TpyGBdDaYy6oJJMNKi4KRAd1Y9fYY74IBY8Jalda7p8muSsy2d8wksbcgZ "
"jgAwpbH8TcseeMgdq6GuX8C6VdeHvD8mm3jwKkd5cNapG+4JA0hZFz9D+HFdL5sf/PRfzoAfRTPN "
"j/56L+dHmx/89F/OgB9FM82P/nov50ebH/z0X86AH0UzzY/+ei/nR5sf/PRfzoAfRTPNj/56L+dH "
"mx/89F/OgB9FM82P/nov50ebH/z0X86AKOv6mui+HdS1R8Ys7aSfHrtUkD9Ky/h9pbaR4E0i2lyb "
"h4BPOT1Msnzvn8WNXPFGlx+IvC2p6OLlImvLd4lkJyFJHBPtmuat/EHjiOxisF8HQC+jQRm7k1KM "
"WnAxvGMuR324zQB1eu6/pvhvTHv9TuBFEp2qoGXkY9ERerMewFcvpugal4s1KDXvFkHkWsDeZp2i "
"E5WE9pZuzSeg6L9at6L4RCaomu+JNRTVtbUHynxtgtAe0Mfb/ePzH2rrfNj/AOei/nQA+imebH/z "
"0X86PNj/AOei/nQA+imebH/z0X86VXVvusD9DQA6iiigAooooAKzNU8OaNrckcmqaZbXbxAqjTRh "
"ioPUCtOigDnP+EB8Jf8AQvad/wB+BR/wgPhL/oXtO/78CujooA5z/hAfCX/Qvad/34FH/CA+Ev8A "
"oXtO/wC/Aro6KAOc/wCEB8Jf9C9p3/fgUf8ACA+Ev+he07/vwK6OigDnP+EB8Jf9C9p3/fgUf8ID "
"4S/6F7Tv+/Aro6KAOc/4QHwl/wBC9p3/AH4FH/CA+Ev+he07/vwK6OigDnP+EB8Jf9C9p3/fgUf8 "
"ID4S/wChe07/AL8CujooA5z/AIQHwl/0L2nf9+BR/wAID4S/6F7Tv+/Aro6KAOc/4QHwl/0L2nf9 "
"+BR/wgPhL/oXtO/78CujooA5z/hAfCX/AEL2nf8AfgUf8ID4S/6F7Tv+/Aro6KAOc/4QHwl/0L2n "
"f9+BV/S/Dei6JLJLpemWtpJIoV2hjClgOcGtSigAooooAKKKKACiiigAooooAKKKKACiiigAoooo "
"AKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigD/9k=\"></td></tr><tr><td colspan=\"2\">I agree to pay "
"the above total amount according to the cardissuer agreement. Retain this copy for your "
"records.</td></tr><tr><td colspan=\"2\">&nbsp;</td></tr><tr><td>Ref.#: RRN 000000710475 "
"S</td></tr><tr><td>Auth.#: "
"076879</td></tr><tr><td></td></tr><tr><td></td></tr><tr><td></td></tr><tr><td></td></tr><tr><td></"
"td></tr><tr><td></td></tr><tr><td></td></tr><tr><td></td></tr><tr><td>Date: 2015-09-22 "
"</td></tr><tr><td>Time: 5:55:43 PM </td></tr><tr><td colspan=\"2\">&nbsp;</td></tr><tr><td "
"colspan=\"2\">&nbsp;</td></tr><tr><td colspan=\"2\" style=\"text-align: center;\">***MERCHANT "
"COPY***</td></tr></table></body></html>";

@synthesize simulatorMode, headless;

#pragma mark - BICSimulator protocol methods

- (NSArray *)supportedModes
{
    return @[@(SimulatorModeCreateSessionCreated),
             @(SimulatorModeCreateSessionInvalid),
             @(SimulatorModeCreateSessionExpired),
             @(SimulatorModeCreateSessionEncryptionFailure),
             @(SimulatorModeCreateSessionHTTPError),
             @(SimulatorModeCreateSessionNetworkError)];
}

- (NSString *)labelForSimulatorMode:(SimulatorMode)simulatorMode
{
    NSString *label = nil;
    
    switch (self.simulatorMode) {
        case SimulatorModeCreateSessionCreated:
            label = @"Authorized";
            break;
        case SimulatorModeCreateSessionInvalid:
            label = @"Invalid Credentials";
            break;
        case SimulatorModeCreateSessionExpired:
            label = @"Password Expired";
            break;
        case SimulatorModeCreateSessionEncryptionFailure:
            label = @"Authorized with Encryption Failure";
            break;
        case SimulatorModeCreateSessionHTTPError:
            label = @"HTTP Error";
            break;
        case SimulatorModeCreateSessionNetworkError:
            label = @"Network Error";
            break;
        default:
            label = @"Developer Issue --> Unknown Mode";
            break;
    }
    
    return label;
}

#pragma mark - BICCreateSession overrides

- (void)getPrintReceipt:(NSString *)transactionId
               language:(NSString *)language
                success:(void (^)(BICReceiptResponse *response))success
                failure:(void (^)(NSError *error))failure
{
    //TODO Validate
    
    BICReceiptResponse *response = [self getSuccessfulResponse];
    
    if (response.isSuccessful) {
        success(response);
    } else {
        failure([[NSError alloc] init]);
    }
}

- (void)sendEmailReceipt:(NSString *)transactionId
                   email:emailAddress
                language:(NSString *)language
                 success:(void (^)(BICReceiptResponse *response))success
                 failure:(void (^)(NSError *error))failure
{
    //TODO Validate
    
    BICReceiptResponse *response = [self getSuccessfulResponse];
    
    if (response.isSuccessful) {
        success(response);
    } else {
        failure([[NSError alloc] init]);
    }
}

- (BICReceiptResponse *)getSuccessfulResponse
{
    BICReceiptResponse *response = [[BICReceiptResponse alloc] init];
    
    response.isSuccessful = YES;
    
    response.code = 1;
    response.version = @"1.0";
    response.message = @"";
    
    response.receiptCustomerCopy = BICCustomerReceipt;
    response.receiptMerchantCopy = BICMerchantReceipt;
    
    return response;
}

@end
