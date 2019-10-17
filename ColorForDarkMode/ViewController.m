//
//  ViewController.m
//  ColorForDarkMode
//
//  Created by liang on 2019/10/17.
//  Copyright © 2019 liang. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, strong) UILabel *darkType;
@end

@implementation ViewController

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
//    NSLog(@"viewDidLayoutSubviews");
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

    self.dataSource = [NSMutableArray arrayWithCapacity:10];

    //    第一组，前景色。文本和分割线使用

    [self.dataSource addObject:@{
        @"---- 前景色（看主标题字体色）": @[
                UIColor.labelColor,
                UIColor.secondaryLabelColor,
                UIColor.tertiaryLabelColor,
                UIColor.quaternaryLabelColor,
                UIColor.linkColor,
                UIColor.placeholderTextColor,
                UIColor.separatorColor,
                UIColor.opaqueSeparatorColor
        ]
    }];
    // 背景色，
    [self.dataSource addObject:@{
        @"---- 背景色（看 Cell 背景色）": @[
                UIColor.systemBackgroundColor,
                UIColor.secondarySystemBackgroundColor,
                UIColor.tertiarySystemBackgroundColor,
                UIColor.systemGroupedBackgroundColor,
                UIColor.secondarySystemGroupedBackgroundColor,
                UIColor.tertiarySystemGroupedBackgroundColor,
        ]
    }];
    // 各式填充色
    [self.dataSource addObject:@{
        @"---- 各式填充色（看 Cell 背景色）": @[
                UIColor.systemFillColor,
                UIColor.secondarySystemFillColor,
                UIColor.tertiarySystemFillColor,
                UIColor.quaternarySystemFillColor
        ]
    }];
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
    printf("\r\n 颜色 | #hex | rgba");
    printf("\r\n --- | --- | ---");
}

- (NSString *)getColorName:(UIColor *)color{
    NSString *name = [color description];
    NSRange start = [name rangeOfString:@"name = "];
    NSInteger from = start.length + start.location;
    NSInteger len = name.length - 1 - from;
    return [name substringWithRange:NSMakeRange(from, len)];
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
//    NSLog(@"numberOfSectionsInTableView, count = %d", self.dataSource.count);
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    NSDictionary *value = self.dataSource[section];
    NSString *key = value.allKeys.firstObject;
    
    NSArray *colors = value[key];
    return colors.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"kcommmon";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    NSDictionary *value = self.dataSource[indexPath.section];
    NSString *key = value.allKeys.firstObject;
    
    NSArray *colors = value[key];
    UIColor *color = [colors objectAtIndex:indexPath.row];

    NSString *colorName = [self getColorName:color];
    cell.textLabel.text = colorName;
    NSString *hex = [self hexFromUIColor:color];
    NSString *rgba = [self rgbaFromUIColor:color];
    
    printf("\r\n %s | %s | %s", [colorName UTF8String], [hex UTF8String], [rgba UTF8String]);
    NSString * _Nonnull desc = [NSString stringWithFormat:@"%@; %@", hex, rgba];
    cell.detailTextLabel.text = desc;
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
    NSDictionary *value = self.dataSource[section];
    NSString *key = value.allKeys.firstObject;
    return key;
}
@end
