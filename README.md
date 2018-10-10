# Service Fabric Business Platform

The Business Platform allows deployment of multiple orchestrated JavaScript services to the Service Fabric cluster, enjoying full range of security, performance, and application lifecycle management capabilities.

This project contains setup scripts and application files necessary to deploy and configure Service Manager and Service Host applications to the Local Service Fabric cluster.

Detailed documentation at https://www.SupercondActor.com/documentation/

## Prerequisites

Before you run provided PoweShell scripts make sure your computer meets the software prerequisites outlined below.   
Note: Provided instructions are for Windows platform.

##### 1. Azure PowerShell

Azure PowerShell provides a set of cmdlets that use the Azure Resource Manager model for managing your Azure resources.
Read <a href="https://docs.microsoft.com/en-us/powershell/azure/install-azurerm-ps" target="_blank">this article</a> which explains the steps to install the Azure PowerShell modules in a Windows environment using PowerShellGet. 

##### 2. OpenSSL

To process cluster certificate needed to communicate with the Service Fabric cluster, provided scripts use OpenSSL software developed by the <a target="_blank" href="http://www.openssl.org/">OpenSSL Project</a>.   
One of the places where you can download setup package for Windows platform is <a target="_blank" href="https://slproweb.com/products/Win32OpenSSL.html">slproweb.com/products/Win32OpenSSL.html</a>

## Deployment to a local development cluster
The setup script deploys and configures Service Manager and Service Host applications to the Local Service Fabric cluster.

#### Creating Local Service Fabric cluster

1. Install <a target="_blank" href="https://docs.microsoft.com/en-us/azure/service-fabric/service-fabric-get-started">Service Fabric SDK</a>.
1. In the Programs locate and start "Service Fabric Local Cluster Manager".
1. Right-click the orange cluster icon in the taskbar notification area, select "Setup Local Cluster", select "5 Node". 
1. Wait several minutes until local cluster is created.    
You can double-click the orange cluster icon to display Local Cluster Manager UI.

#### Installing Business Platform to the Local cluster

1. Download or clone this repository
1. In the "/src" folder locate the PowerShell script *DeployAppsToLocalCluster.ps1*
1. Optionally, take a look at the parameters inside the script, you might want to change some of them, though the script can be run "as-is" with default parameters.
1. Run this PowerShell script
    - You'll be asked to login into your Azure account. This is required to configure authentication. If you have multiple Azure subscriptions the script will ask you to select one.
    - Wait a minute until your local cluster gets configured and Business Platform applications are deployed.

Pay attention to the text displayed after the script completes - it shows Platform URL and may provide important instructions if additional steps are needed.


