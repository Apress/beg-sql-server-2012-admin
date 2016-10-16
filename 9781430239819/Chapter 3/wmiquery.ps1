#Use WMI to obtain the AT Scheduler job list
$colItems = get-wmiobject -class "Win32_ScheduledJob" 
-namespace "root\CIMV2" -computername "."

foreach ($objItem in $colItems) 
{
$JobId = $objItem.JobID
$JobStatus = $objItem.JobStatus
$JobName = $objItem.Command

#Use the SQL Provider Invoke-SqlCmd cmdlet to insert our
## result into the JobReports table
Invoke-SqlCmd -Query "INSERT INTO master..JobReports 
(job_engine, job_engine_id, job_name, job_last_outcome)
 VALUES('NT','$JobId','$JobName','$JobStatus')"
}

#Now let's obtain the job listing from the JobServer object
#REPLACE the <SERVERNAME> with your own server name!
Set-Location "SQL:\<SERVERNAME>\default\JobServer"

$jobItems = get-childitem "Jobs"

foreach ($objItem in $jobItems)
{
$JobId =  $objItem.JobID
$JobStatus = $objItem.LastRunOutcome
$JobName = $objItem.Name

Invoke-SqlCmd -Query "INSERT INTO master..JobReports 
(job_engine, job_engine_id, job_name, job_last_outcome)
 VALUES('AGENT','$JobId','$JobName','$JobStatus')"
}
