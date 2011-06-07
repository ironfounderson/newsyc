//
//  BrowserController.m
//  newsyc
//
//  Created by Grant Paul on 3/7/11.
//  Copyright 2011 Xuzz Productions, LLC. All rights reserved.
//

#import "BrowserController.h"
#import "InstapaperAPI.h"
#import "NavigationController.h"
#import "ProgressHUD.h"
#import "NSArray+Strings.h"

@implementation BrowserController
@synthesize currentURL;

- (id)initWithURL:(NSURL *)url {
    if ((self = [super init])) {
        rootURL = url;
        [self setCurrentURL:url];
        [self setHidesBottomBarWhenPushed:YES];
    }
    
    return self;
}

- (void)dealloc {
    [webview setDelegate:nil];
    [webview release];
    [toolbar release];
    
    [backItem release];
    [forwardItem release];
    [shareItem release];
    [refreshItem release];
    [loadingItem release];
    [spacerItem release];
    [wordCountItem release];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    if (hud != nil) {
        // XXX: this is not actually what we want: this should show on top of
        // other controllers whilte it continues to save. however, since the
        // browser controller, not some "instapaper saving controller", manages
        // the HUD, this is the best we can do for now, and is "good enough"
        [hud dismissWithAnimation:YES];
    }
    
    [super dealloc];
}

- (void)updateToolbarItems {
    [backItem setEnabled:[webview canGoBack]];
    [forwardItem setEnabled:[webview canGoForward]];
    
    UIBarButtonItem *changableItem = nil;
    if ([webview isLoading]) changableItem = loadingItem;
    else changableItem = refreshItem;
    
    [toolbar setItems:[NSArray arrayWithObjects:spacerItem, backItem, spacerItem, spacerItem, forwardItem, spacerItem, spacerItem, spacerItem, wordCountItem, spacerItem, readabilityItem, spacerItem, spacerItem, changableItem, spacerItem, spacerItem, shareItem, spacerItem, nil]];
}

- (void)loadView {
    [super loadView];
    
    toolbar = [[UIToolbar alloc] init];
    [toolbar setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin];
    
    [toolbar sizeToFit];
    CGRect toolbarFrame = [toolbar bounds];
    toolbarFrame.origin.y = [[self view] bounds].size.height - toolbarFrame.size.height;
    [toolbar setFrame:toolbarFrame];
    [toolbar setTintColor:[[[self navigationController] navigationBar] tintColor]];
    [[self view] addSubview:toolbar];
    
    wordCountItem = [[UIBarButtonItem alloc] initWithTitle:@"--" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    backItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back.png"] style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    forwardItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"forward.png"] style:UIBarButtonItemStylePlain target:self action:@selector(goForward)];
    readabilityItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"readability.png"] style:UIBarButtonItemStylePlain target:self action:@selector(readability)];
    refreshItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"refresh.png"] style:UIBarButtonItemStylePlain target:self action:@selector(reload)];
    shareItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(showActionMenu)];
    spacerItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:NULL];
    loadingItem = [[ActivityIndicatorItem alloc] initWithSize:[[refreshItem image] size]];
    [self updateToolbarItems];
    
    CGRect webviewFrame = [[self view] bounds];
    webviewFrame.size.height -= toolbarFrame.size.height;
    webview = [[UIWebView alloc] initWithFrame:webviewFrame];
    [webview setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
    [webview setDelegate:self];
    [webview setScalesPageToFit:YES];
    [[self view] addSubview:webview];
}
    
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (![webview request]) {
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:rootURL];
        [webview loadRequest:[request autorelease]];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    
    [webview setDelegate:nil];
    [webview release];
    webview = nil;
}

- (void)submitInstapaperRequest {
    InstapaperRequest *request = [[InstapaperRequest alloc] initWithSession:[InstapaperSession currentSession]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(instapaperRequestDidAddItem:) name:kInstapaperRequestSucceededNotification object:request];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(instapaperRequestDidFailToAddItem:) name:kInstapaperRequestFailedNotification object:request];
    
    if (hud == nil) {
        hud = [[ProgressHUD alloc] init];
        [hud setText:@"Saving"];
        [hud showInWindow:[[self view] window]];
        [hud release];
    }
    
    [request addItemWithURL:currentURL];
    [request autorelease];
}

- (void)readability {
    [webview stringByEvaluatingJavaScriptFromString:kReadabilityBookmarkletCode];
}

- (void)loginControllerDidLogin:(LoginController *)controller {
    [controller dismissModalViewControllerAnimated:YES];
    [self submitInstapaperRequest];
}

- (void)loginControllerDidCancel:(LoginController *)controller {
    [controller dismissModalViewControllerAnimated:YES];
}

- (void)instapaperRequestDidAddItem:(NSNotification *)notification {
    [hud setText:@"Saved!"];
    [hud setState:kProgressHUDStateCompleted];
    [hud dismissAfterDelay:0.8f animated:YES];
    hud = nil;
}

- (void)instapaperRequestDidFailToAddItem:(NSNotification *)notification {
    [hud setText:@"Error Saving"];
    [hud setState:kProgressHUDStateError];
    [hud dismissAfterDelay:0.8f animated:YES];
    hud = nil;
}

- (void)actionSheet:(UIActionSheet *)action clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == [action cancelButtonIndex]) return;
    
    NSInteger first = [action firstOtherButtonIndex];
    if (buttonIndex == first) {
        [[UIApplication sharedApplication] openURL:[[webview request] URL]];
    } else if (buttonIndex == first + 1) {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        [pasteboard setURL:currentURL];
        [pasteboard setString:[currentURL absoluteString]];
        
        if (hud == nil) {
            ProgressHUD *copied = [[ProgressHUD alloc] init];
            [copied setState:kProgressHUDStateCompleted];
            [copied setText:@"Copied!"];
            [copied showInWindow:[[self view] window]];
            [copied dismissAfterDelay:0.8f animated:YES];
            [copied release];
        }
    } else if (buttonIndex == first + 2) {
        if ([InstapaperSession currentSession] != nil) {
            [self submitInstapaperRequest];
        } else {
            NavigationController *navigation = [[NavigationController alloc] init];
            InstapaperLoginController *login = [[InstapaperLoginController alloc] init];
            [login setDelegate:self];
            [navigation setViewControllers:[NSArray arrayWithObject:login]];
            [self presentModalViewController:[navigation autorelease] animated:YES];
        }
    } 
}

- (void)reload {
    [webview reload];
}

- (void)stop {
    [webview stopLoading];
}

- (void)goBack {
    [webview goBack];
}

- (void)goForward {
    [webview goForward];
}

- (void)showActionMenu {
    UIActionSheet *sheet = [[UIActionSheet alloc]
        initWithTitle:[currentURL absoluteString]
        delegate:self
        cancelButtonTitle:@"Cancel"
        destructiveButtonTitle:nil
        otherButtonTitles:@"Open with Safari", @"Copy Link", @"Read Later", nil
    ];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) [sheet showFromBarButtonItem:shareItem animated:YES];
    else [sheet showInView:[[self view] window]];
    
    [sheet release];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [self updateToolbarItems];
}

- (BOOL)urlIsReadability:(NSURL *)url {
    NSRange range = [url.absoluteString rangeOfString:@"www.readability.com/mobile/articles"];
    return range.location != NSNotFound;
    
}

- (NSString *)flattenHTML:(NSString *)html {
    
    NSScanner *thescanner;
    NSString *text = nil;
    
    thescanner = [NSScanner scannerWithString:html];
    
    while ([thescanner isAtEnd] == NO) {
        
        // find start of tag
        [thescanner scanUpToString:@"<" intoString:nil] ; 
        
        // find end of tag
        [thescanner scanUpToString:@">" intoString:&text] ;
        
        // replace the found tag with a space
        //(you can filter multi-spaces out later if you wish)
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>", text] withString:@" "];
        
    } // while //
    
    return html;
    
}

- (NSUInteger)wordCountInHTML:(NSString *)html {
    NSString *flattenContent = [self flattenHTML:html];
    NSArray *words = [flattenContent componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    __block NSUInteger wordCount = 0;
    [words enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *word = obj;
        if (word.length > 0)
            wordCount++;
    }];
    return wordCount;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self updateToolbarItems];
    [self setCurrentURL:[[webView request] URL]];
    [[self navigationItem] setTitle:[webview stringByEvaluatingJavaScriptFromString:@"document.title"]];
    if ([self urlIsReadability:webView.request.URL]) {
        NSString *articleContent = [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByClassName('article-content')[0].innerHTML"];
        NSUInteger wordCount = [self wordCountInHTML:articleContent];
        
        NSUInteger wordsPerMinute = 350;
        NSUInteger mins = wordCount / wordsPerMinute;
        if (mins <= 2) 
            wordCountItem.title = @"2";
        else if (mins < 5)
            wordCountItem.title = @"5";
        else if (mins < 10)
            wordCountItem.title = @"10";
        else if (mins < 15)
            wordCountItem.title = @"15";
        else
            wordCountItem.title = @">15";            
    }
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [self updateToolbarItems];
}

//These 3 methods from Apple tech doc: http://developer.apple.com/library/ios/#qa/qa1629/_index.html
- (void)openExternalURL:(NSURL *)anExternalURL {
    externalURL = anExternalURL;
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:[NSURLRequest requestWithURL:externalURL] delegate:self startImmediately:YES];
    [conn release];
}

- (NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)response {
    if(response){
        externalURL = [response URL];
    }
    return request;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Leaving Application" message:@"Are you sure you want to leave news:yc?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    [alert show];
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex == 1) {
        [[UIApplication sharedApplication] openURL:externalURL];
    }
}

- (void) alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    [alertView release];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    NSArray *hosts = [NSArray arrayWithObjects:@"itunes.apple.com", @"phobos.apple.com", @"youtube.com", @"maps.google.com", nil];
    NSURL *url = [request URL];
    if(navigationType == UIWebViewNavigationTypeLinkClicked && [hosts containsString:[url host]]) {
        [self openExternalURL:url];
        return NO;
    }
    if (navigationType == UIWebViewNavigationTypeLinkClicked ||
        navigationType == UIWebViewNavigationTypeFormSubmitted ||
        navigationType == UIWebViewNavigationTypeFormResubmitted) {
        [self setCurrentURL:[request URL]];
    }
    
    return YES;
}

AUTOROTATION_FOR_PAD_ONLY

@end
