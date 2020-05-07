function Export-Chart
{
<#
    .SYNOPSIS
        Saves a chart to a file.

    .DESCRIPTION
        The following picture formats are supported: Jpeg, Png, Bmp, Tiff, Gif, Emf, EmfDual and EmfPlus.
#>
    [CmdletBinding()]
    [OutputType([System.IO.FileInfo])]
    param
    (
        ## Chart object to export.
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [System.Windows.Forms.DataVisualization.Charting.Chart] $Chart,

        # Specifies a path to the destination export location.
        [Parameter(Position = 0,ValueFromPipelineByPropertyName)]
        [Alias('PSPath')]
        [ValidateNotNullOrEmpty()]
        [System.String] $Path,

        ## Specifies the export format.
        [Parameter(ValueFromPipelineByPropertyName)]
        [ValidateSet('Jpeg','Png','Bmp','Tiff','Gif','Emf','EmfDual','EmfPlus')]
        [System.String] $Format = 'Png',

        ## Pass the [System.IO.FileItem] object down the pipeline
        [Parameter(ValueFromPipelineByPropertyName)]
        [System.Management.Automation.SwitchParameter] $PassThru
    )
    begin
    {
        $destinationPath = $null

        if ($PSBoundParameters.ContainsKey('Path'))
        {
            $item = Get-Item -Path $Path

            if ($item -is [System.IO.DirectoryInfo])
            {
                ## We have a directory, create the filename
                $destinationPath = Resolve-Path -Path $Path
                $filename = '{0}.{1}' -f $Chart.Name, $Format.ToLower()
            }
            elseif ($item -is [System.IO.FileInfo])
            {
                $destinationPath = $item.Directory.FullName
                $filename = $item.Name

                ## We have a path and filename but no format, attempt to infer the format..
                if (-not $PSBoundParameters.ContainsKey('Format'))
                {
                    $Format = $item.Extension.TrimStart('.')
                    if ('Jpeg','Png','Bmp','Tiff','Gif','Emf','EmfDual','EmfPlus' -notcontains $extension)
                    {
                        throw 'Unsupported format'
                    }
                }
            }
        }
        else
        {
            $destinationPath = (Get-Location -PSProvider Filesystem).Path
            $filename = '{0}.{1}' -f $Chart.Name, $Format.ToLower()
        }
    }
    process
    {
        $filePath = Join-Path -Path $destinationPath -ChildPath $filename
        Write-Verbose -Message ("Exporting '{0}'" -f $filePath)
        $Chart.SaveImage($filePath, $Format)

        if ($PassThru)
        {
            Write-Output -InputObject (Get-Item -Path $filePath)
        }
    }
}
