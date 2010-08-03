--- 
layout: post
title: Convert your Rails application database to UTF-8
---

Its unlikely that this will ever matter in local development, but its good practice to have your environment properly setup.

Dump your database to a file:<br />
`$ mysqldump -u root --skip-set-charset project_development > project_development.sql`

Note: If you are using <a href="http://macports.com/">MacPorts</a> for your mysql installation, `mysqldump` will be `mysqldump5`.

Remove the character sets from the table definitions: (be careful if have the phrase ' DEFAULT CHARSET=latin1' in your data it will be removed!)<br />
`$ sed 's/ DEFAULT CHARSET=latin1//' project_development.sql`

Convert the characters in that file from latin1 to UTF-8 using <a href="http://www.gnu.org/software/libiconv/">iconv</a>:<br />
`$ iconv -f latin1 -t UTF-8 project_development.sql > project_development_utf8.sql`

Drop your existing database and recreate it with the appropriate defaults:<br />
`$ mysql -u root --execute="drop database project_development; create database project_development character set utf8 collate utf8_general_ci;"`

Repopulate your database with your converted data:<br />
`$ mysql -u root project_development < project_development_utf8.sql`

Don't forget to add the encoding to your database.yml!<br />

{% highlight yaml %}
development:
  adapter: mysql
  database: project_development
  username: root
  password: 
  host: localhost
  encoding: utf8
{% endhighlight %}