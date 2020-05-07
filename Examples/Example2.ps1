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

$exampleChart = New-Chart -Name Example2 -Width 600 -Height 600
$exampleChartArea = Add-ChartArea -Chart $exampleChart -Name exampleChartArea -PassThru

<#
    By default, '#VALY' labels are added to the chart (see 'Example1.ps1' for a demonstration of this). These labels
    can be removed by specifying a blank label.
#>
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
