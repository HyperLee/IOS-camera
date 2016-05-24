//
//  ViewController.h
//  noveltek
//
//  Created by noveltek on 2016/3/14.
//  Copyright (c) 2016年 noveltek. All rights reserved.
//

 #import <UIKit/UIKit.h>
 
 
 @protocol AppDelegate <NSObject>
 //@protocol noveltekAppDelegate<NSObject>
 
 @optional
 - (void)photoCapViewController:(UIViewController *)viewController didFinishDismissWithImage:(UIImage *)image;
 
 @end
@interface ViewController : UIViewController
 
 @property(nonatomic,weak)id<AppDelegate> delegate;

@end
