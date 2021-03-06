--- 
layout: post
title: Mongrel vs Evented Mongrel
---

Mongrel is just as fast as Evented Mongrel with a concurrency of 1, but under a concurrency of 10 the difference becomes clear. Evented Mongrel is able to maintain the same 270 req/sec whereas Generic Mongrel falls down to about 120 req/sec.

Hardware is a Celeron 2.4Ghz with 512MB of RAM running Debian Linux.

{% highlight text %}
Concurrency of 1:

Generic Mongrel:

andrew@switch:/var/www/journal.andrewloe.com/current$ ab -n 5000 -c 1 http://journal.andrewloe.com:8200/
This is ApacheBench, Version 2.0.40-dev <$Revision: 1.146 $> apache-2.0
Copyright 1996 Adam Twiss, Zeus Technology Ltd, http://www.zeustech.net/
Copyright 2006 The Apache Software Foundation, http://www.apache.org/

Benchmarking journal.andrewloe.com (be patient)
Completed 500 requests
Completed 1000 requests
Completed 1500 requests
Completed 2000 requests
Completed 2500 requests
Completed 3000 requests
Completed 3500 requests
Completed 4000 requests
Completed 4500 requests
Finished 5000 requests


Server Software:        
Server Hostname:        journal.andrewloe.com
Server Port:            8200

Document Path:          /
Document Length:        24389 bytes

Concurrency Level:      1
Time taken for tests:   18.383634 seconds
Complete requests:      5000
Failed requests:        0
Write errors:           0
Total transferred:      122940000 bytes
HTML transferred:       121945000 bytes
Requests per second:    271.98 [#/sec] (mean)
Time per request:       3.677 [ms] (mean)
Time per request:       3.677 [ms] (mean, across all concurrent requests)
Transfer rate:          6530.70 [Kbytes/sec] received

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        0    0   0.0      0       0
Processing:     2    2   7.5      2      94
Waiting:        0    0   3.0      0      92
Total:          2    2   7.5      2      94

Percentage of the requests served within a certain time (ms)
  50%      2
  66%      2
  75%      2
  80%      2
  90%      3
  95%      3
  98%      3
  99%      3
 100%     94 (longest request)
andrew@switch:/var/www/journal.andrewloe.com/current$ ab -n 5000 -c 1 http://journal.andrewloe.com:8200/
This is ApacheBench, Version 2.0.40-dev <$Revision: 1.146 $> apache-2.0
Copyright 1996 Adam Twiss, Zeus Technology Ltd, http://www.zeustech.net/
Copyright 2006 The Apache Software Foundation, http://www.apache.org/

Benchmarking journal.andrewloe.com (be patient)
Completed 500 requests
Completed 1000 requests
Completed 1500 requests
Completed 2000 requests
Completed 2500 requests
Completed 3000 requests
Completed 3500 requests
Completed 4000 requests
Completed 4500 requests
Finished 5000 requests


Server Software:        
Server Hostname:        journal.andrewloe.com
Server Port:            8200

Document Path:          /
Document Length:        24389 bytes

Concurrency Level:      1
Time taken for tests:   18.287505 seconds
Complete requests:      5000
Failed requests:        0
Write errors:           0
Total transferred:      122940000 bytes
HTML transferred:       121945000 bytes
Requests per second:    273.41 [#/sec] (mean)
Time per request:       3.658 [ms] (mean)
Time per request:       3.658 [ms] (mean, across all concurrent requests)
Transfer rate:          6565.03 [Kbytes/sec] received

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        0    0   0.0      0       0
Processing:     2    2   7.4      2      93
Waiting:        0    0   0.0      0       2
Total:          2    2   7.4      2      93

Percentage of the requests served within a certain time (ms)
  50%      2
  66%      2
  75%      2
  80%      2
  90%      3
  95%      3
  98%      3
  99%      3
 100%     93 (longest request)
andrew@switch:/var/www/journal.andrewloe.com/current$ ab -n 5000 -c 1 http://journal.andrewloe.com:8200/
This is ApacheBench, Version 2.0.40-dev <$Revision: 1.146 $> apache-2.0
Copyright 1996 Adam Twiss, Zeus Technology Ltd, http://www.zeustech.net/
Copyright 2006 The Apache Software Foundation, http://www.apache.org/

Benchmarking journal.andrewloe.com (be patient)
Completed 500 requests
Completed 1000 requests
Completed 1500 requests
Completed 2000 requests
Completed 2500 requests
Completed 3000 requests
Completed 3500 requests
Completed 4000 requests
Completed 4500 requests
Finished 5000 requests


Server Software:        
Server Hostname:        journal.andrewloe.com
Server Port:            8200

Document Path:          /
Document Length:        24389 bytes

Concurrency Level:      1
Time taken for tests:   18.297360 seconds
Complete requests:      5000
Failed requests:        0
Write errors:           0
Total transferred:      122940000 bytes
HTML transferred:       121945000 bytes
Requests per second:    273.26 [#/sec] (mean)
Time per request:       3.659 [ms] (mean)
Time per request:       3.659 [ms] (mean, across all concurrent requests)
Transfer rate:          6561.49 [Kbytes/sec] received

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        0    0   0.0      0       0
Processing:     2    2   7.4      2      93
Waiting:        0    0   0.0      0       0
Total:          2    2   7.4      2      93

Percentage of the requests served within a certain time (ms)
  50%      2
  66%      2
  75%      2
  80%      2
  90%      3
  95%      3
  98%      3
  99%      3
 100%     93 (longest request)
 
Evented Mongrel:

andrew@switch:/var/www/journal.andrewloe.com/current$ ab -n 5000 -c 1 http://journal.andrewloe.com:8200/
This is ApacheBench, Version 2.0.40-dev <$Revision: 1.146 $> apache-2.0
Copyright 1996 Adam Twiss, Zeus Technology Ltd, http://www.zeustech.net/
Copyright 2006 The Apache Software Foundation, http://www.apache.org/

Benchmarking journal.andrewloe.com (be patient)
Completed 500 requests
Completed 1000 requests
Completed 1500 requests
Completed 2000 requests
Completed 2500 requests
Completed 3000 requests
Completed 3500 requests
Completed 4000 requests
Completed 4500 requests
Finished 5000 requests


Server Software:        
Server Hostname:        journal.andrewloe.com
Server Port:            8200

Document Path:          /
Document Length:        24389 bytes

Concurrency Level:      1
Time taken for tests:   18.685346 seconds
Complete requests:      5000
Failed requests:        0
Write errors:           0
Total transferred:      122940000 bytes
HTML transferred:       121945000 bytes
Requests per second:    267.59 [#/sec] (mean)
Time per request:       3.737 [ms] (mean)
Time per request:       3.737 [ms] (mean, across all concurrent requests)
Transfer rate:          6425.25 [Kbytes/sec] received

Connection Times (ms)
             min  mean[+/-sd] median   max
Connect:        0    0   2.7      0      86
Processing:     2    2   7.8      2      99
Waiting:        0    0   0.0      0       0
Total:          2    2   8.3      2      99

Percentage of the requests served within a certain time (ms)
 50%      2
 66%      2
 75%      2
 80%      2
 90%      2
 95%      2
 98%      3
 99%      3
100%     99 (longest request)
andrew@switch:/var/www/journal.andrewloe.com/current$ ab -n 5000 -c 1 http://journal.andrewloe.com:8200/
This is ApacheBench, Version 2.0.40-dev <$Revision: 1.146 $> apache-2.0
Copyright 1996 Adam Twiss, Zeus Technology Ltd, http://www.zeustech.net/
Copyright 2006 The Apache Software Foundation, http://www.apache.org/

Benchmarking journal.andrewloe.com (be patient)
Completed 500 requests
Completed 1000 requests
Completed 1500 requests
Completed 2000 requests
Completed 2500 requests
Completed 3000 requests
Completed 3500 requests
Completed 4000 requests
Completed 4500 requests
Finished 5000 requests


Server Software:        
Server Hostname:        journal.andrewloe.com
Server Port:            8200

Document Path:          /
Document Length:        24389 bytes

Concurrency Level:      1
Time taken for tests:   18.708120 seconds
Complete requests:      5000
Failed requests:        0
Write errors:           0
Total transferred:      122940000 bytes
HTML transferred:       121945000 bytes
Requests per second:    267.26 [#/sec] (mean)
Time per request:       3.742 [ms] (mean)
Time per request:       3.742 [ms] (mean, across all concurrent requests)
Transfer rate:          6417.43 [Kbytes/sec] received

Connection Times (ms)
             min  mean[+/-sd] median   max
Connect:        0    0   2.9      0      85
Processing:     2    2   7.7      2      93
Waiting:        0    0   0.0      0       2
Total:          2    2   8.3      2      93

Percentage of the requests served within a certain time (ms)
 50%      2
 66%      2
 75%      2
 80%      2
 90%      2
 95%      2
 98%      3
 99%      3
100%     93 (longest request)
andrew@switch:/var/www/journal.andrewloe.com/current$ ab -n 5000 -c 1 http://journal.andrewloe.com:8200/
This is ApacheBench, Version 2.0.40-dev <$Revision: 1.146 $> apache-2.0
Copyright 1996 Adam Twiss, Zeus Technology Ltd, http://www.zeustech.net/
Copyright 2006 The Apache Software Foundation, http://www.apache.org/

Benchmarking journal.andrewloe.com (be patient)
Completed 500 requests
Completed 1000 requests
Completed 1500 requests
Completed 2000 requests
Completed 2500 requests
Completed 3000 requests
Completed 3500 requests
Completed 4000 requests
Completed 4500 requests
Finished 5000 requests


Server Software:        
Server Hostname:        journal.andrewloe.com
Server Port:            8200

Document Path:          /
Document Length:        24389 bytes

Concurrency Level:      1
Time taken for tests:   18.759509 seconds
Complete requests:      5000
Failed requests:        0
Write errors:           0
Total transferred:      122940000 bytes
HTML transferred:       121945000 bytes
Requests per second:    266.53 [#/sec] (mean)
Time per request:       3.752 [ms] (mean)
Time per request:       3.752 [ms] (mean, across all concurrent requests)
Transfer rate:          6399.85 [Kbytes/sec] received

Connection Times (ms)
             min  mean[+/-sd] median   max
Connect:        0    0   0.0      0       3
Processing:     2    2   8.4      2      93
Waiting:        0    0   0.1      0       5
Total:          2    2   8.4      2      93

Percentage of the requests served within a certain time (ms)
 50%      2
 66%      2
 75%      2
 80%      2
 90%      2
 95%      2
 98%      3
 99%      3
100%     93 (longest request)

Concurrency of 10:

Generic Mongrel:

andrew@switch:/var/www/journal.andrewloe.com/current$ ab -n 5000 -c 10 http://journal.andrewloe.com:8200/
This is ApacheBench, Version 2.0.40-dev <$Revision: 1.146 $> apache-2.0
Copyright 1996 Adam Twiss, Zeus Technology Ltd, http://www.zeustech.net/
Copyright 2006 The Apache Software Foundation, http://www.apache.org/

Benchmarking journal.andrewloe.com (be patient)
Completed 500 requests
Completed 1000 requests
Completed 1500 requests
Completed 2000 requests
Completed 2500 requests
Completed 3000 requests
Completed 3500 requests
Completed 4000 requests
Completed 4500 requests
Finished 5000 requests


Server Software:        
Server Hostname:        journal.andrewloe.com
Server Port:            8200

Document Path:          /
Document Length:        24389 bytes

Concurrency Level:      10
Time taken for tests:   37.614188 seconds
Complete requests:      5000
Failed requests:        0
Write errors:           0
Total transferred:      122940000 bytes
HTML transferred:       121945000 bytes
Requests per second:    132.93 [#/sec] (mean)
Time per request:       75.228 [ms] (mean)
Time per request:       7.523 [ms] (mean, across all concurrent requests)
Transfer rate:          3191.83 [Kbytes/sec] received

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        0    4  12.3      0     118
Processing:     4   70  38.9     81     189
Waiting:        0   62  37.0     73     181
Total:         27   74  34.0     82     189

Percentage of the requests served within a certain time (ms)
  50%     82
  66%     84
  75%     86
  80%     87
  90%     91
  95%    164
  98%    177
  99%    181
 100%    189 (longest request)
andrew@switch:/var/www/journal.andrewloe.com/current$ ab -n 5000 -c 10 http://journal.andrewloe.com:8200/
This is ApacheBench, Version 2.0.40-dev <$Revision: 1.146 $> apache-2.0
Copyright 1996 Adam Twiss, Zeus Technology Ltd, http://www.zeustech.net/
Copyright 2006 The Apache Software Foundation, http://www.apache.org/

Benchmarking journal.andrewloe.com (be patient)
Completed 500 requests
Completed 1000 requests
Completed 1500 requests
Completed 2000 requests
Completed 2500 requests
Completed 3000 requests
Completed 3500 requests
Completed 4000 requests
Completed 4500 requests
Finished 5000 requests


Server Software:        
Server Hostname:        journal.andrewloe.com
Server Port:            8200

Document Path:          /
Document Length:        24389 bytes

Concurrency Level:      10
Time taken for tests:   45.86964 seconds
Complete requests:      5000
Failed requests:        0
Write errors:           0
Total transferred:      122940000 bytes
HTML transferred:       121945000 bytes
Requests per second:    110.90 [#/sec] (mean)
Time per request:       90.174 [ms] (mean)
Time per request:       9.017 [ms] (mean, across all concurrent requests)
Transfer rate:          2662.81 [Kbytes/sec] received

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        0    0   0.1      0       3
Processing:     3   89  24.1     83     189
Waiting:        0   80  23.0     75     182
Total:          4   89  24.1     83     189

Percentage of the requests served within a certain time (ms)
  50%     83
  66%     85
  75%     86
  80%     87
  90%     91
  95%    174
  98%    179
  99%    182
 100%    189 (longest request)
andrew@switch:/var/www/journal.andrewloe.com/current$ ab -n 5000 -c 10 http://journal.andrewloe.com:8200/
This is ApacheBench, Version 2.0.40-dev <$Revision: 1.146 $> apache-2.0
Copyright 1996 Adam Twiss, Zeus Technology Ltd, http://www.zeustech.net/
Copyright 2006 The Apache Software Foundation, http://www.apache.org/

Benchmarking journal.andrewloe.com (be patient)
Completed 500 requests
Completed 1000 requests
Completed 1500 requests
Completed 2000 requests
Completed 2500 requests
Completed 3000 requests
Completed 3500 requests
Completed 4000 requests
Completed 4500 requests
Finished 5000 requests


Server Software:        
Server Hostname:        journal.andrewloe.com
Server Port:            8200

Document Path:          /
Document Length:        24389 bytes

Concurrency Level:      10
Time taken for tests:   44.996461 seconds
Complete requests:      5000
Failed requests:        0
Write errors:           0
Total transferred:      122940000 bytes
HTML transferred:       121945000 bytes
Requests per second:    111.12 [#/sec] (mean)
Time per request:       89.993 [ms] (mean)
Time per request:       8.999 [ms] (mean, across all concurrent requests)
Transfer rate:          2668.17 [Kbytes/sec] received

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        0    0   0.0      0       0
Processing:    40   89  23.9     83     192
Waiting:       40   80  22.9     75     182
Total:         40   89  23.9     83     192

Percentage of the requests served within a certain time (ms)
  50%     83
  66%     85
  75%     86
  80%     87
  90%     91
  95%    174
  98%    179
  99%    181
 100%    192 (longest request)
 
Evented Mongrel:

andrew@switch:/var/www/journal.andrewloe.com/current$ ab -n 5000 -c 10 http://journal.andrewloe.com:8200/
This is ApacheBench, Version 2.0.40-dev <$Revision: 1.146 $> apache-2.0
Copyright 1996 Adam Twiss, Zeus Technology Ltd, http://www.zeustech.net/
Copyright 2006 The Apache Software Foundation, http://www.apache.org/

Benchmarking journal.andrewloe.com (be patient)
Completed 500 requests
Completed 1000 requests
Completed 1500 requests
Completed 2000 requests
Completed 2500 requests
Completed 3000 requests
Completed 3500 requests
Completed 4000 requests
Completed 4500 requests
Finished 5000 requests


Server Software:        
Server Hostname:        journal.andrewloe.com
Server Port:            8200

Document Path:          /
Document Length:        24389 bytes

Concurrency Level:      10
Time taken for tests:   18.423097 seconds
Complete requests:      5000
Failed requests:        0
Write errors:           0
Total transferred:      122940000 bytes
HTML transferred:       121945000 bytes
Requests per second:    271.40 [#/sec] (mean)
Time per request:       36.846 [ms] (mean)
Time per request:       3.685 [ms] (mean, across all concurrent requests)
Transfer rate:          6516.71 [Kbytes/sec] received

Connection Times (ms)
             min  mean[+/-sd] median   max
Connect:        0    0   0.0      0       1
Processing:    26   36  29.1     27     324
Waiting:       21   31  29.1     23     321
Total:         26   36  29.1     27     324

Percentage of the requests served within a certain time (ms)
 50%     27
 66%     27
 75%     28
 80%     28
 90%     29
 95%    116
 98%    117
 99%    127
100%    324 (longest request)
andrew@switch:/var/www/journal.andrewloe.com/current$ ab -n 5000 -c 10 http://journal.andrewloe.com:8200/
This is ApacheBench, Version 2.0.40-dev <$Revision: 1.146 $> apache-2.0
Copyright 1996 Adam Twiss, Zeus Technology Ltd, http://www.zeustech.net/
Copyright 2006 The Apache Software Foundation, http://www.apache.org/

Benchmarking journal.andrewloe.com (be patient)
Completed 500 requests
Completed 1000 requests
Completed 1500 requests
Completed 2000 requests
Completed 2500 requests
Completed 3000 requests
Completed 3500 requests
Completed 4000 requests
Completed 4500 requests
Finished 5000 requests


Server Software:        
Server Hostname:        journal.andrewloe.com
Server Port:            8200

Document Path:          /
Document Length:        24389 bytes

Concurrency Level:      10
Time taken for tests:   17.749860 seconds
Complete requests:      5000
Failed requests:        0
Write errors:           0
Total transferred:      122940000 bytes
HTML transferred:       121945000 bytes
Requests per second:    281.69 [#/sec] (mean)
Time per request:       35.500 [ms] (mean)
Time per request:       3.550 [ms] (mean, across all concurrent requests)
Transfer rate:          6763.88 [Kbytes/sec] received

Connection Times (ms)
             min  mean[+/-sd] median   max
Connect:        0    0   0.0      0       1
Processing:    23   34  24.9     27     117
Waiting:       20   30  24.9     23     113
Total:         24   34  24.9     27     117

Percentage of the requests served within a certain time (ms)
 50%     27
 66%     27
 75%     28
 80%     28
 90%     28
 95%    116
 98%    116
 99%    117
100%    117 (longest request)
andrew@switch:/var/www/journal.andrewloe.com/current$ ab -n 5000 -c 10 http://journal.andrewloe.com:8200/
This is ApacheBench, Version 2.0.40-dev <$Revision: 1.146 $> apache-2.0
Copyright 1996 Adam Twiss, Zeus Technology Ltd, http://www.zeustech.net/
Copyright 2006 The Apache Software Foundation, http://www.apache.org/

Benchmarking journal.andrewloe.com (be patient)
Completed 500 requests
Completed 1000 requests
Completed 1500 requests
Completed 2000 requests
Completed 2500 requests
Completed 3000 requests
Completed 3500 requests
Completed 4000 requests
Completed 4500 requests
Finished 5000 requests


Server Software:        
Server Hostname:        journal.andrewloe.com
Server Port:            8200

Document Path:          /
Document Length:        24389 bytes

Concurrency Level:      10
Time taken for tests:   18.685583 seconds
Complete requests:      5000
Failed requests:        0
Write errors:           0
Total transferred:      122940000 bytes
HTML transferred:       121945000 bytes
Requests per second:    267.59 [#/sec] (mean)
Time per request:       37.371 [ms] (mean)
Time per request:       3.737 [ms] (mean, across all concurrent requests)
Transfer rate:          6425.17 [Kbytes/sec] received

Connection Times (ms)
             min  mean[+/-sd] median   max
Connect:        5   16  18.5     14     112
Processing:     4   20  20.1     17     115
Waiting:        0   13  19.1     11     111
Total:         25   36  24.9     29     120

Percentage of the requests served within a certain time (ms)
 50%     29
 66%     29
 75%     29
 80%     30
 90%     30
 95%    118
 98%    119
 99%    119
100%    120 (longest request)
{% endhighlight %}
