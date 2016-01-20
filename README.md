<img src="http://www.beanstream.com/wp-content/uploads/2015/08/Beanstream-logo.png" />
# Beanstream iOS SDK API Simulator
iOS framework to simulate responses of the Beanstream SDK API.

<img src="http://ingenico.ca/wp-content/uploads/2014/07/ICMP-Main-carte-Updated-2-web-version-e1424706271455.jpg" height=80 />
The Beanstream SDK lets you simply track payments made by cash or cheque and when combined with an [Ingenico iCMP device](http://ingenico.ca/terminals/icmp/) also allows you to process Debit & Credit Card payments as well.

The main simulator class, BICBeanstreamAPISimulator, simply extends and overrides all the BICBeanstreamnAPI method calls to allow you to accompolish initial development of your apps without having to connect to any actual Beanstream remote web services nor require that you obtain and use an actual iCMP device.

As a developer you can simply clone this project and then reference the enclosed APISimulator directory in your project to compile and link the source and header files. Your project however will need to manage including the Beanstream SDK and its depenendencies that include the AFNetworking library or else you can use CocoaPods to help manage this for you. To be able to compile this project as-is you will need to use CocoaPoads. The projects Podfile had a declared dependency on the Beanstream.SDK.

Please refer to the [API Sample](https://github.com/Beanstream-DRWP/beanstream-ios-apisample) project that acts as a demo app to demonstrate usage of the API Simulator.

Note that the Beanstream SDK itself has CocoaPods specified dependencies that include AFNetworking v2.6.0.

To be able to compile this project you can clone the git source repo to a working directory. As dependencies you will also need to clone the Beanstream API Simulator repo and then ensure all other dependencies are installed via CocoaPods.

Requirement: First install [CocoaPods](https://cocoapods.org).

The following projects should be cloned into the same root directory.

## 1.) Setup Beanstream API Simulator

```
> git clone https://github.com/Beanstream-DRWP/beanstream-ios-apisimulator.git
```

Note that the default resulting directory name "beanstreamios.sdk.apisimulator" should be maintained.

### Optional: Only if you wish to be able to build the simulator

```
> cd beanstreamios.sdk.apisimulator
> pod install
> open APISimulator.xcworkspace
```

For more info on how to use the Beanstream SDK check out [developer.beanstream.com](http://developer.beanstream.com).
