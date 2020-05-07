[CmdletBinding()]
param
(
    [System.String] $Path = '~\Desktop',
    [System.Management.Automation.SwitchParameter] $PassThru,
    [System.String] $Format = 'Png'
)

Import-Module PScriboCharts -Verbose:$false

$sampleData = Get-Process |
    Sort-Object -Property WS -Descending |
        Select-Object -First 16

$exampleChart = New-Chart -Name Example16 -Width 600 -Height 600

<#
    3D charts can be enabled by setting the 'Enable3D' parameter on the chart area.
#>
$addChartAreaParams = @{
    Chart                 = $exampleChart
    Name                  = 'exampleChartArea'
    AxisXTitle            = 'Process Name'
    NoAxisXMajorGridLines = $true
    NoAxisYMajorGridLines = $true
    Enable3D              = $true
}
$exampleChartArea = Add-ChartArea @addChartAreaParams -PassThru

$addChartSeriesParams = @{
    Chart             = $exampleChart
    ChartArea         = $exampleChartArea
    XField            = 'ProcessName'
    Label             = ''
}

$sampleData | Add-AreaChartSeries @addChartSeriesParams -Name 'pmSeries' -YField 'PM'
$sampleData | Add-AreaChartSeries @addChartSeriesParams -Name 'wsSeries' -YField 'WS'

$chartFileItem = Export-Chart -Chart $exampleChart -Path $Path -Format $Format -PassThru

if ($PassThru)
{
    Write-Output -InputObject $chartFileItem
}
