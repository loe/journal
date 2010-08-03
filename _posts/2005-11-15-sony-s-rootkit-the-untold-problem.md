--- 
layout: post
title: "Sony's Rootkit: the untold problem"
---
The whole <a href="http://news.com.com/FAQ+Sonys+rootkit+CDs/2100-1029_3-5946760.html">Sony debacle</a> has been well documented over the last few days. What bugs me more is how <a href="http://microsoft.com/">Microsoft</a> is dealing with the threat. Instead of attacking the root of the problem, they have stated in <a href="http://blogs.technet.com/antimalware/archive/2005/11/12/414299.aspx">a blog post</a> that they will be <a href="http://blogs.technet.com/antimalware/archive/2005/11/12/414299.aspx">removing the rootkit</a> with their <a href="http://www.microsoft.com/athome/security/spyware/software">AntiSpyware Tool</a>. Why is this an issue? Microsoft's approach is wrong. Their entire approach to security is, and this issue does nothing but affirm that. It shouldn't be possible to install the Sony rootkit. Yes it is possible to install rootkits through buffer overflows and other shady methods, but these are MUCH more difficult install; consequently, they are much less frequent. The Sony rootkit is passively installed by the user when they run the CD, why isn't the user notified of this, not even asked for their password in order to modify system files? This problem would never happen on OS X because it would ask the user for their password - something that shouldn't happen when playing a standard audio CD. This minor difference in approaching security is a big part of why OS X has fewer security issues. Windows might be more securely coded than OS X (fewer buffer overflows etc.) but it invites exploits. I wish the trust everyone architecture could change overnight, it would solve most of the issues we face with the internet. 