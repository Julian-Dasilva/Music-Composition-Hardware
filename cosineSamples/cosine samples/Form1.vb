Imports System.IO
Public Class Form1
    Private Sub Delays(ByVal clk As Integer, ByVal samples As Integer)
        Dim coef As Double = clk / (440 * samples)
        For i As Single = -21 To 21 Step 0.5
            ListBox1.Items.Add(CStr(i) + ": " + CStr((coef / 2 ^ (i / 12) - 34)))
        Next

    End Sub
    Private Function IntToBin(ByVal n As Integer) As String
        Dim i As Integer = 2048
        Dim s As String = ""
        While i >= 1
            If n >= i Then
                n -= i
                s += "1"
            Else
                s += "0"
            End If
            i /= 2
        End While
        Return s
    End Function
    Private Sub Button1_Click(sender As Object, e As EventArgs) Handles Button1.Click
        Dim outfile As StreamWriter
        outfile = File.CreateText("cos.coe")

        Dim n As Integer
        Dim s As String
        outfile.WriteLine("memory_initialization_radix = 2;")
        outfile.WriteLine("memory_initialization_vector =")
        For i = 0 To 999
            n = Math.Round(2047.5 * (1 + Math.Cos(2 * Math.PI * 0.001 * i)))
            s = IntToBin(n)
            ListBox1.Items.Add(s)
            If i < 999 Then
                outfile.WriteLine(s + ",")
            Else
                outfile.Write(s + ";")
                outfile.Close()
            End If

        Next


    End Sub

    Private Sub Button2_Click(sender As Object, e As EventArgs) Handles Button2.Click
        Delays(25000000, 100)
    End Sub

End Class
