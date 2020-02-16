#This script will create HyperV VM's to install Dynamics 365 CE Farm
#Domain: idynamics.com
#IDY-DC1 : Domain Controller, ADCS (1 Gb)
#IDY-FE01 : CRM FrontEnd server roles (4 Gb)
#IDY-BE01: CRM BackEnd server roles (2 Gb)
#IDY-AF01: ADFS on Windows Server 2016 (2 Gb)
#IDY-SQL01 : SQL Server 2016 (5 Gb)
#IDY-SP01 : Server for Share Point (4 Gb)
#IDY-EX01: Exchange 2016, NService Bus(4 Gb)
#IDY-CLIENT: Windows 10 Client (2 Gb)
#The IP addresses are assigned automatically like in the previous samples but AL also assignes the gateway and the DNS servers to all machines
#that are part of the lab. AL does that if it finds a machine with the role 'Routing' in the lab.

New-LabDefinition -VmPath 'D:\iDynamics\AutomatedLab-VMs' -Name iDynamics -ReferenceDiskSizeInGB 100 -Path 'D:\iDynamics\Farm' -DefaultVirtualizationEngine HyperV 
Add-LabVirtualNetworkDefinition -Name Lab0
Add-LabVirtualNetworkDefinition -Name 'Default Switch' -HyperVProperties @{ SwitchType = 'External'; AdapterName = 'Wi-Fi'}

Add-LabMachineDefinition -Name IDY-DC1  -Memory 1GB -OperatingSystem 'Windows Server 2016 Datacenter (Desktop Experience)' -Roles RootDC -Network Lab0 -DomainName idynamics.com
$netAdapter = @()
$netAdapter += New-LabNetworkAdapterDefinition -VirtualSwitch Lab0
$netAdapter += New-LabNetworkAdapterDefinition -VirtualSwitch 'Default Switch' -UseDhcp
Add-LabMachineDefinition -Name IDY-FE01 -Memory 4GB -OperatingSystem 'Windows Server 2016 Datacenter (Desktop Experience)' -Roles Routing -NetworkAdapter $netAdapter -DomainName idynamics.com
Add-LabMachineDefinition -Name IDY-BE01 -Memory 2GB -Network Lab0 -OperatingSystem 'Windows Server 2016 Datacenter (Desktop Experience)' -DomainName idynamics.com
Add-LabMachineDefinition -Name IDY-AF01 -Memory 2GB -Network Lab0 -OperatingSystem 'Windows Server 2016 Datacenter (Desktop Experience)' -DomainName idynamics.com
Add-LabMachineDefinition -Name IDY-SQL01 -Memory 5GB -Network Lab0 -OperatingSystem 'Windows Server 2016 Datacenter (Desktop Experience)' -DomainName idynamics.com
Add-LabMachineDefinition -Name IDY-SP01 -Memory 4GB -Network Lab0 -OperatingSystem 'Windows Server 2016 Datacenter (Desktop Experience)' -DomainName idynamics.com
Add-LabMachineDefinition -Name IDY-EX01 -Memory 4GB -Network Lab0 -OperatingSystem 'Windows Server 2016 Datacenter (Desktop Experience)' -DomainName idynamics.com
Add-LabMachineDefinition -Name IDY-CLIENT -Memory 2GB -OperatingSystem 'Windows 10 Enterprise' -Network Lab0 -DomainName idynamics.com

Install-Lab

Show-LabDeploymentSummary -Detailed 