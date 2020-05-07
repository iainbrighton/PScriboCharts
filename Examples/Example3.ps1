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
        Select-Object -First 10

$exampleChart = New-Chart -Name Example3 -Width 600 -Height 600

<#
    Axis labels can be set on each chart area (you can have more than one chart area).
#>
$addChartAreaParams = @{
    Chart      = $exampleChart
    Name       = 'exampleChartArea'
    AxisXTitle = 'Process Name'
    AxisYTitle = 'Working Set'
}
$exampleChartArea = Add-ChartArea @addChartAreaParams -PassThru

$addChartSeriesParams = @{
    Chart     = $exampleChart
    ChartArea = $exampleChartArea
    Name      = 'exampleChartSeries'
    XField    = 'ProcessName'
    YField    = 'WS'
    Label     = ''
}
$sampleData | Add-ColumnChartSeries @addChartSeriesParams

$chartFileItem = Export-Chart -Chart $exampleChart -Path $Path -Format $Format -PassThru

if ($PassThru)
{
    Write-Output -InputObject $chartFileItem
}
