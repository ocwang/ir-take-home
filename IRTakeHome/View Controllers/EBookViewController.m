//
//  EBookViewController.m
//  IRTakeHome
//
//  Created by Chase Wang on 11/6/18.
//  Copyright © 2018 ocw. All rights reserved.
//

#import "EBookViewController.h"

@interface EBookViewController ()

@property (nonatomic, strong) EBook *eBook;

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *bookTitleLabel;
@property (nonatomic, strong) UILabel *authorLabel;
@property (nonatomic, strong) UILabel *summaryLabel;
@property (nonatomic, strong) UIButton *visitButton;

@property (nonatomic) BOOL didSetupConstraints;

@end

@implementation EBookViewController

#pragma mark - Init

- (id)initWithEBook:(EBook *)eBook {
    if (self = [super initWithNibName:nil bundle:nil]) {
        self.eBook = eBook;
    }
    
    return self;
}

#pragma mark - VC Lifecycle

- (void)loadView {
    self.view = [[UIView alloc] init];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.imageView];
    [self.view addSubview:self.bookTitleLabel];
    [self.view addSubview:self.authorLabel];
    [self.view addSubview:self.summaryLabel];
    [self.view addSubview:self.visitButton];
    
    [self.view setNeedsUpdateConstraints];
    [self.view updateConstraintsIfNeeded];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self loadBookImage];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    if (!self.didSetupConstraints) {
        CGFloat imageInset = 50;
        CGFloat topInset = self.view.safeAreaInsets.top + imageInset;
        [self.imageView.topAnchor constraintEqualToAnchor:self.view.topAnchor constant: topInset].active = YES;
        [self.imageView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:imageInset].active = YES;
        [self.imageView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-imageInset].active = YES;
        [self.imageView.heightAnchor constraintEqualToAnchor:self.imageView.widthAnchor multiplier:1].active = YES;
        
        [self.bookTitleLabel.topAnchor constraintEqualToAnchor:self.imageView.bottomAnchor constant:35].active = YES;
        [self.bookTitleLabel.leadingAnchor constraintEqualToAnchor:self.imageView.leadingAnchor].active = YES;
        [self.bookTitleLabel.trailingAnchor constraintEqualToAnchor:self.imageView.trailingAnchor].active = YES;
        
        [self.authorLabel.topAnchor constraintEqualToAnchor:self.bookTitleLabel.bottomAnchor constant:15].active = YES;
        [self.authorLabel.leadingAnchor constraintEqualToAnchor:self.imageView.leadingAnchor].active = YES;
        [self.authorLabel.trailingAnchor constraintEqualToAnchor:self.imageView.trailingAnchor].active = YES;
        
        [self.summaryLabel.topAnchor constraintEqualToAnchor:self.authorLabel.bottomAnchor constant:15].active = YES;
        [self.summaryLabel.leadingAnchor constraintEqualToAnchor:self.imageView.leadingAnchor].active = YES;
        [self.summaryLabel.trailingAnchor constraintEqualToAnchor:self.imageView.trailingAnchor].active = YES;
        
        [self.visitButton.topAnchor constraintGreaterThanOrEqualToAnchor:self.summaryLabel.bottomAnchor constant:35].active = YES;
        [self.visitButton.leadingAnchor constraintEqualToAnchor:self.imageView.leadingAnchor].active = YES;
        [self.visitButton.trailingAnchor constraintEqualToAnchor:self.imageView.trailingAnchor].active = YES;
        CGFloat bottomInset = self.view.safeAreaInsets.bottom + 35;
        [self.visitButton.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor constant:-bottomInset].active = YES;
        [self.visitButton.heightAnchor constraintEqualToConstant:50].active = YES;
        
        self.didSetupConstraints = YES;
    }
}

#pragma mark - Target Actions

- (void)visitButtonTapped:(UIButton *)sender {
    NSURL *iTunesStoreURL = [[NSURL alloc] initWithString:self.eBook.iTunesStoreURL];
    if (iTunesStoreURL == nil || ![[UIApplication sharedApplication] canOpenURL:iTunesStoreURL]) {
        return;
    }
    
    [[UIApplication sharedApplication] openURL:iTunesStoreURL
                                       options:[NSDictionary dictionary]
                             completionHandler:nil];
}

#pragma mark - Misc.

- (void)loadBookImage {
    // in production, you'd use some third party library that handles
    // caching and other optimizations and an opacity fade
    
    NSURL *imageURL = [[NSURL alloc] initWithString:self.eBook.imageURLLarge];
    
    if (imageURL == nil) {
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        __strong typeof(self) strongSelf = weakSelf;
        
        NSData *data = [NSData dataWithContentsOfURL:imageURL];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            strongSelf.imageView.image = [UIImage imageWithData:data];
        });
    });
}

#pragma mark - Properties

- (UIImageView *)imageView {
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc] init];
        _imageView.backgroundColor = [UIColor lightGrayColor];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    return _imageView;
}

- (UILabel *)bookTitleLabel {
    if (_bookTitleLabel == nil) {
        _bookTitleLabel = [[UILabel alloc] init];
        _bookTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _bookTitleLabel.textAlignment = NSTextAlignmentCenter;
        _bookTitleLabel.text = self.eBook.bookTitle;
        
    }
    
    return _bookTitleLabel;
}

- (UILabel *)authorLabel {
    if (_authorLabel == nil) {
        _authorLabel = [[UILabel alloc] init];
        _authorLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _authorLabel.textAlignment = NSTextAlignmentCenter;
        _authorLabel.text = self.eBook.authors;
    }
    
    return _authorLabel;
}

- (UILabel *)summaryLabel {
    if (_summaryLabel == nil) {
        _summaryLabel = [[UILabel alloc] init];
        _summaryLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _summaryLabel.text = self.eBook.bookSummary;
        _summaryLabel.numberOfLines = 0;
    }
    
    return _summaryLabel;
}

- (UIButton *)visitButton {
    if (_visitButton == nil) {
        _visitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _visitButton.translatesAutoresizingMaskIntoConstraints = NO;
        
        
        [_visitButton setTitle:@"Visit on iTunes" forState:UIControlStateNormal];
        _visitButton.backgroundColor = [UIColor blueColor];
        _visitButton.layer.cornerRadius = 8;
        
        [_visitButton addTarget:self action:@selector(visitButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _visitButton;
}

@end
