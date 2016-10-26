SecondAid App Design Document

## Table of Contents
  * [App Design](#app-design)
    * [Objective](#objective)
    * [Audience](#audience)
    * [Experience](#experience)
  * [Technical](#technical)
    * [Screens](#Screens)
    * [External services](#external-services)
    * [Views, View Controllers, and other Classes](#Views-View-Controllers-and-other-Classes)
  * [MVP Milestones](#mvp-milestones)
    * [Week 1](#week-1)
    * [Week 2](#week-2)
    * [Week 3](#week-3)
    * [Week 4](#week-4)
    * [Week 5](#week-5)
    * [Week 6](#week-6)

---

### App Design

#### Objective
Anybody who is in distress or sees others in distress can alert first-aid trained individuals within their vicinity to come to their aid. 

#### Audience
Anybody who is not first-aid trained but wants to help others in emergency situations can use the app 

#### Experience
As a normal user, I want to be able to help those in physical trouble even though I am not first-aid trained so that they can receive the necessary medical attention as soon as possible

[Back to top ^](#)

---

### Technical

#### Screens
* Main login/sign-up page
  * Sign-up page that requires certain personal particulars
    * Fullname
    * Email
    * Phone number
    * Password/Re-enter password
    * First-aid experience
  * Sign-up acknowledgment page
    * Input verification code
  * Forgot password page
    * Key in registered email address
    * Input verification code
  * Reset password page
    * Password/Re-enter password
* Notifications page
  * Explanation for first-time users
    * Explains how to use app for callers
    * Explains how to use app for responders
  * Summary page - lists all alerts in the past 10 mins
    * Alert time
    * Responses
    * Distance from location
    * Responded?
    * Alert Description
  * Specific notification page - shows when individual entries are clicked
    * Map view of alert location
    * Number of responders to alert
    * I'm coming button
    * Callback button
* SOS page
  * Fields to include description at scene
    * Alerter's clothes color
    * Nearby landmark
    * Victim's condition
    * Other info
  * Light image that changes colour according to alert status
    * Unlit - Default
    * Red - Alert sent
    * Green - First-aiders on their way
  * Call for help button
    * Default - "Call for help!"
      * Prompts for user's password
    * Pressed - "Alert sent!"
* Settings page
  * Set effective distance for notification
  * Change first aid qualification
  * Terminate account

#### External services
* Apple's UIMapKit
* Push Notification
* Parse

#### Views, View Controllers, and other Classes
* Views
  * List Notification Table View Cell
    * Col 1 : Time elapsed
    * Col 2 : Number of responders 
    * Col 3 : Description (click to get pop-up view with more descriptions)
* View Controllers
  * Notification view controller 
  * Respond to notification view controller
  * SOS view controller
  * Settings view controller 
* Other Classes
  * Error Handling class
  * Parse Helper class
  * Alerts class

#### Data models
* User class 
  * Username
  * Password
  * Email
  * Phone number
  * First aid experience
  * Current location
* Alerts class
  * Time created (date)
  * From user (PFUser)
  * Alert description (String)
  * Responders (PFRelation)

[Back to top ^](#)

---

### MVP Milestones
[The overall milestones of first usable build, core features, and polish are just suggestions, plan to finish earlier if possible. The last 20% of work tends to take about as much time as the first 80% so do not slack off on your milestones!]

#### Week 1
_planing your app_
* draw up object relationships (mostly done)
* set up basic UI and controllers (done)
* set up parse database models (done)
* start linking up codes (started)



#### Week 2
_finishing a usable build_
* continue linking up codes (continuing)
* implement MapKit (started)



#### Week 3
* implement push notification

#### Week 4
* [goals for the week, should be finishing all core features]

#### Week 5
_starting the polish_
* [goals for the week]

#### Week 6
_submitting to the App Store_
* [goals for the week, should be finishing the polish -- demo day on Saturday!]
