//
//  ViewController.m
//  TestApp
//
//  Created by shiva on 15/06/2017.
//  Copyright © 2017 ACUMEN. All rights reserved.
//

#import "ViewController.h"
#import "ImageDetailsCell.h"
#import "FullImageViewController.h"

@interface ViewController () <NSURLSessionDelegate> {
    NSArray* imagesArray;
    NSArray *searchResults;
}

@property(nonatomic,strong)NSMutableArray *imageURLPath;
//@property(nonatomic,strong) NSMutableData *responseData;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self getTheResponseFromAPI];
    
    [_loader startAnimating];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Getting the Response and paring
- (void)getTheResponseFromAPI {
    //    Getting the Response from API using nsurl session
    NSString *url = [NSString stringWithFormat:@"https://api.flickr.com/services/feeds/photos_public.gne?format=json"];
    NSURLSessionConfiguration *sessionConfig =
    [NSURLSessionConfiguration defaultSessionConfiguration];
    
    NSURLSession *session =
    [NSURLSession sessionWithConfiguration:sessionConfig delegate:self
                             delegateQueue:nil];
    NSURLSessionTask *task = [session dataTaskWithURL:[NSURL URLWithString:url]
                                    completionHandler:
                              ^(NSData *data, NSURLResponse *response, NSError *error) {
                                  if (data) {
                                      [_loader stopAnimating];
                                      _loader.hidden = YES;
                                      [self parseResponse:data];
                                  } else {
                                      NSLog(@"Failed to fetch %@: %@", url, error);
                                  }
                              }];
    [task resume];
    
}
- (void)parseResponse:(NSData *)responseData{
    
    NSString *dataAsString = [NSString stringWithUTF8String:[responseData bytes]];
    
    NSString *correctedJSONString = [NSString stringWithString:[dataAsString substringWithRange:NSMakeRange (15, dataAsString.length-15-1)]];
    
    correctedJSONString = [correctedJSONString stringByReplacingOccurrencesOfString:@"\\'" withString:@"‘"];
    
    NSData *correctedData = [correctedJSONString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    
    //Store the json response in NSDictionary
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:correctedData options:NSJSONReadingAllowFragments error:&error];
    if (error) {
        
    } else {
        
        imagesArray = [json objectForKey:@"items"];
        [_collectionView reloadData];
        _collectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    
}
#pragma mark - Collection view delegate methods
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return imagesArray.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"imageCell";
    ImageDetailsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    [cell updateWellnessContent:[imagesArray objectAtIndex:indexPath.row]];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat cellWidth = (self.view.bounds.size.width - 30)/3;
    return CGSizeMake(cellWidth, cellWidth+45);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"the selected cell is: %ld",indexPath.row);
    FullImageViewController *fullImage = [self.storyboard instantiateViewControllerWithIdentifier:@"FullImageViewController"];
    fullImage.imageDetailsDct = imagesArray[indexPath.row];
    [self.navigationController pushViewController:fullImage animated:YES];
    
}
#pragma mark - Search Methods
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    //    [self filterContentForSearchText:searchString
    //                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
    //                                      objectAtIndex:[self.searchDisplayController.searchBar
    //                                                     selectedScopeButtonIndex]]];
    
    return YES;
}
@end
