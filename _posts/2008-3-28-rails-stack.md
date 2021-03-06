--- 
layout: post
title: Rails Stack
---
## [Linux](http://kernel.org/), [MySQL](http://mysql.com/), [nginx](http://nginx.org/), [Mongrel](http://mongrel.rubyforge.com/), [Rails](http://rubyonrails.org/), and friends.

## Big Picture:

An ideal setup uses two different servers or virtual machines to split up the load and facilitate scaling. The first machine runs nginx serving static content and acting as a reverse proxy passing dynamic requests to a pool of mongrels running the rails application. The second machine is a dedicated MySQL database server. Even if you only have one physical box, two virtual machines (Xen based) is preferred, it is easier to scale and doesn't require as much memory context switching. Our host, Engine Yard, uses a similar setup based on Gentoo and Xen.

## Linux Setup:

All of the tools and applications used in this stack are actively developed and available in most package management systems. This document will assume you use Debian/GNU Linux, but will work equally well on Ubuntu. If choose to use Fedora, Gentoo or another distribution, you will need substitute commands for your package-management tool.

Installing and configuring Linux is outside the scope of this document, but you should strive for a minimalist system based on a recent release of the 2.6 kernel. Debian and Ubuntu both offer a number of "pre-made" configurations in their installers, just avoid installing anything more than the base system as it will just add more software that you will have to disable or remove later.

## Conventions:

`$` indicates a standard shell prompt.

`#` indicates the command needs to be run as the root user, either by switching to the root user account or assuming root privileges with a tool like `sudo`.

## Tools:

While installing and managing a Linux server, you will often need the power of the root account. However, because the root user is so powerful, it dangerous to use all the time. A better solution is to use a standard user account and only assume the privileges of the root user when necessary. Sudo was designed to do exactly this.

`# apt-get install sudo`

Once the package is installed, the list of users able to assume root powers is controlled by `/etc/sudoers`. This file must be edited with the `visudo` command, which will open your default editor (or vi if your shell does not have an editor set).

`# visudo`

If you are unfamiliar with vi, press 'i' to put it in insert mode, then add a line to enable your user.

`username	ALL=(ALL) ALL`

You can read more on the sudo package to better understand this configuration file. Once you have completed your edit, press escape (ESC) to exit editor mode. To save the file type ':' to enter command mode and then type 'w' and 'q' (meaning write and quit). The file should be properly saved and your user will now be able to assume root privileges.

## Database Server:

MySQL is our database of choice, it is popular in the Rails community, proven to scale, and fast (especially in a read heavy environment).

To install, use the mysql-server package.

`# apt-get install mysql-server`

Your package manager should handle all the dependencies, including the mysql-client package, which we will use to improve our Ruby to MySQL performance. The installer may prompt you for a few questions, aim to accept the defaults and enter in information specific to your server.

### Database Configuration:

The configuration file for MySQL is usually located in `/etc/mysql as my.cnf`. Most MySQL packages also include a number of other simple configurations to help MySQL perform better. Take a look at `my-large.cnf` and `my-small.cnf` in `/usr/share/mysql` and update your `/etc/mysql/my.cnf` to reflect your hardware or virtual machine's configuration. MySQL tuning is a complex subject, but some basic configuration can go a long way to helping the application to perform well.

Before adding any databases, it is also important to instruct MySQL to use more international character encodings and collations. Storing the data in this way will make internationalization a simpler task in the future.

In `/etc/mysql/my.cnf`:

{% highlight text %}
[client]
default-character-set = utf8

[server]
default-character-set = utf8
default-collation = utf8_general_ci
{% endhighlight %}

These directives instruct MySQL to use UTF-8 for everything. If you have not already, restart your database server.

`# /etc/init.d/mysql restart`

You can now add the database to the server.

`$ mysqladmin -u root create database_name`

Consult the MySQL documentation to change the root user's password and to add a user with privileges on the specific database. It may be simpler to use a MySQL administration GUI to achieve these tasks.

## Application Server

The application server requires the most complex setup.

### Ruby & Ruby Gems

To start, you will need [Ruby](http://www.ruby-lang.org/) and [Ruby Gems](http://www.ruby-lang.org/).

`# apt-get install ruby rubygems`

`ruby` is a transitional package, currently it will install Ruby 1.8.6 (as of March 20, 2008), unless you know of a specific feature or bug to avoid, it is simplest to let the the package-management system handle which version you get. [Ruby Gems](http://rubyforge.org/projects/rubygems/) is a package management system for system for third party ruby libraries, it functions much like [CPAN](http://www.cpan.org/) for [Perl](http://www.perl.com/) or [PEAR](http://www.perl.com/) for [PHP](http://php.net/). We're going to want a number of gems, but first lets update gems itself, from within itself -- how meta.

`# gem update --system`

Ruby gems should now download and recompile itself. Once that has completed, you can install the gems we'll need. The first one is a bit trickier than the others.

`# gem install mysql`

The `mysql` gem provides fast C bindings between Ruby and MySQL, if you aren't already using these on your local machine you should give them a spin, the performance increase is well worth the minimal amount of effort required to install them. If you have your MySQL installed in a non-standard location, you may have to pass in `mysql_config`.

`# gem install mysql -- --with-mysql-config=/your/path/to/mysql_config`

With `mysql` all setup and out of the way, its easy to install everything else you need.

`# gem install rails mongrel mongrel_cluster`

`rails` is optional, you may choose to freeze rails inside your application, which would override this gem. `mongrel` and `mongrel_cluster` are the gems that provide us with our application server. Before diving into mongrel, there are a few more gems you may want that are entirely optional. 

`# gem install tmail swiftiply`

`tmail` is an e-mail library, and is the same library that the `ActiveMailer` component of Rails uses. Rails 2.0 now looks for this gem before loading its own bundled copy; by installing the gem you can get extra features and bug fixes that may have been released.

`swiftiply` is a gem that patches mongrel to use the event based network programming model, commonly called "evented mongrels". You can find more on [Ezra Zygmuntowicz's Brainspl.at](http://brainspl.at/articles/2007/05/12/event-driven-mongrel-and-swiftiply-proxy) and [my journal](http://journal.andrewloe.com/) where I did some [elementary benchmarking](http://journal.andrewloe.com/2007/05/22/mongrel-vs-evented-mongrel/).

### Mongrel

[Mongrel](http://mongrel.rubyforge.org/) will serve as our application server, containing an instance of the Ruby interpreter and our Rails application.

bq. Mongrel is a fast HTTP library and server for Ruby that is intended for hosting Ruby web applications of any kind using plain HTTP rather than FastCGI or SCGI.

From inside your rails application you can start a mongrel server and interact with your application. By default, rails will start in development mode.

`$ mongrel_rails start`

A daemon with the application should now be running on port 3000. `ctrl+c` to stop the server, lets move on to [mongrel_cluster](http://mongrel.rubyforge.org/wiki/MongrelCluster)

### Mongrel Cluster

[Mongrel Cluster](http://mongrel.rubyforge.org/wiki/MongrelCluster) will manage a pool of mongrels that nginx will reverse proxy requests to.

bq. Mongrel_cluster is a GemPlugin that wrappers the mongrel HTTP server and simplifies the deployment of webapps using a cluster of mongrel servers. Mongrel_cluster will conveniently configure and control several mongrel servers, or groups of mongrel servers, which are then load balanced using a reverse proxy solution.

The [wiki](http://mongrel.rubyforge.org/wiki/MongrelCluster) has more extensive documentation, right now we will only look at the basics.

`# mongrel_rails cluster::configure -e production -p 8000 -N 3 -c /path/to/your/application -a 127.0.0.1 --user mongrel --group mongrel`

This line creates the file `application/path/config/mongrel_cluster.yml`. Most of the switches are self explanatory, `-a 127.0.0.1` configures the IP that the server binds to, by making it local you make it impossible to hit a mongrel directly without passing through the proxy. `-p` and `-N` configure the start port and the number of mongrels to start, so 8000, 8001, and 8002 in this case. `--user` and `--group` are the system user and group the servers will run under; because the mongrels run on an unprivileged port, they may run as an unprivileged user to improve security. `-e` is the environment our rails application will run in and `-c` is the path to our application (mongrel cluster will look for its configuration file at this path + `config/mongrel_cluster.yml`, you may use `-C` if you want to directly specify a YAML config file).

{% highlight yaml %}
--- 
user: mongrel
group: mongrel
cwd: /path/to/my/application
address: 127.0.0.1
port: "8000"
servers: 3
environment: production
pid_file: log/mongrel.pid
{% endhighlight %}

### Evented Mongrel

To use evented mongrels, you just need to pass an environmental variable `EVENT=1` while starting your server. With `mongrel_cluster` that will look like this:

`# EVENT=1 mongrel_rails cluster::start`

Don't forget to pass it even if you are just restarting the servers! At the top of the mongrel.log you should see it notify you that it is using events.

## Web Server

Currently our application server and web server are on the same virtual machine. In the future, we may choose to scale by moving the web server and static content to another virtual machine (or perhaps a CDN like Akamai) and have pure application servers. For now, we will keep things simple.

### nginx

[nginx](http://nginx.org/) is a very fast proxy that we will also use to serve our static content.

`# apt-get install nginx`

Configuration is very straight forward, everything is done in `/etc/nginx/nginx.conf`. The following configuration is based on [Ezra Zygmuntowicz's Brainspl.at" "nginx.conf](http://brainspl.at/nginx.conf.txt).

{% highlight nginx %}
# user and group to run as
user  www-data www-data;

# number of nginx workers
worker_processes  3;

# pid of nginx master process
pid /var/run/nginx.pid;

# Number of worker connections. 1024 is a good default
events {
  worker_connections 1024;
}

# start the http module where we config http access.
http {
  # pull in mime-types. You can break out your config 
  # into as many include's as you want to make it cleaner
  include /etc/nginx/mime.types;

  # set a default type for the rare situation that
  # nothing matches from the mimie-type include
  default_type  application/octet-stream;

  # configure log format
  log_format main '$remote_addr - $remote_user [$time_local] '
                  '"$request" $status  $body_bytes_sent "$http_referer" '
                  '"$http_user_agent" "$http_x_forwarded_for"';

  # main access log
  access_log  /var/log/nginx_access.log  main;

  # main error log
  error_log  /var/log/nginx_error.log debug;

  # no sendfile on OSX
  sendfile on;

  # These are good default values.
  tcp_nopush        on;
  tcp_nodelay       off;
  # output compression saves bandwidth 
  gzip            on;
  gzip_http_version 1.0;
  gzip_comp_level 2;
  gzip_proxied any;
  gzip_types      text/plain text/html text/css application/x-javascript text/xml application/xml application/xml+rss text/javascript;


  # this is where you define your mongrel clusters. 
  # you need one of these blocks for each cluster
  # and each one needs its own name to refer to it later.
  upstream mongrel {
		fair; # This changes from round-robin based to load based.
    server 127.0.0.1:8000;
    server 127.0.0.1:8001;
    server 127.0.0.1:8002;
  }


  # the server directive is nginx's virtual host directive.
  server {
    # port to listen on. Can also be set to an IP:PORT
    listen 80;
    
    # Set the max size for file uploads to 50Mb
    client_max_body_size 50M;

    # sets the domain[s] that this vhost server requests for
    # server_name www.[yourdomain].com [yourdomain].com;

    # doc root
    root /path/to/your/application/public;

    # vhost specific access log
    access_log  /var/log/nginx.vhost.access.log  main;

    # this rewrites all the requests to the maintenance.html
    # page if it exists in the doc root. This is for capistrano's
    # disable web task
    if (-f $document_root/system/maintenance.html) {
      rewrite  ^(.*)$  /system/maintenance.html last;
      break;
    }

    location / {
      # needed to forward user's IP address to rails
      proxy_set_header  X-Real-IP  $remote_addr;

      # needed for HTTPS
      proxy_set_header  X-Forwarded-For $proxy_add_x_forwarded_for;
      proxy_set_header Host $http_host;
      proxy_redirect false;
      proxy_max_temp_file_size 0;
      
      # If the file exists as a static file serve it directly without
      # running all the other rewite tests on it
      if (-f $request_filename) { 
        break; 
      }

      # check for index.html for directory index
      # if its there on the filesystem then rewite 
      # the url to add /index.html to the end of it
      # and then break to send it to the next config rules.
      if (-f $request_filename/index.html) {
        rewrite (.*) $1/index.html break;
      }

      # this is the meat of the rails page caching config
      # it adds .html to the end of the url and then checks
      # the filesystem for that file. If it exists, then we
      # rewite the url to have explicit .html on the end 
      # and then send it on its way to the next config rule.
      # if there is no file on the fs then it sets all the 
      # necessary headers and proxies to our upstream mongrels
      if (-f $request_filename.html) {
        rewrite (.*) $1.html break;
      }

      if (!-f $request_filename) {
        proxy_pass http://mongrel;
        break;
      }
    }

    error_page   500 502 503 504  /500.html;
    location = /500.html {
      root   /path/to/your/application/public;
    }
  }
}
{% endhighlight %}

Now that you have nginx configured, start it and you should have a solid rails stack up and running.

`# /etc/init.d/nginx start`

## Request Cycle

Unlike more traditional setups, each individual request does not necessarily take the same path. Nginx monitors port 80 and accepts all incoming requests. Using the rewrite rules it looks for a file in the `public` directory with `/url/path + .html`. If it finds this static HTML page, it replies. It also searches for `index.html` to retrieve folder indexes. These static HTML files are generated by rails' page caching mechanism, and provide enormous performance gains at a cost of flexibility. If nginx is unable to find an HTML page, it forwards the request to the cluster of mongrels. The mongrel that gets the request depends on which proxy algorithm you choose; the fair option spread the requests based on availability. Once received, the mongrel then runs the request through the rails application: the database is hit, ruby does some magic, and a page is completed and passed back to the mongrel which logs the request as complete and passes it back to nginx. If page caching is enabled, rails writes the page that was just generated to the `public` directory (lazy caching) before handing it off to the mongrel. Nginx takes this page and forwards it to the browser, acting as a proxy (gateway). The general process is repeated on each request, but the mongrel that is given the dynamic request will be different, and a cached page may be found, avoiding the need to engage the mongrels all together.
