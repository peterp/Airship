# Airship.app

I badly wanted an iPhone. Back in 2008 I bought an iPhone 3G and proudly proclaimed to my girlfriend (now wife) that I was going to write apps!

The first app I ever wrote was a South African Income Tax calculator, it reached #1 of the free chart in the South African App Store. This was not a big deal, because it was only myself and Nico from Glucode who had "South African made" apps in the store.

Airship was my second iOS application. I think I sold 10,000 copies over it's lifetime. I wrote some code and added some features that made me want to go insane:

### A chunked multipart mime parser:

The first iteration was written in Objective-C, it took months to figure it out! I remember how excited I felt when I finally got it working. I deployed it to my iPhone 3G and... it was too slow! Uploads over Wi-Fi over HTTP were excruciatingly slow!

I rewrote it all in C and it was amazingly fast. (My C skills are questionable. As far as I could tell it didn't leak, and it didn't crash.)

### Replicating Photos.app viewer:

Back in the day one of the more impressive things you did whilst trying to win hearts and minds over your iPhone's usability was to demo pinch-to-zoom. I wanted that in my own application, and I wanted it to be perfect. 

There are a few subtle details that I puzzled over for a few days. I just remember this been particularly difficult to copy.

### Customizing all user-interface elements

It really wasn't easy in iOS 3. I had custom textured backgrounds on UINavigationBar, and UITabBar.



I recently found the code and I'm sharing it here.

