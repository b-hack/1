# Létrehozunk egy SerialPort objektumot
$port = New-Object System.IO.Ports.SerialPort
$port.PortName = "COMx"  # Az Arduino soros portjának megfelelő COM portot adj meg
$port.BaudRate = 9600  # A Baud sebességet az Arduino kódban beállított sebességgel egyeztetheted
$port.Open()  # Nyitjuk a soros portot

# Folyamatos olvasás a soros portról és kiírás a képernyőre
while ($true) {
    if ($port.IsOpen) {
        $receivedData = $port.ReadLine()
        Write-Host "Received data: $receivedData"

        # Bemenet várakozik
        $input = Read-Host "Enter data to send (or type 'exit' to quit)"

        if ($input -eq "exit") {
            break  # Kilépés a ciklusból, ha "exit" lett beírva
        }

        # Küldjük az inputot a soros porton
        $port.WriteLine($input)
    } else {
        Write-Host "Serial port is closed. Exiting..."
        break
    }
}

# Bezárjuk a soros portot, amikor kilépünk a ciklusból
$port.Close()
