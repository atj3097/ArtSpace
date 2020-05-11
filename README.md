# ArtSpace 

### Introduction
ArtSpace is an immersive app where users can browse art available for sale and even preview on their walls. Independent artists can post their art and make it available for sale. Shoppers can view art and use an innovative augmented-reality feature to see how it would look in their home. 

## User Stories 
* Artiste: Independent artists can have trouble getting their work in front of potential buyers. An artiste using ArtSpace can post images of their art to a central marketplace where new buyers have a chance to discover them and purchase their art.

* Art Appreciator: Art Appreciators can use this app to find high-quality art outside of what is availble through mass-market retailers or expensive galleries and art dealers. They can preview the art in their home, and if they like it, set up an in-app purchase.

## Features
# Augemented reality shopping experience. 
![](aumentedReality.gif)
# In-app purchases Using Stripe
![](paymentGif.gif) 
# Save Your Card Information  
![](saveCard.gif) 
# Post Your Own Art 
![](uploadArt.gif) 
# Save Art To Purchase Later 
![](savedArtGif.gif)
## Technology Stack
- ARKit
- Stripe
- UIKit
- Firebase 
## Stripe Backend 
[Built in Node.Js using Firebase Cloud Functions](https://github.com/atj3097/ArtSpaceBackend)
## Instructions On Installation
* Git Clone This Repository
* Run Pod install In Terminal(All CocoaPods are already in the PodFile)  
* Open ArtSpaceDos.xcworkspace  
* Delete the EXISTING GoogleService-Info.plist in the project(Screenshot Below 👇🏾) 
![](Tutorial.jpg)
* [Download Our Firebase Plist and enter the Decryption Key below](https://mega.nz/file/YRwFTCyA) 
* Decryption Key - H6J72Q32XT2Dv__c_NNdIvHJ8uitIinWOY95-dSXDyM 
* Lastly, right click 'Add Files' on the project folder while XCode is open and add the GoogleService-Info.plist that you downloaded to your computer.  

![](Instructions.gif)
* Build and Run the app! The first build will take a minute or two but I promise its worth it!
* Login and enjoy the app!
