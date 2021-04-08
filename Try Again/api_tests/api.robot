*** Settings ***
Library  RequestsLibrary
Library  Collections
Library  JSONLibrary
Library  OperatingSystem

*** Variables ***
${base_url}         https://gorest.co.in/public-api/users
${bearerToken}      Bearer f9d9bb242584d8560953ab2ae27cee65244e1c846ef776cfc37a9f20af8abc96

*** Test Cases ***
Create New User
    create session      mysession       ${base_url}

    ${headers}      create dictionary       Authorization=${bearerToken}        Content-Type=application/json
    ${json_object}=     Load Json From File             ${CURDIR}/user.json

    ${response}=    post request    mysession       /       data=${json_object}     headers=${headers}
    #log to console      ${response.status_code}
    #log to console      ${response.content}

    #Validation
    Should Be Equal As Strings      ${response.status_code}             200
    Should Be Equal As Integers     ${response.json()['code']}          201

    ${json_object}=     to json     ${response.content}
    ${id_value}=      get value from json     ${json_object}      $.data.id
    log to console      ${id_value[0]}
    Set Global Variable     ${id_value[0]}

Get User Detail
    create session      mysession       ${base_url}/${id_value[0]}

    ${headers}      create dictionary       Authorization=${bearerToken}        Content-Type=application/json

    ${response}=    get request    mysession       /        headers=${headers}
    # log to console      ${response.status_code}
    # log to console      ${response.content}

    #Validation
    Should Be Equal As Strings      ${response.status_code}             200
    Should Be Equal As Integers     ${response.json()['code']}          200

Update User Detail
    create session      mysession       ${base_url}/${id_value[0]}

    ${headers}      create dictionary       Authorization=${bearerToken}        Content-Type=application/json
    ${json_object}=     Load Json From File             ${CURDIR}/userUpdate.json

    ${response}=    put request    mysession       /       data=${json_object}     headers=${headers}
    # log to console      ${response.status_code}
    # log to console      ${response.content}

    #Validation
    Should Be Equal As Strings      ${response.status_code}             200
    Should Be Equal As Integers     ${response.json()['code']}          200

    ${json_object}=     to json     ${response.content}
    ${name_value}=      get value from json     ${json_object}      $.data.name
    log to console      ${name_value[0]}
    should be equal     ${name_value[0]}       Muhammad

Delete User
    create session      mysession       ${base_url}/${id_value[0]}

    ${headers}      create dictionary       Authorization=${bearerToken}        Content-Type=application/json

    ${response}=    delete request    mysession       /        headers=${headers}
    # log to console      ${response.status_code}
    # log to console      ${response.content}

    #Validation
    Should Be Equal As Strings      ${response.status_code}             200
    Should Be Equal As Integers     ${response.json()['code']}          204