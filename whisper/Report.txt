We ran a test to change the way we presented a feed of whispers to our users.
How do you think the test performed ?



Data:
there are 2 data files:

users.csv -> has the userid, device they use, time that they started using whisper
	  -> FORMAT: user_id, device_type & app_version, ts_created

events.csv -> a log of events that the app generated for different cohorts
	   -> FORMAT: test cohort of the event, event name, user_id, whisper_id, extra information, time when the event was generated
	   -> the extra field contains "reply" when the whisper was in reply to another whisper and "top-level" when it's a top level post.


Please include analysis, code and conclusion in a pdf report.



Analysis Result
===============

### Data Errors

1. users.csv log file has 29 users with wrong datetime stamp "1969-12-31 16:00:00"


### Statistics:

1. Excluding "1969-12-31 16:00:00" from users.csv

    users.csv log range from = 2012-07-08 11:01:30
                          to = 2016-02-25 18:27:03

2. events.csv log range from = 2016-03-02 18:39:48 
                          to = 2016-03-10 18:28:41

3.
   -------------- Top 25 Operating System By User  ----------------

                    48,515                ios 5.8.1
                    29,205               ios 5.8.13
                    23,765            android 5.9.1
                    15,034               ios 5.8.12
                    14,177           android 5.9.11
                    9,581            android 5.9.10
                    2,531                ios 5.8.11
                    2,304             android 5.9.6
                    1,660                ios 5.8.10
                    1,003                 ios 5.9.4
                    859                   ios 5.8.9
                    738               android 5.9.8
                    648               android 5.9.0
                    557               android 4.6.6
                    515                   ios 4.6.6
                    358                   ios 5.9.2
                    337               android 5.8.1
                    277                   ios 5.8.7
                    232                   ios 5.8.6
                    230              android 5.8.11
                    229                   ios 5.8.8
                    192                   ios 5.8.2
                    151               android 5.9.4
                    140                   ios 4.6.4
                    137                   ios 4.2.0

4.  Total Top-Level:  180,199
    Total Reply    :  399,266



5. Cohort Statistics:

                        A cohort : reply      =   71,135
                        A cohort : top-level  =   29,222
                        A cohort : undefined  =  186,227
                       ------------------------------------
                               Total A cohort =  286,584


                        B cohort : reply      =   67,543
                        B cohort : top-level  =   30,208
                        B cohort : undefined  =  185,090
                       ------------------------------------
                               Total B cohort =  282,841 
                        
                        C cohort : reply      =   66,765
                        C cohort : top-level  =   30,486
                        C cohort : undefined  =  182,906
                       ------------------------------------
                               Total C cohort =  280,157
                        
                        D cohort : reply      =   66,266
                        D cohort : top-level  =   30,468
                        D cohort : undefined  =  186,345
                       ------------------------------------
                               Total D cohort =  283,079
                        
                        E cohort : reply      =   61,427
                        E cohort : top-level  =   29,939
                        E cohort : undefined  =  186,478
                       ------------------------------------
                               Total E cohort =  277,844
                        
                        F cohort : reply      =   66,130
                        F cohort : top-level  =   29,876
                        F cohort : undefined  =  194,162
                       ------------------------------------
                               Total F cohort =  290,168


7. Detail Cohort Statistics 

            A Cohort : reply Whisper Created           =   71,135
            A Cohort : top-level Whisper Created       =   29,222
            A Cohort : undefined Conversation Created  =   99,318
            A Cohort : undefined Heart                 =   86,909
            
            B Cohort : reply Whisper Created           =   67,543
            B Cohort : top-level Whisper Created       =   30,208
            B Cohort : undefined Conversation Created  =   97,166
            B Cohort : undefined Heart                 =   87,924
            
            C Cohort : reply Whisper Created           =   66,765
            C Cohort : top-level Whisper Created       =   30,486
            C Cohort : undefined Conversation Created  =   97,779
            C Cohort : undefined Heart                 =   85,127
            
            D Cohort : reply Whisper Created           =   66,266
            D Cohort : top-level Whisper Created       =   30,468
            D Cohort : undefined Conversation Created  =  105,250
            D Cohort : undefined Heart                 =   81,095
            
            E Cohort : reply Whisper Created           =   61,427
            E Cohort : top-level Whisper Created       =   29,939
            E Cohort : undefined Conversation Created  =  100,205
            E Cohort : undefined Heart                 =   86,273
            
            F Cohort : reply Whisper Created           =   66,130
            F Cohort : top-level Whisper Created       =   29,876
            F Cohort : undefined Conversation Created  =  103,766
            F Cohort : undefined Heart                 =   90,396


