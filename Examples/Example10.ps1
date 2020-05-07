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

$exampleChart = New-Chart -Name Example10 -Width 600 -Height 600

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
    Name              = 'exampleChartSeries'
    XField            = 'ProcessName'
    YField            = 'WS'
    Label             = ''
    ColorPerDataPoint = $true
}
$sampleData | Add-ColumnChartSeries @addChartSeriesParams

<#
    Titles can be added to chart areas. By default they are rendered outside the inner plot position. It is
    possible to display the title inside by using the '-DockedInsideChartArea' switch parameter.
#>

$addChartTitleParams = @{
    Chart     = $exampleChart
    ChartArea = $exampleChartArea
    Name      = 'example8'
    Text      = 'PScribo Charts Example 8'
    Font      = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Arial', '16', [System.Drawing.FontStyle]::Bold)
}
Add-ChartTitle @addChartTitleParams

$chartFileItem = Export-Chart -Chart $exampleChart -Path $Path -Format $Format -PassThru

if ($PassThru)
{
    Write-Output -InputObject $chartFileItem
}
