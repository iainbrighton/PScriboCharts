function Add-ChartAnnotation
{
    [CmdletBinding(DefaultParameterSetName = 'Anchor')]
    [OutputType([System.Windows.Forms.DataVisualization.Charting.Annotation])]
    param
    (
        ## Chart object to add the chart area
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [System.Windows.Forms.DataVisualization.Charting.Chart] $Chart,

        ## Annotation text to display.
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [System.String] $Text,

        ## Annotation text to display.
        [Parameter(ValueFromPipelineByPropertyName)]
        [System.String] $Name = $Text,

        ## The X coordinate to which the annotation is anchored
        [Parameter(Mandatory, ValueFromPipelineByPropertyName, ParameterSetName = 'Anchor')]
        [System.Int32] $AnchorX,

        ## The Y coordinate to which the annotation is anchored
        [Parameter(Mandatory, ValueFromPipelineByPropertyName, ParameterSetName = 'Anchor')]
        [System.Int32] $AnchorY,

        ## Sets the X coordinate of the annotation
        [Parameter(Mandatory, ValueFromPipelineByPropertyName, ParameterSetName = 'Position')]
        [System.Int32] $X,

        ## Sets the Y coordinate of the annotation
        [Parameter(Mandatory, ValueFromPipelineByPropertyName, ParameterSetName = 'Position')]
        [System.Int32] $Y,

        ## Name of the X axis to which an annotation is attached.
        [Parameter(ValueFromPipelineByPropertyName, ParameterSetName = 'Position')]
        [System.String] $AxisXName,

        ## Name of the Y axis to which an annotation is attached.
        [Parameter(ValueFromPipelineByPropertyName, ParameterSetName = 'Position')]
        [System.String] $AxisYName,

        ## The height, in pixels, of an annotation.
        [Parameter(ValueFromPipelineByPropertyName)]
        [System.Int32] $Height,

        ## The width, in pixels, of an annotation.
        [Parameter(ValueFromPipelineByPropertyName)]
        [System.Int32] $Width,

        [Parameter(ValueFromPipelineByPropertyName)]
        [ValidateSet('TopLeft', 'TopCenter', 'TopRight', 'MiddleLeft', 'MiddleCenter', 'MiddleRight', 'BottomLeft', 'BottomCenter', 'BottomRight')]
        [System.String] $Alignment = 'TopLeft',

        ## The font for the annotation text.
        [Parameter(ValueFromPipelineByPropertyName)]
        [System.Drawing.Font] $Font = (Get-DefaultFont),

        ## Indicates the annotation text is multiline.
        [Parameter(ValueFromPipelineByPropertyName)]
        [System.Management.Automation.SwitchParameter] $IsMultiLine,

        ## Pass the Windows.Forms.DataVisualization.Charting.Annotation object down the pipeline.
        [Parameter(ValueFromPipelineByPropertyName)]
        [System.Management.Automation.SwitchParameter] $PassThru
    )
    process
    {
        $chartAnnotation = New-Object -TypeName System.Windows.Forms.DataVisualization.Charting.TextAnnotation # -ArgumentList $Name
        $chartAnnotation.Text = $Text
        $chartAnnotation.Font = $Font
        $chartAnnotation.IsMultiline = $IsMultiLine.ToBool()
        $chartAnnotation.Alignment = $Alignment

        if ($PSCmdlet.ParameterSetName -eq 'Anchor')
        {
            $chartAnnotation.AnchorX = $AnchorX
            $chartAnnotation.AnchorY = $AnchorY
        }
        elseif ($PSCmdlet.ParameterSetName -eq 'Position')
        {
            $chartAnnotation.X = $X
            $chartAnnotation.Y = $Y
            if ($PSBoundParameters.ContainsKey('AxisXName'))
            {
                $chartAnnotation.AxisXName = $AxisXName
            }
            if ($PSBoundParameters.ContainsKey('AxisYName'))
            {
                $chartAnnotation.AxisYName = $AxisYName
            }
        }

        if ($PSBoundParameters.ContainsKey('Width'))
        {
            $chartAnnotation.Width = $Width
        }
        if ($PSBoundParameters.ContainsKey('Height'))
        {
            $chartAnnotation.Height = $Height
        }

        $Chart.Annotations.Add($chartAnnotation)

        if ($PassThru)
        {
            Write-Output -InputObject $chartAnnotation
        }
    }
}
