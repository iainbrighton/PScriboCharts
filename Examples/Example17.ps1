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

$exampleChart = New-Chart -Name Example17 -Width 600 -Height 200 -Palette Berry

<#
    Two separate chart areas can be applied to the same chart, e.g.

    ------------------------------------------- CHART ------------------------------------------
    |   ____________ CHART AREA 1_______________    ____________ CHART AREA 2 _______________  |
    |   |                                       |   |                                       |  |
    |   |                                       |   |                                       |  |
    |   |                                       |   |                                       |  |
    |   |                                       |   |                                       |  |
    |   |                                       |   |                                       |  |
    |   |                                       |   |                                       |  |
    |   |                                       |   |                                       |  |
    |   |                                       |   |                                       |  |
    |   |                                       |   |                                       |  |
    |   |                                       |   |                                       |  |
    |   |_______________________________________|   |_______________________________________|  |
    -------------------------------------------------------------------------------------------
#>

<#
    Add a chart area on the left that occupies 50% of the chart width
    and insert a multicolored spline chart.
#>
$addChartAreaParams = @{
    Chart                 = $exampleChart
    Name                  = 'chartArea1'
    X                     = 0
    Y                     = 0
    Width                 = 50
    Height                = 100
    NoAxisXMajorGridLines = $true
}
$exampleChartArea1 = Add-ChartArea @addChartAreaParams -PassThru
$addSplineChartSeriesParams = @{
    Chart             = $exampleChart
    ChartArea         = $exampleChartArea1
    Name              = 'handlesSeries'
    XField            = 'ProcessName'
    YField            = 'Handles'
    Label             = ''
    ColorPerDataPoint = $true
}
$sampleData | Add-SplineChartSeries @addSplineChartSeriesParams

<#
    Add a chart area on the right that occupies the remaining 50% of the chart width
    and insert a multicolored spline area chart.
#>
$addChartAreaParams = @{
    Chart                 = $exampleChart
    Name                  = 'chartArea2'
    X                     = 50
    Y                     = 0
    Width                 = 50
    Height                = 100
    NoAxisXMajorGridLines = $true
}
$exampleChartArea2 = Add-ChartArea @addChartAreaParams -PassThru
$addSplineAreaChartSeriesParams = @{
    Chart             = $exampleChart
    ChartArea         = $exampleChartArea2
    Name              = 'pmSeries'
    XField            = 'ProcessName'
    YField            = 'PM'
    Label             = ''
    ColorPerDataPoint = $true
}
$sampleData | Add-SplineAreaChartSeries @addSplineAreaChartSeriesParams

$chartFileItem = Export-Chart -Chart $exampleChart -Path $Path -Format $Format -PassThru

if ($PassThru)
{
    Write-Output -InputObject $chartFileItem
}
