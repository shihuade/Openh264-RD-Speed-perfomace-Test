Openh264-RD-Speed-perfomace-Test
===============================

About:
------
- this repositiry is for openh264 RD and speed preformance test
     - SCC RD and speed performance test for those YUV list in YUV_SCC.cfg
     - SVC RD and speed performance test for those YUV list in YUV_SVC.cfg
- test report is under folder ./TestResult
     - AllTestSequence_SCC.csv is SCC test report
     - AllTestSequence_SVC.csv is SVC test report
     - AllTestSequence_XXX.csv contain all YUVs' performance data(psnr, bit rate, fps and encoder time)


Usage:
-----
- ./run_Main.sh    YUV_SCC.cfg    YUV_SVC.cfg     $YourTestYUVDir
     - script will search YUV file under given YUVDir
     - test time depends on how many sequences in YUC_XXX.cfg
     - wait for minutes,and final test report can be found at ./TestResult
     - for more detail about each test YUV's info, you can refer to xxx.log files
     
Structure of Working directory：
-------------------------------
- AllTestData
     - will be deleted and  created before test
     - test space for all test YUVs
     - all test temp data e.g log files, bit stream files etc are generated under this directory
     
- Scripts
     - test related script files
- Codec
   - will be deleted and  created before test
   - codec and cfg files are copied to this folder after building codec from ./Source

- Source
   - will be deleted and  created before test
   - for latest openh264 repository clone from offical github website
- TestResult
   - will be deleted and  created before test
   - all test report can be found under this folder when all test completed
   
How does it work:
------------
-    1. prepare test folder: ./Codec  ./Source   ./TestResult  ./AllTestData
-    2. run_CheckoutCiscoOpenh264Codec.sh will clone latest openh264 repository from https://github.com/cisco/openh264
        to ./Source
-    3. run_BuildCodec.sh will open PSNR calculation macro and build codec, copy codec, cfg files  to ./Codec 
-    4. run_AllTestSequence.sh will run test for all test YUVs
-    5. copy test report AllTestSequence_XXX.csv from ./AllTestData to ./TestResult


Test YUV configuration:
----------------------
- for SCC YUVs, please list the name in YUV_SCC.cfg 
- for SVC YUVs, please list the name in YUV_SVC.cfg 
- for All test YUVs, please put it under $YoutTestYUV folder

PSNR calculate macro:
---------------------
- enable below macro in file /codec/encoder/core/inc/as264_common.h
     - actually, it will be automatically done by script run_BuildCodec.sh
     - #define FRAME_INFO_OUTPUT
     - #define STAT_OUTPUT
     - #define ENABLE_PSNR_CALC



