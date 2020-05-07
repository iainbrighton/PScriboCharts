function New-Chart
{
<#
    .SYNOPSIS
        Creates a new [System.Windows.Forms.DataVisualization.Charting.Chart] object.

    .DESCRIPTION
        A chart is a container for collections of series data and chart areas. Each chart can hold multiple
        chart areas so that multiple charts can be displayed. Each chart area can contain one or more series
        of data that are used to render the chart.

    .LINK
        https://docs.microsoft.com/en-us/dotnet/api/system.windows.forms.datavisualization.charting.chart
#>
    [CmdletBinding(DefaultParameterSetName = 'Palette')]
    [OutputType([System.Windows.Forms.DataVisualization.Charting.Chart])]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions','')]
    param
    (
        ## Internal chart name. This name is used when exporting a chart.
        [Parameter(Mandatory, ValueFromPipelineByPropertyName, ParameterSetName = 'Palette')]
        [Parameter(Mandatory, ValueFromPipelineByPropertyName, ParameterSetName = 'CustomPalette')]
        [System.String] $Name,

        ## The width of the chart in pixels. If not specified, defaults to 200.
        [Parameter(ValueFromPipelineByPropertyName, ParameterSetName = 'Palette')]
        [Parameter(ValueFromPipelineByPropertyName, ParameterSetName = 'CustomPalette')]
        [System.Int32] $Width = 200,

        ## The height of the chart in pixels. If not specified, defaults to 150.
        [Parameter(ValueFromPipelineByPropertyName, ParameterSetName = 'Palette')]
        [Parameter(ValueFromPipelineByPropertyName, ParameterSetName = 'CustomPalette')]
        [System.Int32] $Height = 150,

        ## Background color of the chart.
        [Parameter(ValueFromPipelineByPropertyName, ParameterSetName = 'Palette')]
        [Parameter(ValueFromPipelineByPropertyName, ParameterSetName = 'CustomPalette')]
        $BackColor = [System.Drawing.Color]::Empty,

        ## Chart border width.
        [Parameter(ValueFromPipelineByPropertyName, ParameterSetName = 'Palette')]
        [Parameter(ValueFromPipelineByPropertyName, ParameterSetName = 'CustomPalette')]
        [System.Int32] $BorderWidth = 1,

        ## Chart border color.
        [Parameter(ValueFromPipelineByPropertyName, ParameterSetName = 'Palette')]
        [Parameter(ValueFromPipelineByPropertyName, ParameterSetName = 'CustomPalette')]
        [System.Drawing.Color] $BorderColor = [System.Drawing.Color]::Black,

        ## Chart border style. If not specified, defaults to 'NotSet'.
        [Parameter(ValueFromPipelineByPropertyName, ParameterSetName = 'Palette')]
        [Parameter(ValueFromPipelineByPropertyName, ParameterSetName = 'CustomPalette')]
        [ValidateSet('NotSet','Dash','DashDot','DashDotDot','Dot','Solid')]
        [System.String] $BorderStyle = 'NotSet',

        ## Custom chart palette.
        [Parameter(ValueFromPipelineByPropertyName, ParameterSetName = 'CustomPalette')]
        [System.Drawing.Color[]] $CustomPalette,

        ## Built-in chart palette.
        [Parameter(ValueFromPipelineByPropertyName, ParameterSetName = 'Palette')]
        [ValidateSet('Amber','Berry','Blue','BlueGrey','Bright','BrightPastel','Brown','Chocolate','Cyan','DeepOrange',
                     'DeepPurple','EarthTones','Excel','Fire','Grayscale','Green','Grey','Indigo','Light','LightBlue',
                     'LightGreen','Lime','Orange','Pastel','Pink','Purple','Red','SeaGreen','SemiTransparent','Teal',
                     'Yellow')]
        [System.String] $Palette = 'Pastel',

        ## Apply the palette colors in reverse order.
        [Parameter(ValueFromPipelineByPropertyName)]
        [System.Management.Automation.SwitchParameter] $ReversePalette
    )
    process
    {
        Write-Verbose -Message ($localized.CreatingChart -f $Name)
        $chart = New-object System.Windows.Forms.DataVisualization.Charting.Chart
        $chart.Name = $Name
        $chart.Width = $Width
        $chart.Height = $Height
        $chart.BackColor = $BackColor
        $chart.BorderColor = $BorderColor
        $chart.BorderDashStyle = $BorderStyle
        $chart.BorderWidth = $BorderWidth

        $chart.RenderingDpiX = 600.0
        $chart.RenderingDpiY = 600.0

        if (-not $PSBoundParameters.ContainsKey('CustomPalette'))
        {
            $CustomPalette = Get-ColorPalette -Palette $Palette
        }

        ## We don't want to reverse the array passed in
        $paletteCopy = $CustomPalette.Clone()
        if ($ReversePalette)
        {
            [System.Array]::Reverse($paletteCopy)
        }

        $chart.Palette = [System.Windows.Forms.DataVisualization.Charting.ChartColorPalette]::None
        $chart.PaletteCustomColors = $paletteCopy
        Write-Output -InputObject $chart
    }
}
