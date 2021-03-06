function Add-StackedColumnChartSeries
{
<#
    .SYNOPSIS
        Adds a stacked column chart Series to an existing ChartArea.
#>
    [CmdletBinding(DefaultParameterSetName = 'Default')]
    [OutputType([System.Windows.Forms.DataVisualization.Charting.Series])]
    param
    (
        ## Source objects used to plot data points on the chart.
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [System.Object[]] $InputObject,

        ## Series name
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [System.String] $Name,

        ## Chart to add the data series to.
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [System.Windows.Forms.DataVisualization.Charting.Chart] $Chart,

        ## ChartArea to add the series to.
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [System.Windows.Forms.DataVisualization.Charting.ChartArea] $ChartArea,

        ## InputObject property name to bind to the X axis.
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [System.String] $XField,

        ## InputObject property name to bind to the Y axis.
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [System.String] $YField,

        ## Built-in color palette to apply to the data series.
        [Parameter(Mandatory, ValueFromPipelineByPropertyName, ParameterSetName = 'Palette')]
        [System.String] $Palette,

        ## Custom color palette to apply to the data series.
        [Parameter(Mandatory, ValueFromPipelineByPropertyName, ParameterSetName = 'CustomPalette')]
        [System.Drawing.Color[]] $CustomPalette,

        ## Apply a specific color to the data series.
        [Parameter(Mandatory, ValueFromPipelineByPropertyName, ParameterSetName = 'Color')]
        [System.Drawing.Color] $Color,

        ## Apply an seperate color from the palette per data point.
        [Parameter(ValueFromPipelineByPropertyName)]
        [System.Management.Automation.SwitchParameter] $ColorPerDataPoint,

        ## Reverse the color palette.
        [Parameter(ValueFromPipelineByPropertyName)]
        [System.Management.Automation.SwitchParameter] $ReversePalette,

        ## Hide zero value data point labels.
        [Parameter(ValueFromPipelineByPropertyName)]
        [System.Management.Automation.SwitchParameter] $HideZeroValueLabels,

        ## Sort the series.
        [Parameter(ValueFromPipelineByPropertyName)]
        [ValidateSet('Ascending','Descending')]
        [System.String] $Sort,

        ## Series data point label.
        [Parameter(ValueFromPipelineByPropertyName)]
        [System.String] $Label = '#VALY',

        ## Axis label text for the series.
        [Parameter(ValueFromPipelineByPropertyName)]
        [System.String] $AxisLabel,

        ## Label for the data series that is displayed in a legend.
        [Parameter(ValueFromPipelineByPropertyName)]
        [System.String] $LegendText = '#VALX',

        ## Data point (border) width.
        [Parameter(ValueFromPipelineByPropertyName)]
        [System.Int32] $BorderWidth = 1,

        ## Data point border color.
        [Parameter(ValueFromPipelineByPropertyName)]
        [System.Drawing.Color] $BorderColor,

        ## Data label font.
        [Parameter(ValueFromPipelineByPropertyName)]
        [System.Drawing.Font] $Font = (Get-DefaultFont),

        ## Data label text color.
        [Parameter(ValueFromPipelineByPropertyName)]
        [System.Drawing.Color] $LabelForeColor = [System.Drawing.Color]::FromName('Black'),

        ## Data label back color.
        [Parameter(ValueFromPipelineByPropertyName)]
        [System.Drawing.Color] $LabelBackColor = [System.Drawing.Color]::FromName('Empty'),

        ## X axis type.
        [Parameter(ValueFromPipelineByPropertyName)]
        [ValidateSet('Primary', 'Secondary')]
        [System.String] $XAxisType = 'Primary',

        ## Y axis type.
        [Parameter(ValueFromPipelineByPropertyName)]
        [ValidateSet('Primary', 'Secondary')]
        [System.String] $YAxisType = 'Primary',

        ## Hide the data series from any legend.
        [Parameter(ValueFromPipelineByPropertyName)]
        [System.Management.Automation.SwitchParameter] $HideFromLegend,

        ## Pass the [System.Windows.Forms.DataVisualization.Charting.Series] object down the pipeline.
        [Parameter(ValueFromPipelineByPropertyName)]
        [System.Management.Automation.SwitchParameter] $PassThru,

        <# Chart type specific parameters #>

        [Parameter(ValueFromPipelineByPropertyName)]
        [ValidateSet('Outside', 'Left', 'Right', 'Center')]
        [System.String] $LabelPosition,

        ## Bar, Candlestick, Column, Stacked Bar, 100% Stacked Bar, Stacked Column, 100% Stacked Column, Stock, Box Plot, Error Bar, Range Bar, Range Column
        [Parameter(ValueFromPipelineByPropertyName)]
        [System.Int32] $PointWidth
    )
    begin
    {
        $dataPoints = New-Object -TypeName System.Collections.ArrayList -ArgumentList @();
    }
    process
    {
        foreach ($object in $InputObject)
        {
            [ref] $null = $dataPoints.Add($object)
        }
    }
    end
    {
        $chartType = [System.Windows.Forms.DataVisualization.Charting.SeriesChartType]::StackedColumn
        $dataPointCollection = $dataPoints | Convert-ToOrderedDictionary -Key $XField -Value $YField
        $chartSeries = Add-ChartSeries @PSBoundParameters -DataPointCollection $dataPointCollection -ChartType $chartType

        <# Chart type specific parameters #>

        if ($PSBoundParameters.ContainsKey('LabelPosition'))
        {
            $chartSeries['BarLabelStyle'] = $LabelPosition
        }

        if ($PSBoundParameters.ContainsKey('PointWidth'))
        {
            $chartSeries['PixelPointWidth'] = $PointWidth.ToString()
        }

        if ($PassThru)
        {
            Write-Output -InputObject $chartSeries
        }
    }
}
