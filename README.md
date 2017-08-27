# iASTwitter (Death Note)

Simple twitter client

![Death Note](https://ws3.sinaimg.cn/large/006tNc79gy1fiy8z2uj7aj307z07zq3h.jpg)

## TODO

### Login

- [x] Has a button that opens a web page for authentication. It will be dismissed after the user grants and save the user credential in device settings.
- [x] Handle the situation when you kill the app after the credential saved to not open the login screen page again. it will open the second screen.

### User Followers

- [x] It display logged-in user followers in a list. The list contains profile image, full name, handle, and bio. Each cell height will depend if the follower has bio or not. if the follower has bio it will show all the bio in the cell, and if not it will show just the name, and handle.
- [x] Tapping on a follower will open the Follower Information screen.
- [ ] You should cache the API response for offline use.
- [ ] Bonus: handle device orientation (when in portrait it will be a list, in landscape it will be a grid).
- [ ] Bonus: add a drop down menu that show multi accounts that they saved already on the settings, and choose any one of them. Once i choose an account it will reload the page and show the followers related to that account.
- [x] Bonus: add refresh page loading and infinite scrolling.
Follower Information
- [x] Display follower profile Image and background (if not; add any default image).
- [x] Display last 10 tweets in a list.
- [ ] Bonus: create a sticky header for background image, when users scroll the screen. The background should still stick to the top of the screen and stretch.
- [ ] Bonus: make profile image and background image clickable, and open them in overlay view.

### Extra Bonus

- [x] Write the code using Swift language.
- [x] Localization (Arabic and English).

## Requirements

- iOS 10.0+
- Xcode 8.0+
- Swift 3.0+

## Installation

Install CocoaPods first if you don't have it already (more about CocoaPods [here](https://cocoapods.org)):

```bash
$ gem install cocoapods
```
> CocoaPods 1.1.0+ is required to build dependencies.

To clone iASTwitter the first time, simply run the command:

```bash
$ git clone https://github.com/iAmrSalman/iASTwitter.git
```
Then, run the following command:

```bash
$ pod install
```

## Inpiration 

I got my inpiration from [Death Note Movie](https://www.youtube.com/watch?v=gvxNaSIB_WI) & [Anime](https://www.youtube.com/watch?v=tJZtOrm-WPk)