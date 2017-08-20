FROM microsoft/aspnet
 
##install web deploy
RUN mkdir c:\install
ADD WebDeploy_2_10_amd64_en-US.msi /install/WebDeploy_2_10_amd64_en-US.msi
 
##install webapplication
WORKDIR /install
RUN msiexec.exe /i c:\install\WebDeploy_2_10_amd64_en-US.msi /qn
RUN mkdir c:\SampleApp
WORKDIR /SampleApp
ADD fixAcls.ps1 /SampleApp/fixAcls.ps1
ADD SampleApp/SampleApp.zip /SampleApp/SampleApp.zip
ADD SampleApp/SampleApp.deploy.cmd /SampleApp/SampleApp.deploy.cmd
ADD SampleApp/SampleApp.SetParameters.xml /SampleApp/SampleApp.SetParameters.xml
 
# Running deploy.cmd once will result in an ACLS error
RUN SampleApp.deploy.cmd /Y
 
# This script will fix the ACLS error
RUN powershell.exe -executionpolicy bypass .\fixAcls.ps1

#Lastly we will need to run the deploy.cmd again to complete the installation
RUN SampleApp.deploy.cmd /Y
 
EXPOSE 80
