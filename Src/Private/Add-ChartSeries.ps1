function Add-ChartSeries
{
<#
    .SYNOPSIS
        Adds a chart Series to an existing ChartArea.
#>
    [CmdletBinding(DefaultParameterSetName = 'Default')]
    [OutputType([System.Windows.Forms.DataVisualization.Charting.Series])]
    param
    (
        ## Source objects used to plot data points on the chart.
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [System.Object[]] $InputObject,

        ## Data series name.
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

        ## Catch all to allow splatting from chart-specific series cmdlets
        [Parameter(ValueFromRemainingArguments)]
        [System.Object[]] $RemainingArguments
    )
    process
    {
        Write-Verbose -Message ($localized.CreatingChartSeries -f $Name)
        $chartSeries = New-Object -TypeName 'System.Windows.Forms.DataVisualization.Charting.Series' -ArgumentList $Name
        $chartSeries.ChartArea = $ChartArea.Name
        $chartSeries.ChartType = $ChartType
        $chartSeries.AxisLabel = $AxisLabel
        $chartSeries.XAxisType = $XAxisType
        $chartSeries.YAxisType = $YAxisType
        $Chart.Series.Add($chartSeries)
        $chartSeries.Points.DataBindXY($DataPointCollection.Keys, $DataPointCollection.Values)

        ## Default/all chart options
        $chartSeries.Label = $Label
        $chartSeries.LegendText = $LegendText

        $chartSeries.Font = $Font
        $chartSeries.LabelForeColor = $LabelForeColor
        $chartSeries.LabelBackColor = $LabelBackColor
        $chartSeries.IsVisibleInLegend = -not $HideFromLegend.ToBool()

        $chartSeries.BorderWidth = $BorderWidth
        if ($PSBoundParameters.ContainsKey('BorderColor'))
        {
            $chartSeries.BorderColor = $BorderColor
        }

        if ($PSBoundParameters.ContainsKey('Sort'))
        {
            if ($Sort -eq 'Ascending')
            {
                $chartSeries.Sort([System.Windows.Forms.DataVisualization.Charting.PointSortOrder]::Ascending)
            }
            else
            {
                $chartSeries.Sort([System.Windows.Forms.DataVisualization.Charting.PointSortOrder]::Descending)
            }
        }

        if ($PSCmdlet.ParameterSetName -eq 'Color')
        {
            $chartSeries.Color = $Color
        }
        if ($PSCmdlet.ParameterSetName -eq 'CustomPalette')
        {
            ## Use the supplied custom palette array
            Write-Verbose ($localized.ApplyingCustomColorPalette -f $Name)
        }
        elseif ($PSCmdlet.ParameterSetName -eq 'Palette')
        {
            ## Convert the supplied palette name into a custom palette array
            Write-Verbose ($localized.ApplyingColorPalette  -f $Palette, $Name)
            $CustomPalette = Get-ColorPalette -Palette $Palette
        }
        else
        {
            if ($Chart.Palette -eq [System.Windows.Forms.DataVisualization.Charting.ChartColorPalette]::None)
            {
                ## Use the charts custom palette
                $CustomPalette = $Chart.PaletteCustomColors
            }
            else
            {
                ## Convert the chart's palette name into a custom palette array
                $CustomPalette = Get-ColorPalette -Palette $Chart.Palette
            }
        }

        if ($ReversePalette)
        {
            Write-Verbose -Message ("Reversing palette.")
            [System.Array]::Reverse($CustomPalette)
        }

        $paletteIndex = 0
        foreach ($point in $chartSeries.Points)
        {
            #if ($ColorPerDataPoint -or $PSBoundParameters.ContainsKey('Palette') -or $PSBoundParameters.ContainsKey('CustomPalette'))
            if ($ColorPerDataPoint)
            {
                $point.Color = $CustomPalette[$paletteIndex]
                if ($ColorPerDataPoint)
                {
                    $paletteIndex ++
                    if ($paletteIndex -ge $CustomPalette.Count)
                    {
                        $paletteIndex = 0
                    }

                }
            }

            if ($HideZeroValueLabels)
            {
                if ($point.YValues[0] -eq 0)
                {
                    $point.Label = ''
                }
            }
        }

        Write-Output -InputObject $chartSeries
    }
}
