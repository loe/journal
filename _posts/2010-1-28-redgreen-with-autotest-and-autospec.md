--- 
layout: post
title: redgreen with autotest and autospec
---
I use both RSpec and Test/Unit and the accompanying autospec and autotest. I was struggling to get coloring for both without breakage.

Trick is to only require redgreen/autotest if the RSPEC environmental variable is not set. Here is my ~/.autotest:

{% highlight ruby %}
require 'autotest/fsevent'
require 'autotest/growl'
require 'redgreen/autotest' unless ENV['RSPEC']

Autotest::Growl::show_modified_files = true
Autotest::Growl::remote_notification = true
Autotest::Growl::image_dir = File.join(ENV['HOME'], '.autotest-growl')

Autotest.add_hook :initialize do |at|
  at.sleep = 1
  %w{.svn .hg .git vendor}.each {|exception| at.add_exception(exception)}
  
  unless ARGV.empty?
    if File.exist? 'config/environment.rb'
      at.find_directories = ARGV.length == 1 ? ["spec/#{ARGV.first}", "app/#{ARGV.first}"] : ARGV.dup
    end
  end
  
  at.add_mapping(%r%^spec/(processors|mailers|middlewares)/.*rb$%) { |filename, _| filename }
end
{% endhighlight %}