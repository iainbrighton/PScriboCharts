[CmdletBinding()]
param
(
    [System.String] $Path = '~\Desktop',
    [System.Management.Automation.SwitchParameter] $PassThru,
    [System.String] $Format = 'Png'
)

$sampleData = Get-Process |
    Sort-Object -Property Handles -Descending |
        Select-Object -First 7

$exampleChart = New-Chart -Name Example11 -Width 600 -Height 600

$addChartAreaParams = @{
    Chart = $exampleChart
    Name  = 'exampleChartArea'
}
$exampleChartArea = Add-ChartArea @addChartAreaParams -PassThru

$addChartSeriesParams = @{
    Chart             = $exampleChart
    ChartArea         = $exampleChartArea
    Name              = 'exampleChartSeries'
    XField            = 'ProcessName'
    YField            = 'Handles'
    Palette           = 'Pastel'
    ColorPerDataPoint = $true
}
$exampleChartSeries = $sampleData | Add-PieChartSeries @addChartSeriesParams -PassThru

<#
    Legends can be added to chart areas. By default they are rendered outside the inner plot position. It is
    possible to display the title inside by using the '-DockedInsideChartArea' switch parameter.

    By default the legend title is centered, but it can be moved to align with the legend items.
#>
$addChartLegendParams = @{
    Chart             = $exampleChart
    Name              = 'Process Name'
    TitleAlignment    = 'Near'
}
Add-ChartLegend @addChartLegendParams

$chartFileItem = Export-Chart -Chart $exampleChart -Path $Path -Format $Format -PassThru

if ($PassThru)
{
    Write-Output -InputObject $chartFileItem
}
