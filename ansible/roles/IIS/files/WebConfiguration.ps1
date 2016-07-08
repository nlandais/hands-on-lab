#
# Need to create a module for these actions
#

Set-WebConfigurationProperty '/system.webServer/httpErrors' -Name "errorMode" -Value "Custom"
foreach ($errorcode in 401,403,404) {
    Set-WebConfiguration -Filter "/system.webServer/httpErrors/error[@statusCode='$errorcode']" -value @{path="notfound.htm"} 
}

foreach ($errorcode in 500,501,502) {
    Set-WebConfiguration -Filter "/system.webServer/httpErrors/error[@statusCode='$errorcode']" -value @{path="unexpected.htm"} 
}

#enable compression for json and xml
foreach ($mimeType in "json","xml") {
    Add-WebConfiguration -Filter '/system.webServer/httpCompression/dynamicTypes' -value @{mimeType="application/$mimeType";enabled="true"}    
}

foreach ($name in "dynamicCompressionLevel","staticCompressionLevel") {
    Set-WebConfigurationProperty '/system.webServer/httpCompression/scheme' -Name $name -Value 4       
}