//
//  UIViewController+Dismiss.m
//  StoryBoard
//
//  Created by lingostar on 10/2/12.
//  Copyright (c) 2012 lingostar. All rights reserved.
//

#import "UIViewController+Storyboard.h"

@implementation UIViewController(UIViewController_Storyboard)

- (IBAction)navigationBackToRoot:(id)sender
{
    UINavigationController *navController = self.navigationController;
    [navController popToRootViewControllerAnimated:YES];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UIView *view in self.view.subviews) {
        [view resignFirstResponder];
    }
    
}


- (IBAction)exit:(UIStoryboardSegue *)segue
{
    
}

- (IBAction)dismissPush:(UIStoryboardSegue *)segue
{
    UIViewController *destVC = segue.destinationViewController;

    dispatch_async(dispatch_get_main_queue(),
                   ^{[destVC performSegueWithIdentifier:@"ModalDismissPush" sender:nil];}
                   );
}

- (IBAction)dismiss:(id)sender;
{
    [self dismissViewControllerAnimated:YES completion:nil];
}





@end
