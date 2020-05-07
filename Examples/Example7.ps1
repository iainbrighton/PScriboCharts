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

$exampleChart = New-Chart -Name Example7 -Width 600 -Height 600

$addChartAreaParams = @{
    Chart                 = $exampleChart
    Name                  = 'exampleChartArea'
    AxisXTitle            = 'Process Name'
    AxisYTitle            = 'Working Set'
    NoAxisXMajorGridLines = $true
    NoAxisYMajorGridLines = $true
}
$exampleChartArea = Add-ChartArea @addChartAreaParams -PassThru

<#
    There are several built-in color palettes that can be applied to the chart series. These are:

        * Amber
        * Berry
        * Blue
        * BlueGrey
        * Bright
        * BrightPastel
        * Brown
        * Chocolate
        * Cyan
        * DeepOrange
        * DeepPurple
        * EarthTones
        * Excel
        * Fire
        * Grayscale
        * Green
        * Grey
        * Indigo
        * Light
        * LightBlue
        * LightGreen
        * Lime
        * Orange
        * Pastel
        * Pink
        * Purple
        * Red
        * SeaGreen
        * SemiTransparent
        * Teal
        * Yellow
#>
$addChartSeriesParams = @{
    Chart             = $exampleChart
    ChartArea         = $exampleChartArea
    Name              = 'exampleChartSeries'
    XField            = 'ProcessName'
    YField            = 'WS'
    Label             = ''
    ColorPerDataPoint = $true
    Palette           = 'Berry'
}
$sampleData | Add-ColumnChartSeries @addChartSeriesParams

$chartFileItem = Export-Chart -Chart $exampleChart -Path $Path -Format $Format -PassThru

if ($PassThru)
{
    Write-Output -InputObject $chartFileItem
}
