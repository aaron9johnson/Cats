//
//  ViewController.m
//  Cats
//
//  Created by Aaron Johnson on 2017-10-23.
//  Copyright © 2017 Aaron Johnson. All rights reserved.
//

#import "ViewController.h"
#import "MyCollectionViewCell.h"
#import "Photo.h"

@interface ViewController ()
@property NSMutableArray *photos;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _photos = [NSMutableArray new];
    [self catsFromFlicker];
}
-(void)catsFromFlicker{
    //https://api.flickr.com/services/rest/?method=flickr.photos.search&format=json&nojsoncallback=1&api_key=b9e8e163b77044fdadc7c1e29f8286c8&tags=cat
    NSURL *url = [NSURL URLWithString:@"https://api.flickr.com/services/rest/?method=flickr.photos.search&format=json&nojsoncallback=1&api_key=b9e8e163b77044fdadc7c1e29f8286c8&tags=cat"];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    urlRequest.HTTPMethod = @"GET";
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *urlSession = [NSURLSession sessionWithConfiguration:configuration];
    NSURLSessionDataTask *dataTask = [urlSession dataTaskWithRequest:urlRequest
                                                   completionHandler:^(NSData * _Nullable data,
                                                                       NSURLResponse * _Nullable response,
                                                                       NSError * _Nullable error)
                                      {
                                          // Here we access HTTP data , Status codes, and JSON
                                          // If we don't get a 200 status code, error will not be nil
                                          if (error)
                                          {
                                              NSLog(@"Error getting data");
                                          }
                                          else
                                          {
                                              NSError *jsonError = nil;
                                              NSDictionary *readStuffDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
                                              
                                              if (jsonError)
                                              {
                                                  NSLog(@"jsonError: %@", jsonError.localizedDescription);
                                              }
                                              else
                                              {
                                                  NSLog(@"They are: %lu", (unsigned long)readStuffDict.count);
                                                  NSDictionary *temp = [readStuffDict objectForKey:@"photos"];
                                                  NSArray *temp2 = [temp objectForKey:@"photo"];
                                                  for(NSDictionary *any in temp2){
                                                      Photo *new = [Photo new];
                                                      NSString *url = [NSString stringWithFormat:@"https://farm%@.staticflickr.com/%@/%@_%@.jpg", [any objectForKey:@"farm"],[any objectForKey:@"server"],[any objectForKey:@"id"],[any objectForKey:@"secret"]];
                                                      new.url = [NSURL URLWithString:url];
                                                      new.title = [any objectForKey:@"title"];
                                                      [self.photos addObject:new];
                                                  }
                                                  
                                                  // Tell the main queue, to do somthing
                                                  dispatch_async(dispatch_get_main_queue(), ^{
                                                      [self.myCollectionView reloadData];
                                                  });
                                              }
                                          }
                                          
                                      }];
    
    [dataTask resume]; // Like saying start my request
    
    NSLog(@"view did load");
}
- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    MyCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"myCell" forIndexPath:indexPath];
    
    Photo *temp = self.photos[indexPath.item];
    cell.myImageView.image = temp.image;
    cell.myLabel.text = temp.title;
    
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.photos.count;
}
//
//- (void)encodeWithCoder:(nonnull NSCoder *)aCoder {
//    <#code#>
//}
//
//- (void)traitCollectionDidChange:(nullable UITraitCollection *)previousTraitCollection {
//    <#code#>
//}
//
//- (void)preferredContentSizeDidChangeForChildContentContainer:(nonnull id<UIContentContainer>)container {
//    <#code#>
//}
//
//- (CGSize)sizeForChildContentContainer:(nonnull id<UIContentContainer>)container withParentContainerSize:(CGSize)parentSize {
//    <#code#>
//}
//
//- (void)systemLayoutFittingSizeDidChangeForChildContentContainer:(nonnull id<UIContentContainer>)container {
//    <#code#>
//}
//
//- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(nonnull id<UIViewControllerTransitionCoordinator>)coordinator {
//    <#code#>
//}
//
//- (void)willTransitionToTraitCollection:(nonnull UITraitCollection *)newCollection withTransitionCoordinator:(nonnull id<UIViewControllerTransitionCoordinator>)coordinator {
//    <#code#>
//}
//
//- (void)didUpdateFocusInContext:(nonnull UIFocusUpdateContext *)context withAnimationCoordinator:(nonnull UIFocusAnimationCoordinator *)coordinator {
//    <#code#>
//}
//
//- (void)setNeedsFocusUpdate {
//    <#code#>
//}
//
//- (BOOL)shouldUpdateFocusInContext:(nonnull UIFocusUpdateContext *)context {
//    <#code#>
//}
//
//- (void)updateFocusIfNeeded {
//    <#code#>
//}

@end

