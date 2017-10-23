//
//  Photo.h
//  Cats
//
//  Created by Aaron Johnson on 2017-10-23.
//  Copyright © 2017 Aaron Johnson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Photo : NSObject
@property (nonatomic) UIImage *image;
@property NSURL *url;
@property NSString *title;
@end
