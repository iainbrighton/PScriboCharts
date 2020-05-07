function Convert-ToOrderedDictionary
{
    [CmdletBinding()]
    [OutputType([System.Collections.Specialized.OrderedDictionary])]
    param
    (
        [Parameter(Mandatory, ValueFromPipeline)]
        [System.Object[]] $InputObject,

        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [System.String] $Key,

        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [System.Object] $Value
    )
    begin
    {
        $hashtable = [Ordered] @{ }
    }
    process
    {
        foreach ($object in $InputObject)
        {
            $objectKey = $object.$Key
            $hashtable[$objectKey] = $object.$Value
        }
    }
    end
    {
        Write-Output -InputObject $hashtable
    }
}
