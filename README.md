[![header](/assets/header.png)](https://business.ramotion.com?utm_source=gthb&utm_medium=special&utm_campaign=elongation-preview-logo)

[![Twitter](https://img.shields.io/badge/Twitter-@Ramotion-blue.svg?style=flat)](http://twitter.com/Ramotion)
[![CocoaPods](https://img.shields.io/cocoapods/p/elongation-preview.svg)](https://cocoapods.org/pods/ElongationPreview)
[![CocoaPods](https://img.shields.io/cocoapods/v/ElongationPreview.svg)](http://cocoapods.org/pods/ElongationPreview)
[![CocoaPods](https://img.shields.io/cocoapods/metrics/doc-percent/ElongationPreview.svg)](https://cdn.rawgit.com/Ramotion/elongation-preview/master/docs/index.html)

[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Ramotion/elongation-preview)
[![Travis](https://travis-ci.org/Ramotion/elongation-preview.svg?branch=master)](https://travis-ci.org/Ramotion/elongation-preview)
[![codebeat badge](https://codebeat.co/badges/6a009992-5bf2-4730-aa35-f3b20ce7693d)](https://codebeat.co/projects/github-com-ramotion-elongation-preview)

<br>

## About
This project is maintained by Ramotion, Inc.<br>
We specialize in the designing and coding of custom UI for Mobile Apps and Websites.<br><br>**Looking for developers for your project?**

<a href="http://business.ramotion.com?utm_source=gthb&utm_medium=special&utm_campaign=elongation-preview-contact-us/#Get_in_Touch" > <img src="https://github.com/Ramotion/navigation-stack/raw/master/contact_our_team@2x.png" width="150" height="30"></a>

<br>

## Requirements

- iOS 9.0+
- Xcode 8

<br>

## Installation
You can install `ElongationPreview` in several ways:

- Add source files to your project.

<br>

- Use [CocoaPods](https://cocoapods.org):
``` ruby
pod 'ElongationPreview'
```

<br>

- Use [Carthage](https://github.com/Carthage/Carthage):
```
github "Ramotion/elongation-preview"
```

<br>

## How to use

First of all, import module to your source file.

```swift
import ElongationPreview
```

### 1. `ElongationViewController`

Then subclass `ElongationViewController` and configure it as you wish.

```swift
class RootViewController: ElongationViewController { }
```

Now you must register reusable cell in `tableView`. If you prefer to use Storyboards, you can drag `UITableViewCell` from bottom-right menu, *lay it out* and change it's class to `ElongationCell`. Of course, there are some specific requirements on how you can configure cell's subviews.

#### `ElongationCell`

- Easier way: copy [DemoElongationCell](/ElongationPreview/ElongationPreviewDemo/Views/DemoElongationCell.xib) from demo project and change it as you wish. Add your own views to `top`, `bottom` and `scalable` containers.

- If you want to create cell from scratch, this is how your cell hierarchy should look like:

   ![hierarchy](/assets/elongationCellHierarchy.png)
   
##### Required properties:   
`bottomView` — the view which comes from behind the cell when you tap on the cell.

`scalableView` — the view which will be scaled when you tap on the cell.
 
`topView` — static top view, add here all the views which wont be scaled and must stay on their position.

And these constraints: `topViewHeightConstraint`, `topViewTopConstraint`, `bottomViewHeightConstraint`, `bottomViewTopConstraint`.

<br>

### 2. `ElongationDetailViewController`

```swift
class DetailViewController: ElongationDetailViewController { }
```

If you want to display some details for objects from the `root` view, it's better to subclass `ElongationDetailViewController` and configure it for displaying your data.

This class holds `headerView` property which actually represents `ElongationCell` in expanded state and it'll be used as a header for `tableView` by default.

<br>

## Notes
If you need to override
```swift
func scrollViewDidScroll(_ scrollView: UIScrollView)
```
or
```swift
func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
```
you must call `super` because some important configuration was made in these methods in superclass (`ElongationViewController`).

<br>

## Appearance & Behaviour
You can customize both appearance & behaviour of `ElongationPreview` control by tuning some params of `ElongationConfig` and overriding `shared` instance.

```swift
// Create new config.
var config = ElongationConfig()

// Change desired properties.
config.parallaxFactor = 20 
config.scaleViewScaleFactor = 0.9
config.topViewHeight = 190
config.bottomViewHeight = 170
config.bottomViewOffset = 20
config.parallaxFactor = 100
config.separatorHeight = 0.5
config.separatorColor = .white

// Save created config as `shared` instance.
ElongationConfig.shared = config
```

> All parameters with their descriptions listed in [`ElongationConfig`](/ElongationPreview/Source/ElongationConfig.swift) file.

<br>

## License

ElongationPreview is released under the MIT license.
See [LICENSE](./LICENSE) for details.

<br>

## Follow us

[![Twitter URL](https://img.shields.io/twitter/url/http/shields.io.svg?style=social)](https://twitter.com/intent/tweet?text=https://github.com/ramotion/elongation-preview)
[![Twitter Follow](https://img.shields.io/twitter/follow/ramotion.svg?style=social)](https://twitter.com/ramotion)
