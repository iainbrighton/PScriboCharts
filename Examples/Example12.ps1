[CmdletBinding()]
param
(
    [System.String] $Path = '~\Desktop',
    [System.Management.Automation.SwitchParameter] $PassThru,
    [System.String] $Format = 'Png'
)

Import-Module PScriboCharts -Verbose:$false

$sampleData = Get-Process |
    Sort-Object -Property Handles -Descending |
        Select-Object -First 7

$exampleChart = New-Chart -Name Example12 -Width 600 -Height 600

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
$exampleChartSeries = $sampleData | Add-DoughnutChartSeries @addChartSeriesParams -PassThru

<#
    Annotations can be added a chart area at any co-ordinate. For example, this can be used to place
    in the center of a doughnut chart.

    The AnchorX and AnchorY positions are the co-ordinates from the top left of the chart area, specified
    as percentages.
#>
$addChartAnnotationParams = @{
    Chart   = $exampleChart
    Text    = $sampleData | Measure-Object -Property Handles -Sum | Select-Object -ExpandProperty Sum
    AnchorX = 53
    Anchory = 53
    Font    = New-ChartFont -Name 'Arial' -Size 28
}
Add-ChartAnnotation  @addChartAnnotationParams

$chartFileItem = Export-Chart -Chart $exampleChart -Path $Path -Format $Format -PassThru

if ($PassThru)
{
    Write-Output -InputObject $chartFileItem
}
