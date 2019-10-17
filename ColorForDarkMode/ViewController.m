//
//  ViewController.m
//  ColorForDarkMode
//
//  Created by liang on 2019/10/17.
//  Copyright © 2019 liang. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UITableViewDataSource>

@property (nonatomic, strong) NSMutableDictionary *dataSource;

@property (nonatomic, strong) UILabel *darkType;
@end

@implementation ViewController

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    NSLog(@"viewDidLayoutSubviews");
}

- (void)layoutVCViews{
    NSLog(@"layoutVCViews");
    [self.view setNeedsLayout];
    [self.view setNeedsDisplay];
    [self.view layoutSubviews];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"动态适配颜色 cheatsheet";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"layout" style:UIBarButtonItemStylePlain target:self action:@selector(layoutVCViews)];
    
    UITableView *sv = [UITableView new];
    sv.dataSource = self;
    [self.view addSubview:sv];
    sv.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [sv.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor], [sv.leftAnchor constraintEqualToAnchor:self.view.leftAnchor],
        [sv.rightAnchor constraintEqualToAnchor:self.view.rightAnchor], [sv.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor]
    ]];

    self.dataSource = [NSMutableDictionary dictionaryWithCapacity:10];

    // 标题
    UILabel *title = [UILabel new];
    title.frame = CGRectMake(0, 0, 200, 60);
    self.darkType = title;
    title.text = @"现在处于 - dark";
    title.font = [UIFont systemFontOfSize:18];
    UIColor *titleColor = [[UIColor alloc] initWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
        if (traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
            return [UIColor systemRedColor];
        } else {
            return [UIColor systemBlueColor];
        }
    }];
    title.textColor = titleColor;
    sv.tableHeaderView = title;
    //    第一组，前景色。文本和分割线使用
    NSDictionary *enums = @{
        @"labelColor" : UIColor.labelColor,
        @"secondaryLabelColor" : UIColor.secondaryLabelColor,
        @"tertiaryLabelColor" : UIColor.tertiaryLabelColor,
        @"quaternaryLabelColor" : UIColor.quaternaryLabelColor,
        @"linkColor" : UIColor.linkColor,
        @"placeholderTextColor" : UIColor.placeholderTextColor,
        @"separatorColor" : UIColor.separatorColor,
        @"opaqueSeparatorColor" : UIColor.opaqueSeparatorColor
    };
    [self.dataSource setObject:enums forKey:@"---- 前景色（看主标题字体色）"];
    // 背景色，
    NSDictionary *enums2 = @{
        @"systemBackgroundColor" : UIColor.systemBackgroundColor,
        @"secondarySystemBackgroundColor" : UIColor.secondarySystemBackgroundColor,
        @"tertiarySystemBackgroundColor" : UIColor.tertiarySystemBackgroundColor,
        @"quaternaryLabelColor" : UIColor.quaternaryLabelColor,
        @"systemGroupedBackgroundColor" : UIColor.systemGroupedBackgroundColor,
        @"secondarySystemGroupedBackgroundColor" : UIColor.secondarySystemGroupedBackgroundColor,
        @"tertiarySystemGroupedBackgroundColor" : UIColor.tertiarySystemGroupedBackgroundColor
    };
    [self.dataSource setObject:enums2 forKey:@"---- 背景色（看 Cell 背景色）"];

    // 各式填充色
    NSDictionary *enums3 = @{
        @"systemFillColor" : UIColor.systemFillColor,
        @"secondarySystemFillColor" : UIColor.secondarySystemFillColor,
        @"tertiarySystemFillColor" : UIColor.tertiarySystemFillColor,
        @"quaternarySystemFillColor" : UIColor.quaternarySystemFillColor,
        @"systemGroupedBackgroundColor" : UIColor.systemGroupedBackgroundColor,
        @"secondarySystemGroupedBackgroundColor" : UIColor.secondarySystemGroupedBackgroundColor,
        @"tertiarySystemGroupedBackgroundColor" : UIColor.tertiarySystemGroupedBackgroundColor
    };
    [self.dataSource setObject:enums3 forKey:@"---- 各式填充色（看 Cell 背景色）"];
}

- (NSString *)hexFromUIColor:(UIColor *)color
{
    CGFloat r, g, b, a;
    [color getRed:&r green:&g blue:&b alpha:&a];

    // can not invert - the only component is the alpha
    // e.g. self == [UIColor groupTableViewBackgroundColor]
    return [NSString stringWithFormat:@"#%X%X%X%X", (long)(r * 255), (long)(g * 255), (long)(b * 255), (long)(a * 255)];
}

- (NSString *)rgbaFromUIColor:(UIColor *)color
{
    CGFloat r, g, b, a;
    [color getRed:&r green:&g blue:&b alpha:&a];

    // can not invert - the only component is the alpha
    // e.g. self == [UIColor groupTableViewBackgroundColor]
    return [NSString stringWithFormat:@"rgba(%0.4f,%0.4f,%0.4f,%0.2f)", r, g, b, a];
}

#pragma mark datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataSource.allKeys.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *allKeys = self.dataSource.allKeys;
    NSString *key = [allKeys objectAtIndex:section];

    NSDictionary *value = self.dataSource[key];
    return value.allKeys.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"kcommmon";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    NSArray *allKeys = self.dataSource.allKeys;
    NSString *key = [allKeys objectAtIndex:indexPath.section];

    NSDictionary *value = self.dataSource[key];
    NSArray *subKeys = value.allKeys;
    NSString *subKey = subKeys[indexPath.row];
    UIColor *color = [value objectForKey:subKey];

    cell.textLabel.text = subKey;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@; %@", [self hexFromUIColor:color],[self rgbaFromUIColor:color]];
    if ( [key containsString:@"前景色"]) {
        // 字体，前景色
        cell.textLabel.textColor = color;
    } else {
        cell.textLabel.textColor = UIColor.labelColor;
        cell.contentView.backgroundColor = color;
    }
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSArray *allKeys = self.dataSource.allKeys;
    NSString *key = [allKeys objectAtIndex:section];
    return key;
}
@end
