[CmdletBinding()]
param
(
    [System.String] $Path = '~\Desktop',
    [System.Management.Automation.SwitchParameter] $PassThru,
    [System.String] $Format = 'Png'
)

<#
    From Powershell v3 onwards, the module should not need to be explicitly imported. It is included
    here to avoid any ambiguity.
#>
Import-Module PScriboCharts -Verbose:$false

<#
    Generate some sample data to use as an example. This could be a collections of [System.Object[]] (or derived) types.
#>
$sampleData = Get-Process |
    Sort-Object -Property WS -Descending |
        Select-Object -First 10

<#
    Creates a new chart. The name given to the chart is used when exporting the graphic.
#>
$exampleChart = New-Chart -Name Example1 -Width 600 -Height 600

<#
    Adds a chart area to the chart used to plot a series of data. A chart can contain multiple chart areas.
#>
$exampleChartArea = Add-ChartArea -Chart $exampleChart -Name exampleChartArea -PassThru

<#
    Add a column chart series to the chart area. The chart is plotted by using the 'ProcessName' property for the
    X axis and the 'WS' property for the Y axis, from each object in the $sampleData collection.

    The series type determines the layout/format of the chart. In this instance it's a column chart but could also be
    a line chart by using '$sampleData | Add-LineChartSeries @addChartSeriesParams' instead.
#>
$addChartSeriesParams = @{
    Chart     = $exampleChart
    ChartArea = $exampleChartArea
    Name      = 'exampleChartSeries'
    XField    = 'ProcessName'
    YField    = 'WS'
}
$sampleData | Add-LineChartSeries @addChartSeriesParams

<#
    Export the chart to a .png (by default) file.
#>
$chartFileItem = Export-Chart -Chart $exampleChart -Path $Path -Format $Format -PassThru

if ($PassThru)
{
    Write-Output -InputObject $chartFileItem
}
