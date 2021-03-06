param(
    $hashLength = 256,
    $rounds = 64
)
[int[]]$in = (gc .\input.txt).ToCharArray()
$in += @(17, 31, 73, 47, 23)
$array = @(0..($hashLength - 1))
$skip, $pos = 0, 0

for ($_r = 0; $_r -lt $rounds; $_r++) {
    foreach ($instruction in $in) {
        $end = $pos + $instruction - 1
        $subArray = $array[$pos..$end] # create a subarray of the lenght of this
        if ($end -ge $hashLength) {
            $end = $end % $hashLength
            $subArray += $array[0..$end]
        }
        [array]::Reverse($subArray)
        $i = $pos
        foreach ($number in $subArray) {
            $array[($i % $hashLength)] = $number
            $i++
        }
        $pos = ($end + $skip + 1) % $hashLength
        $skip++
    }
}
$hash = ""
foreach ($group in @(0..(15 % $array.Length))) {
    $idx = $group * 16
    $val = $array[$idx]
    foreach ($x in $array[($idx + 1)..($idx + 15)]) {
        $val = $val -bxor $x
    }
    $hash += [Convert]::ToString($val, 16).padleft(2, "0")
}
$hash