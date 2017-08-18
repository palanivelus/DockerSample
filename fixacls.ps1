param([string]$dir);

$out = icacls "$dir" /verify /t /q
Foreach($line in $out)
{
    if ($line -match '(.:[^:]*): (.*)')
    {
        $path = $Matches[1]
        $acl = Get-Acl $path
        Set-Acl $path $acl
    }
}