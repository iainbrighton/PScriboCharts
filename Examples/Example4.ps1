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

$exampleChart = New-Chart -Name Example4 -Width 600 -Height 600

<#
    You can specify the label and title fonts (including size and weight) used on the chart axes.

    By default, the .NET charting library will firstly decrease the font size used in the axes labels. You can
    override this behaviour by specify in minimum font size that can be rendered by using the
    'AxisXLabelMinFontSize' and/or 'AxisYLabelMinFontSize' parameters.
#>
$customLabelFont = New-ChartFont -Name 'Arial' -Size 9
$customTitleFont = New-ChartFont -Name 'Arial' -Size 10 -Bold
$addChartAreaParams = @{
    Chart                 = $exampleChart
    Name                  = 'exampleChartArea'
    AxisXTitle            = 'Process Name'
    AxisYTitle            = 'Working Set'
    AxisXTitleFont        = $customTitleFont
    AxisXLabelFont        = $customLabelFont
    AxisYTitleFont        = $customTitleFont
    AxisYLabelFont        = $customLabelFont
    AxisXLabelMinFontSize = 9
    AxisYLabelMinFontSize = 9
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
