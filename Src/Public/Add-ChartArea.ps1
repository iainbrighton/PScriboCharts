function Add-ChartArea
{
<#
    .SYNOPSIS
        Adds a chart area to an existing chart.

    .DESCRIPTION
        A chart area is the rectangular area that encompasses the plot position, the tick marks, the axis labels and
        the axis titles on the chart. The plot position is the rectangular area that encompasses the inner plot
        position, the tick marks, and the axis labels. The inner plot position is the rectangular area, inside the x
        and y-axis lines, where the data points are drawn.

    .LINK
        https://docs.microsoft.com/en-us/dotnet/api/system.windows.forms.datavisualization.charting.chartarea
#>
    [CmdletBinding(DefaultParameterSetName = 'Default')]
    [OutputType([System.Windows.Forms.DataVisualization.Charting.ChartArea])]
    param
    (
        ## Chart object to add the chart area
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [System.Windows.Forms.DataVisualization.Charting.Chart] $Chart,

        ## Name of the chart area to add to the chart
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [System.String] $Name,

        [Parameter(ValueFromPipelineByPropertyName)]
        [System.Drawing.Color] $AxisXMajorGridLineColor,

        [Parameter(ValueFromPipelineByPropertyName)]
        [ValidateSet('Dash','DashDot','DashDotDot','Dot','NotSet','Solid')]
        [System.String] $AxisXMajorGridLineDashStyle,

        [Parameter(ValueFromPipelineByPropertyName)]
        [System.Drawing.Font] $AxisXLabelFont = (Get-DefaultFont),

        [Parameter(ValueFromPipelineByPropertyName)]
        [System.Drawing.Font] $AxisXTitleFont = (Get-DefaultFont),

        [Parameter(ValueFromPipelineByPropertyName)]
        [System.Drawing.Color] $AxisYMajorGridLineColor,

        [Parameter(ValueFromPipelineByPropertyName)]
        [ValidateSet('Dash','DashDot','DashDotDot','Dot','NotSet','Solid')]
        [System.String] $AxisYMajorGridLineDashStyle,

        [Parameter(ValueFromPipelineByPropertyName)]
        [System.Drawing.Font] $AxisYLabelFont = (Get-DefaultFont),

        [Parameter(ValueFromPipelineByPropertyName)]
        [System.Drawing.Font] $AxisYTitleFont = (Get-DefaultFont),

        [Parameter(ValueFromPipelineByPropertyName)]
        [System.Int32] $AxisXLabelMinFontSize = 6,

        [Parameter(ValueFromPipelineByPropertyName)]
        [System.Int32] $AxisXLabelMaxFontSize = 10,

        [Parameter(ValueFromPipelineByPropertyName)]
        [System.Int32] $AxisYLabelMinFontSize = 6,

        [Parameter(ValueFromPipelineByPropertyName)]
        [System.Int32] $AxisYLabelMaxFontSize = 10,

        [Parameter(ValueFromPipelineByPropertyName)]
        [System.Management.Automation.SwitchParameter] $Enable3d,

        [Parameter(ValueFromPipelineByPropertyName)]
        [System.Int32] $Inclination = 25,

        ## The relative X-coordinate of the top-left corner of the chart area
        [Parameter(Mandatory, ValueFromPipelineByPropertyName, ParameterSetName = 'Position')]
        [Parameter(Mandatory, ValueFromPipelineByPropertyName, ParameterSetName = 'PositionAndInnerPosition')]
        [ValidateRange(0, 100)]
        [System.Int32] $X,

        ## The relative Y-coordinate of the top-left corner of the chart area
        [Parameter(Mandatory, ValueFromPipelineByPropertyName, ParameterSetName = 'Position')]
        [Parameter(Mandatory, ValueFromPipelineByPropertyName, ParameterSetName = 'PositionAndInnerPosition')]
        [ValidateRange(0, 100)]
        [System.Int32] $Y,

        ## The relative height of the chart area
        [Parameter(Mandatory, ValueFromPipelineByPropertyName, ParameterSetName = 'Position')]
        [Parameter(Mandatory, ValueFromPipelineByPropertyName, ParameterSetName = 'PositionAndInnerPosition')]
        [ValidateRange(0, 100)]
        [System.Int32] $Height,

        ## The relative width of the chart area
        [Parameter(Mandatory, ValueFromPipelineByPropertyName, ParameterSetName = 'Position')]
        [Parameter(Mandatory, ValueFromPipelineByPropertyName, ParameterSetName = 'PositionAndInnerPosition')]
        [ValidateRange(0, 100)]
        [System.Int32] $Width,

        ## The relative X-coordinate of the top-left corner of the inner plot position
        [Parameter(Mandatory, ValueFromPipelineByPropertyName, ParameterSetName = 'InnerPosition')]
        [Parameter(Mandatory, ValueFromPipelineByPropertyName, ParameterSetName = 'PositionAndInnerPosition')]
        [ValidateRange(0, 100)]
        [System.Int32] $InnerX,

        ## The relative Y-coordinate of the top-left corner of the inner plot position
        [Parameter(Mandatory, ValueFromPipelineByPropertyName, ParameterSetName = 'InnerPosition')]
        [Parameter(Mandatory, ValueFromPipelineByPropertyName, ParameterSetName = 'PositionAndInnerPosition')]
        [ValidateRange(0, 100)]
        [System.Int32] $InnerY,

        ## The relative height of the inner plot position
        [Parameter(Mandatory, ValueFromPipelineByPropertyName, ParameterSetName = 'InnerPosition')]
        [Parameter(Mandatory, ValueFromPipelineByPropertyName, ParameterSetName = 'PositionAndInnerPosition')]
        [ValidateRange(0, 100)]
        [System.Int32] $InnerHeight,

        ## The relative width of the inner plot position
        [Parameter(Mandatory, ValueFromPipelineByPropertyName, ParameterSetName = 'InnerPosition')]
        [Parameter(Mandatory, ValueFromPipelineByPropertyName, ParameterSetName = 'PositionAndInnerPosition')]
        [ValidateRange(0, 100)]
        [System.Int32] $InnerWidth,

        [Parameter(ValueFromPipelineByPropertyName)]
        [System.String] $AxisXTitle,

        [Parameter(ValueFromPipelineByPropertyName)]
        [ValidateSet('Near','Center','Far')]
        [System.String] $AxisXTitleAlignment = 'Center',

        [Parameter(ValueFromPipelineByPropertyName)]
        [System.String] $AxisYTitle,

        [Parameter(ValueFromPipelineByPropertyName)]
        [ValidateSet('Near','Center','Far')]
        [System.String] $AxisYTitleAlignment = 'Center',

        [Parameter(ValueFromPipelineByPropertyName)]
        [System.Double] $AxisXInterval,

        [Parameter(ValueFromPipelineByPropertyName)]
        [System.Double] $AxisYInterval,

        [Parameter(ValueFromPipelineByPropertyName)]
        [System.Double] $AxisX2Interval,

        [Parameter(ValueFromPipelineByPropertyName)]
        [System.Double] $AxisY2Interval,

        [Parameter(ValueFromPipelineByPropertyName)]
        [System.Management.Automation.SwitchParameter] $UseSameFontSizeForAllAxes,

        [Parameter(ValueFromPipelineByPropertyName)]
        [System.Management.Automation.SwitchParameter] $NoAxisXMajorGridLines,

        [Parameter(ValueFromPipelineByPropertyName)]
        [System.Management.Automation.SwitchParameter] $NoAxisYMajorGridLines,

        [Parameter(ValueFromPipelineByPropertyName)]
        [System.Management.Automation.SwitchParameter] $NoAxisXMargin,

        [Parameter(ValueFromPipelineByPropertyName)]
        [System.Management.Automation.SwitchParameter] $NoAxisYMargin,

        [Parameter(ValueFromPipelineByPropertyName)]
        [ValidateSet('Dash', 'DashDot', 'DashDotDot', 'Dot', 'NotSet', 'Solid')]
        [System.String] $BorderStyle = 'NotSet',

        [Parameter(ValueFromPipelineByPropertyName)]
        [System.Int32] $BorderWidth = 0,

        [Parameter(ValueFromPipelineByPropertyName)]
        [System.Drawing.Color] $BorderColor = [System.Drawing.Color]::Black,

        ## Pass the [System.Windows.Forms.DataVisualization.Charting.ChartArea] object down the pipeline
        [Parameter(ValueFromPipelineByPropertyName)]
        [System.Management.Automation.SwitchParameter] $PassThru
    )
    process
    {
        $chartArea = New-Object -TypeName System.Windows.Forms.DataVisualization.Charting.ChartArea -ArgumentList $Name

        if ($PSCmdlet.ParameterSetName -in 'Position','PositionAndInnerPosition')
        {
            $chartArea.Position.Auto = $false
            $chartArea.Position.X = $X
            $chartArea.Position.Y = $Y
            $chartArea.Position.Width = $Width
            $chartArea.Position.Height= $Height
        }
        else
        {
            $chartArea.Position.Auto = $true
        }

        if ($PSCmdlet.ParameterSetName -in 'InnerPosition','PositionAndInnerPosition')
        {
            $chartArea.InnerPlotPosition.Auto = $false
            $chartArea.InnerPlotPosition.X = $InnerX
            $chartArea.InnerPlotPosition.Y = $InnerY
            $chartArea.InnerPlotPosition.Width = $InnerWidth
            $chartArea.InnerPlotPosition.Height= $InnerHeight
        }
        else
        {
            $chartArea.InnerPlotPosition.Auto = $true
        }

        $chartArea.AxisX.MajorGrid.Enabled = -not $NoAxisXMajorGridLines.ToBool()
        $chartArea.AxisX2.MajorGrid.Enabled = -not $NoAxisXMajorGridLines.ToBool()
        $chartArea.AxisY.MajorGrid.Enabled = -not $NoAxisYMajorGridLines.ToBool()
        $chartArea.AxisY2.MajorGrid.Enabled = -not $NoAxisYMajorGridLines.ToBool()

        $chartArea.AxisX.TitleFont = $AxisXTitleFont
        $chartArea.AxisX.LabelStyle.Font = $AxisXLabelFont
        $chartArea.AxisX2.LabelStyle.Font = $AxisXLabelFont
        $chartArea.AxisX.LabelAutoFitMinFontSize  = $AxisXLabelMinFontSize
        $chartArea.AxisX2.LabelAutoFitMinFontSize  = $AxisXLabelMinFontSize
        $chartArea.AxisX.LabelAutoFitMaxFontSize  = $AxisXLabelMaxFontSize
        $chartArea.AxisX2.LabelAutoFitMaxFontSize  = $AxisXLabelMaxFontSize
        $chartArea.AxisY.TitleFont = $AxisYTitleFont
        $chartArea.AxisY.LabelStyle.Font = $AxisYLabelFont
        $chartArea.AxisY2.LabelStyle.Font = $AxisYLabelFont
        $chartArea.AxisY.LabelAutoFitMinFontSize  = $AxisYLabelMinFontSize
        $chartArea.AxisY2.LabelAutoFitMinFontSize  = $AxisYLabelMinFontSize
        $chartArea.AxisY.LabelAutoFitMaxFontSize  = $AxisYLabelMaxFontSize
        $chartArea.AxisY2.LabelAutoFitMaxFontSize  = $AxisYLabelMaxFontSize

        $chartArea.IsSameFontSizeForAllAxes = $UseSameFontSizeForAllAxes.ToBool()
        $chartArea.BackColor = [System.Drawing.Color]::Empty
        $chartArea.BorderColor = $BorderColor
        $chartArea.BorderWidth = $BorderWidth
        $chartArea.BorderDashStyle = $BorderStyle
        $chartArea.AxisX.IsMarginVisible = -not $NoAxisXMargin.ToBool()
        $chartArea.AxisY.IsMarginVisible = -not $NoAxisYMargin.ToBool()

        if ($PSBoundParameters.ContainsKey('AxisXMajorGridLineColor'))
        {
            $chartArea.AxisX.MajorGrid.LineColor = $AxisXMajorGridLineColor
        }
        if ($PSBoundParameters.ContainsKey('AxisYMajorGridLineColor'))
        {
            $chartArea.AxisY.MajorGrid.LineColor = $AxisYMajorGridLineColor
        }

        if ($PSBoundParameters.ContainsKey('AxisXMajorGridLineDashStyle'))
        {
            $chartArea.AxisX.MajorGrid.LineDashStyle = $AxisXMajorGridLineDashStyle
        }
        if ($PSBoundParameters.ContainsKey('AxisYMajorGridLineDashStyle'))
        {
            $chartArea.AxisY.MajorGrid.LineDashStyle = $AxisYMajorGridLineDashStyle
        }

        if ($PSBoundParameters.ContainsKey('AxisXInterval'))
        {
            $chartArea.AxisX.Interval = $AxisXInterval
        }
        if ($PSBoundParameters.ContainsKey('AxisYInterval'))
        {
            $chartArea.AxisY.Interval = $AxisYInterval
        }
        if ($PSBoundParameters.ContainsKey('AxisX2Interval'))
        {
            $chartArea.AxisX2.Interval = $AxisX2Interval
        }
        if ($PSBoundParameters.ContainsKey('AxisY2Interval'))
        {
            $chartArea.AxisY2.Interval = $AxisY2Interval
        }
        if ($PSBoundParameters.ContainsKey('AxisXTitle'))
        {
            $chartArea.AxisX.Title = $AxisXTitle
            $chartArea.AxisX.TitleAlignment = $AxisXTitleAlignment
        }
        if ($PSBoundParameters.ContainsKey('AxisYTitle'))
        {
            $chartArea.AxisY.Title = $AxisYTitle
            $chartArea.AxisY.TitleAlignment = $AxisYTitleAlignment
        }

        if ($Enable3d)
        {
            $chartArea.Area3DStyle.Enable3D = $true
            $chartArea.Area3DStyle.Inclination = $Inclination
        }

        $Chart.ChartAreas.Add($chartArea)

        if ($PassThru)
        {
            Write-Output -InputObject $chartArea
        }
    }
}
