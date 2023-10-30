# Létrehozunk egy SerialPort objektumot
$port = New-Object System.IO.Ports.SerialPort
$port.PortName = "COMx"  # Az Arduino soros portjának megfelelő COM portot adj meg
$port.BaudRate = 9600  # A Baud sebességet az Arduino kódban beállított sebességgel egyeztetheted
$port.Open()  # Nyitjuk a soros portot

# Az adatok fogadásához és küldéséhez használt függvények
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

# Folyamatosan figyeljük az adatokat és a bemenetet
while ($true) {
    # Ellenőrizzük az adatok érkezését
    Receive-Data

    # Ellenőrizzük a bemenetet
    if ($Host.UI.RawUI.KeyAvailable) {
        $key = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown").Character
        if ($key -eq "q") {
            # Kilépünk a ciklusból, ha "q" betűt ütünk be
            break
        } else {
            # Küldünk adatot, ha más betűt ütünk be
            Send-Data $key
        }
    }
}

# Bezárjuk a soros portot, amikor kilépünk a ciklusból
$port.Close()
