*** Settings ***
#Suite Setup       SetupBrowsingEnv
#Suite Teardown    DestroyBrowsingEnv
Resource          ../../../lib/web/WebLib.txt
Resource          ../../../lib/web/Ingestion/Ingestion_Config_UI.txt
Library           Selenium2Library
*** Variables ***
${url}            http://plaban-lenovo:9090/
${app_pkg_loc}    /home/plaban/tf2jan/apa/pi-demo-3.4.0.apa
${dt_version}     3.8.0-SNAPSHOT
${apex_version}    3.4.0
${email_id}       plaban.biswas@sitpune.edu.in
${password}       usui!9!9
${Pkg_Name}    Mobile Demo
${App_Name}    MobileDemo
${Alter_Pkg_Name}    Pi Demo
${Alter_App_Name}    PiDemo



*** Test Cases ***
Run_Demo_App_Test      #PASS
    [Documentation]    Test case details: plaban-lenovo:9090
    Connect_To_DT_Console    ${url}
    #Develop The App    Demo    Pi Demo
    Launch The app    Pi Demo    PiDemo
    sleep    10s
    Click Element     xpath=/html/body/div[4]/div/div[4]/a
    sleep    10s
    ${state}   Get Text    xpath=//span[@dt-status='data.state']/span
    Run Keyword Unless    '${state}'=='RUNNING'    Fail    PiDemo application is not started, current state is ${state}
    [Teardown]    Close Browser





Run_Non_Existing_Application_Test   #PASS
    Connect_To_DT_Console    ${url}
    #Develop The App     Demo    Mobile Demo
    Launch The app    Pi Demo    PiDemo
    #Mobile Demo    MobileDemo  #pre
    [Teardown]    Close Browser

Run_New_Application_Test      #PASS
    Connect_To_DT_Console    ${url}
    #Develop The App    Demo    Pi Demo    #/full/path/which/is/correct
    Launch The app    Pi Demo    PiDemo
    [Teardown]    Close Browser

Verify_License_Details       #PASS
    Connect_To_DT_Console    ${url}
    ${test}=    License_Info_Details
    Log Dictionary    ${test}
    [Teardown]    Close Browser

Import_New_License_Test     #PASS
    Connect_To_DT_Console    ${url}
    Import_License_File    /home/plaban/datatorrent/releases/3.6.0/COMMUNITY_EDITION_LICENSE.txt
    #/home/corect/path/here/DT_Certification/dt-20150504212046-j6u0k2fe

Verify_Gateway_Info_Details   #PASS
    Connect_To_DT_Console    ${url}
    ${test}=    System_Gw_Info_Details
    Log Dictionary    ${test}
    ${GateWayInfo}=  Get From Dictionary    ${test}    version
    ${GateWayInfo}=  Convert To String   ${GateWayInfo}
    ${version_string}=    convert to string        3.5.0-dt20160916
    log    ${version_string}
    #dictionary should contain item    ${test}    version    ${version_string}
    List Should Contain Value    ${GateWayInfo}    ${version_string}
    [Teardown]    Close Browser

Verify_Hadoop_Info_Details   #PASS
    Connect_To_DT_Console    ${url}
    ${test}=    Hadoop_Info_Details
    [Teardown]    Close Browser

Application_Shutdown_Test    #PASS
    [Documentation]    Test case details: plaban-lenovo:9090
    Connect_To_DT_Console    ${url}
    Develop The App    Demo    Pi Demo
    Launch The app    Pi Demo    PiDemo
    sleep    10s
    Click Element     xpath=/html/body/div[4]/div/div[4]/a
    #//t[contains(text(),"Application ID")]/../a    #Navigate to the launched app monitor page through the link on success message
    sleep    15s
    ${state}    Get Text    //span[@dt-status='data.state']/span
    Run Keyword Unless    '${state}'=='RUNNING'    Fail    PiDemo application is not started, current state is ${state}
    sleep    10s
    Click Element    //span[text()='shutdown']/..    #Shutdown the launched app
    Wait Until Page Contains Element    //h3[text()="End this application?"]    #timeout=10s
    Click Element    //button[contains(@class,'btn-danger')]
    sleep    10s
    Wait Until Page Contains Element    //span[text()='FINISHED']/..
    [Teardown]    Close Browser

Application_Kill_Test   #PASS
    [Documentation]    Test case details: plaban-lenovo:9090
    Connect_To_DT_Console    ${url}
    #Develop The App    Demo    Pi Demo
    Launch The app    Pi Demo    PiDemo
    sleep    10s
    Click Element    xpath=/html/body/div[4]/div/div[4]/a
    #//t[contains(text(),"Application ID")]/../a    #Navigate to the launched app monitor page through the link on success message
    sleep    15s
    ${state}    Get Text    //span[@dt-status='data.state']/span
    Run Keyword Unless    '${state}'=='RUNNING'    Fail    PiDemo application is not started, current state is ${state}
    sleep    10s
    Click Element    //span[text()='kill']/..    #Shutdown the launched app
    Wait Until Page Contains Element    //h3[text()="End this application?"]    #timeout=10s
    Click Element    //button[contains(@class,'btn-danger')]
    sleep    10s
    Wait Until Page Contains Element    //span[text()='KILLED']/..
    [Teardown]    Close Browser

RTS_APEX_Version_Check
    Connect_To_DT_Console    ${url}
    ${config_info}=    System_Gw_Info_Details
    Log Dictionary    ${config_info}
    Comment    ${version_string}=    convert to string    3.4.0
    Comment    log    ${version_string}
    Comment    Verify Apex version string
    ${apex_version_dict}=    Get From Dictionary    ${config_info}    version
    ${apex_version_dict}=    Convert To String    ${apex_version_dict}
    Log    ${apex_version_dict}
    ${apex_version_str}=    Convert To String    ${apex_version}
    List Should Contain Value    ${apex_version_dict}    ${apex_version_str}
    ${rts_version_dict}    Get From Dictionary    ${config_info}    rtsVersion
    ${rts_version_dict}    Convert To String    ${rts_version_dict}
    Log    ${rts_version_dict}
    ${rts_version_str}=    Convert To String    ${dt_version}
    List Should Contain Value    ${rts_version_dict}    ${rts_version_str}
    [Teardown]    Close Browser

Operator_Kill_Test
    Connect_To_DT_Console    ${url}
    Develop The App    Demo    Pi Demo
    Launch The app    Pi Demo    PiDemo
    sleep    10s
    Click Element    xpath=/html/body/div[4]/div/div[4]/a
    #//t[contains(text(),"Application ID")]/../a    #Navigate to the launched app monitor page through the link on success message
    Sleep    60s    #Delay in response due to remote connection
    Click Element    //span[text()='physical']/..
    sleep    5s
    ${before_kill_Container_ID}    Get Text    //a[text()='rand']/../../..//a[@dt-page-href="Container"]
    Click Element    //a[text()='rand']/../../..//a[@dt-page-href="Container"]    #Retrieve container ID for rand operator
    Page Should Contain Element    //h2[contains(text(),'container')]
    sleep    10s
    Click Element    //tr[@class='even']//input    #Select a container
    Click Element    //t[text()='kill']/..
    Reload Page
    sleep    10s    #Delay in response due to remote connection
    Page Should Contain Element    //span[@ng-if='dtStatus' and text()='KILLED']
    Click Element    //a[@ng-bind="breadcrumb.label" and contains(@ng-href,"apps")]    #Navigate to application monitor page
    Sleep    5s
    ${after_kill_Container_ID}    Get Text    //a[text()='rand']/../../..//a[@dt-page-href="Container"]
    Should Not Be Equal As Strings    ${before_kill_Container_ID}    ${after_kill_Container_ID}
    [Teardown]    Close Browser



####User added
Upload_package_test
    Connect_To_DT_Console    ${url}
    #Develop The App   Demo   Pi Demo

    Launch The App    Pi Demo   PiDemo
    sleep   10s
### Can be used to type text   /html/body/div[2]/div/div[4]/div[2]/div[3]/table/thead/tr[2]
###version --  link  ----/html/body/div[2]/div/div[4]/div[2]/div[2]/h2/a verify string
###Name is unique

###test-Plaban###
Launch_List_Test    #PASS                                                               #Launch_app_from_list_view
    Connect_To_DT_Console    ${url}
    Go_To_Page    Develop    Application Packages                                       #goto home->develop

    Capture Page Screenshot

    ${navigate_to_page}    Set Variable    //t[text()='Application Packages']/..        #generic way to find Application packages instead of Absolute path
    Click Element   xpath=${navigate_to_page}                                           #goto develop->Application packages
    Wait Until Page Contains    Applications    timeout=20s                             #wait for application to become visible
    select checkbox     xpath=(//INPUT[@type='checkbox'])[27]
    Capture Page Screenshot
    sleep   5s
    ${navigate_to_page}    Set Variable    //*[contains(text(),'pi-demo @ 3.5.0')]      #generic for version specific
    Click Element   xpath=${navigate_to_page}
    Wait Until Page Contains    v3.5.0          timeout=20s

    Capture Page Screenshot

    ${navigate_to_page}    Set Variable    //table//a[text()='PiDemo']                  #since many launch options, select one with PiDemo only
    Click Element   xpath=${navigate_to_page}
    Wait Until Page Contains    Package Properties         timeout=20s

    Capture Page Screenshot

    ${navigate_to_page}    Set Variable    //button//span[contains(text(),'launch')]    #search the launch for PiDemo
    Click Element   xpath=${navigate_to_page}
    Wait Until Page Contains    Launch PiDemo         timeout=30s

    Capture Page Screenshot

    ${navigate_to_page}    Set Variable    //button//span[contains(text(),'Launch')]    #search the pop-up window after clicking launch
    Click Element   xpath=${navigate_to_page}
    Wait Until Page Contains    Application ID          timeout=20s

    Capture Page Screenshot

    #${navigate_to_page}    Set Variable   //div//span[contains(text(),'pause')]        #pause the application id popup
    #Click Element   xpath=${navigate_to_page}

    ${navigate_to_page}    Set Variable    //div//a[contains(text(),'application')]     #navigate to monitor
    Click Element   xpath=${navigate_to_page}
    Wait Until Page Contains    State       timeout=50s
    sleep   10s

    Capture Page Screenshot

    ${state}    Get Text     xpath=//span[@dt-status='data.state']/span
    Run Keyword Unless    '${state}'=='RUNNING'    Fail    PiDemo application is not started, current state is ${state}
    [Teardown]    Close Browser


Import_from_AppHub
    Connect_To_DT_Console    ${url}
    Go_To_Page    Develop    AppHub   #goto home->develop
    Capture Page Screenshot

    ${navigate_to_page}    Set Variable    //t[text()='AppHub Packages']/..    #generic way to find Application packages instead of Absolute path
    Click Element   xpath=${navigate_to_page}       #goto develop->AppHub packages
    Wait Until Page Contains    Word Count Demo    timeout=20s     #wait for application to become visible
    Capture Page Screenshot

    ${navigate_to_page}    Set Variable     /html/body/div[2]/div/div[4]/div[16]/div/div/div[2]/a  #generic for version specific
    Click Element   xpath=${navigate_to_page}
    Wait Until Page Contains    v3.4.0          timeout=20s
    Capture Page Screenshot

    sleep  2s
    Click Element        xpath=//button/t[text()='import']  #/html/body/div[2]/div/h2/div/button[1]/t

    sleep  3s

    Capture page screenshot

    [Teardown]    Close Browser

###test-Shubhu###
Launch_New_Way
    [Documentation]    Test case details:http://shubham-inspiron-5558:9090/
    Connect_To_DT_Console    ${url}
    #Develop The App    Demo    Pi Demo
    Launch The App New    mobile-demo    MobileDemo    3.5.0
    sleep    16s
    Click Element     xpath=/html/body/div[4]/div/div[4]/a
    sleep    10s
    ${state}    Get Text    //span[@dt-status='data.state']/span
    sleep    15s
    Run Keyword Unless    '${state}'=='RUNNING'    Fail    PiDemo application is not started, current state is ${state}
    [Teardown]    Close Browser

####test-Aishwarya
Configure_App_Test
    Connect_To_DT_Console    ${url}
    Go_To_Page    Develop     Development
    Wait Until Page Contains     Application Packages

    Click Element   xpath=/html/body/div[2]/div/div[1]/h2/a/t  #app packg link

    Click Element   xpath=/html/body/div[2]/div/h1/div/label[1]/span  #move to grid view
    ${Select_Demo_App_xpath}=    Set Variable     //*[contains(text(),'PiDemo')]       #find the app name
    sleep   5s
    log   ${Select_Demo_App_xpath}

    Wait Until Element Is Visible    xpath=${Select_Demo_App_xpath}
    Click Element    xpath=${Select_Demo_App_xpath}        #click on the app
    sleep     5s

    Click Element   xpath=/html/body/div[2]/div/h1/span[2]/div/button/t     #click on the configure button

    Click Element   xpath=/html/body/ul/li/a           #click on the popup after the previous click

    sleep   7s
    #Wait Until Page Contains    create      timeout=5s


   # Input Text      xpath=//*[@id="pkgName"]    PiDemo_1

    Click Element   xpath=/html/body/div[1]/div/div/div[3]/button[1]      #click on create

    sleep   5s

    Click Element   xpath=/html/body/div[4]/div/div[4]/a        #click on the link in the successful msg

    sleep   5s
    Wait Until Page Contains    launch      timeout=10s
    Click Element   xpath=/html/body/div[2]/div/h1/span[2]/button[3]      #click on the launch button for this configuration
    sleep   5s
    Click Element   xpath=/html/body/div[1]/div/div/form/div[3]/button[1]/span      #click on the green launch button in the popup

    sleep   10s
    Wait Until Page Contains    Application ID      timeout=30s
    #Click Element     xpath=/html/body/div[4]/div/div[2]/span       #click on the pause button

    Click Element     xpath=/html/body/div[4]/div/div[4]/a      #click on the appid  crashing
    sleep    7s
    ${state}   Get Text    xpath=//span[@dt-status='data.state']/span
    sleep   20s
    Run Keyword Unless    '${state}'=='RUNNING'    Fail    PiDemo application is not started, current state is ${state}   timeout=10s


    [Teardown]    Close Browser

App_Details_Containers_deselectall
    Connect_To_DT_Console    ${url}
    Connect_To_DT_Console    ${url}
    Launch The app   Mobile Demo    MobileDemo
    Wait Until Page Contains     Application ID     timeout=30s
    Click Element   xpath=//*[contains(text(),'Application ID')]
    Wait Until Page Contains    RUNNING    timeout=30s
    Click Element     xpath=//div/ul/li[2]/a/span[contains(text(),'physical')]
    Click Element     xpath=//div//button[2]/t[contains(text(),'retrieve killed')]
    Click Element     xpath=//div/span[1]/button[1]/t[contains(text(),'select active')]
    Execute JavaScript    window.scrollTo(10,700)
    Wait Until Page Contains    deselect all    timeout=20s
    Click Element   xpath=//div/span[1]/button/t[contains(text(),'deselect all')]


##Misc Test-1##
Test_Misc    #open google search and search for the particular item
    ${url}     Set Variable    https://www.google.com
    Open Browser    ${url}     CHROME
    Capture Page Screenshot
    Input Text     id=lst-ib    Pokemon Go
    sleep    5s
    Capture Page Screenshot
    Wait Until Page Contains     All
    Press Key     id=lst-ib         \\\13
    #Click Element    xpath=//*[@id="sblsbb"]/button
    sleep    5s
    Capture Page Screenshot
    #Wait Until Page Contains     Homepage
    #${url}     Set Variable      //*[contains(text(),Homepage)]
    #Click Element       xpath=//*[@id="rso"]/div[2]/div/h3/a
    #Capture Page Screenshot
    [Teardown]    Close Browser

##Misc Test-2##
Test_Misc_Gmail_login
    ${url}     Set Variable    https://www.gmail.com                #variable for navigation
    Open Browser    ${url}     CHROME                               #open chrome browser in new window
    Capture Page Screenshot                                         #takes screenshot of current window

    Input Text     Email    ${email_id}                             #inputs text(email-id) in the mail input box
    Capture Page Screenshot                                         #takes screenshot of current window
    Press Key       Email       \\\13                               #simulates  press of 'enter' key
    sleep       5s                                                  #wait for 5 seconds
    Capture Page Screenshot                                         #takes screenshot of current window

    Click Element        //*[@id="PersistentCookie"]                #remove stay signed in check in check box
    sleep       1s                                                  #wait for 1 seconds
    Capture Page Screenshot                                         #takes screenshot of current window
    sleep       2s                                                  #wait for 2 seconds

    Input Text     Passwd    ${password}                            #inputs text(password) in the password input box
    sleep       1s                                                  #wait for 1 seconds
    Capture Page Screenshot                                         #takes screenshot of current window
    Press Key      Passwd        \\\13                              #simulates  press of 'enter' key
    Sleep       5s                                                  #wait for 5 seconds
    Capture Page Screenshot                                         #takes screenshot of current window

    Click Element       xpath=//*[@id="gb"]/div[1]/div[1]/div[2]/div[4]/div[1]/a/span        #Click on profile icon for option of log out
    sleep       3s                                                  #wait for 3 seconds
    Capture Page Screenshot                                         #takes screenshot of current window
    Click Element       xpath=//*[@id="gb_71"]                      #Click on log out button
    sleep       3s                                                  #wait 3 seconds
    Capture Page Screenshot                                         #takes screenshot of current window

    [Teardown]    Close Browser                                     #Closes the browser


##########################################################################
#                                                                        #
#\\\------------------------Assigned-Test-Cases-----------------------///#
#                                                                        #
##########################################################################

##System_Configuration


Navigate_to_System_Configuration        #Test no. 1                             #PASSED
    Open Browser    ${url}     CHROME                                           #Open Chrome in new window
    Connect_To_DT_Console    ${url}
    Go_To_Page      Configure       System Configuration                        #goto home -> Configure
    Click Element       xpath=//a/t[text()='System Configuration']              #goto Configure -> System Configuration
    #Below Are list of expected text to be found on the page as per the test case
    Page Should Contain     System Configuration
    Page Should Contain     Gateway Information
    Page Should Contain     Hadoop Information
    Page Should Contain     System Properties
    Page Should Contain     App Data Tracker
    Page Should Contain     Usage Reporting
    Capture Page Screenshot
    [Teardown]  Close Browser

Restart_Gateway                         #Test no. 2                             #PASSED
    Open Browser    ${url}     CHROME                                           #Open Chrome in new window
    Connect_To_DT_Console    ${url}
    Go_To_Page      Configure       System Configuration                        #goto home -> Configure
    Click Element       xpath=//a/t[text()='System Configuration']              #goto Configure -> System Configuration
    Wait Until Page Contains     Gateway Information
    Click Element       xpath=//button/t[text()='restart the gateway']          #Click button to restart gateway
    Wait Until Page Contains     Are you sure you want to restart the gateway?  #Verifies the Popup Window
    Click Element       xpath=//button[text()='Yes, restart the gateway']
    Page Should Contain     restarting the gateway...
    Wait Until Page Contains     Gateway successfully restarted!
    Capture Page Screenshot
    [Teardown]    Close Browser


Check_Gateway_Information               #Test no. 3                             #PASSED
    Open Browser    ${url}     CHROME                                           #Open Chrome in new window
    Connect_To_DT_Console    ${url}
    Go_To_Page      Configure       System Configuration                        #goto home -> Configure
    Click Element       xpath=//a/t[text()='System Configuration']              #goto Configure -> System Configuration
    Wait Until Page Contains     Gateway Information
    Read Table      xpath=(//TABLE[@class='simple table'])[1]                   #Reads the Gateway information table and displays the table in log
    Capture Page Screenshot
    [Teardown]    Close Browser

Check_Hadoop_Information                #Test no. 4                             #PASSED
   Open Browser    ${url}     CHROME                                            #Open Chrome in new window
   Connect_To_DT_Console    ${url}
   Go_To_Page      Configure       System Configuration                         #goto home -> Configure
   Click Element        xpath=//a/t[text()='System Configuration']              #goto Configure -> System Configuration
   Wait Until Page Contains     Hadoop Information
   Read Table       xpath=(//TABLE[@class='simple table'])[2]                   #Reads the Hadoop information table and displays the table in log

   [Teardown]    Close Browser

Check_System_Properties                 #Test no. 5   #table_info       #FAIL With some hiccups
   Open Browser    ${url}     CHROME                                   #Open Chrome in new window
   Connect_To_DT_Console    ${url}
   Go_To_Page      Configure       System Configuration                #goto home -> Configure
   Click Element       xpath=//a/t[text()='System Configuration']      #goto Configure -> System Configuration
   Wait Until Page Contains     System Properties
   Read Table         xpath=//DIV[@class='mlhr-rows-table-wrapper']
   [Teardown]    Close Browser

Change_System_Property                  #Test no. 6 #tableinfo and change property     #PASSED
    Open Browser    ${url}     CHROME                                           #Open Chrome in new window
    Connect_To_DT_Console    ${url}
    Go_To_Page      Configure       System Configuration                        #goto home -> Configure
    Click Element       xpath=//a/t[text()='System Configuration']              #goto Configure -> System Configuration
    Wait Until Page Contains     System Properties
    ${Property_Name}        Set Variable        dt.version
    Input Text      xpath=(//INPUT[@type='text'])[1]        ${Property_Name}
    wait until page does not contain        dt.loggers.level
    click element       xpath=//SPAN[@class='btn btn-xs btn-danger ng-scope'][text()='change']
    Wait Until Page Contains        Change System Property
    input text      xpath=//TEXTAREA[@msd-elastic='']       3.8.0-SNAPSHOT      #in suite setup make changes accordingly for 3.7.0 beforehand
    Wait Until Element is Enabled       xpath=//BUTTON[@class='btn ng-binding btn-danger']
    click element       xpath=//BUTTON[@class='btn ng-binding btn-danger']
    #search for update version in table
    Capture page screenshot
    [Teardown]    Close Browser

Delete_System_Property                 #Test no. 7 #table info and delete       #PASS With some hiccups
    Open Browser    ${url}     CHROME                                           #Open Chrome in new window
    Connect_To_DT_Console    ${url}
    Go_To_Page      Configure       System Configuration                        #goto home -> Configure
    Click Element       xpath=//a/t[text()='System Configuration']              #goto Configure -> System Configuration
    Wait Until Page Contains     System Properties
    ${Property_Name}        Set Variable        dt.version
    Input Text      xpath=(//INPUT[@type='text'])[1]        ${Property_Name}    #input of property name to be deleted
    wait until page does not contain        dt.loggers.level                    #check that will determine dt.loggers and any other item is not displayed after search
    click element       xpath=//SPAN[@class='btn btn-xs btn-danger ng-scope'][text()='delete']      #Click on delete button
    wait until page contains        Delete System Property                      #Delete Confirmation Page
    Click Element       xpath=//BUTTON[@class='btn btn-danger ng-binding ng-scope']         #Button to confirm Delete operation
    #search for update version in table
    Capture page screenshot
    [Teardown]    Close Browser

Add_System_Property                     #Test no. 8  #table info.               #PASSED  #Should run delete first
    Open Browser    ${url}     CHROME                                           #Open Chrome in new window
    Connect_To_DT_Console    ${url}
    Go_To_Page      Configure       System Configuration                        #goto home -> Configure
    Click Element       xpath=//a/t[text()='System Configuration']              #goto Configure -> System Configuration
    Wait Until Page Contains     System Properties
    Click Button        xpath=//BUTTON[@class='btn btn-success']                #Click on 'Add System Property'
    Element Should Be Disabled      xpath=//BUTTON[@class='btn ng-binding btn-success']         #Check for Save Button which should be disabled in this situation i.e. incomplete fields
    ${Property_Name}        Set Variable        dt.version                                      #Adding Property Name of dt.version
    Input Text      xpath=//INPUT[@id='propName']        ${Property_Name}
    Element Should Be Disabled      xpath=//BUTTON[@class='btn ng-binding btn-success']         #Check for Save Button which should be disabled in this situation i.e. an incomplete field or invalid name field
    Input Text      xpath=//TEXTAREA[@msd-elastic='']        3.8.0-SNAPSHOT                     #Adding Property Value
    Element Should Be Enabled         xpath=//BUTTON[@class='btn ng-binding btn-success']       #Check for Save Button which should be enabled in this situation i.e. both text fields are filled and valid
    Click Button        xpath=//BUTTON[@class='btn ng-binding btn-success']                     #Click the save Button if element is visible`
    Sleep       2s
    #search for update version in table
    Capture Page Screenshot
    [Teardown]      Close Browser

Add_System_Property_no_key_and_value        #Test no. 9                         #PASSED       #check for visibility seperate for no key and value in one test case
    Open Browser    ${url}     CHROME                                           #Open Chrome in new window
    Connect_To_DT_Console    ${url}
    Go_To_Page      Configure       System Configuration                        #goto home -> Configure
    Click Element       xpath=//a/t[text()='System Configuration']              #goto Configure -> System Configuration
    Wait Until Page Contains     System Properties
    Click Button        xpath=//BUTTON[@class='btn btn-success']                #Click on 'Add System Property'

    #Check-1 Verifies that if both the text fields are empty then save button should be disabled
    Element Should Be Disabled      xpath=//BUTTON[@class='btn ng-binding btn-success']         #Check for Save Button which should be disabled in this situation i.e. an incomplete field or invalid name field
    #Entering here should confirm the Check-1 is successfully completed

    #Check-2 For Single text box fill i.e. only Property Name
    Input Text      xpath=//*[@id="propName"]       dt.version
    Element Should Be Disabled      xpath=//BUTTON[@class='btn ng-binding btn-success']         #Check for Save Button which should be disabled in this situation i.e. an incomplete field or invalid name field
    #Entering here should confirm the Check-2 is successfully completed

    Clear Element Text      xpath=//*[@id="propName"]                           #Removing of text from Property Name text box for next step of test

    #Check-3 For Single text box fill i.e. only Property Value
    Input Text      xpath=//TEXTAREA[@msd-elastic='']        3.8.0-SNAPSHOT     #Adding Property Value Only
    Element Should Be Disabled      xpath=//BUTTON[@class='btn ng-binding btn-success']         #Check for Save Button which should be disabled in this situation i.e. an incomplete field or invalid name field
    #Entering here should confirm the Check-3 is successfully completed

    Sleep       2s
    Capture Page Screenshot
    [Teardown]      Close Browser

Add_Already_Existing_System_Property        #Test no. 10                        #PASSED     #Check for unique property name (Redundant Property name)
    Open Browser    ${url}     CHROME                                           #Open Chrome in new window
    Connect_To_DT_Console    ${url}
    Go_To_Page      Configure       System Configuration                        #goto home -> Configure
    Click Element       xpath=//a/t[text()='System Configuration']              #goto Configure -> System Configuration
    Wait Until Page Contains     System Properties
    Click Button        xpath=//BUTTON[@class='btn btn-success']                #Click on 'Add System Property'
    Input Text      xpath=//*[@id="propName"]       dt.version                  #Redundant property name
    Page Should Contain      Property already exists with the same name.        #Check For Redundant Name
    Element Should Be Disabled      xpath=//BUTTON[@class='btn ng-binding btn-success']         #Check for Save Button which should be disabled in this situation i.e. an incomplete field or invalid name field
    Capture Page Screenshot
    [Teardown]      Close Browser

Check_Transient_System_Property_Info        #Test no. 11                        #PASSED    problem         with hiccups get popup message
    Open Browser    ${url}     CHROME                                           #Open Chrome in new window
    Connect_To_DT_Console    ${url}
    Go_To_Page      Configure       System Configuration                        #goto home -> Configure
    Click Element       xpath=//a/t[text()='System Configuration']              #goto Configure -> System Configuration
    Wait Until Page Contains     System Properties
    ${Property_Name}        Set Variable        dt.loggers.level
    Input Text      xpath=(//INPUT[@type='text'])[1]        ${Property_Name}    #Transient Property Search
    Wait Until Page Does Not Contain        dt.version                          #Check for only dt.loggers.level is present
    Mouse Over      xpath=//I[@ng-if='!row.canSet']                             #Hover over the transient property (i) symbol
    Sleep       1s                                                              #Sleep for i second so that popup appears
    Capture Page Screenshot
    ${message}      Get Text        xpath=//I[@ng-if='!row.canSet']
    Log     ${message}
    [Teardown]      Close Browser

Sort_The_Columns_property_and_value           #Test no. 12                      #Pass with display sort difficulty
    Open Browser    ${url}     CHROME                                           #Open Chrome in new window
    Connect_To_DT_Console    ${url}
    Go_To_Page      Configure       System Configuration                        #goto home -> Configure
    Click Element       xpath=//a/t[text()='System Configuration']              #goto Configure -> System Configuration
    Wait Until Page Contains     System Properties
    set window position     0     10000
    Capture Page Screenshot
    Click Element       xpath=(//SPAN[@class='column-text ng-binding ui-sortable-handle'])[1]
    Sleep       1s
    #get the sorted values in dictionary and compare with sorted values both ascendiing and descending
    Capture Page Screenshot
    [Teardown]      Close Browser

Search_The_Columns_property_and_value         #Test no. 13                       #PASSED problem is checking with dictionary as previous
    Open Browser    ${url}     CHROME                                            #Open Chrome in new window
    Connect_To_DT_Console    ${url}
    Go_To_Page      Configure       System Configuration                         #goto home -> Configure
    Click Element       xpath=//a/t[text()='System Configuration']               #goto Configure -> System Configuration
    Wait Until Page Contains     System Properties

    #Check-1 Property Value
    Input Text      xpath=(//INPUT[@type='text'])[1]        dt.version

    #Check if the required element is visible only here

    Clear Element Text      xpath=(//INPUT[@type='text'])[1]                     #Clear text area for check for value

    Input Text      xpath=(//INPUT[@type='text'])[2]        3.8.0-SNAPSHOT

    #Check if the required element is visible only here

    Capture Page Screenshot
    [Teardown]      Close Browser

App_Data_Tracker_Enable                        #Test no. 14                      #PASSED        #App Data Tracker should be Disabled before hand Guide in Suite
    Open Browser    ${url}     CHROME                                            #Open Chrome in new window
    Connect_To_DT_Console    ${url}
    Go_To_Page      Configure       System Configuration                         #goto home -> Configure
    Click Element       xpath=//a/t[text()='System Configuration']               #goto Configure -> System Configuration
    Wait Until Page Contains     App Data Tracker                                #Check if App data tracker is present
    Click Element       xpath=//T[text()='Enable App Data Tracker']              #Click on 'Enable App Data Tracker' to enable it and a popup should be displayed for confirmation
    Page Should Contain     Enable App Data Tracker?                             #Check/Verify if  Popup is displayed or not
    Click Element       xpath=//BUTTON[@ng-click='$close()'][text()='Enable']    #Confirmation for enabling App Data Tracker
    Wait Until Page Contains        App Data Tracker is enabled now.             #Confirmaton that App Data Tracker is Enabled Now
    Reload Page                                                                  #Refreshes the page for checking if App Data Tracker is Enabled or Not
    Wait Until Page Contains        App Data Tracker      timeout=10s
    Page Should Contain     Disable App Data Tracker                             #Final confirmation that App Data Tracker is Enabled
    [Teardown]      Close Browser

App_Data_Tracker_Disable                        #Test no. 15                     #PASSED         #App Data TArcker should be Enabled before hand
    Open Browser    ${url}     CHROME                                            #Open Chrome in new window
    Connect_To_DT_Console    ${url}
    Go_To_Page      Configure       System Configuration                         #goto home -> Configure
    Click Element       xpath=//a/t[text()='System Configuration']               #goto Configure -> System Configuration
    Wait Until Page Contains     App Data Tracker                                #Check if App data tracker is present
    Click Element       xpath=//T[text()='Disable App Data Tracker']             #Click on 'Disable App Data Tracker' to enable it and a popup should be displayed for confirmation
    Page Should Contain     Disable App Data Tracker?                            #Check/Verify if  Popup is displayed or not
    Click Button        xpath=//BUTTON[@ng-click='$close()'][text()='Disable']   #Confirmation for disabling App Data Tracker
    Wait Until Page Contains        App Data Tracker is disabled and killed.     #Confirmaton that App Data Tracker is Disabled Now
    Reload Page                                                                  #Refreshes the page for checking if App Data Tracker is Disabled or Not
    Wait Until Page Contains        App Data Tracker      timeout=10s
    Page Should Contain     Enable App Data Tracker                              #Final confirmation that App Data Tracker is Disabled
    [Teardown]      Close Browser

App_Data_Tracker_Change_Queue                   #Test no. 16                     #PASSED   #Some discrepency in test cases unable to find App Data Tracker Settings which belongs to Plaban       #drop down menu encountered #should be choose a queue before hand in drop down menu and App_Data_Tracker_Should_be_running_beforehand
    Open Browser    ${url}     CHROME                                            #Open Chrome in new window
    Connect_To_DT_Console    ${url}
    Go_To_Page      Configure       System Configuration                         #goto home -> Configure
    Click Element       xpath=//a/t[text()='System Configuration']               #goto Configure -> System Configuration
    Wait Until Page Contains        App Data Tracker
    Select From List By Label       xpath=//SELECT[@class='form-control ng-pristine ng-untouched ng-valid']       default
    Wait Until Page Contains        Restart App Data Tracker?
    Click Element      xpath=//BUTTON[@ng-click='$close()'][text()='Okay']
    Sleep       1s
    Page Should Contain     Starting App Data Tracker....                        #alert should be present-gives no alerts found
    Sleep       2s
    Wait Until Page Contains        App Data Tracker has been restarted successfully.       timeout=50s
    Capture Page Screenshot
    [Teardown]      Close Browser

Usage_Reporting_Disable                         #Test no. 17                     #PASSED #Should be enabled before      #Confirm in guide
    Open Browser    ${url}     CHROME                                            #Open Chrome in new window
    Connect_To_DT_Console    ${url}
    Go_To_Page      Configure       System Configuration                         #goto home -> Configure
    Click Element       xpath=//a/t[text()='System Configuration']               #goto Configure -> System Configuration
    Wait Until Page Contains     Usage Reporting
    Click Button       xpath=//BUTTON[@class='btn btn-danger ng-binding']        #Click on 'Disable App Data Tracker' Button
    Wait Until Page Contains        This action will restart the gateway. Are you sure you want to proceed?         #Display of Popup
    Click Button       xpath=//BUTTON[@class='btn btn-danger ng-binding'][text()='Disable']                         #Confirmation of Gateway restart
    Wait Until Page Contains        restarting the gateway...                    #Confirmation of above action
    Wait Until Page Contains        Gateway successfully restarted!              #Confirmation that Gateway restarted
    Sleep       5s
    Reload Page                                                                  #To view the Changed state
    Wait Until Page Contains        Usage Reporting    timeout=10s
    Page Should Contain     Enable Reporting                                     #Confirmation of Succesful Test Run
    [Teardown]      Close Browser



Usage_Reporting_Enable                          #Test no. 18                     #PASSED     #Should be disabled before
    Open Browser    ${url}     CHROME                                            #Open Chrome in new window
    Connect_To_DT_Console    ${url}
    Go_To_Page      Configure       System Configuration                         #goto home -> Configure
    Click Element       xpath=//a/t[text()='System Configuration']               #goto Configure -> System Configuration
    Wait Until Page Contains     Usage Reporting
    Click Button        xpath=//BUTTON[@class='btn btn-danger ng-binding']       #Click on 'Enable App Data Tracker' Button
    Wait Until Page Contains        This action will restart the gateway. Are you sure you want to proceed?     #Display of Popup
    Click Button        xpath=//BUTTON[@class='btn btn-danger ng-binding'][text()='Enable']                     #Confirmation of Gateway restart
    Wait Until Page Contains        restarting the gateway...                    #Confirmation of above action
    Wait Until Page Contains        Gateway restarted                            #Confirmation that Gateway restarted
    Sleep       5s                                                               #Sleep for allowing gateway to restart
    Reload Page                                                                  #Refreshes the page for Change in text of button
    Wait Until Page Contains        Usage Reporting       timeout=10s
    Page Should Contain     Disable Reporting                                    #Confirmation of Successful test run
    [Teardown]      Close Browser

#***Security Configuration***
Navigate_to_Security_Configuration                #Test no. 19                   #PASSED
    Open Browser    ${url}     CHROME                                            #Open Chrome in new window
    Connect_To_DT_Console    ${url}
    Go_To_Page      Configure       Security Configuration                       #goto home -> Configure
    Click Element       xpath=(//T[text()='Security Configuration'][text()='Security Configuration'])[1]        #Navigate to Security Configuration
    Wait Until Page Contains        Secure mode can be enabled by selecting an Authentication                   #Confirmation of successfull navigation
    Click Element     xpath=//I[@class='caret pull-right']                       #Click on drop down menu for display
    Sleep       2s                                                               #Wait for Drop down to appear
    Capture Page Screenshot                                                      #Screenshot confirmation for Drop Down
    [Teardown]      Close Browser

Set_authentication_to_password                    #Test no. 20                   #problem with drop down menu
    Open Browser    ${url}     CHROME                                            #Open Chrome in new window
    Connect_To_DT_Console    ${url}
    Go_To_Page      Configure       Security Configuration                       #goto home -> Configure
    Click Element       xpath=(//T[text()='Security Configuration'][text()='Security Configuration'])[1]        #Navigate to Security Configuration
    Wait Until Page Contains        Secure mode can be enabled by selecting an Authentication                   #Confirmation of successfull navigation
    sleep   2s
    get selected list labels        xpath=/html/body/div[2]/div/div/form/table/tbody/tr/td[2]/span/div/div/div/span/span[2]    #Password         #problem here
    Capture Page Screenshot
    [Teardown]          Close Browser

Set_authentication_to_None                          #Test no. 21                 #problem with drop down menu
    Open Browser    ${url}     CHROME                                            #Open Chrome in new window
    Connect_To_DT_Console    ${url}
    Go_To_Page      Configure       Security Configuration                       #goto home -> Configure
    click element   xpath=(//T[text()='Security Configuration'][text()='Security Configuration'])[1]
    WAIT UNTIL PAGE CONTAINS    Secure mode can be enabled by selecting an Authentication
    select from list    xpath=/html/body/div[2]/div/div/form/table/tbody/tr/td[2]/span/div/div/div/span/span[2]        None    #problem here
    Capture Page Screenshot
    [Teardown]          Close Browser

Set_suthentication_to_existing_option               #22       #problem with drop down menu
    Open Browser    ${url}     CHROME                                   #Open Chrome in new window
    Connect_To_DT_Console    ${url}
    Go_To_Page      Configure       Security Configuration                #goto home -> Configure

    click element   xpath=(//T[text()='Security Configuration'][text()='Security Configuration'])[1]

    WAIT UNTIL PAGE CONTAINS    Secure mode can be enabled by selecting an Authentication

    select from list    xpath=/html/body/div[2]/div/div/form/table/tbody/tr/td[2]/span/div/div/div/span/span[2]        None    #problem here        (should be same as show before dropping down)
    Capture Page Screenshot
    [Teardown]          Close Browser


Cancel_Security_Configuration                       #23             #problem with drop down
    Open Browser    ${url}     CHROME                                   #Open Chrome in new window
    Connect_To_DT_Console    ${url}

    Go_To_Page      Configure       Security Configuration                       #goto home -> Configure

    click element   xpath=(//T[text()='Security Configuration'][text()='Security Configuration'])[1]

    WAIT UNTIL PAGE CONTAINS    Secure mode can be enabled by selecting an Authentication

    select from list    xpath=/html/body/div[2]/div/div/form/table/tbody/tr/td[2]/span/div/div/div/span/span[2]        None    #problem here        (should be same as show before dropping down)
    #here  Press cancel when popup after save occurs
    Capture Page Screenshot
    [Teardown]          Close Browser


#***Security Alerts Management and History***
Navigate_to_System_Alerts_Management                #Test no. 24                 #PASSED
    Open Browser    ${url}     CHROME                                            #Open Chrome in new window
    Connect_To_DT_Console    ${url}
    Go_To_Page      Configure       System Alerts                                #goto home -> Configure
    Click Element       xpath=(//T[text()='System Alerts'][text()='System Alerts'])[1]      #Click On System Alerts
    Page Should Contain        System Alerts Management                          #Confirmation of successful navigation to System Alerts Page
    Capture Page Screenshot
    [Teardown]          Close Browser

Systems_Alert_Management_History_Link               #Test no. 25                 #PASSED
    Open Browser    ${url}     CHROME                                            #Open Chrome in new window
    Connect_To_DT_Console    ${url}
    Go_To_Page      Configure       System Alerts                                #goto home -> Configure
    Click Element       xpath=(//T[text()='System Alerts'][text()='System Alerts'])[1]      #Click On System Alerts
    Page Should Contain     System Alerts History                                #Confirmation of successful navigation to System Alerts Page
    Click Element       xpath=//A[@href='#/config/alerts-history'][text()='System Alerts History']      #Click on System Alerts History Link
    Page Should Contain     System Alerts Management.                            #Confirmation of successful navigation to System Alerts History Page
    Capture Page Screenshot
    [Teardown]          Close Browser

Create_New_Alert                                    #Test no. 26                 #PASSED #if empty then no alerts found # Add in suite setup
    Open Browser    ${url}     CHROME                                            #Open Chrome in new window
    Connect_To_DT_Console    ${url}
    Go_To_Page      Configure       System Alerts                                #goto home -> Configure
    Click Element       xpath=(//T[text()='System Alerts'][text()='System Alerts'])[1]      #Click On System Alerts
    Page Should Contain        System Alerts Management                          #Confirmation of successful navigation to System Alerts Page
    Click Button        xpath=//BUTTON[@ng-click='createAlert(users, roles)']    #Click on 'create new alert'
    Wait Until Page Contains        Required fields                              #COnfirmation that 'New Alert' popup window is encountered
    input text      xpath=(//INPUT[@type='text'])[1]        Test_Case_6
    input text      xpath=(//INPUT[@type='text'])[2]        xyz@datatorrent.com
    input text      xpath=//INPUT[@type='number']           6000
    input text      xpath=//TEXTAREA[@ng-model='theAlert.data.condition']       Test_Case
    input text      xpath=//TEXTAREA[@ng-model='theAlert.data.description']     Create_New_Alert_Test_Case_Running_Test_1
    Capture Page Screenshot
    click element       xpath=//BUTTON[@class='btn btn-success']
    Capture Page Screenshot
    wait until page does not contains       Required fields
    page should contain     Test_Case
    [Teardown]          Close Browser

Create_New_Alert_Negative                           #Test no. 27                 #PASSED
    Open Browser    ${url}     CHROME                                            #Open Chrome in new window
    Connect_To_DT_Console    ${url}
    Go_To_Page      Configure       System Alerts                                #goto home -> Configure
    Click Element       xpath=(//T[text()='System Alerts'][text()='System Alerts'])[1]      #Click On System Alerts
    Page Should Contain        System Alerts Management                          #Confirmation of successful navigation to System Alerts Page
    Click Button        xpath=//BUTTON[@ng-click='createAlert(users, roles)']    #Click on 'create new alert'
    Wait Until Page Contains        Required fields                              #COnfirmation that 'New Alert' popup window is encountered
    Element Should Be Disabled      xpath=//BUTTON[@class='btn btn-success']     #Confirmation that the 'Save' button is disabled

    #Check-1: Invalid Name (already existing name and empty field)
    ##Check-1.1:Already Existing Name
    Input Text      xpath=(//INPUT[@type='text'])[1]        Test_Case_1          #Check for Already Existing Name
    Page Should Contain     This alert name already exists.                      #Confirmation success of Check-1.1
    Element Should Be Disabled       xpath=//BUTTON[@class='btn btn-success']    #Check if 'Create' is disabled
    Capture Page Screenshot
    ##Check-1.2:Empty Field Check
    Clear Element Text      xpath=(//INPUT[@type='text'])[1]                     #Check for Empty Field
    Page Should Contain     Please enter a name for this alert.                  #Confirmation success of Check-1.2
    Element Should Be Disabled       xpath=//BUTTON[@class='btn btn-success']    #Check if 'Create' is disabled
    Capture Page Screenshot

    #Check-2: Invalid Email
    ##Check-2.1:Wrong Email text
    Input Text      xpath=(//INPUT[@type='text'])[2]            datatorrent      #Check for validity for e-mail
    Page Should Contain     Invalid email address.                               #Confirmation of success of Check-2.1
    Element Should Be Disabled       xpath=//BUTTON[@class='btn btn-success']    #Check if 'Create' is disabled
    Capture Page Screenshot
    ##Check-2.2:Empty Field Check
    Clear Element Text      xpath=(//INPUT[@type='text'])[2]                     #Check for Empty Field
    Page Should Contain     Please enter an email for this alert.                #Confirmaton of Check-2.2
    Element Should Be Disabled       xpath=//BUTTON[@class='btn btn-success']    #Check if 'Create' is disabled
    Capture Page Screenshot

    #Check-3: Invalid Threshold
    ##Check-3.1:Only Numeric Characters Check
    Input Text      xpath=//INPUT[@type='number']       abc                      #Enters alphabets to check for Numeric input(only numeric characters appear on on text field)
    ${Character_Check}      Get Text        xpath=//INPUT[@type='number']        #Gets the text from text box
    Should Not Be Equal     ${Character_Check}      abc                          #Confirms Check-3.1 if passed
    Capture Page Screenshot
    ##Check-3.2:Empty Field Check
    Clear Element Text      xpath=//INPUT[@type='number']                        #Check for empty field
    Page Should Contain     Please enter the threshold for this alert.           #Confirmation of Check-3.2
    Element Should Be Disabled       xpath=//BUTTON[@class='btn btn-success']    #Check if 'Create' is disabled
    Capture Page Screenshot

    #Check-4: Invalid condition
    Input Text      xpath=//TEXTAREA[@ng-model='theAlert.data.condition']       ABC
    Clear Element Text      xpath=//TEXTAREA[@ng-model='theAlert.data.condition']    #Check for empty field
    Page Should Contain     Please enter a valid Javascript express for this alert.  #Confirmation for check-4
    Element Should Be Disabled      xpath=//BUTTON[@class='btn btn-success']         #Check if 'Create' is disabled
    Capture Page Screenshot

    [Teardown]      Close Browser

Create_New_Alert_Condition_Link                     #Test no. 28                 #PASSED
    Open Browser    ${url}     CHROME                                            #Open Chrome in new window
    Connect_To_DT_Console    ${url}
    Go_To_Page      Configure       System Alerts                                #goto home -> Configure
    Click Element       xpath=(//T[text()='System Alerts'][text()='System Alerts'])[1]      #Click On System Alerts
    Page Should Contain        System Alerts Management                          #Confirmation of successful navigation to System Alerts Page
    Click Button        xpath=//BUTTON[@ng-click='createAlert(users, roles)']    #Click on 'create new alert'
    Wait Until Page Contains        Required fields                              #Confirmation that 'New Alert' popup window is encountered
    Click Element   xpath=//A[@href='http://docs.datatorrent.com/dtgateway/#system-alerts'][text()='Click here']        #System Alerts Documentation
    #check_for_new_browser_window_here
    Select Window   Title=dtGateway - DataTorrent Documentation                  #Switch Browser tab
    Page Should Contain     Rest API                                             #Confirmation of Successful Switch
    Capture Page Screenshot
    [Teardown]      Close Browser

Systems_Alerts_Management_Search                    #Test no. 29                 #Revise Suite Setup #PASS     #should make test_alerts_beforehand with varied fields Test_Case_1, Test_Case_2, Test_Case_3 etc created before in suite setup
    Open Browser    ${url}     CHROME                                            #Open Chrome in new window
    Connect_To_DT_Console    ${url}
    Go_To_Page      Configure       System Alerts                                #goto home -> Configure
    Click Element       xpath=(//T[text()='System Alerts'][text()='System Alerts'])[1]      #Click On System Alerts
    Page Should Contain        System Alerts Management                          #Confirmation of successful navigation to System Alerts Page

    ##Search_by_name
    Input Text     xpath=(//INPUT[@type='text'])[2]        Case_1
    #page should not contain            Test_Case_2                              #other test cases names - Test_Case_1,Test_Case_2,Test_Case_3 etc.
    Capture Page Screenshot

    ##Search_by_email
    clear element text      xpath=(//INPUT[@type='text'])[2]
    input text      xpath=(//INPUT[@type='text'])[3]        xyz
    page should not contain   abc                                                             #other email used abc@datatorrent.com etc
    Capture Page Screenshot

    ##Search_by_threshold
    clear element text      xpath=(//INPUT[@type='text'])[3]
    input text      xpath=(//INPUT[@type='text'])[4]        6000            #other thresholds present were 3000,4000,5000,7000 etc
    page should not contain   5000
    Capture Page Screenshot

    ##Search_By_Condition
    clear element text      xpath=(//INPUT[@type='text'])[4]
    input text      xpath=(//INPUT[@type='text'])[5]        Case_2          #conditions were Test_Case_1_condition, Test_Case_2_condition etc
    #page should not contain   Test_Case_1
    Capture Page Screenshot

    ##Search_By_Message
    clear element text      xpath=(//INPUT[@type='text'])[5]
    input text              xpath=(//INPUT[@type='text'])[6]     New_Alert_Test_Case_Running_Test_2
    page should not contain  New_Alert_Test_Case_Running_Test_1
    CAPTURE PAGE SCREENSHOT

    [Teardown]      close Browser

System_Alerts_Management_Sort       #30         #using dicionary compare sort #Not Completed
    Open Browser    ${url}     CHROME                                   #Open Chrome in new window
    Connect_To_DT_Console    ${url}

    Go_To_Page      Configure       System Alerts               #goto home -> Configure
    click element       xpath=(//T[text()='System Alerts'][text()='System Alerts'])[1]
    page should contain  System Alerts Management

    ##Sort_By_Name
    Capture Page Screenshot
    click element   xpath=(//SPAN[@class='column-text ng-binding ui-sortable-handle'])[2]
    Capture Page Screenshot

    ##Sort_By_Email
    Capture Page Screenshot
    click element  xpath=(//SPAN[@class='column-text ng-binding ui-sortable-handle'])[3]
    Capture Page Screenshot

    ##Sort_By_Threshold
    Capture Page Screenshot
    click element   xpath=(//SPAN[@class='column-text ng-binding ui-sortable-handle'])[4]
    Capture Page Screenshot

    ##Sort_By_Condition
    Capture Page Screenshot
    click element   xpath=(//SPAN[@class='column-text ng-binding ui-sortable-handle'])[5]
    Capture Page Screenshot

    ##Sort_By_Message
    Capture Page Screenshot
    click element   xpath=(//SPAN[@class='column-text ng-binding ui-sortable-handle'])[6]
    Capture Page Screenshot

    [Teardown]      close Browser

Change_Existing_Alert       #31     #PASS            #not_fully_completed        #check existing using search
    Open Browser    ${url}     CHROME                                   #Open Chrome in new window
    Connect_To_DT_Console    ${url}

    Go_To_Page      Configure       System Alerts               #goto home -> Configure
    click element       xpath=(//T[text()='System Alerts'][text()='System Alerts'])[1]
    page should contain  System Alerts Management

    input text      xpath=(//INPUT[@type='text'])[2]        Test_Case_1     #Search_by_test_case since name is unique therefore only one result
    click element   xpath=//SPAN[@class='btn btn-xs btn-info ng-scope'][text()='change']
    wait until page contains  Required fields
    element should be disabled      xpath=//BUTTON[@class='btn btn-success']
    clear element text  xpath=//TEXTAREA[@ng-model='theAlert.data.condition']
    input text      xpath=//TEXTAREA[@ng-model='theAlert.data.condition']           Test_Case_7
    click element   xpath=//BUTTON[@class='btn btn-success']

    input text      xpath=(//INPUT[@type='text'])[2]            Test_Case_1         #check for authenticity
    input text      xpath=(//INPUT[@type='text'])[5]            Test_Case_7

    page should contain     Test_Case_1         #if passed beyond this line then present and changes are made
    Capture Page Screenshot
    [Teardown]      close Browser


Delete_Alert        #32     #PASS revise again
    Open Browser    ${url}     CHROME                                   #Open Chrome in new window
    Connect_To_DT_Console    ${url}

    Go_To_Page      Configure       System Alerts               #goto home -> Configure
    click element       xpath=(//T[text()='System Alerts'][text()='System Alerts'])[1]
    page should contain  System Alerts Management


    input text      xpath=(//INPUT[@type='text'])[2]        Test_Case_6     #Search_by_test_case since name is unique therefore only one result
    select checkbox     xpath=(//INPUT[@type='checkbox'])[2]
    click button    xpath=//BUTTON[@ng-click='removeAlerts()']
    wait until page contains    Delete selected alert?
    click button    xpath=//BUTTON[@ng-click='$close()'][text()='Okay']
    [Teardown]      Close Browser



Top_Navbar_Alert_Manu       #33         #PASS #Check_Again
    Open Browser    ${url}     CHROME                                   #Open Chrome in new window
    Connect_To_DT_Console    ${url}
    sleep  2s
    click element  xpath=//*[@id="main-nav-collapse"]/alerts-icon[2]/ul/li/a/span
    Capture Page Screenshot
    page should contain  Alerts History
    page should contain  Alerts Management
    click element   xpath=(//A[@href='#/config/alerts-history'])[3]
    page should contain     Below are the occurrences of triggered alerts.
    Capture Page Screenshot
    click element  xpath=//*[@id="main-nav-collapse"]/alerts-icon[2]/ul/li/a/span
    Capture Page Screenshot
    ${Test_Variable}    set variable  Test_Case_5
    click element   xpath=(//SPAN[@class='name ng-binding'][text()='${Test_Variable}'][text()='${Test_Variable}'])[3]
    sleep   2s
    Capture Page Screenshot
    [Teardown]      Close Browser

Top_Navbar_Alert_Manu_Alert_Message     #34     #Need Work
    Open Browser    ${url}     CHROME                                   #Open Chrome in new window
    Connect_To_DT_Console    ${url}
    sleep  2s

    #Positive
    Go_To_Page      Configure       System Alerts               #goto home -> Configure
    click element       xpath=(//T[text()='System Alerts'][text()='System Alerts'])[1]
    page should contain  System Alerts Management
    click button    xpath=//BUTTON[@ng-click='createAlert(users, roles)']
    wait until page contains    Required fields
    input text      xpath=(//INPUT[@type='text'])[1]        Test_Case_6
    input text      xpath=(//INPUT[@type='text'])[2]        xyz@datatorrent.com
    input text      xpath=//INPUT[@type='number']           6000
    input text      xpath=//TEXTAREA[@ng-model='theAlert.data.condition']       Test_Case
    input text      xpath=//TEXTAREA[@ng-model='theAlert.data.description']     Craete_New_Alert_Test_Case_Running_Test_1
    Capture Page Screenshot
    click element   xpath=//BUTTON[@class='btn btn-success']
    Capture Page Screenshot
    wait until page does not contain    Required fields
    page should contain   Test_Case
    #positive Green check marks

    #Negative

    Go_To_Page      Configure       System Alerts               #goto home -> Configure
    click element       xpath=(//T[text()='System Alerts'][text()='System Alerts'])[1]
    page should contain  System Alerts Management
    click button    xpath=//BUTTON[@ng-click='createAlert(users, roles)']
    wait until page contains    Required fields

    element should be disabled       xpath=//BUTTON[@class='btn btn-success']

    #invalid name
    clear element text      xpath=(//INPUT[@type='text'])[1]
    page should contain     Please enter a name for this alert.
    element should be disabled       xpath=//BUTTON[@class='btn btn-success']
    ##invalid email
    input text      xpath=(//INPUT[@type='text'])[2]            datatorrent
    page should contain     Invalid email address.
    element should be disabled       xpath=//BUTTON[@class='btn btn-success']
    ##invalid threshold
    clear element text       xpath=//INPUT[@type='number']
    page should contain     Please enter the threshold for this alert.
    element should be disabled       xpath=//BUTTON[@class='btn btn-success']
    ##Invalid condition
    clear element text      xpath=//TEXTAREA[@ng-model='theAlert.data.condition']
    page should contain     Please enter a valid Javascript express for this alert.
    element should be disabled      xpath=//BUTTON[@class='btn btn-success']
    #negative  red circle

    #for combination    red circle number on circle should display active alerts
    [Teardown]      Close Browser


Navigate_Management                                 #Test no. 35                 #PASSED
    Open Browser    ${url}     CHROME                                            #Open Chrome in new window
    Connect_To_DT_Console    ${url}
    Go_To_Page      Configure       System Alerts                                #goto home -> Configure
    Click Element       xpath=(//T[text()='System Alerts'][text()='System Alerts'])[1]      #Click On System Alerts
    Page Should Contain        System Alerts Management                          #Confirmation of successful navigation to System Alerts Page
    Capture Page Screenshot
    Click Element       xpath=//A[@href='#/config/alerts-history'][text()='System Alerts History']      #Navigate to Sytem Alerts History
    Page Should Contain     Below are the occurrences of triggered alerts.       #Confirm Navigation
    Capture Page Screenshot
    Click Element       xpath=//A[@href='#/config/alerts-management'][text()='System Alerts Management']    #Navigate to Systems= Alerts Management
    Page Should Contain     Use this page to configure alerts to monitor running applications and Hadoop cluster.       #Confirm Navigation
    Capture Page Screenshot

    [Teardown]      Close Browser


Navigate_System_Alert_History                       #Test no. 36                 #PASSED
    Open Browser    ${url}     CHROME                                            #Open Chrome in new window
    Connect_To_DT_Console    ${url}
    Go_To_Page      Configure       System Alerts                                #goto home -> Configure
    Click Element       xpath=(//T[text()='System Alerts'][text()='System Alerts'])[1]      #Click On System Alerts
    Page Should Contain        System Alerts Management                          #Confirmation of successful navigation to System Alerts Page
    Capture Page Screenshot
    Click Element  xpath=//A[@href='#/config/alerts-history'][text()='System Alerts History']       #Navigate to System Alerts History
    Page Should Contain     Below are the occurrences of triggered alerts.       #Confirmation of Navigation
    Capture Page Screenshot
    
    [Teardown]      Close Browser


System_Alerts_History_Search        #37     #FAIL Element visibility issue
    Open Browser    ${url}     CHROME                                   #Open Chrome in new window
    Connect_To_DT_Console    ${url}

    Go_To_Page      Configure       System Alerts               #goto home -> Configure
    click element       xpath=(//T[text()='System Alerts'][text()='System Alerts'])[1]
    page should contain  System Alerts Management

    click element  xpath=//A[@href='#/config/alerts-history'][text()='System Alerts History']
    page should contain     Below are the occurrences of triggered alerts.

    ##Search_By_Name
    input text      xpath=(//INPUT[@type='text'])[2]    Test_Case_5
    Capture Page Screenshot
    sleep  2s
    page should not contain  Test_Case_2

     ##Search_By_In_Time
    input text      xpath=(//SPAN[@class='column-text ng-binding ui-sortable-handle'])[2]      11:22:03
    Capture Page Screenshot
    sleep  2s
    page should not contain  Test_Case_2

     ##Search_By_Out_Time
    input text      xpath=(//SPAN[@class='column-text ng-binding ui-sortable-handle'])[3]       -
    Capture Page Screenshot
    sleep  2s
    page should not contain  Test_Case_2

     ##Search_By_Active
    input text      xpath=(//SPAN[@class='column-text ng-binding ui-sortable-handle'])[4]       yes
    Capture Page Screenshot
    sleep  2s
    page should not contain  Test_Case_2

     ##Search_By_Message
     input text      xpath=(//SPAN[@class='column-text ng-binding ui-sortable-handle'])[5]      #insert relevant text here
    Capture Page Screenshot
    sleep  2s
    page should not contain  Test_Case_2

    [Teardown]      Close Browser

System_Alerts_History_Sort      #38         #get list and compare
    Open Browser    ${url}     CHROME                                   #Open Chrome in new window
    Connect_To_DT_Console    ${url}

    Go_To_Page      Configure       System Alerts               #goto home -> Configure
    click element       xpath=(//T[text()='System Alerts'][text()='System Alerts'])[1]
    page should contain  System Alerts Management

    click element  xpath=//A[@href='#/config/alerts-history'][text()='System Alerts History']
    page should contain     Below are the occurrences of triggered alerts.

    ##Sort_By_Name
            ##logic for comparison get list and compare with your sorted list

    ##Sort_By_In_Time
            ##logic for comparison get list and compare with your sorted list

    ##Sort_By_Out_Time
            ##logic for comparison get list and compare with your sorted list

    ##Sort_By_Active
            ##logic for comparison get list and compare with your sorted list

    ##Sort_By_Message
            ##logic for comparison get list and compare with your sorted list

    [Teardown]      Close Browser

System_Alerts_History_Details                       #Test no. 39                 #PASSED
    Open Browser    ${url}     CHROME                                            #Open Chrome in new window
    Connect_To_DT_Console    ${url}
    Go_To_Page      Configure       System Alerts                                #goto home -> Configure
    Click Element       xpath=(//T[text()='System Alerts'][text()='System Alerts'])[1]      #Click On System Alerts
    Page Should Contain        System Alerts Management                          #Confirmation of successful navigation to System Alerts Page
    Click Element       xpath=//A[@href='#/config/alerts-history'][text()='System Alerts History']      #Navigate to System Alert History
    Page Should Contain     Below are the occurrences of triggered alerts.       #Confirm Navigation
    ${Alert_Name}       Set Variable        Test_Case_2                          #Alert Name
    Click Element       xpath=//A[@ng-click='options.parentScope.alertDetail(row)'][text()='${Alert_Name}']     #Click on Alert
    Wait Until Page Contains        Alert Details                                #Confirm Popup windows for Alert Details
    Sleep       1s                                                               #Required to make the Popupoptically visible to take screenshot
    Capture Page Screenshot

    [Teardown]      Close Browser


System_Alerts_History_Management_Link                #Test no. 40                #PASSED
    Open Browser    ${url}     CHROME                                            #Open Chrome in new window
    Connect_To_DT_Console    ${url}
    Go_To_Page      Configure       System Alerts                                #goto home -> Configure
    Click Element       xpath=(//T[text()='System Alerts'][text()='System Alerts'])[1]      #Click On System Alerts
    Page Should Contain        System Alerts Management                          #Confirmation of successful navigation to System Alerts Page
    Click Element       xpath=//A[@href='#/config/alerts-history'][text()='System Alerts History']      #Navigate to System Alert History
    Page Should Contain     Below are the occurrences of triggered alerts.       #Confirm Navigation
    Click Element       xpath=//A[@href='#/config/alerts-management'][text()='System Alerts Management']      #Navigate to Systems Alerts Management
    Page Should Contain     Use this page to configure alerts to monitor running applications and Hadoop cluster.       #Confirm Navigation
    Capture Page Screenshot

    [Teardown]      Close Browser



#***Ameya***
Monitor_Page_Table_Sort_TC5
    Connect_To_DT_Console    ${url}
    Launch The app    ${Pkg_Name}    ${App_Name}  #comment when running individual test case
    sleep    10s
    Launch The app    ${Alter_Pkg_Name}    ${Alter_App_Name}
    sleep    10s
    Go_To_Page    Monitor    Cluster Overview
    Click Element    //*[contains(text(),'${App_Name}')]
    ${id1}    Get Text    //*[contains(@dt-container-shorthand,'data.id')]
    ${id1}    Convert To String     ${id1}
    ${user1}    Get Text    xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[1]/div/div[2]/div/div/div/h4/span[2]
    ${user1}    Convert To String    ${user1}
    ${state1}   Get Text    xpath=//span[@dt-status='data.state']/span
    Go To Page    Monitor    Cluster Overview
    Click Element    //*[contains(text(),'${Alter_App_Name}')]
    ${id2}    Get Text    //*[contains(@dt-container-shorthand,'data.id')]
    ${id2}    Convert To String     ${id2}
    ${user2}    Get Text    xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[1]/div/div[2]/div/div/div/h4/span[2]
    ${user2}    Convert To String    ${user2}
    ${state2}   Get Text    xpath=//span[@dt-status='data.state']/span
    Go To Page    Monitor    Cluster Overview

    #ID

    ${count}=  get matching xpath count  xpath=/html/body/div[2]/div[2]/div/div[2]/div/table/tbody[3]//tr[contains(text()," ")]/../tr
    ${count_str}=  convert to string  ${count}
    LOG  ID
    click element  xpath=/html/body/div[2]/div[2]/div/div[2]/table/thead/tr[1]/th[2]
    click element  xpath=/html/body/div[2]/div[2]/div/div[2]/table/thead/tr[1]/th[2]
    ${ids}=  create list
    : FOR    ${INDEX}    IN RANGE    1    ${count_str}+1
    \    Log    ${INDEX}
    \    ${id}=  get text  xpath=/html/body/div[2]/div[2]/div/div[2]/div/table/tbody[3]/tr[${INDEX}]/td[2]
    \    ${id_str}=  convert to string  ${id}
    \    append to list  ${ids}  ${id_str}
    ${ids_sorted}=  create list
    ${ids_sorted}=  copy list  ${ids}
    sort list  ${ids_sorted}
    LOG  SORTED
    Lists Should Be Equal  ${ids_sorted}  ${ids}
    ${ids_reverse}=  create list
    click element  xpath=/html/body/div[2]/div[2]/div/div[2]/table/thead/tr[1]/th[2]
    : FOR    ${INDEX}    IN RANGE    1    ${count_str}+1
    \    Log    ${INDEX}
    \    ${id}=  get text  xpath=/html/body/div[2]/div[2]/div/div[2]/div/table/tbody[3]/tr[${INDEX}]/td[2]
    \    ${id_str}=  convert to string  ${id}
    \    append to list  ${ids_reverse}  ${id_str}
    ${ids_sorted}=  create list
    ${ids_sorted}=  copy list   ${ids_reverse}
    sort list  ${ids_sorted}
    reverse list  ${ids_sorted}
    Lists Should Be Equal  ${ids_sorted}  ${ids_reverse}

    #NAME

    ${count}=  get matching xpath count  xpath=/html/body/div[2]/div[2]/div/div[2]/div/table/tbody[3]//tr[contains(text()," ")]/../tr
    ${count_str}=  convert to string  ${count}
    LOG  ID
    click element  xpath=/html/body/div[2]/div[2]/div/div[2]/table/thead/tr[1]/th[3]
    #click element  xpath=/html/body/div[2]/div[2]/div/div[2]/table/thead/tr[1]/th[3]
    ${ids}=  create list
    : FOR    ${INDEX}    IN RANGE    1    ${count_str}+1
    \    Log    ${INDEX}
    \    ${id}=  get text  xpath=/html/body/div[2]/div[2]/div/div[2]/div/table/tbody[3]/tr[${INDEX}]/td[3]
    \    ${id_str}=  convert to string  ${id}
    \    append to list  ${ids}  ${id_str}
    ${ids_sorted}=  create list
    ${ids_sorted}=  copy list  ${ids}
    sort list  ${ids_sorted}
    LOG  SORTED
    Lists Should Be Equal  ${ids_sorted}  ${ids}
    ${ids_reverse}=  create list
    click element  xpath=/html/body/div[2]/div[2]/div/div[2]/table/thead/tr[1]/th[3]
    : FOR    ${INDEX}    IN RANGE    1    ${count_str}+1
    \    Log    ${INDEX}
    \    ${id}=  get text  xpath=/html/body/div[2]/div[2]/div/div[2]/div/table/tbody[3]/tr[${INDEX}]/td[3]
    \    ${id_str}=  convert to string  ${id}
    \    append to list  ${ids_reverse}  ${id_str}
    ${ids_sorted}=  create list
    ${ids_sorted}=  copy list   ${ids_reverse}
    sort list  ${ids_sorted}
    reverse list  ${ids_sorted}
    Lists Should Be Equal  ${ids_sorted}  ${ids_reverse}

    #STATE

    ${count}=  get matching xpath count  xpath=/html/body/div[2]/div[2]/div/div[2]/div/table/tbody[3]//tr[contains(text()," ")]/../tr
    ${count_str}=  convert to string  ${count}
    LOG  ID
    click element  xpath=/html/body/div[2]/div[2]/div/div[2]/table/thead/tr[1]/th[4]
    #click element  xpath=/html/body/div[2]/div[2]/div/div[2]/table/thead/tr[1]/th[4]
    ${ids}=  create list
    : FOR    ${INDEX}    IN RANGE    1    ${count_str}+1
    \    Log    ${INDEX}
    \    ${id}=  get text  xpath=/html/body/div[2]/div[2]/div/div[2]/div/table/tbody[3]/tr[${INDEX}]/td[4]
    \    ${id_str}=  convert to string  ${id}
    \    append to list  ${ids}  ${id_str}
    ${ids_sorted}=  create list
    ${ids_sorted}=  copy list  ${ids}
    sort list  ${ids_sorted}
    LOG  SORTED
    Lists Should Be Equal  ${ids_sorted}  ${ids}
    ${ids_reverse}=  create list
    click element  xpath=/html/body/div[2]/div[2]/div/div[2]/table/thead/tr[1]/th[4]
    : FOR    ${INDEX}    IN RANGE    1    ${count_str}+1
    \    Log    ${INDEX}
    \    ${id}=  get text  xpath=/html/body/div[2]/div[2]/div/div[2]/div/table/tbody[3]/tr[${INDEX}]/td[4]
    \    ${id_str}=  convert to string  ${id}
    \    append to list  ${ids_reverse}  ${id_str}
    ${ids_sorted}=  create list
    ${ids_sorted}=  copy list   ${ids_reverse}
    sort list  ${ids_sorted}
    reverse list  ${ids_sorted}
    Lists Should Be Equal  ${ids_sorted}  ${ids_reverse}

    #USER

    ${count}=  get matching xpath count  xpath=/html/body/div[2]/div[2]/div/div[2]/div/table/tbody[3]//tr[contains(text()," ")]/../tr
    ${count_str}=  convert to string  ${count}
    LOG  ID
    click element  xpath=/html/body/div[2]/div[2]/div/div[2]/table/thead/tr[1]/th[5]
    #click element  xpath=/html/body/div[2]/div[2]/div/div[2]/table/thead/tr[1]/th[5]
    ${ids}=  create list
    : FOR    ${INDEX}    IN RANGE    1    ${count_str}+1
    \    Log    ${INDEX}
    \    ${id}=  get text  xpath=/html/body/div[2]/div[2]/div/div[2]/div/table/tbody[3]/tr[${INDEX}]/td[5]
    \    ${id_str}=  convert to string  ${id}
    \    append to list  ${ids}  ${id_str}
    ${ids_sorted}=  create list
    ${ids_sorted}=  copy list  ${ids}
    sort list  ${ids_sorted}
    LOG  SORTED
    Lists Should Be Equal  ${ids_sorted}  ${ids}
    ${ids_reverse}=  create list
    click element  xpath=/html/body/div[2]/div[2]/div/div[2]/table/thead/tr[1]/th[5]
    : FOR    ${INDEX}    IN RANGE    1    ${count_str}+1
    \    Log    ${INDEX}
    \    ${id}=  get text  xpath=/html/body/div[2]/div[2]/div/div[2]/div/table/tbody[3]/tr[${INDEX}]/td[5]
    \    ${id_str}=  convert to string  ${id}
    \    append to list  ${ids_reverse}  ${id_str}
    ${ids_sorted}=  create list
    ${ids_sorted}=  copy list   ${ids_reverse}
    sort list  ${ids_sorted}
    reverse list  ${ids_sorted}
    Lists Should Be Equal  ${ids_sorted}  ${ids_reverse}

    #QUEUE

    ${count}=  get matching xpath count  xpath=/html/body/div[2]/div[2]/div/div[2]/div/table/tbody[3]//tr[contains(text()," ")]/../tr
    ${count_str}=  convert to string  ${count}
    LOG  ID
    click element  xpath=/html/body/div[2]/div[2]/div/div[2]/table/thead/tr[1]/th[6]
    #click element  xpath=/html/body/div[2]/div[2]/div/div[2]/table/thead/tr[1]/th[6]
    ${ids}=  create list
    : FOR    ${INDEX}    IN RANGE    1    ${count_str}+1
    \    Log    ${INDEX}
    \    ${id}=  get text  xpath=/html/body/div[2]/div[2]/div/div[2]/div/table/tbody[3]/tr[${INDEX}]/td[6]
    \    ${id_str}=  convert to string  ${id}
    \    append to list  ${ids}  ${id_str}
    ${ids_sorted}=  create list
    ${ids_sorted}=  copy list  ${ids}
    sort list  ${ids_sorted}
    LOG  SORTED
    Lists Should Be Equal  ${ids_sorted}  ${ids}
    ${ids_reverse}=  create list
    click element  xpath=/html/body/div[2]/div[2]/div/div[2]/table/thead/tr[1]/th[6]
    : FOR    ${INDEX}    IN RANGE    1    ${count_str}+1
    \    Log    ${INDEX}
    \    ${id}=  get text  xpath=/html/body/div[2]/div[2]/div/div[2]/div/table/tbody[3]/tr[${INDEX}]/td[6]
    \    ${id_str}=  convert to string  ${id}
    \    append to list  ${ids_reverse}  ${id_str}
    ${ids_sorted}=  create list
    ${ids_sorted}=  copy list   ${ids_reverse}
    sort list  ${ids_sorted}
    reverse list  ${ids_sorted}
    Lists Should Be Equal  ${ids_sorted}  ${ids_reverse}

    #STARTED

    ${count}=  get matching xpath count  xpath=/html/body/div[2]/div[2]/div/div[2]/div/table/tbody[3]//tr[contains(text()," ")]/../tr
    ${count_str}=  convert to string  ${count}
    LOG  ID
    click element  xpath=/html/body/div[2]/div[2]/div/div[2]/table/thead/tr[1]/th[7]
    #click element  xpath=/html/body/div[2]/div[2]/div/div[2]/table/thead/tr[1]/th[7]
    ${ids}=  create list
    : FOR    ${INDEX}    IN RANGE    1    ${count_str}+1
    \    Log    ${INDEX}
    \    ${id}=  get text  xpath=/html/body/div[2]/div[2]/div/div[2]/div/table/tbody[3]/tr[${INDEX}]/td[7]
    \    ${id_str}=  convert to string  ${id}
    \    append to list  ${ids}  ${id_str}
    ${ids_sorted}=  create list
    ${ids_sorted}=  copy list  ${ids}
    sort list  ${ids_sorted}
    LOG  SORTED
    Lists Should Be Equal  ${ids_sorted}  ${ids}
    ${ids_reverse}=  create list
    click element  xpath=/html/body/div[2]/div[2]/div/div[2]/table/thead/tr[1]/th[7]
    : FOR    ${INDEX}    IN RANGE    1    ${count_str}+1
    \    Log    ${INDEX}
    \    ${id}=  get text  xpath=/html/body/div[2]/div[2]/div/div[2]/div/table/tbody[3]/tr[${INDEX}]/td[7]
    \    ${id_str}=  convert to string  ${id}
    \    append to list  ${ids_reverse}  ${id_str}
    ${ids_sorted}=  create list
    ${ids_sorted}=  copy list   ${ids_reverse}
    sort list  ${ids_sorted}
    reverse list  ${ids_sorted}
    Lists Should Be Equal  ${ids_sorted}  ${ids_reverse}

    #LIFETIME

    ${count}=  get matching xpath count  xpath=/html/body/div[2]/div[2]/div/div[2]/div/table/tbody[3]//tr[contains(text()," ")]/../tr
    ${count_str}=  convert to string  ${count}
    LOG  ID
    click element  xpath=/html/body/div[2]/div[2]/div/div[2]/table/thead/tr[1]/th[8]
    #click element  xpath=/html/body/div[2]/div[2]/div/div[2]/table/thead/tr[1]/th[8]
    ${ids}=  create list
    : FOR    ${INDEX}    IN RANGE    1    ${count_str}+1
    \    Log    ${INDEX}
    \    ${id}=  get text  xpath=/html/body/div[2]/div[2]/div/div[2]/div/table/tbody[3]/tr[${INDEX}]/td[8]
    \    ${id_str}=  convert to string  ${id}
    \    append to list  ${ids}  ${id_str}
    ${ids_sorted}=  create list
    ${ids_sorted}=  copy list  ${ids}
    sort list  ${ids_sorted}
    LOG  SORTED
    Lists Should Be Equal  ${ids_sorted}  ${ids}
    ${ids_reverse}=  create list
    click element  xpath=/html/body/div[2]/div[2]/div/div[2]/table/thead/tr[1]/th[8]
    : FOR    ${INDEX}    IN RANGE    1    ${count_str}+1
    \    Log    ${INDEX}
    \    ${id}=  get text  xpath=/html/body/div[2]/div[2]/div/div[2]/div/table/tbody[3]/tr[${INDEX}]/td[8]
    \    ${id_str}=  convert to string  ${id}
    \    append to list  ${ids_reverse}  ${id_str}
    ${ids_sorted}=  create list
    ${ids_sorted}=  copy list   ${ids_reverse}
    sort list  ${ids_sorted}
    reverse list  ${ids_sorted}
    Lists Should Be Equal  ${ids_sorted}  ${ids_reverse}

    #MEMORY
    ${count}=  get matching xpath count  xpath=/html/body/div[2]/div[2]/div/div[2]/div/table/tbody[3]//tr[contains(text()," ")]/../tr
    ${count_str}=  convert to string  ${count}
    LOG  ID
    click element  xpath=/html/body/div[2]/div[2]/div/div[2]/table/thead/tr[1]/th[9]
    #click element  xpath=/html/body/div[2]/div[2]/div/div[2]/table/thead/tr[1]/th[9]
    ${ids}=  create list
    : FOR    ${INDEX}    IN RANGE    1    ${count_str}+1
    \    Log    ${INDEX}
    \    ${id}=  get text  xpath=/html/body/div[2]/div[2]/div/div[2]/div/table/tbody[3]/tr[${INDEX}]/td[9]
    \    ${id_str}=  convert to string  ${id}
    \    append to list  ${ids}  ${id_str}
    ${ids_sorted}=  create list
    ${ids_sorted}=  copy list  ${ids}
    sort list  ${ids_sorted}
    LOG  SORTED
    Lists Should Be Equal  ${ids_sorted}  ${ids}
    ${ids_reverse}=  create list
    click element  xpath=/html/body/div[2]/div[2]/div/div[2]/table/thead/tr[1]/th[9]
    : FOR    ${INDEX}    IN RANGE    1    ${count_str}+1
    \    Log    ${INDEX}
    \    ${id}=  get text  xpath=/html/body/div[2]/div[2]/div/div[2]/div/table/tbody[3]/tr[${INDEX}]/td[9]
    \    ${id_str}=  convert to string  ${id}
    \    append to list  ${ids_reverse}  ${id_str}
    ${ids_sorted}=  create list
    ${ids_sorted}=  copy list   ${ids_reverse}
    sort list  ${ids_sorted}
    reverse list  ${ids_sorted}
    Lists Should Be Equal  ${ids_sorted}  ${ids_reverse}
    [Teardown]    Close Browser

Top_Navbar_Alert_Menu_Alert_Message_1    #Test no. 34                    #Needs Work
    Open Browser    ${url}     CHROME                                   #Open Chrome in new window
    Connect_To_DT_Console    ${url}
    Sleep  2s

    ${Alert_Count}=     Get Text        xpath=(//SPAN[@class='badge no-alert ng-scope'])[3]
    Log     ${Alert_Count}

    #Positive Alerts
    Click Element       xpath=(//SPAN[@class='badge no-alert ng-scope'])[3]
    Capture Page Screenshot

Connect_To_SIT_Captive_Portal_Login
    Open Browser    http://10.10.216.2:8090       CHROME
    Wait Until Page Contains        SYMBIOSIS HILL BASE CAMPUS
    Input Text      xpath=//INPUT[@type='text']         14070121136
    Input Password      xpath=//INPUT[@type='password']     qw
    Click Element   xpath=//INPUT[@id='logincaption']
    Wait Until Page Contains        You have successfully logged in
    [Teardown]  Close Browser

*** Keywords ***
Open_Chrome_in_incognito_mode
    [Arguments]    ${url}
    ${options}=    Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys, selenium.webdriver
    Call Method    ${options}    add_argument    --allow-running-insecure-content
    Call Method    ${options}    add_argument    --disable-web-security
    Call Method    ${options}    add_argument    --user-data-dir\=/Users/myName/AppData/Local/Google/Chrome/User Data
    Create WebDriver    CHROME    chrome_options=${options}
    Go To       ${url}
