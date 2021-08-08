$currentPath = Get-Location
$path = Split-Path -Path $currentPath -Parent
$extdir = "-Djava.ext.dirs="+$path+"\plugins;"+$path+"\lib;"
$thank = "Thank you!"

Write-Host "WebSphere Password Encoder Tool For Windows"
Write-Host "Put this script into WebSphere install_root/bin directory before run it!"
Write-Host ""
switch($args[0]){
    "-decode" {
        $hash = Read-Host "Please input hash that you want to decode"
        if (-Not ([string]::IsNullOrEmpty($hash))) {
            $result = (& $path\java\bin\java $extdir com.ibm.ws.security.util.PasswordDecoder "$hash")
            if ( -Not $result.Contains("ERROR") ) {
                $result = $result.split(",")[-1].Trim()
                Write-Host $result
            }
            else {
                Write-Host "seems that hash is using wrong algorithm or already decoded!"
            }
        }
        else {
            Write-Host "You didn't input any hash."
            Write-Host "Plase check again!"    
        };Break
    }
    "" {
        $passwordSecureText = Read-Host "Please enter the password" -AsSecureString
        $password =[Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($passwordSecureText))
        $passwordSecureText1 = Read-Host "Please re-enter the password" -AsSecureString
        $password1 =[Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($passwordSecureText1))

        if ( (-Not ([string]::IsNullOrEmpty($password))) -and (-Not ([string]::IsNullOrEmpty($password1))) ) {
            if($password -ne $password1){
                Write-Host "Passwords not match"
                Write-Host "Please check again!"
            }
            else {
                Write-Host "Passwords match, please wait for the encoded password!"
                $result = (& $path\java\bin\java $extdir com.ibm.ws.security.util.PasswordEncoder "$password1")
                if(-Not $result.Contains("ERROR")) {
                    $result = $result.split(",")[-1].Trim()
                    Write-Host $result
                }
                else {
                    Write-Host "Something wrong, please check your password again!"
                    $result = $result.split(" ")[0,1,2,3,5,6].Trim()
                    Write-Host $result
                } 
            }
        }
        else {
            Write-Host "One or more of the password is empty."
            Write-Host "Plase check again!" 
        }; Break
    }
    Default {
        Write-Host "To run it just execute "$PSCommandPath
    }
}
Write-Host $thank