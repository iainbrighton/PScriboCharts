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

$exampleChart = New-Chart -Name Example9 -Width 600 -Height 600

$addChartAreaParams = @{
    Chart                 = $exampleChart
    Name                  = 'exampleChartArea'
    AxisXTitle            = 'Process Name'
    AxisYTitle            = 'Working Set'
    NoAxisXMajorGridLines = $true
    NoAxisYMajorGridLines = $true
}
$exampleChartArea = Add-ChartArea @addChartAreaParams -PassThru

$addChartSeriesParams = @{
    Chart             = $exampleChart
    ChartArea         = $exampleChartArea
    XField            = 'ProcessName'
    Label             = ''
    ColorPerDataPoint = $true
}
<#
    It is possible to plot two (or more) data series in the same chart area. For example, this would include
    multiple data series in a stacked bar or stacked area chart. This example adds a line chart of the pageable
    memory (PM) for each process on top of the column chart.
#>
$sampleData | Add-ColumnChartSeries @addChartSeriesParams -Name 'columnSeries' -YField 'WS'
$sampleData | Add-LineChartSeries @addChartSeriesParams -Name 'lineSeries' -CustomPalette @([System.Drawing.Color]::Black) -YField 'PM'

$chartFileItem = Export-Chart -Chart $exampleChart -Path $Path -Format $Format -PassThru

if ($PassThru)
{
    Write-Output -InputObject $chartFileItem
}
