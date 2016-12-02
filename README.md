<img src="http://www.beanstream.com/wp-content/uploads/2015/08/Beanstream-logo.png" />
# Beanstream iOS SDK API Simulator
<img align="right" src="https://ingenico.ca/binaries/content/gallery/us-website/media-library/image-gallery/product-composite-banners/ingenico-icmp-1030x400.jpg" height=200px />
iOS framework to simulate Beanstream SDK API responses

With the Beanstream SDK, it is easy to track payments made by cash or cheque, and when combined with an [Ingenico iCMP device](https://ingenico.ca/mobile-solutions/mobile-smart-terminals/icmp.html), you can also process Debit &amp; Credit Card payments.

The main simulator class, BICBeanstreamAPISimulator, simply extends and overrides all the BICBeanstreamnAPI method calls to allow you to accompolish initial development of your apps without having to connect to any actual Beanstream remote web services nor require that you obtain and use an actual iCMP device. Each Beanstream SDK call is overridden to simulate limited data validation of requests and to provide sample response or error data models. Most each SDK call will also initially result in an alert sheet being displayed to allow a user to pick from a set of potential response types (E.g. Pass, Fail, Error).

As a developer you can simply clone this project and then reference the enclosed APISimulator directory in your project to compile and link the source and header files. Your project however will need to manage including the Beanstream SDK and its depenendencies that include the AFNetworking library or else you can use CocoaPods to help manage this for you. To be able to compile this project as-is you will need to use CocoaPoads. The projects Podfile had a declared dependency on the Beanstream.SDK.

To demonstrate usage of the API Simulator, refer to the Beanstream SDK API Sample App project that acts as a demo app.

Please refer to the Beanstream SDK [API Sample App](https://github.com/Beanstream/beanstream-ios-apisample) project that acts as a demo app to demonstrate usage of the API Simulator.

Note that the Beanstream SDK itself has CocoaPods specified dependencies that include AFNetworking v2.6.0.

To be able to compile this project you can clone the git source repo to a working directory. As dependencies you will also need to clone the Beanstream API Simulator repo and then ensure all other dependencies are installed via CocoaPods.

## 1.) Prerequisites:

First install [CocoaPods](https://cocoapods.org) and a plug-in to access our Artifactory repository.

```
> sudo gem install cocoapods
> sudo gem install cocoapods-art
```

Next ensure you have your Artifactory credentials setup by Beanstream Developer Support and apply them to a .netrc file in your $HOME directory.

```
machine beanstream.jfrog.io
login <USERNAME>
password <PASSWORD>
```

Add the Beanstream Partner/Artifactory repo.

```
> pod repo-art add beanstream-partner "https://beanstream.jfrog.io/beanstream/api/pods/beanstream-partner"
```

## 2.) Setup Beanstream API Simulator

```
> git clone https://github.com/Beanstream/beanstream-ios-apisimulator.git
```

Note that the default resulting directory name "beanstream-ios-apisimulator" should be maintained.

### Optional: Only if you wish to be able to build the simulator

Requirement: First install [CocoaPods](https://cocoapods.org).

```
> cd beanstream-ios-apisimulator
> pod install
> open APISimulator.xcworkspace
```

For more info on how to use the Beanstream SDK check out [developer.beanstream.com](http://developer.beanstream.com).
