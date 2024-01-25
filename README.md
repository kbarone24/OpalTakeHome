**Main requirements**
- [x] The top reward should always show the reward the user is currently making progress towards or the best reward that is waiting to be unlocked.
- [x] Progress per reward is exactly related to number of friends invited and the user makes progress towards all of them at once. So if one reward requires 10 invites and the other requires 20, on completion of the first reward the user is already 50% of the way to unlocking the other reward.
- [x] The purple on this screen is related to the home gemstone the user selected and so it should be a value that can be changed to re-theme this screen.
- [x] A reward is not automatically claimed when it is complete, the user should tap “Claim” to unlock the reward.
- [x] The “Share Referral Link” button should open the native share sheet. For convenience the “Add Friends” button should also open this popup.
- [x] The implementation of this screen does not need to work with real backend functionality, but you should create it as if it were with classes that request / return the expected objects asynchronously.

**Bonus requirements**
- [ ] Support for live updating of referral status while viewing this screen if a friend installs Opal
- [ ] Animations + interactions that enhance the overall experience
- [ ] New rewards can be added dynamically at any time and should automatically update the UI and any progress as and when they are.
- [x] Design System setup + convenience for fonts, colours, icons etc
- [x] Any other ideas you have that would have a positive impact on the success metrics for this screen (see below)

**Modifications / future work**
- [x] Referred friends consistency for regular / pro users 
- [ ] Differentiate between completed vs not completed goals with more strategic use of color -> maybe the progress bar on incomplete goals grayscale (except for the most recent goal) 
- [ ] Celebration animation when user taps "claim." Option to apply the new gem style

**Concessions**
Concessions made with consideration of time constraint vs. user need 
- View with profile pictures next to "Referred friends:" in Top Reward section
- Radial gradient on top of view 
- Dotted container border in Top Reward section
- Unable to fix all constraints warnings -> they occur when the view is reloading and has not yet determined intrinsic content sizes and thus does not have an impact on UX
- Opal pro reward logo is incomplete
- Live updates for new rewards + referrals -> Unsure how to implement without a remote data source

