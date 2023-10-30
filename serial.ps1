# Létrehozunk egy SerialPort objektumot
$port = New-Object System.IO.Ports.SerialPort
$port.PortName = "COMx"  # Az Arduino soros portjának megfelelő COM portot adj meg
$port.BaudRate = 9600  # A Baud sebességet az Arduino kódban beállított sebességgel egyeztetheted
$port.Open()  # Nyitjuk a soros portot

# Bemeneti adatok gyűjtésére használt változó
$inputBuffer = ""

# Folyamatosan figyeljük a bemenetet
while ($true) {
    # Ellenőrizzük a bemenetet
    if ($Host.UI.RawUI.KeyAvailable) {
        $key = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown").Character
        if ($key -eq "`r") {
            # Ha "Enter"-t nyomtál, elküldjük a bemeneti adatot és töröljük a buffer-t
            Send-Data $inputBuffer
            $inputBuffer = ""
        } else {
            # Az összes többi karaktert hozzáadjuk a bemeneti buffer-hez
            $inputBuffer += $key
        }
    }

    # Ellenőrizzük az adatok érkezését
    Receive-Data
}

# Bezárjuk a soros portot, amikor kilépünk a ciklusból
$port.Close()

# Az adatok küldéséhez és fogadásához használt függvények
function Receive-Data {
    if ($port.IsOpen) {
        $receivedData = $port.ReadLine()
        Write-Host "Received data: $receivedData"
    } else {
        Write-Host "Serial port is closed."
    }
}

function Send-Data($data) {
    if ($port.IsOpen) {
        $port.WriteLine($data)
        Write-Host "Sent data: $data"
    } else {
        Write-Host "Serial port is closed."
    }
}
