--- 
layout: post
title: Comments are back!
---
After a few minutes of tinkering I've got an <a href="http://www.wellardsworld.com/archives/2004/10/30/imageauth-hack-for-wordpress/">Image Authenitcation</a> system in place. The system is essentially pretty simple. Every time a comment page is visited a random image is generated, along with its key. The user then just enters the key they see in the randomly generated image when posting a comment and the script checks this, failures will be rejected. Every 30 minutes cron goes through and deletes all the images more than 30 minutes old. Works for me.
